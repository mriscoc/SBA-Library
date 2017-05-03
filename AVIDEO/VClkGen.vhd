-- File Name: VClkGen.vhd
-- Title: Layered AVideo
-- Version: 0.1
-- Date: 2017/04/18
-- Author: Miguel A. Risco Castillo
-- Description: Analog Video Clock Generator for SBA System
--------------------------------------------------------------------------------
-- Copyright:
--
-- This code, modifications, derivate work or based upon, can not be used or
-- distributed without the complete credits on this header.
--
-- The copyright notices in the source code may not be removed or modified.
-- If you modify and/or distribute the code to any third party then you must not
-- veil the original author. It must always be clearly identifiable.
--
-- Although it is not required it would be a nice move to recognize my work by
-- adding a citation to the application's and/or research. If you use this
-- component for your research please include the appropriate credit of Author.
--
-- FOR COMMERCIAL PURPOSES REQUEST THE APPROPRIATE LICENSE FROM THE AUTHOR.
--
-- For non commercial purposes this version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
--------------------------------------------------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Videopackage.all;

entity VideoClockGen is
  Generic(
    sysfreq:positive:=50E6;             -- System frequency
    VParams:TVideoParams:=VGAParams
  );
  port (
      -- Host Interface
      RST_I    : in std_logic;          -- Main Reset
      CLK_I    : in std_logic;          -- System Clock
      -- Video Interface
      VCK_O    : out std_logic          -- Video Pixel Clock
   );
end VideoClockGen;

architecture VideoClockGen_Arch of VideoClockGen is
signal vclki : std_logic;

begin

-- Video Clock generation
--  vclki <= CLK_I;

VClk: Process (RST_I,CLK_I)
begin
  if RST_I='1' then
    vclki <= '0';
  elsif rising_edge (CLK_I) then
    vclki <= not vclki;
  end if;
end process VClk;

VCK_O <= vclki;

end architecture VideoClockGen_Arch;
