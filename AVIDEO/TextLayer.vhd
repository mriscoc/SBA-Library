--------------------------------------------------------------------------------
-- File Name: TextLayer.vhd
-- Title: textString display layer
-- Version: 0.1
-- Date: 2016/12/19
-- Author: Miguel A. Risco Castillo
-- Description: Display text labels in a Video layer
--------------------------------------------------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.VideoPackage.all;
use work.Txt16x16ROMPackage.all;

entity TextLayer is
    Generic (Loc:TPoint:=(1,1);            -- Location
             Color:TColor:=(0,128,255);    -- Text color
             Caption:String := "TESTLABEL" -- Text
             );
    Port ( -- SBA interface
           RST_I : in STD_LOGIC;
           CLK_I : in STD_LOGIC;
           -- Video interface
           VCK_I : in std_logic;            -- Video Clock
           VD_I  : in TVData;               -- Video data in
           VD_O  : out TVData               -- Video data out
         );
end TextLayer;

architecture Behavioral of TextLayer is

signal TxtPixel : std_logic;

begin

VGADataProc: process(VCK_I) --(VD_I.X,VD_I.Y)
begin
  if rising_edge(VCK_I) then
-- Get previous layer values
    VD_O<=VD_I;

-- overlay
    if (TxtPixel/='0') then
       VD_O.Color <= Color;
    end if;

  end if;
end process VGADataProc;

LabelProc: Process (VD_I)
variable tsel:std_logic;
begin
  tsel := '0';
  if IsRect(VD_I,Loc.Y,Loc.X,ChrW*Caption'length,ChrH) then
      tsel := '1';
  end if;
  if (tsel='1') then
    TxtPixel <=StrPx(VD_I.X-Loc.X,VD_I.Y-Loc.Y,Caption);
  else
    TxtPixel <= '0';
  end if;
end process LabelProc;

end Behavioral;

