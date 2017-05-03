-- File Name: VideoLayers.vhd
-- Title: Video Layer Stack for AVideo
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

entity LayerStack is
port(
-- SBA Interface
  RST_I : in  std_logic;         -- active high reset
  CLK_I : in  std_logic;         -- Main System clock
  STB_I : in  std_logic;         -- Strobe/ChipSelect, active high
  WE_I  : in  std_logic;         -- Bus write enable: active high, Read: active low
  ADR_I : in  std_logic_vector;  -- Address bus
  DAT_I : in  std_logic_vector;  -- Data input bus
-- Analog Video Interface;
  VCK_I : in std_logic;          -- Video Clock
  VD_I  : in TVData;             -- Video data in
  VD_O  : out TVData             -- Video data out
);
end LayerStack;

architecture arch of LayerStack is

constant NLAYER : integer := 5;
signal VDatai : TVDataArray(0 to NLAYER);
signal STBi   : std_logic_vector(NLAYER-1 downto 0);

signal Boxes : TBoxArray(0 to 4);
signal BoxColor : TColor;

begin

  BoxColor <= Pal2Col(CGAPallete(to_integer(unsigned(DAT_I(3 downto 0))))) when STBi(0)='1';
  Boxes(0)<=((4,258,65,26),BoxColor,'0');
  Boxes(1 to 4)<=(
    ((5+22,258+2*16,2,2),clwhite,'1'),
    ((45+22,258+2*16,2,2),clwhite,'1'),
    ((85+22,258+2*16,2,2),clwhite,'1'),
    ((125+22,258+2*16,2,2),clwhite,'1')
    );

  BoxesLayer:entity work.BoxesLayer
  Port map (
    -- Box Data
    Boxes => Boxes,
    -- Video interface
    VCK_I => VCK_I,
    VD_I  => VDatai(0),
    VD_O  => VDatai(1)
  );

  NumDsply: entity work.NumberLayer
  generic map(
    (260,5),
	(255,96,32)
  )
  port map(
    -------------
    RST_I => RST_I,
    CLK_I => CLK_I,
    STB_I => STBi(1),
    WE_I  => WE_I,
    DAT_I => DAT_I,
    -------------
    VCK_I => VCK_I,
    VD_I  => VDatai(1),
    VD_O  => VDatai(2)
  );

  NumDsply2: entity work.NumberLayer
  generic map(
    (260,45),
	(255,96,32)
  )
  port map(
    -------------
    RST_I => RST_I,
    CLK_I => CLK_I,
    STB_I => STBi(2),
    WE_I  => WE_I,
    DAT_I => DAT_I,
    -------------
    VCK_I => VCK_I,
    VD_I  => VDatai(2),
    VD_O  => VDatai(3)
  );

  NumDsply3: entity work.NumberLayer
  generic map(
    (260,85),
	(255,96,32)
  )
  port map(
    -------------
    RST_I => RST_I,
    CLK_I => CLK_I,
    STB_I => STBi(3),
    WE_I  => WE_I,
    DAT_I => DAT_I,
    -------------
    VCK_I => VCK_I,
    VD_I  => VDatai(3),
    VD_O  => VDatai(4)
  );

  NumDsply4: entity work.NumberLayer
  generic map(
    (260,125),
	(255,96,32)
  )
  port map(
    -------------
    RST_I => RST_I,
    CLK_I => CLK_I,
    STB_I => STBi(4),
    WE_I  => WE_I,
    DAT_I => DAT_I,
    -------------
    VCK_I => VCK_I,
    VD_I  => VDatai(4),
    VD_O  => VDatai(5)
  );

DML:entity work.DMuxLayer
  generic map(NLAYER=>NLAYER)
  port map(
    STB_I => STB_I,
    ADR_I => ADR_I,
    STB_O => STBi
  );

-- Video Data Chain
VDatai(0) <= VD_I;
VD_O <= VDatai(NLAYER);

end arch;
