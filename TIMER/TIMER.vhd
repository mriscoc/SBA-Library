--------------------------------------------------------------------------------
--
-- TIMER
--
-- Title: Timer Module for SBA
-- Version 0.2
-- Date: 2017/05/22
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/TIMER
--
-- Description: Generic 32 bits Multiple Timer Module.
-- Base address + 0 is TMRDATL: Timer register less significant word
-- Base address + 1 is TMRDATH: Timer register high significand word
-- Base address + 2 is TMRCFG: Timer config
-- Base address + 3 is TMRCHS: Timer Channel select
--
-- Read TMRCFG bits: TOUT & TMROE & TMRIF & TMRIE & TMREN
-- Write TMRCFG bits: X & TMROE & X & TMRIE & TMREN
-- TOUT : Timer Output
-- TMROE : Timer Output enable
-- TMRIF : Timer Interrupt flag
-- TMRIE : Timer Interrupt enable
-- TMREN : Timer Enable
--
-- Generics:
-- chans: number of timers
--
-- Release Notes:
--
-- v0.2 2017/05/22
-- Added Output Enable control bit, change in IFprocess
--
-- v0.1 2017/05/12
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

Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity TIMER is
generic (
  chans:positive:=4
  );
port (
  -- SBA Bus Interface
  CLK_I : in std_logic;            -- SBA Main System Clock
  RST_I : in std_logic;            -- SBA System reset
  WE_I  : in std_logic;            -- SBA Write/Read Enable control signal
  STB_I : in std_logic;            -- SBA Strobe/chip select
  ADR_I : in std_logic_vector;     -- SBA Address bus / Register select
  DAT_I : in std_logic_vector;     -- SBA Data input bus / Register data
  DAT_O : out std_logic_vector;    -- SBA Data output bus / Register data
  INT_O	: out std_logic;           -- Interrupt request output
  -- PORT Interface;
  TOUT  : out std_logic_vector(chans-1 downto 0) -- Frequency Converter Input Channels
  );
end TIMER;

Architecture TIMER_Arch of TIMER is
constant TMRWIDTH:integer:=32;
type tTMR is array (0 to chans-1) of unsigned(TMRWIDTH-1 downto 0);
signal TMRi,CNTi:tTMR;
signal TOUTi:std_logic_vector(chans-1 downto 0);
signal CH:integer range 0 to chans-1;
signal TMREN:std_logic_vector(chans-1 downto 0); -- Timer Enable
signal TMRIE:std_logic_vector(chans-1 downto 0); -- Timer Interrupt Enable
signal TMRIF:std_logic_vector(chans-1 downto 0); -- Timer Interrupt Flag
signal TMROE:std_logic_vector(chans-1 downto 0); -- Timer Output Enable

constant TMRDATL:integer:=0;
constant TMRDATH:integer:=1;
constant TMRCFG:integer:=2;
constant TMRCHS:integer:=3;

begin

CounterProcess :process (CLK_I,RST_I,TMREN)
begin
  for i in 0 to chans-1 loop
    if (RST_I='1') or (TMREN(i)='0') then
      TOUTi(i)<= '0';
      CNTi(i) <= (CNTi(i)'range=>'0');
    elsif rising_edge(CLK_I) then
      if CNTi(i) >= TMRi(i) then
         if TMROE(i)='1' then TOUTi(i)<=not TOUTi(i); else TOUTi(i)<= '0'; end if;
         CNTi(i) <= (CNTi(i)'range=>'0');
      else
         CNTi(i) <= CNTi(i)+1;
      end if;
    end if;
  end loop;
end process CounterProcess;

IFProcess : process(RST_I,STB_I,WE_I,CNTi,CLK_I,CH)
begin
  if (RST_I='1') then
    TMRIF <= (others=>'0');
  elsif rising_edge(CLK_I) then
    if ((STB_I='1') and (WE_I='0')) then TMRIF(CH) <= '0'; end if;
    for i in 0 to chans-1 loop
      if CNTi(i) = TMRi(i) then
        TMRIF(i) <= TMRIE(i);
      end if;
    end loop;
  end if;
end process IFProcess;

SBAWriteProcess : process(CLK_I,RST_I,STB_I,WE_I,ADR_I)
variable ADRi:integer;
variable CHi:integer;
begin
  if (RST_I='1') then
    CH <= 0;
    TMREN <= (others=>'0');
    TMRIE <= (others=>'0');
    TMROE <= (others=>'0');
    TMRi  <= (others=>(others=>'1'));
  elsif rising_edge(CLK_I) and (STB_I='1') and (WE_I='1') then
    ADRi := to_integer(unsigned(ADR_I(1 downto 0)));
    case ADRi is
       When TMRDATL => TMRi(CH)(15 downto 0 ) <= resize(unsigned(DAT_I),16);
       When TMRDATH => TMRi(CH)(31 downto 16) <= resize(unsigned(DAT_I),16);
       When TMRCFG  => TMROE(CH) <= DAT_I(3); TMRIE(CH) <= DAT_I(1); TMREN(CH) <= DAT_I(0);
       When TMRCHS  => CHi := to_integer(unsigned(DAT_I));
                       if (CHi<chans) then
                         CH <= CHi;
                       else
                         CH <= chans-1;
                       end if;
       When OTHERS  => null;
    end case;
  end if;
end process SBAWriteProcess;

SBAReadProcess : process(RST_I,STB_I,WE_I,ADR_I,CH,CNTi,TMROE,TMRIF,TMRIE,TMREN,TOUTi)
variable ADRi:integer;
begin
  if (RST_I='0') and (STB_I='1') and (WE_I='0') then
    ADRi := to_integer(unsigned(ADR_I(1 downto 0)));
    case ADRi is
       When TMRDATL => DAT_O <= std_logic_vector(resize(CNTi(CH)(15 downto 0 ),DAT_O'length));
       When TMRDATH => DAT_O <= std_logic_vector(resize(CNTi(CH)(31 downto 16),DAT_O'length));
       When TMRCFG  => DAT_O <= (DAT_O'length-1 downto 5=>'0')&TOUTi(CH)&TMROE(CH)&TMRIF(CH)&TMRIE(CH)&TMREN(CH);
       When TMRCHS  => DAT_O <= std_logic_vector(to_unsigned(CH,16));
       When OTHERS  => DAT_O <= (DAT_O'range=>'X');
    end case;
  else
    DAT_O <= (DAT_O'range=>'X');
  end if;
end process SBAReadProcess;

TOUT <= TOUTi;
INT_O <= '0' when TMRIF=(TMRIF'range=>'0') else '1';

end TIMER_Arch;
