--------------------------------------------------------------------------------
-- File Name: Videopkg.vhd
-- Title: SBA Analog Video Package
-- Version: 0.3
-- Date: 2016/11/28
-- Author: Miguel A. Risco Castillo
-- web page: http://sba.accesus.com
--
-- Description and Notes:
-- Package with functions and constants definitions for the SBA analog
-- video system.
--
-- 24bits RGB Color
-- Resolutions, Video Clock:
-- VGA 640x480, 25MHz
-- SVGA 800x600, 50MHz
-- XGA 1024x768, 65MHz
-- XGA+ 1152x864, 108MHz
-- WXGA 1280x800, 83.46MHz
-- SXGA 1280x1024, 108MHz
-- HD 1366x768
-- WXGA+ 1440x900
--
--------------------------------------------------------------------------------
-- This version is released under the GNU/GLP license
-- if you use this component for your research please
-- include the appropriate credit of Author.
-- For commercial purposes request the appropriate
-- license from the author.
--------------------------------------------------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package Videopackage is

constant MAXWIDTH  : integer := 1920;  -- Maximum Screen Width (FHD)
constant MAXHEIGHT : integer := 1080;  -- Maximun Screen Height (FHD)

type TVideoParams is record
  VCLK    : integer;
-- Horizontal  Parameter
  H_ACT   : integer;
  H_FRONT : integer;
  H_SYNC  : integer;
  H_BACK  : integer;
-- Vertical Parameter
  V_ACT   : integer;
  V_FRONT : integer;
  V_SYNC  : integer;
  V_BACK  : integer;
end record;

--VGA 640x480
constant VGAParams : TVideoParams := (
  VCLK    => 25e6,
-- Horizontal  Parameter
  H_ACT   => 640,
  H_FRONT => 16,
  H_SYNC  => 96,
  H_BACK  => 48,
-- Vertical Parameter
  V_ACT   => 480,
  V_FRONT => 11, --10,
  V_SYNC  => 2,
  V_BACK  => 31 --33
);

--SVGA 800x600
constant SVGAParams : TVideoParams := (
  VCLK    => 50e6,
-- Horizontal  Parameter
  H_ACT   => 800,
  H_FRONT => 56,
  H_SYNC  => 120,
  H_BACK  => 64,
-- Vertical Parameter
  V_ACT   => 600,
  V_FRONT => 37,
  V_SYNC  => 6,
  V_BACK  => 23
);

--XGA 1024x768
constant XGAParams : TVideoParams := (
  VCLK    => 65e6,
-- Horizontal  Parameter
  H_ACT   => 1024,
  H_FRONT => 24,
  H_SYNC  => 136,
  H_BACK  => 160,
-- Vertical Parameter
  V_ACT   => 768,
  V_FRONT => 3,
  V_SYNC  => 6,
  V_BACK  => 29
);

--XGA+ 1152x864
constant XGAPParams : TVideoParams := (
  VCLK    => 108e6,
-- Horizontal  Parameter
  H_ACT   => 1152,
  H_FRONT => 64,
  H_SYNC  => 128,
  H_BACK  => 256,
-- Vertical Parameter
  V_ACT   => 864,
  V_FRONT => 1,
  V_SYNC  => 3,
  V_BACK  => 32
);

--WXGA 1280x800
constant WXGAParams : TVideoParams := (
  VCLK    => 834006e3,
-- Horizontal  Parameter
  H_ACT   => 1280,
  H_FRONT => 64,
  H_SYNC  => 136,
  H_BACK  => 200,
-- Vertical Parameter
  V_ACT   => 800,
  V_FRONT => 1,
  V_SYNC  => 3,
  V_BACK  => 24
);

--SXGA 1280x1024
constant SXGAParams : TVideoParams := (
  VCLK    => 108e6,
-- Horizontal  Parameter
  H_ACT   => 1280,
  H_FRONT => 48,
  H_SYNC  => 112,
  H_BACK  => 248,
-- Vertical Parameter
  V_ACT   => 1024,
  V_FRONT => 1,
  V_SYNC  => 3,
  V_BACK  => 38
);

type TColor is record
    R : integer range 0 to 255;          -- Box Color Red
    G : integer range 0 to 255;          -- Box Color Green
    B : integer range 0 to 255;          -- Box Color Blue
end record;

constant clBlack  : TColor := (0,0,0);
constant clWhite  : TColor := (255,255,255);
constant clRed    : TColor := (255,0,0);
constant clLime   : TColor := (0,255,0);
constant clBlue   : TColor := (0,0,255);
constant clYellow : TColor := (255,255,0);
constant clFuchsia: TColor := (255,0,255);
constant clAqua   : TColor := (0,255,255);

