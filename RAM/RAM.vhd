-----------------------------------------------------------
-- SBAram.vhd
-- Generic RAM for SBA v1.0 (Simple Bus Architecture)
-- Infer internal RAM Blocks for the most FPGA families
--
-- Version 0.3
-- Date: 20120612
-- 
-- Miguel A. Risco Castillo
-- email: mrisco@gmail.com
-- web page: http://mrisco.accesus.com
--
-- Notes:
-- v0.3
-- Configurable width and depth bits, the width must be
-- equal or lower the SBA Data bus width
--
-- v0.2
-- Minor changes in address and ACK_O signals
--
-- v0.1
-- Inspirated by DOULOS - designer: JK (2008)
--
-- This version is released under the GNU/GLP license
-- if you use this component for your research please
-- include the appropriate credit of Author.
-- For commercial purposes request the appropriate
-- license from the author.
-- 
-----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.SBA_package.all;

entity SBAram is
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
end SBAram;

architecture arch1 of SBAram is

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

end architecture arch1;