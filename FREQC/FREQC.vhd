--------------------------------------------------------------------------------
--
-- FREQC
--
-- Title: Frequency converter for SBA
-- Version 1.3
-- Date: 2017/03/30
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/FREQC
--
-- Description: Generic Frequency converter for use with Voltage to Frequency
-- converters. The IP Core counts the pulses comming in to a port for a
-- specified time window. The value of count is storaged into a internal
-- register. For example, if the input frequency at C_I(0) is 10KHz and the
-- window time is setup to 100ms = 0.1s then, the register at ADR_I=0 will have
-- 10,000 Hz / 0.1 s = 1,000 counts.
--
-- Generics:
-- chans: number of input channels C_I
-- wsizems: size in miliseconds of the counting window
-- sysfrec: frequency of the main clock in hertz
-- debug: debug flag, 1:print debug information, 0:hide debug information
--
-- SBA interface:
-- ADR_I: select the channel to read.
-- DAT_O: has the data of the count for the selected channel
--
-- Release Notes:
--
-- v1.3
-- Added interrupt capability
--
-- v1.2
-- Implementation of process for channel request
--
-- v1.1
-- OutProcess to avoid out of range of REG(ADR_I) in channel request
--
-- v1.0
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

Entity FREQC is
generic (
  chans:positive:=16;
  wsizems:positive:=100;
  sysfreq:positive:=50E6;
  debug:integer:=1
  );
port (
  -- SBA Bus Interface
  CLK_I : in std_logic;            -- SBA Main System Clock
  RST_I : in std_logic;            -- SBA System reset
  WE_I  : in std_logic;            -- SBA Write/Read Enable control signal
  STB_I : in std_logic;            -- SBA Strobe/chip select
  ADR_I : in std_logic_vector;     -- SBA Address bus / Register select
  DAT_O : out std_logic_vector;    -- SBA Data output bus / Register data
  INT_O	: out std_logic;           -- Interrupt request output
  -- PORT Interface;
  C_I   : in std_logic_vector(chans-1 downto 0) -- Input Channels
  );
end FREQC;

Architecture FREQC_Arch of FREQC is

constant MAXCOUNT:integer:=wsizems*integer(real(sysfrec)/real(1000));
type tCNT is array (0 to chans-1) of unsigned(DAT_O'range);
signal REG,CNT:tCNT;
signal T1,T2:std_logic_vector(C_I'range);
signal W:std_logic;
signal CH:integer range 0 to chans-1;

begin

WindowProcess :process (CLK_I,RST_I)             -- Window generator process
variable Wcnt : integer range 0 to MAXCOUNT;
begin
  if RST_I='1' then
    W <= '1';
    Wcnt := 0;
    if (debug=1) then
     report "Clock Window: " & integer'image(MAXCOUNT) & " time: " & real'image(real(MAXCOUNT)/real(sysfrec));
    end if;
  elsif rising_edge(CLK_I) then
    if Wcnt = MAXCOUNT then
       W <= '0';
       Wcnt := 0;
    else
       W <= '1';
       Wcnt := Wcnt+1;
    end if;
  end if;
end process WindowProcess;

CHANSGEN : for i in 0 to chans-1 generate

  InputProcess : process (CLK_I,RST_I)           -- Ext. signal sync process
  begin
    if RST_I='1' then
      T1(i) <= '0';
      T2(i) <= '0';
    elsif rising_edge(CLK_I) then
      T1(i) <= C_I(i);
      T2(i) <= T1(i);
    end if;
  end process InputProcess;

  CountProcess : process (CLK_I,RST_I,W,T2(i))   -- Count process
  begin
    if RST_I='1' then
      REG(i) <= (others=>'0');
      CNT(i) <= (others=>'0');
    elsif rising_edge(CLK_I) then
      if W='0' then
        REG(i) <= CNT(i);
        CNT(i) <= (others=>'0');
      elsif (T1(i)='0') and (T2(i)='1') then     -- T1<>T2 and T2=1, edge detection
        CNT(i) <= CNT(i)+1;
      end if;
    end if;
  end process CountProcess;

end generate CHANSGEN;

IntProcess : process(CLK_I,RST_I,W,STB_I,WE_I)
begin
  if (RST_I='1') or ((STB_I='1') and (WE_I='0')) then
    INT_O <= '0';
  elsif rising_edge(CLK_I) then
    if W='0' then
      INT_O <= '1';
    end if;
  end if;
end process IntProcess;

selectCHProcess : process(STB_I,WE_I,ADR_I)
begin
  if ((STB_I='1') and (WE_I='0')) then
    CH <= to_integer(unsigned(ADR_I));
  else
    CH <= 0;
  end if;
end process selectCHProcess;

DAT_O <= std_logic_vector(REG(CH));

end FREQC_Arch;
