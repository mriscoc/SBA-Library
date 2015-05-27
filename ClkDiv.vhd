--------------------------------------------------------------------------------
-- Company: uE - CIDI - UTP
--
-- File: clkdiv.VHD
-- File history:
--      4.3: 2011-04-12
--      4.2: 2010-10-14
--      4.1: 2010-09-21 
--      4.0: 2010-08-03
--      3.0: 2009-09-24
--
-- Description:
--
-- v4.3 Debug messages, change variables to signals to improve performance 
-- v4.2 Change Config file from SBA_package to SBA_config
-- v4.1 Improve calc divider for guarantee equal or lower frequencies
-- v4.0 Synchronous Reset
-- v3.0 Inital public release.
--
-- Clock divider with generics Module
-- Using SBA_config for frecuency calculation
--
-- Targeted device: Any
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
--------------------------------------------------------------------------------

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SBA_config.all;

entity ClkDiv is
generic (frec:positive:=1000);    --  Means 1KHz
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

constant M : integer := integer(real(sysfrec)/real(2*frec)+0.499)-1;

begin

 process (CLK_I,RST_I)
 begin
   if rising_edge(CLK_I) then
     if RST_I = '1' then
       if (debug=1) then
         report "CLKDiv Div: " & integer'image(M) & " frec: " & real'image(real(sysfrec)/real(2*(M+1)));
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