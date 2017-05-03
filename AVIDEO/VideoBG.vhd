--------------------------------------------------------------------------------
-- File Name: VideoBG.vhd
-- Title: Background display layer
-- Version: 0.4
-- Date: 2016/12/02
-- Author: Miguel A. Risco Castillo
-- Description: Background static elements
-- Notes: Put here all the not dinamic elements
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Videopackage.all;
use work.BitMapROMPackage.all;
use work.Txt16x16ROMPackage.all;

entity Background is
    Generic(VParams:TVideoParams:=VGAParams);
    Port ( RST_I : in STD_LOGIC;
           CLK_I : in STD_LOGIC;
           VD_I  : in TVData;
           VD_O  : out TVData
         );
end Background;

architecture Behavioral of Background is

constant Boxes : TBoxArray(0 to 3):=(
    ((299,99,26,9),(255,0,0),'0'),
    ((299+10,99,26,9),(16,255,0),'0'),
    ((299+20,99,26,9),(255,255,0),'0'),
    ((299+30,99,26,9),(16,0,255),'0')
    );

type Tlabel is record
  Point : TPoint;
  Color : TColor;
  caption : string(1 to 15);
end record;
type TLabelArray is array (integer range <>) of TLabel;

constant labels : TLabelArray (0 to 5) :=(
   ((10,10),clwhite,   "POWER AMP VOLT:"),
   ((10,50),clred,     "POWER AMP CURR:"),
   ((10,90),clLime,    "PRE AMP VOLT  :"),
   ((10,130),clSkyBlue,"APLICATOR VOLT:"),
   ((10,210),clyellow, "PROCESS       :"),
   ((10,250),clViolet, "INFORMATION   :")
);

constant fcolor :tcolor := clwhite;
constant bcolor :tcolor := (0,8,16);

constant ImgBox : TBox:=((430,160,Num5x7Rom'Length(2),Num5x7Rom'Length(1)),(255,255,255),'1');

signal TxtPixel : std_logic;
signal TxtColor : TColor;

begin

VGADataProc: process(CLK_I) --(VD_I.X,VD_I.Y)
variable P:std_logic_vector(7 downto 0);

begin
  if rising_edge(CLK_I) then

-- Get previous layer values
    VD_O<=VD_I;

-- default background
    VD_O.Color <= bcolor;

--  frame lines
    if (VD_I.X=0) or
       (VD_I.Y=0) or
       (VD_I.X=VParams.H_ACT-1) or
       (VD_I.Y=VParams.V_ACT-1) then
      VD_O.Color <= clwhite;
    end if;

-- Monocromatic Image box  // Con transparencia indicada por el valor 0
    if IsBox(VD_I,ImgBox) and (Num5x7Rom(VD_I.Y-ImgBox.Rect.T,VD_I.X-ImgBox.Rect.L)/='0') then
       VD_O.Color <= ImgBox.Color;
    end if;

-- Boxes
    for I in Boxes'low to Boxes'high loop
        if IsBox(VD_I,Boxes(I)) then
           VD_O.Color <= Boxes(I).Color;
        end if;
    end loop;

-- Labels
    if TxtPixel/='0' then
      VD_O.Color <= TxtColor; --fcolor;
    end if;

  end if;

end process VGADataProc;

LabelsProc: Process (VD_I)
variable TxtPos : TPoint;
variable TxtStr : String (Labels(0).caption'range);
variable inrec  : boolean;
begin
  TxtPos := (0,0);
  TxtStr := (others => ' ');
  TxtColor <= clRed;
  inrec  := false;
  For I in Labels'low to Labels'high loop
    if IsRect(VD_I,Labels(I).Point.Y,Labels(I).Point.X,ChrW*Labels(I).caption'length,ChrH) then
      TxtPos := Labels(I).Point;
      TxtStr := Labels(I).caption;
      TxtColor <= Labels(I).color;
      inrec  := true;
    end if;
  end loop;

  if (inrec) then
    TxtPixel <=StrPx(VD_I.X-TxtPos.X,VD_I.Y-TxtPos.Y,TxtStr);
  else
    TxtPixel <= '0';
  end if;

end process LabelsProc;

end Behavioral;
