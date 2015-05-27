----------------------------------------------------
-- SBA GPIO Module
--
-- version 2.2 20120626
--
-- Author:
-- (c) Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- web page: http://mrisco.accesus.com
--
--
-- This code, modifications, derivate
-- work or based upon, can not be used
-- or distributed without the
-- complete credits on this header and
-- the consent of the author.
--
-- This version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
-- if you use this component for your research please
-- include the appropriate credit of Author.
--
-- For commercial purposes request the appropriate
-- license from the author.
--
--
-- Notes
--
-- v2.2
-- Removed dependency of SBA_config
--
-- v2.1
-- Synchronous Reset, SBA 1.0 compliant
---------------------------------------------------

Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity GPIO_Adapter is
generic (size:positive:=4);
port (
  -- SBA Bus Interface
  CLK_I : in std_logic;
  RST_I : in std_logic;
  WE_I  : in std_logic;
  STB_I : in std_logic;
  DAT_I : in std_logic_vector;
  DAT_O : out std_logic_vector;
  -- PORT Interface;
  P_I   : in std_logic_vector(size-1 downto 0);
  P_O   :out std_logic_vector(size-1 downto 0)
  );
end GPIO_Adapter;

Architecture Arch of GPIO_Adapter is
begin

process (CLK_I,RST_I)
begin
  if rising_edge(CLK_I) then
    if RST_I='1' then
      P_O <= (others => '0');
    elsif (STB_I='1') and (WE_I='1') then
      P_O <= DAT_I(P_O'range);
    end if;
  end if;
end process;

DAT_O <= std_logic_vector(resize(unsigned(P_I),DAT_O'length));

end Arch;