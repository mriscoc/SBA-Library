--------------------------------------------------------------------------------
-- File Name: VideoOut.vhd
-- Title: Video Signals Output
-- Version: 0.1
-- Date: 2016/12/21
-- Author: Miguel A. Risco Castillo
-- web page: http://sba.accesus.com
--
-- Description and Notes:
-- Consolidate Video Signals for DAC Output
--
-- This version is released under the GNU/GLP license
-- if you use this component for your research please
-- include the appropriate credit of Author.
-- For commercial purposes request the appropriate
-- license from the author.
--------------------------------------------------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Videopackage.all;

entity VideoOut is
  Generic(
    RGBbits:positive range 1 to 8:=4
  );
  port (
    -- Video Interface
    VD_I     : in TVData;
    -- VGA Interface;
    R  : out std_logic_vector(RGBbits-1 downto 0);
    G  : out std_logic_vector(RGBbits-1 downto 0);
    B  : out std_logic_vector(RGBbits-1 downto 0);
    HS : out std_logic;
    VS : out std_logic
  );
end VideoOut;


architecture Video_Arch of VideoOut is

begin

R <= std_logic_vector(to_unsigned(VD_I.Color.R,8)(7 downto 8-RGBbits)) when (VD_I.BK='1') else (others=>'0');
G <= std_logic_vector(to_unsigned(VD_I.Color.G,8)(7 downto 8-RGBbits)) when (VD_I.BK='1') else (others=>'0');
B <= std_logic_vector(to_unsigned(VD_I.Color.B,8)(7 downto 8-RGBbits)) when (VD_I.BK='1') else (others=>'0');
HS<= VD_I.HS;
VS<= VD_I.VS;

end architecture Video_Arch;

