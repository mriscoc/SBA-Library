--------------------------------------------------------------------------------
-- File Name: DMuxLayer.vhd
-- Title: Layer Video enable Demultiplexer
-- Version: 0.1
-- Date: 2017/04/15
-- Author: Miguel A. Risco Castillo
-- Description: STB enable Demultiplexer for layer selection
--------------------------------------------------------------------------------
-- Copyright:
--
-- This code, modifications, derivate work or based upon, can not be used or
-- distributed without the complete credits on this header.
--
-- The copyright notices in the source code may not be removed or modified.
-- If you modify and/or distribute the code to any third party then you must not
-- veil the original author. It must always be clearly identifiable.
--
-- Although it is not required it would be a nice move to recognize my work by
-- adding a citation to the application's and/or research. If you use this
-- component for your research please include the appropriate credit of Author.
--
-- FOR COMMERCIAL PURPOSES REQUEST THE APPROPRIATE LICENSE FROM THE AUTHOR.
--
-- For non commercial purposes this version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity DMuxLayer  is
Generic(NLAYER:positive:=6);
port(
   STB_I: in std_logic;                               -- Address Enabler
   ADR_I: in std_logic_vector;                        -- Address input Bus
   STB_O: out std_logic_vector(NLAYER-1 downto 0)     -- Strobe Chips selector
);
end DMuxLayer;

architecture DMuxLayer_Arch of DMuxLayer is

signal STBi : std_logic_vector(STB_O'range);
constant n : positive := integer(log2(real(NLAYER)));

begin

ADDRProc:process(ADR_I(n downto 0))

  function stb(val:natural) return std_logic_vector is
  variable ret : unsigned(NLAYER-1 downto 0);
  begin
    ret:=(0 => '1', others=>'0');
    return std_logic_vector((ret sll (val)));
  end;

begin
  STBi <= stb(to_integer(unsigned(ADR_I(n downto 0))));
end process;

  STB_O <= STBi When STB_I='1' else (others=>'0');

end DMuxLayer_Arch;
