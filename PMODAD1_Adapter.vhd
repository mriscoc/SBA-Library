------------------------------------------------------------
-- PMODAD1_Adapter.vhd
--
-- Versión 0.1 20120614
--
-- 2 register: ADC0 and ADC1 12 bits extended to DAT_O width
-- ADR_I Select the register '0'to ADC0 and '1' to ADC1
--
-- SBA Slave Adapter for Digilent Pmod AD1 module
--
-- The AD1 (2xAD7476A) converts an analog input signal
-- ranging from 0-3.3 volts to a 12-bit digital value
-- in the range 0 to 4095.
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
------------------------------------------------------------
--
-- Notes:
--
--
-- Rev 0.1
-- Initial release
--
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SBA_config.all;


entity PMODAD1_Adapter is
port(
-- SBA Interface
   RST_I : in  std_logic;        -- active high reset
   CLK_I : in  std_logic;        -- Main clock
   DAT_O : out std_logic_vector; -- Data output Bus
   STB_I : in  std_logic;        -- Strobe
   ADR_I : in  std_logic_vector; -- Register AD0/AD1 selector
   WE_I  : in  std_logic;        -- Bus write, active high
-- Interface for PMODAD1
   CS    : out std_logic;        -- chipselect active low
   D1    : in  std_logic;        -- AD1 DATA 1
   D2    : in  std_logic;        -- AD1 DATA 2
   SCK   : out std_logic         -- SPI Clock
);
end PMODAD1_Adapter;

architecture  PMODAD1_Arch of  PMODAD1_Adapter is
type tstate is (IniSt, GetD, EndSt); -- SPI Communication States

signal state    : tstate;
signal streamD0 : std_logic_vector (15 downto 0);
signal streamD1 : std_logic_vector (15 downto 0);
signal AD0REG   : std_logic_vector (11 downto 0);
signal AD1REG   : std_logic_vector (11 downto 0);
signal SCKN     : unsigned (3 downto 0);           -- SCK Counter
signal SCKi     : std_logic;                       -- SCK Generated SPI Clock

begin

-- SPI Clock generator:

SCK1: if (sysfrec>20E6) generate
  CLK_Div : entity work.ClkDiv
  Generic map (frec=>20E6)
  Port Map(
    RST_I => RST_I,
    CLK_I => CLK_I,
    CLK_O => SCKi
  );
end generate;

SCK2: if (sysfrec<=20E6) generate
  SCKi <= CLK_I;
end generate;

-- SPI BUS Proccess
  
SPIState:process (SCKi, RST_I)
  begin
    if (RST_I='1') then
      state   <= IniSt;
      CS      <= '1';
      SCKN    <= (others => '0');
    elsif rising_edge(SCKi) then
      case State is
        when IniSt => CS    <='0';
                      state <= GetD;
                      SCKN  <= (others => '0');

        when GetD  => if (SCKN = 15) then
                        state<= EndSt;
                      else
                        SCKN <= SCKN+1;
                      end if;

        when EndSt => CS <='1';
                      state <= IniSt;
      end case;
    end if;
  end process;

SPIData:process(SCKi, RST_I, state)
  begin
    if (RST_I='1') then
      streamD0<= (OTHERS =>'0');
      streamD1<= (OTHERS =>'0');
      AD0REG  <= (others => '0');
      AD1REG  <= (others => '0');
    elsif falling_edge(SCKi) then
      case State is
        when GetD  => streamD0 <= streamD0(streamD0'high-1 downto 0) & D1;
                      streamD1 <= streamD1(streamD1'high-1 downto 0) & D2;

        when EndSt => AD0REG   <= StreamD0(11 downto 0);
                      AD1REG   <= StreamD1(11 downto 0);

        when others=> streamD0 <= streamD0;
                      streamD1 <= streamD1;
                      AD0REG   <= AD0REG;
                      AD1REG   <= AD1REG;
      end case;
    end if;
  end process;

-- Interface signals
  SCK   <= SCKi When state=GetD else '1';
  DAT_O <= "0000" & AD0REG when ADR_I(0)='0' else "0000" & AD1REG;

end  PMODAD1_Arch;