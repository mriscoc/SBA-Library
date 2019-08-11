--------------------------------------------------------------------------------
-- DEMO
--
-- Title: DEMO IP Core for SBA
--
-- Version: 0.3
-- Date: 2019/08/11
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/DEMO
--
-- Description: Simple demo vhd file, the design units in this file can be used
-- as template for create new IP Cores.
--
-- Follow SBA v1.2 Guidelines
--
--------------------------------------------------------------------------------
-- For Copyright and release notes please refer to:
-- https://github.com/mriscoc/SBA-Library/tree/master/DEMO/readme.md
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


