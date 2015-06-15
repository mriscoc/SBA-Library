--------------------------------------------------------------------------------
--
-- RAM
--
-- Title: Generic RAM for SBA v1.1
-- Version 0.4
-- Date: 2015/06/14
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/RAM
--
-- Description: RAM core, infer internal RAM Blocks for most of FPGA families
--
--
-- Release Notes:
--
-- v0.4 2015/06/14
-- Entity rename from SBARam to RAM
-- Following SBA v1.1 guidelines

-- v0.3 20120612
-- Configurable width and depth bits, the width must be
-- equal or lower the SBA Data bus width
--
-- v0.2
-- Minor changes in address and ACK_O signals
--
-- v0.1
-- Inspirated by DOULOS - designer: JK (2008)
--
--------------------------------------------------------------------------------
-- Copyright:
--
-- (c) 2008-2015 Miguel A. Risco Castillo
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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.SBApackage.all;

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
variable ADRv : integer;
begin
  if rising_edge(CLK_I) then
    if (STB_I='1') then
      ADRv := to_integer(resize(unsigned(ADR_I),depth));
      if (WE_I = '1') then RAM(ADRv) <= DAT_I(width-1 downto 0); end if;
      ADRI <= ADRv;
    end if;
  end if;
end process;

STBProc: Process (RST_I,CLK_I)
begin
  if (RST_I='1') then ACKi<='0';
  elsif rising_edge(CLK_I) then ACKi <= STB_I; end if;
end process;

DAT_O <= std_logic_vector(resize(unsigned(RAM(ADRI)),DAT_O'length));
ACK_O <= '1' When (ACKi='1' and STB_I='1') else '0';

end architecture RAM_arch1;

