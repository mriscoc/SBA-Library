--------------------------------------------------------------------------------
--
-- EASYDRV
--
-- Title: Easy Driver step motor adapter for SBA
-- Version 1.2
-- Date: 2017/04/10
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/EASYDRV
--
-- Description: SBA Simple step motor adapter for Easy Driver and similar
-- hardware. The IP Core have a register where the current position (currpos) is
-- storage, this register can be reset internally using the corresponding bit
-- in the control register or externally using the input port RSTPOS.
-- Writing to the set position register (setpos) instruct to the adapter to
-- source the appropriate signals trough the DIR and STEP outputs to achieve the
-- new position. When the step motor arrive to the destiny position a flag
-- (INTSTUS) is set to '1' in the status register and reset when the status
-- register is readed. The IP Core controls the STEP speed and acceleration.
--
-- Generics:
-- minspd: minimum step/second speed
-- maxspd: maximum step/second speed
-- sysfrec: frequency of the main clock in hertz
-- debug: debug flag, 1:print debug information, 0:hide debug information
--
-- SBA interface:
-- ADR_I = 0 : Read: Status Register; Write: Set Position
-- ADR_I = 1 : Read: Current Position; Write: Control Register
--
-- Release Notes:
--
-- v1.2 2017/04/10
-- ENABLE output is active low, added INTSTUS flag.
--
-- v1.1 2017/04/10
-- Added SBARead process
--
-- v1.0 2017/04/07
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

Entity EASYDRV is
generic (
  minspd:positive:=5;             -- Minimum step/second speed
  maxspd:positive:=1000;          -- Maximum step/second speed
  sysfrec:positive:=50E6;         -- System frequency
  debug:natural:=1                -- Debug
  );
port (
  -- SBA Bus Interface
  CLK_I : in std_logic;           -- SBA Main System Clock
  RST_I : in std_logic;           -- SBA System reset
  WE_I  : in std_logic;           -- SBA Write/Read Enable control signal
  STB_I : in std_logic;           -- SBA Strobe/chip select
  ADR_I : in std_logic_vector;    -- SBA Address bus / Register select
  DAT_I : in std_logic_vector;    -- SBA Data input bus / Write Control/Position
  DAT_O : out std_logic_vector;   -- SBA Data output bus / Read Status/Position
  INT_O	: out std_logic;          -- Interrupt request output
  -- PORT Interface;
  nENABLE: out std_logic;         -- EASYDRIVER enable outputs, active low
  DIR    : out std_logic;         -- EASYDRIVER direction
  STEP   : out std_logic;         -- EASYDRIVER step
  RSTPOS : in std_logic           -- Force reset position input
  );
end EASYDRV;

Architecture EASYDRV_Arch of EASYDRV is

constant maxdly:integer:=integer(real(sysfrec)/(2.0*real(minspd)));
constant mindly:integer:=integer(real(sysfrec)/(2.0*real(maxspd)));
constant incdly:integer:=integer(real(maxdly-mindly)/300.0);

