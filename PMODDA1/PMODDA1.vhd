--------------------------------------------------------------------------------
--
-- PMODDA1
--
-- Title: SBA Slave IP Core adapter for Digilent Pmod DA1 module
--
-- Version: 0.5
-- Date: 2018/07/07
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/PMODDA1
--
-- Description: The PMod DA1 module has two AD7303, this chip is a dual 8-bit
-- voltage out DAC SPI interface.
-- Write 16 bits word: MSB:LSB = DAC2:DAC1
-- Read 16 bits word: LSbit (bit0) is '0' after writing into the register and
-- '1' at the end of conversion.
--
-- Follow SBA v1.1 guidelines
--
-- Release Notes:
--
-- v0.5 2018/07/07
-- Complete rewrite
--
-- v0.4 2017/08/04
-- Change sysfrec to sysfreq

-- v0.3.2 2015/09/06
-- Release for SBA library
-- Remove SBA_Config dependency
-- Follow SBA v1.1 guidelines
--
-- v0.3.1 2013/04/02
-- Follow SBA v1.0 guidelines
--
-- v0.2 20121205
-- Adapted for ICTP FPGA Course
--
-- v0.1 20120610
-- Initial release
--
--------------------------------------------------------------------------------
-- Copyright:
--
-- (c) Miguel A. Risco-Castillo
--
-- This code, modifications, derivate work or based upon, can not be used or
-- distributed without the complete credits on this header.
--
-- This version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
-- if you use this component for your research please include the appropriate
-- credit of Author.
--
-- The code may not be included into ip collections and similar compilations
-- which are sold. If you want to distribute this code for money then contact me
-- first and ask for my permission.
--
-- These copyright notices in the source code may not be removed or modified.
-- If you modify and/or distribute the code to any third party then you must not
-- veil the original author. It must always be clearly identifiable.
--
-- Although it is not required it would be a nice move to recognize my work by
-- adding a citation to the application's and/or research.
--
-- FOR COMMERCIAL PURPOSES REQUEST THE APPROPRIATE LICENSE FROM THE AUTHOR.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PMODDA1 is
generic(
  debug:positive:=1;
  sysfreq:positive:=50E6
);
port(
-- SBA Interface
   RST_I : in  std_logic;        -- active high reset
   CLK_I : in  std_logic;        -- Main System clock
   STB_I : in  std_logic;        -- Strobe/Chip Select, active high
   WE_I  : in  std_logic;        -- Bus Write enable: active high, Read: active low
   DAT_I : in  std_logic_vector; -- Data input Bus
   DAT_O : out std_logic_vector; -- Data output Bus
--Pmod interface signals
   nSYNC : out std_logic;
   D0    : out std_logic;
   D1    : out std_logic;
   SCLK  : out std_logic
   );
end PMODDA1;

architecture DA1 of PMODDA1 is

-- control constant: Update DAC A DAC register from shift register.Both
-- DACs active.Internal reference.
  constant control     : std_logic_vector(7 downto 0) := "00000011";

--------------------------------------------------------------------------------
-- Title      : signal assignments
--
-- Description: The following signals are enumerated signals for the 
--              finite state machine,2 temporary vectors to be shifted out to the 
--              AD7303 chips, a divided clock signal to drive the AD7303 chips,
--              a counter to divide the internal 50 MHz clock signal,
--              a 4-bit counter to be used to shift out the 16-bit register,
--              and 2 enable signals for the parallel load and shift of the 
--              shift register.
-------------------------------------------------------------------------------- 

  type states is (Idle,ShiftOut,SyncData);

  signal current_state : states;
  signal clk_div       : std_logic;
  signal shiftCounter  : unsigned(3 downto 0);
  signal Stream0       : std_logic_vector(15 downto 0);
  signal Stream1       : std_logic_vector(15 downto 0);
  signal DATA0         : std_logic_vector(7 downto 0);
  signal DATA1         : std_logic_vector(7 downto 0);
  signal START         : std_logic;
  signal DONE          : std_logic;

begin

--------------------------------------------------------------------------------
-- Title      : System clock divider
--
-- Description: Divided clock signal to drive the AD7303 chips,
--              use clk_div to reduce the internal 50 MHz clock signal to
--              12.5 MHz max
-------------------------------------------------------------------------------- 

SCK1: if (sysfreq>30E6) generate
  clkDiv : entity work.ClkDiv
  Generic map (
    infreq=>sysfreq,
    outfreq=>125E5           -- 12.5 MHz
    )
  Port Map(
    RST_I => RST_I,
    CLK_I => CLK_I,
    CLK_O => clk_div
  );
end generate;

SCK2: if (sysfreq<=30E6) generate
  clk_div <= CLK_I;
end generate;

--------------------------------------------------------------------------------
-- SBA interface
--------------------------------------------------------------------------------

SBA_intf : process (CLK_I, RST_I)
  begin
    if rising_edge(CLK_I) then
      if (RST_I='1') then
        DATA0 <= (others => '0');
        DATA1 <= (others => '0');
        START<='0';
      elsif (STB_I='1' and WE_I='1') then
        DATA0 <= DAT_I(7 downto 0);
        DATA1 <= DAT_I(15 downto 8);
        START<='1';
      elsif (current_state=ShiftOut) then
        START<='0';
      end if;
    end if;
  end process SBA_intf;

--------------------------------------------------------------------------------
-- DAC interface
--------------------------------------------------------------------------------

  process (clk_div,START)
  begin
    if (START='1') then
      shiftCounter <= (others => '0');
    elsif rising_edge(clk_div) then
      if (current_state = ShiftOut) then
        shiftCounter <= shiftCounter + 1;
      end if;
    end if;
  end process;

  process (clk_div, RST_I)
  begin
    if (RST_I='1') then
      Stream0 <= (others=>'0');
      Stream1 <= (others=>'0');
    elsif rising_edge(clk_div) then
      case current_state is
        when ShiftOut =>
          Stream0 <= Stream0(14 downto 0) & '0';
          Stream1 <= Stream1(14 downto 0) & '0';
        when others =>
          Stream0 <= control & DATA0;
          Stream1 <= control & DATA1;
      end case;
    end if;
  end process;

  process (clk_div, RST_I)
  begin
    if (RST_I='1') then
      current_state <= Idle;
    elsif rising_edge(clk_div) then
      if (START='1') then
        current_state <= ShiftOut;
      elsif (shiftCounter = "1111") then
        current_state <= SyncData;
      elsif (DONE = '1') then
        current_state <= Idle;
      else
        current_state <= current_state;
      end if;
    end if;
  end process;

  process (clk_div,RST_I,START)
  begin
    if (RST_I='1') then
         DONE <= '1';
    elsif (START='1') then
         DONE <= '0';
    elsif rising_edge(clk_div) then
      if (current_state = SyncData) then
         DONE <= '1';
      end if;
    end if;
  end process;

  process (clk_div, RST_I)
  begin
    if (RST_I='1') then
      nSYNC <= '1';
    elsif rising_edge(clk_div) then
      if (START='1') then
        nSYNC <= '0';
      elsif (shiftCounter = "1111") then
        nSYNC <= '1';
      end if;
    end if;
  end process;

  DAT_O <= (DAT_O'high downto 1 =>'0') & (DONE and not START);
  SCLK <= not clk_div;
  D0 <= Stream0(15);
  D1 <= Stream1(15);
end DA1;
            
          
