--------------------------------------------------------------------------------
--
-- RAM
--
-- Title: Generic RAM for SBA
-- Version 1.0
-- Date: 2019/07/29
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/RAM
--
-- Description: RAM core, allows to infer internal RAM Blocks for most of FPGA
-- families
--------------------------------------------------------------------------------
-- For Copyright and release notes please refer to:
-- https://github.com/mriscoc/SBA-Library/tree/master/RAM/readme.md
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity RAM is
generic(
      width:positive:=8;
      depth:positive:=8
     );
port (
      -- SBA Bus Interface
      CLK_I : in std_logic;
      RST_I : in std_logic;
      WE_I  : in std_logic;
      STB_I : in std_logic;
      ACK_O : out std_logic;         -- Strobe Acknoledge
      ADR_I : in std_logic_vector;
      DAT_I : in std_logic_vector;
      DAT_O : out std_logic_vector
     );
end RAM;

architecture RAM_arch1 of RAM is

constant iMax : integer := (2**depth)-1;
type TRam is array (0 to iMax) of std_logic_vector(width-1 downto 0);
signal RAM : TRam;
signal ADRI: integer range 0 to iMax;
signal ACKi: std_logic;

begin

RAMProc: process(CLK_I) is
begin
  if rising_edge(CLK_I) then
    if (STB_I='1') and (WE_I='1') then
      RAM(ADRI) <= DAT_I(width-1 downto 0);
    end if;
  end if;
end process;

ACKProc: Process (RST_I,CLK_I) is
begin
  if (RST_I='1') then
    ACKi <= '1';
  elsif rising_edge(CLK_I) then
    if (STB_I='1') and (WE_I='0') then     -- Wait 1 cycle when Read from RAM
      ACKi <= '0';
    else
      ACKi <= '1';
    end if;
  end if;
end process;

ADRI  <= to_integer(resize(unsigned(ADR_I),depth));
DAT_O <= std_logic_vector(resize(unsigned(RAM(ADRI)),DAT_O'length));
ACK_O <= ACKi;

end architecture RAM_arch1;

