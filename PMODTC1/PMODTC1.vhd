--------------------------------------------------------------------------------
-- PMODTC1
--
-- Title: SBA Slave IP Core adapter for Digilent Pmod AD1 module
--
-- Versión 0.1
-- Date 2019/04/14
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/PMODTC1
--
-- Description: The PMODTC1 is an SBA IPCore designed to driver the Digilent PmodTC1 module,
-- a cold-juntion K-Type thermocouple to digital converter. It integrates the MAX31855,
-- this reports the measured temperature in 14 bits with 0.25°C resolution.
-- The SBA core has 2 register, selectec by  ADR_I to access the 32 bits of the
-- MAX31855, thermocuple ADR_I(0)=1 and reference junction temperatures ADR_I(0)=0.
--
-- Follow SBA v1.1 guidelines
--
-- Release Notes:
--
-- v0.1 2019/04/14
-- Initial release
--
--------------------------------------------------------------------------------
-- Copyright:
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

entity PMODTC1 is
generic(
  debug:positive:=1;
  sysfreq:positive:=50E6
);
port(
-- SBA Interface
   RST_I : in  std_logic;        -- active high reset
   CLK_I : in  std_logic;        -- Main clock
   STB_I : in  std_logic;        -- Strobe
   WE_I  : in  std_logic;        -- Bus write, active high
   ADR_I : in  std_logic_vector; -- Register AD0/AD1 selector
   DAT_O : out std_logic_vector; -- Data output Bus
-- Interface for PMODTC1
   nCS   : out std_logic;        -- chipselect active low
   MISO  : in  std_logic;        -- Master In Slave Out
   SCK   : out std_logic         -- SPI Clock
);
end PMODTC1;

architecture  PMODTC1_Arch of  PMODTC1 is
type tstate is (IniSt, GetD, EndSt); -- SPI Communication States

signal state    : tstate;
signal stream   : std_logic_vector (31 downto 0);  -- Serial input register
signal DREG     : std_logic_vector (31 downto 0);  -- Data register
signal SCKN     : unsigned (4 downto 0);           -- SCK Counter
signal SCKi     : std_logic;                       -- SCK Generated SPI Clock

begin

-- SPI Clock generator:

SCK1: if (sysfreq>5E6) generate
  CLK_Div : entity work.ClkDiv
  Generic map (
    infreq=>sysfreq,
    outfreq=>5E6
    )
  Port Map(
    RST_I => RST_I,
    CLK_I => CLK_I,
    CLK_O => SCKi
  );
end generate;

SCK2: if (sysfreq<=5E6) generate
  SCKi <= CLK_I;
end generate;

-- SPI BUS Proccess
  
SPIState:process (SCKi, RST_I)
  begin
    if (RST_I='1') then
      state   <= IniSt;
      nCS      <= '1';
      SCKN    <= (others => '0');
    elsif falling_edge(SCKi) then
      case State is
        when IniSt => nCS   <='0';
                      state <= GetD;
                      SCKN  <= (others => '0');

        when GetD  => if (SCKN = 31) then
                        state<= EndSt;
                      else
                        SCKN <= SCKN+1;
                      end if;

        when EndSt => nCS <='1';
                      state <= IniSt;
      end case;
    end if;
  end process;

SPIData:process(SCKi, RST_I, state)
  begin
    if (RST_I='1') then
      stream<= (OTHERS =>'0');
      DREG  <= (others => '0');
    elsif rising_edge(SCKi) then
      case State is
        when GetD  => stream <= stream(stream'high-1 downto 0) & MISO;

        when EndSt => DREG   <= Stream;

        when others=> stream <= stream;
                      DREG   <= DREG;
      end case;
    end if;
  end process;

-- Interface signals
  SCK   <= SCKi When state=GetD else '0';
  DAT_O <= std_logic_vector(resize(signed(DREG(15 downto 0)),DAT_O'length)) when ADR_I(0)='0' else
           std_logic_vector(resize(signed(DREG(31 downto 16)),DAT_O'length));

end  PMODTC1_Arch;
