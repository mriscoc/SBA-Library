--------------------------------------------------------------------------------
--
-- FIBGEN
--
-- Title: Fibonacci IP-Core for SBA
-- Version 1.0.0
-- Date: 2025/08/08
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/FIBGEN
--
-- Description: Simple Fibonacci generator IP block, each member of the series
-- is generated at each read cycle. This core doesn't implement a range check so
-- the ouput can overun if calculated next value do not fit the width of the
-- data bus.
--
--------------------------------------------------------------------------------
-- For Copyright and release notes please refer to:
-- https://github.com/mriscoc/SBA-Library/tree/master/FIBGEN/readme.md
--------------------------------------------------------------------------------

Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity FIBGEN is
generic (size:positive:=8);
port (
  -- SBA Bus Interface
  CLK_I : in std_logic;
  RST_I : in std_logic;
  WE_I  : in std_logic;
  STB_I : in std_logic;
  DAT_O : out std_logic_vector
  );
end FIBGEN;

Architecture FIBGEN_Arch of FIBGEN is

Signal P0, P1, PN :unsigned(15 downto 0) :=  (others => '0');

begin

GenProcess : process (CLK_I,RST_I)
begin
  if rising_edge(CLK_I) then
    if RST_I='1' then
      P0 <= (others => '0');
      P1 <= (0 => '1', others => '0');
    elsif (STB_I='1') and (WE_I='0') then
      P0 <= P1;
      P1 <= PN;
    end if;
  end if;
end process GenProcess;

DAT_O <= std_logic_vector(resize(P0,DAT_O'length));
PN <= P0 + P1;

end FIBGEN_Arch;

