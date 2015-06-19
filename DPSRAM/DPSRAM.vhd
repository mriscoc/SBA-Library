-----------------------------------------------------------
-- DPSRam.vhd
-- Generic Dual Port Single clock RAM for
-- SBA v1.0 (Simple Bus Architecture)
--
-- Version 0.2
-- Date: 20150528
--
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
-- SBA 1.0 Compliant
--
-- Generics: data width bits , address depth bits
--
-- Notes:
--
-- v0.2 20150528
-- remove ACK lines: not in use
--
-- v0.1 20120612
-- Initial release
-- Inspirated in Altera examples
--
-----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity DPSram is
generic(
      width:positive:=8;
      depth:positive:=8
     );
port (
      -- SBA Bus Interface
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
	process(CLK_I)
	begin
		if(rising_edge(CLK_I)) then
			if (STB1_I='1') and (WE1_I = '1') then
				RAM(ADR1i) <= DAT1_I(width-1 downto 0);
			end if;
		end if;
	end process;
	
	-- Output Process Port 0
	process(CLK_I)
	begin
		if(rising_edge(CLK_I)) then
			DAT0_O <= std_logic_vector(resize(unsigned(RAM(ADR0i)),DAT0_O'length));
      end if;
	end process;

	-- Output Process Port 0
--	process(ADR0i)
--	begin
--	  DAT0_O <= std_logic_vector(resize(unsigned(RAM(ADR0i)),DAT0_O'length));
--	end process;

 ADR0i <= to_integer(unsigned(ADR0_I(depth-1 downto 0)));
 ADR1i <= to_integer(unsigned(ADR1_I(depth-1 downto 0)));

end rtl;

