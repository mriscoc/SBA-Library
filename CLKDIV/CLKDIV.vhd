--------------------------------------------------------------------------------
--
-- CLKDIV
--
-- Title=CLKDIV is an IPCore for divide an Input clock signal
--
-- Version: 4.5
-- Date: 2017/03/22
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/CLKDIV
--
-- Description = CLKDIV automatically calculate the divider for give an
-- 'outfrec'. 'infrec' is the frequency of the input clock
--
-- Follow SBA v1.1 Guidelines
--
-- Release Notes:
--
-- v4.5 2017/03/22
-- Correct bug in debug generic type (positive to natural)
--
-- v4.4 2015/05/26
-- Start to follow SBA v1.1 guidelines, remove SBAconfig dependency
--
-- v4.3 2011-04-12
-- Debug messages, change variables to signals to improve performance
--
-- v4.2 2010-10-14
-- Change Config file from SBA_package to SBA_config
--
-- v4.1 2010-09-21
-- Improve calc divider for guarantee equal or lower frequencies
--
-- v4.0 2010-08-03
-- Synchronous Reset
--
-- v3.0 2009-09-24
-- Initial release.
--
--------------------------------------------------------------------------------
-- Copyright:
--
-- (c) Miguel A. Risco-Castillo
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
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ClkDiv is
generic (
 infrec:positive:=50E6;         -- 50MHz default system frequency
 outfrec:positive:=1000;        -- 1KHz output frequency
 debug:natural:=1               -- Debug mode 1=on, 0:off
);
port (
    CLK_I : in std_logic;
    RST_I : in std_logic;
    CLK_O : out std_logic
);
end ClkDiv;

architecture clkdiv_arch of ClkDiv is
signal Q : std_logic;
signal Y : integer;
signal YP: integer;

constant M : integer := integer(real(infrec)/real(2*outfrec)+0.499)-1;

begin

 process (CLK_I,RST_I)
 begin
   if rising_edge(CLK_I) then
     if RST_I = '1' then
       if (debug=1) then
         report "CLKDiv Div: " & integer'image(M) & " outfrec: " & real'image(real(infrec)/real(2*(M+1)));
       end if;
       Y <= 0;
       Q <='0';
     elsif Y=M then
       Y <= 0;
       Q <= not Q;
     else 
       Y <= YP;
     end if;
   end if;
 end process;

 YP<=Y+1; 
 CLK_O<=Q;

end clkdiv_arch;
