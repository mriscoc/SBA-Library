--------------------------------------------------------------------------------
--
-- GPIO
--
-- Title: General Purpose Input Output IP-Core for SBA
-- Version 2.4.2
-- Date: 2019/12/16
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/GPIO
--
-- Description: Generic Input/Output parallel port,
-- Inputs and Outputs are latched on rising edge of CLK.
--
--------------------------------------------------------------------------------
-- For Copyright and release notes please refer to:
-- https://github.com/mriscoc/SBA-Library/tree/master/GPIO/readme.md
--------------------------------------------------------------------------------

Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity GPIO is
generic (size:positive:=8);
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
end GPIO;

Architecture GPIO_Arch of GPIO is
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

end GPIO_Arch;
