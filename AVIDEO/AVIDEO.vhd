-- File Name: AVideo.vhd
-- Title: Layered AVideo
-- Version: 0.3
-- Date: 2016/12/19
-- Author: Miguel A. Risco Castillo
-- Description: Layered Analog Video for SBA System
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SBApackage.all;
use work.Videopackage.all;

entity AVideo is
generic (
  sysfreq:positive:=50E6;              -- System frequency
  VParams:TVideoParams:=VGAParams;     -- Select Video Mode
  RGBbits:positive range 1 to 8:=4
);
port(
-- SBA Interface
  RST_I : in  std_logic;               -- active high reset
  CLK_I : in  std_logic;               -- Main System clock
  STB_I : in  std_logic;               -- Strobe/ChipSelect, active high
  WE_I  : in  std_logic;               -- Bus write enable: active high, Read: active low
  ADR_I : in  std_logic_vector;        -- Address bus
  DAT_I : in  std_logic_vector;        -- Data input bus
-- Analog Video Interface;
  R  : out std_logic_vector(RGBbits-1 downto 0);
  G  : out std_logic_vector(RGBbits-1 downto 0);
  B  : out std_logic_vector(RGBbits-1 downto 0);
  HS : out std_logic;
  VS : out std_logic
);
end AVideo;

architecture arch of AVideo is

signal VDatai : TVDataArray(0 to 2);
signal vgaclk : std_logic;

begin
	
  VideoClk: entity work.VideoClockGen
  Generic map(
    sysfreq=>sysfreq,
    VParams=>VGAParams
  )
  port map (
    RST_I => RST_I,
    CLK_I => CLK_I,
    --------------------
    VCK_O => vgaclk
  );

  VideoSync: entity work.VideoSyncGen
  Generic map(
    VParams=>VGAParams
  )
  port map (
    VCK_I => vgaclk,
    RST_I => RST_I,
    --------------------
    VD_O  => VDatai(0)
  );

  BackLayer: entity work.Background
  Generic map(
    VParams=>VGAParams
  )
  port map(
    RST_I => RST_I,
    CLK_I => vgaclk,
    VD_I  => VDatai(0),
    VD_O  => VDatai(1)
  );

  LayerStack: entity work.LayerStack
  port map(
  -- SBA Interface
    RST_I => RST_I,          -- active high reset
    CLK_I => CLK_I,          -- Main System clock
    STB_I => STB_I,          -- Strobe/ChipSelect, active high
    WE_I  => WE_I,           -- Bus write enable: active high, Read: active low
    ADR_I => ADR_I,          -- Address bus
    DAT_I => DAT_I,          -- Data input bus
    -------------
    VCK_I => vgaclk,
    VD_I  => VDatai(1),
    VD_O  => VDatai(2)
  );

  VideoOut:entity work.VideoOut
  generic map(
    RGBbits=>RGBbits
  )
  port map(
    VD_I => VDatai(2),
    R  => R,
    G  => G,
    B  => B,
    HS => HS,
    VS => VS
  );

end arch;
