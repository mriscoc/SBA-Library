--------------------------------------------------------------------------------
-- DPSRam.vhd
-- Generic Dual Port Single clock RAM for SBA v1.1 (Simple Bus Architecture)
--
-- Version 0.4
-- Date: 2018/03/30
--
-- Author:
-- (c) Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- web page: http://mrisco.accesus.com
-- sba webpage: http://sba.accesus.com
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
-- SBA 1.1 Compliant
--
-- Generics: data width bits, address depth bits
--
-- Release Notes:
--
-- v0.4 2018/03/30
-- Add generics for generate registered and unregistered data output versions
--
-- v0.3 2016/02/07
-- Add RST_I line, for SBA v.1.1 compliant
--
-- v0.2 2015/05/28
-- remove ACK lines: not in use
--
-- v0.1 2012/06/12
-- Initial release
-- Inspirated in Altera examples
--
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity DPSram is
generic(
      width:positive:=8;
      depth:positive:=8;
      registered:boolean:=true
     );
port (
      -- SBA Bus Interface
      RST_I  : in std_logic;
      CLK_I  : in std_logic;
      -- Output Port 0
      ADR0_I : in std_logic_vector;
      DAT0_O : out std_logic_vector;
      -- Input Port 1
      STB1_I : in std_logic;
      WE1_I  : in std_logic;
      ADR1_I : in std_logic_vector;
      DAT1_I : in std_logic_vector
     );
end DPSram;

Architecture rtl of DPSram is

constant iMax : integer := (2**depth)-1;
type TRam is array (0 to iMax) of std_logic_vector(width-1 downto 0);
signal RAM : TRam;
signal ADR0i,ADR1i : integer range 0 to iMax;

begin
  -- Input Process Port 1
  process(CLK_I,RST_I)
  begin
    if(rising_edge(CLK_I)) then
	  if (RST_I='0') and (STB1_I='1') and (WE1_I = '1') then
	     RAM(ADR1i) <= DAT1_I(width-1 downto 0);
	  end if;
    end if;
  end process;
	

registered_output: if registered generate
  -- Output Process Port 0
  process(CLK_I)
  begin
    if(rising_edge(CLK_I)) then
	  DAT0_O <= std_logic_vector(resize(unsigned(RAM(ADR0i)),DAT0_O'length));
    end if;
  end process;
end generate;

unregistered_output: if not registered generate
  -- Output Process Port 0
  process(ADR0i)
  begin
    DAT0_O <= std_logic_vector(resize(unsigned(RAM(ADR0i)),DAT0_O'length));
  end process;
end generate;

 ADR0i <= to_integer(unsigned(ADR0_I(depth-1 downto 0)));
 ADR1i <= to_integer(unsigned(ADR1_I(depth-1 downto 0)));

end rtl;

