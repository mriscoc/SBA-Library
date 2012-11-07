----------------------------------------------------------------
-- SBA SysCon
-- System CLK & Reset Generator
--
-- v0.1
-- 20110410
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
-- Notes:
--
-- v0.1
-- First version
--
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sba_config.all;
use work.sba_package.all;

entity  SysCon  is
port(
   CLK_I: in  std_logic;          -- External Clock input
   CLK_O: out std_logic;          -- System Clock output 
   RST_I: in  std_logic;          -- Asynchronous Reset Input
   RST_O: out std_logic           -- Synchronous Reset Output
);
end SysCon;

architecture SysCon_arch of SysCon is

   Signal CLKi : std_logic;
   Signal RSTi : std_logic;

begin

  process(RST_I, CLKi)
  begin
    if RST_I='1' then
      RSTi<='1';
    elsif rising_edge(CLKi) then
      RSTi<='0';
    end if;
  end process;

  process(RSTi,CLKi)
  begin
    if RSTi='1' then
      RST_O<='1';
    elsif rising_edge(CLKi) then
      RST_O<='0';
    end if;
  end process; 

CLKi  <= CLK_I;                   -- Insert a divider if is needed

CLK_O <= CLKi;
  
end SysCon_arch;