type tMotSt is (MIdle, MUp, MDw, MArrive);
signal MotSt:tMotSt;
signal currPos,setPos:integer range -65535 to 65535;
signal controlReg,statusReg:std_logic_vector(DAT_I'range);
signal rsti,stepi,diri,enablei:std_logic;
signal currdly:integer range mindly-incdly to maxdly;

alias RSTCTRL : std_logic is controlReg(0);
alias ENACTRL : std_logic is controlReg(1);

alias RSTSTUS : std_logic is statusReg(0);
alias ENASTUS : std_logic is statusReg(1);
alias ACTSTUS : std_logic is statusReg(2);
alias DIRSTUS : std_logic is statusReg(3);
alias INTSTUS : std_logic is statusReg(4);

impure function deltaPos return integer is
begin
  return (currPos-setPos);
end function deltaPos;

begin

DebugProcess:process(RST_I)
begin
  if (debug=1) and (RST_I='0') then
     report "Min steps by second: " & real'image(real(sysfrec)/(2.0*real(maxdly))) & " Max delay:" & integer'image(maxdly);
     report "Max steps by second: " & real'image(real(sysfrec)/(2.0*real(mindly))) & " Min delay:" & integer'image(mindly);
  end if;
end process DebugProcess;

StpDlyProcess:process(MotSt,enablei,CLK_I)               -- Step delay process
variable cntdly:integer range 0 to maxdly;
begin
  if (MotSt=MIdle) or (enablei='0') then
    stepi <= '1';
    cntdly := 0;
  elsif rising_edge(CLK_I) then
    if cntdly = currdly then
      stepi<=not stepi;
      cntdly:=0;
    else
      cntdly:=cntdly+1;
    end if;
  end if;
end process StpDlyProcess;

ThrottleProcess:process(MotSt,stepi)
begin
  if (MotSt=MIdle) then
    currdly<=maxdly;
  elsif rising_edge(stepi) then
    if currdly>mindly then
      currdly<=currdly-incdly;
    end if;
  end if;
end process ThrottleProcess;

MotStProcess:process(RST_I,CLK_I)                -- Step move motor
begin
  if (RST_I='1') then
    MotSt <= MIdle;
  elsif rising_edge(CLK_I) then
    case MotSt is
      when MIdle =>
        if deltaPos>0 then MotSt <= MDw;
        elsif deltaPos<0 then MotSt <= MUp;
        end if;
      when MUp   =>
        if (deltaPos>0) then MotSt <= MIdle;
        elsif (deltaPos=0) then MotSt <= MArrive;
        end if;
      when MDw   =>
        if (deltaPos<0) then MotSt <= MIdle;
        elsif (deltaPos=0) then MotSt <= MArrive;
        end if;
      when Others =>
        MotSt <= MIdle;
    end case;
  end if;
end process MotStProcess;

DirProcess:process(MotSt)                        -- Direction
begin
  case MotSt is
    when MUp    => diri <= '1';
    when MDw    => diri <= '0';
    when Others => diri <= '1';
  end case;
end process DirProcess;

PositionProcess:process(rsti,stepi)
begin
  if (rsti='1') then
    currPos<=0;
  elsif rising_edge(stepi) then
    case MotSt is
      when MUp => currPos <= currPos+1;
      when MDw => currPos <= currPos-1;
      when others => currPos <= currPos;
    end case;
  end if;
end process PositionProcess ;

-- ADR_I = 0 : Read: Status Register; Write: Set Position
-- ADR_I = 1 : Read: Current Position; Write: Control Register
SBAWriteProcess : process (RST_I,rsti,CLK_I)
begin
  if RST_I='1' then
    ControlReg <= (others=>'0');
  elsif rsti='1' then
    setPos <= 0;
  elsif rising_edge(CLK_I) then
    if (STB_I='1') and (WE_I='1') then
      Case ADR_I(0) is
        When '0' => setPos <= to_integer(signed(DAT_I));
        When '1' => controlReg <= DAT_I;
        When Others => null;
      end case;
    end if;
  end if;
end process SBAWriteProcess;

SBAReadProcess : process(ADR_I(0))
begin
  case ADR_I(0) is
      When '0' => DAT_O <= statusReg;
      When '1' => DAT_O <= std_logic_vector(to_unsigned(currPos,DAT_O'length));
      When Others => DAT_O <= (DAT_O'range=>'-');
  end case;
end process SBAReadProcess;

IntProcess : process(CLK_I,RST_I,STB_I,WE_I,ADR_I(0))
begin
  if (RST_I='1') then
    INTSTUS <= '0';
  elsif rising_edge(CLK_I) then
    if (MotSt=MArrive) then
      INTSTUS <= '1';
    elsif ((STB_I='1') and (WE_I='0') and (ADR_I(0)='0')) then
      INTSTUS <= '0';
    end if;
  end if;
end process IntProcess;

rsti <= RSTPOS or RSTCTRL or RST_I;
enablei <= ENACTRL and not rsti;

RSTSTUS <= rsti;
ENASTUS <= enablei;
DIRSTUS <= diri;
ACTSTUS <= '0' When (MotSt=MIdle) else '1';

INT_O <= INTSTUS;
STEP  <= stepi;
DIR   <= diri;
nENABLE <= not enablei;

end EASYDRV_Arch;
