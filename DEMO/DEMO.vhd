--------------------------------------------------------------------------------
--
-- DEMO
--
-- Title: DEMO IP Core for SBA
--
-- Version: 0.2
-- Date: 2016/11/04
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/DEMO
--
-- Description: Simple demo vhd file, the design units in this file can be used
-- as template for create new IP Cores.
--
-- Follow SBA v1.1 Guidelines
--
-- Release Notes:
--
-- v0.2 2016/11/04
-- Added INT_O output and REQUERIMENTS/UserFiles in Ini file
--
-- v0.1 2015/06/19
-- * First release
--
--------------------------------------------------------------------------------
-- Copyright:
--
-- (c) 2008-2015 Miguel A. Risco-Castillo
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

entity DEMO is
generic(
  debug:positive:=1;
  sysfreq:positive:=25E6
);
port(
-- SBA Interface
   RST_I : in  std_logic;         -- active high reset
   CLK_I : in  std_logic;         -- Main System clock
   STB_I : in  std_logic;         -- Strobe/ChipSelect, active high
   WE_I  : in  std_logic;         -- Bus write enable: active high, Read: active low
   ADR_I : in  std_logic_vector;  -- Address bus
   DAT_I : in  std_logic_vector;  -- Data input bus
   DAT_O : out std_logic_vector;  -- Data Output bus
   INT_O : out std_logic;         -- Interrupt request output
-- Example of aditionals interface signals
   P_O   : out std_logic_vector(7 downto 0);  -- Example of output port
   P_I   : in  std_logic_vector(7 downto 0)   -- Example of input port
);
end DEMO;

architecture DEMO_Arch of DEMO is
begin

OutputProcess : process (CLK_I,RST_I)
begin
  if rising_edge(CLK_I) then
    if RST_I='1' then
      P_O <= (others => '0');
    elsif (STB_I='1') and (WE_I='1') then
      P_O <= DAT_I(P_O'range);
    end if;
  end if;
end process OutputProcess;

InputProcess : process (CLK_I,RST_I)
begin
  if rising_edge(CLK_I) then
    DAT_O <= std_logic_vector(resize(unsigned(P_I),DAT_O'length));
  end if;
end process InputProcess;

INT_O <= '0';

end DEMO_Arch;


