------------------------------------------------------------
-- PMODDA1_Adapter.vhd
--
-- Versión 0.1 20120610
--
-- The PMod DA1 module have two AD7303,
-- this chip is a dual, 8-bit voltage out DAC
-- SPI interface
-- requires 1x16bit register:
-- Write MSB:DAC2 LSB:DAC1
-- Read LSbit is '0' after write into register and
-- '1' at the end of conversion.
--
-- SBA Slave Adapter for Digilent Pmod DA1 module
--
-- SBA v1.0 compliant
--
------------------------------------------------------------
--
--
-- Author:
-- (c) Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- web page: http://mrisco.accesus.com
-- sba webpage: http://sba.accesus.com
--
-- This code, modifications, derivate
-- work or based upon, can not be used
-- or distributed without the
-- complete credits on this header and
-- the consent of the author.
--
-- This version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
-- if you use this component for your research please
-- include the appropriate credit of Author.
--
-- For commercial purposes request the appropriate
-- license from the author.
--
--
-- This adapter is based upon the work of Ioana Dabacan
-- DA1 Reference Component (c) 2008 Digilent Ro.
--
------------------------------------------------------------
--
-- Notes:
--
-- Rev 0.1
-- Initial release
--
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SBA_config.all;

entity PMODDA1_Adapter is
port(
-- SBA Interface
   RST_I : in  std_logic;        -- active high reset
   CLK_I : in  std_logic;        -- System clock
   DAT_I : in  std_logic_vector; -- Data input Bus
   DAT_O : out std_logic_vector; -- Data output Bus
   STB_I : in  std_logic;        -- Strobe, chip select
   WE_I  : in  std_logic;        -- Bus write, active high
--Pmod interface signals
   nSYNC : out std_logic;
   D0    : out std_logic;
   D1    : out std_logic;
   SCLK  : out std_logic
   );
end PMODDA1_Adapter;

architecture DA1 of PMODDA1_Adapter is

--      control constant: Update DAC A DAC register from shift register.Both
--          DACs active.Internal reference.
          constant control     : std_logic_vector(7 downto 0) := "00000011";
------------------------------------------------------------------------------------
--    Title      : signal assignments
--
-- Description: The following signals are enumerated signals for the 
--              finite state machine,2 temporary vectors to be shifted out to the 
--              AD7303 chips, a divided clock signal to drive the AD7303 chips,
--              a counter to divide the internal 50 MHz clock signal,
--              a 4-bit counter to be used to shift out the 16-bit register,
--              and 2 enable signals for the paralel load and shift of the 
--              shift register.
-- 
------------------------------------------------------------------------------------ 

          type states is (Idle,ShiftOut,SyncData);
                 
          signal current_state : states;
          signal next_state : states;
          signal temp1         : std_logic_vector(15 downto 0);
          signal temp2         : std_logic_vector(15 downto 0);           
          signal clk_div       : std_logic;      
          signal shiftCounter  : unsigned(3 downto 0);
          signal enShiftCounter: std_logic;
          signal enParalelLoad : std_logic;
     -- Converted interface signals from reference component
          signal DATA1         : std_logic_vector(7 downto 0);
          signal DATA2         : std_logic_vector(7 downto 0);
          signal START         : std_logic;
          signal DONE          : std_logic;

begin

-- System clock divider, clk_div (max 30MHz)
SCK1: if (sysfrec>30E6) generate
  clkDiv : entity work.ClkDiv
  Generic map (frec=>30E6)
  Port Map(
    RST_I => RST_I,
    CLK_I => CLK_I,
    CLK_O => clk_div
  );
end generate;

SCK2: if (sysfrec<=30E6) generate
  clk_div <= CLK_I;
end generate;

