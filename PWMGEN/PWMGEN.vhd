--------------------------------------------------------------------------------
--
-- PWMGEN
--
-- Title: PWM Generator for SBA
-- Version 1.0
-- Date: 2017/03/27
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/PWMGEN
--
-- Description: Generic Pulse Width Modulation Generator for use with SBA, the
-- duty cycle value is choosen by writting in to the DC register of the
-- corresponding channel. Use ADR_I to select the channel and DAT_I to write to
-- the DC register. The resolution of the PWM is 10 bits = 1024
--
-- Generics:
-- chans: number of output channels PWM_O
-- pwmfreq: frequency of the output PWM signal
-- sysfrec: frequency of the main clock in hertz
-- debug: debug flag, 1:print debug information, 0:hide debug information
--
-- SBA interface:
-- ADR_I: select the channel to write.
-- DAT_I: the value of the duty cycle in steps of 10 bits
--
-- Release Notes:
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

Entity PWMGEN is
generic (
  chans:positive:=16;
  pwmfreq:positive:=10E3;
  sysfrec:positive:=50E6;
  debug:natural:=1
  );
port (
  -- SBA Bus Interface
  CLK_I : in std_logic;            -- SBA Main System Clock
  RST_I : in std_logic;            -- SBA System reset
  WE_I  : in std_logic;            -- SBA Write/Read Enable control signal
  STB_I : in std_logic;            -- SBA Strobe/chip select
  ADR_I : in std_logic_vector;     -- SBA Address bus / Register select
  DAT_I : in std_logic_vector;     -- SBA Data input bus / Duty cycle register
  -- PORT Interface;
  PWM_O : out std_logic_vector(chans-1 downto 0)  -- PWM output Channels
  );
end PWMGEN;

Architecture PWMGEN_Arch of PWMGEN is

constant MAXCOUNT:integer:=integer(real(sysfrec)/(1024.0*real(pwmfreq)))-1;
type tCNT is array (0 to chans-1) of unsigned(9 downto 0);
signal DC,CNT:tCNT;
signal E:std_logic;

begin

StepProcess :process (CLK_I,RST_I)               -- PWM step process
variable Wcnt : integer range 0 to MAXCOUNT;
begin
  if RST_I='1' then
    E <= '0';
    Wcnt := 0;
    if (debug=1) then
     report "Real PWM frequency: " & real'image(  real(sysfrec)/(1024.0*real(MAXCOUNT+1))   );
    end if;
  elsif rising_edge(CLK_I) then
    if Wcnt < MAXCOUNT then
       E <= '0';
       Wcnt := Wcnt+1;
    else
       E <= '1';
       Wcnt := 0;
    end if;
  end if;
end process StepProcess;

DCRegProcess : process (CLK_I,RST_I,STB_I,WE_I)  -- SBA write to DC process
variable Ch:integer range 0 to chans-1;
begin
  if RST_I='1' then
    DC <=(others=>(others=>'0'));
  elsif rising_edge(CLK_I) then
    if (STB_I='1') and (WE_I='1') then
      Ch := to_integer(unsigned(ADR_I));
      DC(Ch) <= unsigned(DAT_I(DC(0)'range));
    end if;
  end if;
end process DCRegProcess;

CHANSGEN : for i in 0 to chans-1 generate

  CountProcess : process (CLK_I,RST_I,E)         -- Count process
  begin
    if RST_I='1' then
      CNT(i) <= (others=>'0');
    elsif rising_edge(CLK_I) then
      if (E='1') then
        CNT(i) <= CNT(i)+1;
      end if;
    end if;
  end process CountProcess;

--  PWMProcess : process (CNT,DC)                -- BAD alternative PWM output process
--  begin
--    if (CNT(i)<DC(i)) then
--      PWM_O(i)<='1';
--    else
--      PWM_O(i)<='0';
--    end if;
--  end process PWMProcess;

  PWMProcess : process (CLK_I,RST_I)             -- PWM output process
  begin
    if RST_I='1' then
      PWM_O(i)<='0';
    elsif rising_edge(CLK_I) then
      if (CNT(i)=0) then
        PWM_O(i)<='1';
      end if;
      if (CNT(i)=DC(i)) then
        PWM_O(i)<='0';
      end if;
    end if;
  end process PWMProcess;

end generate CHANSGEN;

end PWMGEN_Arch;