constant clMaroon : TColor := (128,0,0);
constant clGreen  : TColor := (0,128,0);
constant clOlive  : TColor := (128,128,0);
constant clNavy   : TColor := (0,0,128);
constant clPurple : TColor := (128,0,128);
constant clTeal   : TColor := (0,128,128);
constant clGray   : TColor := (128,128,128);
constant clSilver : TColor := (192,192,192);
constant clLtGray : TColor := (192,192,192);
constant clDkGray : TColor := (128,128,128);
constant clSkyBlue: TColor := (166,202,240);
constant clCream  : TColor := (255,251,240);
constant clMedGray: TColor := (160,160,164);
constant clViolet : TColor := (128,128,255);
constant clMoneyGreen: TColor := (192,220,192);

type TPoint is record
  X : integer range 0 to MAXHEIGHT-1;
  Y : integer range 0 to MAXHEIGHT-1;
end record;

type TRect is record
    T : integer range 0 to MAXHEIGHT-1;  -- Box Top
    L : integer range 0 to MAXWIDTH-1;   -- Box Left
    W : integer range 1 to MAXWIDTH-1;   -- Box Width
    H : integer range 1 to MAXHEIGHT-1;  -- Box Height
end record;
type TRectArray is array (integer range <>) of TRect;

type TBox is record
  Rect  : TRect;
  Color : TColor;
  Fill  : Std_logic;
end record;
type TBoxArray is array (integer range <>) of TBox;

type TPallete is Array (integer range 0 to 15) of std_logic_vector(23 downto 0);
constant CGAPallete : TPallete :=(x"000000", x"0000AA", x"00AA00", x"00AAAA", x"AA0000", x"AA00AA", x"AA5500", x"AAAAAA", x"555555", x"5555FF", x"55FF55", x"55FFFF", x"FF5555", x"FF55FF", x"FFFF55", x"FFFFFF");

type TVData is record
    X:integer range 0 to MAXWIDTH;
    Y:integer range 0 to MAXHEIGHT;
    Color:TColor;
    HS:std_logic;
    VS:std_logic;
    BK:std_logic;
end record;
type TVDataArray is Array (integer range <>) of TVData;


  function IsRect(VD:TVData; Rect:TRect) return boolean;
  function IsRect(VD:TVData; T,L,W,H:integer) return boolean;
  function IsEdge(VD:TVData; Rect:TRect) return boolean;
  function IsEdge(VD:TVData; T,L,W,H:integer) return boolean;
  function IsBox(VD:TVData; Box:TBox) return boolean;

  function Pal2Col(Value:std_logic_vector) return Tcolor;

end;

package body Videopackage is

  function IsBox(VD:TVData; Box:TBox) return boolean is
  begin
    if (Box.Fill='1') then
      return isRect(VD,Box.Rect);
    else
      return isEdge(VD,Box.Rect);
    end if;
  end IsBox;

  function IsRect(VD:TVData; Rect:TRect) return boolean is
  begin
    return (VD.X>=Rect.L) and (VD.X< Rect.L + Rect.W) and (VD.Y>=Rect.T) and (VD.Y< Rect.T + Rect.H);
  end IsRect;

  function IsRect(VD:TVData; T,L,W,H:integer) return boolean is
  variable Rect:TRect;
  begin
    Rect.T:=T; Rect.L:=L; Rect.W:=W; Rect.H:=H;
    return IsRect(VD,Rect);
  end;

  function IsEdge(VD:TVData; Rect:TRect) return boolean is
  begin
    return ((VD.X>=Rect.L) and (VD.X<Rect.L + Rect.W) and ((VD.Y=Rect.T) or (VD.Y=Rect.T + Rect.H -1 ))) or
           ((VD.Y>=Rect.T) and (VD.Y<Rect.T + Rect.H) and ((VD.X=Rect.L) or (VD.X=Rect.L + Rect.W -1 )));
  end IsEdge;

  function IsEdge(VD:TVData; T,L,W,H:integer) return boolean is
  variable Rect:TRect;
  begin
    Rect.T:=T; Rect.L:=L; Rect.W:=W; Rect.H:=H;
    return IsEdge(VD,Rect);
  end;

  -- Convert palete value in tcolor
  function Pal2Col(Value:std_logic_vector) return Tcolor is
  variable color:tcolor;
  variable uv:unsigned(23 downto 0);
  begin
    uv:=resize(unsigned(Value),24);
    color.R:=to_integer(unsigned(uv(23 downto 16)));
    color.G:=to_integer(unsigned(uv(15 downto 8)));
    color.B:=to_integer(unsigned(uv(7 downto 0)));
    return color;
  end;


end Videopackage;
