--------------------------------------------------------------------------------
-- PMODAD1
--
-- Title: SBA Slave IP Core adapter for Digilent Pmod AD1 module
--
-- Versión 0.2
-- Date 2018/03/16
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/PMODAD1
--
-- Description: SBA Slave Adapter for Digilent Pmod AD1 module, the AD1 (2xAD7476A)
-- converts an analog input signal ranging from 0-3.3 volts to a 12-bit digital
-- value in the range 0 to 4095. Has 2 register: AD0 and AD1 (12 bits extended
-- to DAT_O width), ADR_I Selects the registers AD0 (ADR_I(0)=0) or AD1 (ADR_I(0)=1).
--
-- Follow SBA v1.1 guidelines
--
-- Release Notes:
--
-- v0.2 2018/03/16
-- Adapt to SBA v1.1
-- Pin CS changed to nCS (Active low)
--
-- v0.1 2012/06/14
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

entity PMODAD1 is
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
-- Interface for PMODAD1
   nCS   : out std_logic;        -- chipselect active low
   D0    : in  std_logic;        -- AD1 Input data 0
   D1    : in  std_logic;        -- AD1 Input data 1
   SCK   : out std_logic         -- SPI Clock
);
end PMODAD1;

architecture  PMODAD1_Arch of  PMODAD1 is
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

SCK1: if (sysfreq>20E6) generate
  CLK_Div : entity work.ClkDiv
  Generic map (
    infrec=>sysfreq,
    outfrec=>20E6
    )
  Port Map(
    RST_I => RST_I,
    CLK_I => CLK_I,
    CLK_O => SCKi
  );
end generate;

SCK2: if (sysfreq<=20E6) generate
  SCKi <= CLK_I;
end generate;

-- SPI BUS Proccess
  
SPIState:process (SCKi, RST_I)
  begin
    if (RST_I='1') then
      state   <= IniSt;
      nCS      <= '1';
      SCKN    <= (others => '0');
    elsif rising_edge(SCKi) then
      case State is
        when IniSt => nCS    <='0';
                      state <= GetD;
                      SCKN  <= (others => '0');

        when GetD  => if (SCKN = 15) then
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
      streamD0<= (OTHERS =>'0');
      streamD1<= (OTHERS =>'0');
      AD0REG  <= (others => '0');
      AD1REG  <= (others => '0');
    elsif falling_edge(SCKi) then
      case State is
        when GetD  => streamD0 <= streamD0(streamD0'high-1 downto 0) & D0;
                      streamD1 <= streamD1(streamD1'high-1 downto 0) & D1;

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