-- SBA interface:
SBA_intf : process (CLK_I, RST_I)
  begin
    if rising_edge(CLK_I) then
      if (RST_I='1') then
        DATA1 <= (others => '0');
        DATA2 <= (others => '0');
        START<='0';
      elsif (STB_I='1' and WE_I='1') then
        DATA1 <= DAT_I(7 downto 0);
        DATA2 <= DAT_I(15 downto 8);
        START<='1';
      elsif (current_state=ShiftOut) then
        START<='0';
      end if;
    end if;
  end process;

  DAT_O <= (DAT_O'high downto 1 =>'0') & (DONE and not START);
  SCLK <= not clk_div;

-----------------------------------------------------------------------------------
--
-- Title      : counter
--
-- Description: This is the process were the temporary registers will be loaded and
--              shifted.When the enParalelLoad signal is generated inside the state 
--              the temp1 and temp2 registers will be loaded with the 8 bits of control
--              concatenated with the 8 bits of data. When the enShiftCounter is 
--              activated, the 16-bits of data inside the temporary registers will be 
--              shifted. A 4-bit counter is used to keep shifting the data 
--              inside temp1 and temp 2 for 16 clock cycles.
--    
-----------------------------------------------------------------------------------    

counter : process(clk_div, enParalelLoad, enShiftCounter)
        begin
            if (clk_div = '1' and clk_div'event) then
               if enParalelLoad = '1' then
                   shiftCounter <= "0000";
                   temp1 <= control & DATA1;
                   temp2 <= control & DATA2;
                elsif (enShiftCounter = '1') then 
                   temp1 <= temp1(14 downto 0)&temp1(15);
                   temp2 <= temp2(14 downto 0)&temp2(15);    
                   shiftCounter <= shiftCounter + 1;
                end if;
            end if;
        end process;

                    D0 <= temp1(15);                             
                    D1 <= temp2(15);

        
---------------------------------------------------------------------------------
--
-- Title      : Finite State Machine
--
-- Description: This 3 processes represent the FSM that contains three states. The first 
--              state is the Idle state in which a temporary registers are 
--              assigned the updated value of the input "DATA1" and "DATA2". The next state 
--              is the ShiftOut state which is the state where the 16-bits of 
--              temporary registers are shifted out left from the MSB to the two serial outputs,
--              D0 and D1. Immediately following the second state is the third 
--              state SyncData. This state drives the output signal sync high for
--              2 clock signals telling the AD7303 to latch the 16-bit data it 
--              just recieved in the previous state. 
-- Notes:         The data will change on the lower edge of the clock signal. Their 
--                is also an asynchronous reset that will reset all signals to their 
--                original state.
--
-----------------------------------------------------------------------------------        
        
-----------------------------------------------------------------------------------
--
-- Title      : SYNC_PROC
--
-- Description: This is the process were the states are changed synchronously. At 
--              reset the current state becomes Idle state.
--    
-----------------------------------------------------------------------------------            
SYNC_PROC: process (clk_div, rst_i)
   begin
      if (clk_div'event and clk_div = '1') then
         if (rst_i = '1') then
            current_state <= Idle;
         else
            current_state <= next_state;
         end if;        
      end if;
   end process;
    
-----------------------------------------------------------------------------------
--
-- Title      : OUTPUT_DECODE
--
-- Description: This is the process were the output signals are generated
--              unsynchronously based on the state only (Moore State Machine).
--    
-----------------------------------------------------------------------------------        
OUTPUT_DECODE: process (current_state)
   begin
      if current_state = Idle then
            enShiftCounter <='0';
            DONE <='1';
            nSYNC <='1';
            enParalelLoad <= '1';
        elsif current_state = ShiftOut then
            enShiftCounter <='1';
            DONE <='0';
            nSYNC <='0';
            enParalelLoad <= '0';
        else --if current_state = SyncData then
            enShiftCounter <='0';
            DONE <='0';
            nSYNC <='1';
            enParalelLoad <= '0';
        end if;
   end process;
    
-----------------------------------------------------------------------------------
--
-- Title      : NEXT_STATE_DECODE
--
-- Description: This is the process were the next state logic is generated 
--              depending on the current state and the input signals.
--    
-----------------------------------------------------------------------------------    
    NEXT_STATE_DECODE: process (current_state, START, shiftCounter)
   begin
      
      next_state <= current_state;  --default is to stay in current state
     
      case (current_state) is
         when Idle =>
            if START = '1' then
               next_state <= ShiftOut;
            end if;
         when ShiftOut =>
            if shiftCounter = x"F" then
               next_state <= SyncData;
            end if;
         when SyncData =>
            if START = '0' then
            next_state <= Idle;
            end if;
         when others =>
            next_state <= Idle;
      end case;      
   end process;
    
end DA1;
            
          
