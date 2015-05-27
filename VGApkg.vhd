library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

package VGApkg is

constant SWIDTH  : integer := 640;  -- Screen Width
constant SHEIGHT : integer := 480;  -- Screen Height

type VDataType is record
    X:integer range 0 to SWIDTH;
    Y:integer range 0 to SHEIGHT;
    R:integer range 0 to 255;
    G:integer range 0 to 255;
    B:integer range 0 to 255;
    HS:std_logic;
    VS:std_logic;
    BK:std_logic;
end record;
type VDataArray is Array (integer range <>) of VDataType;

type BoxType is   --array (0 to 6) of integer;
  record
     T : integer range 0 to SHEIGHT-1;  -- Box Top
     L : integer range 0 to SWIDTH-1;   -- Box Left
     W : integer range 1 to SWIDTH-1;   -- Box Width
     H : integer range 1 to SHEIGHT-1;  -- Box Height
     R : integer range 0 to 255;        -- Box Color Red
     G : integer range 0 to 255;        -- Box Color Green
     B : integer range 0 to 255;        -- Box Color Blue
     F : boolean;                       -- Fill Box?
  end record;
  
type BoxArray is array (integer range <>) of BoxType;
type ROMType is Array(integer range <>,integer range <>) of std_logic_vector(7 downto 0);
type BitRom is Array(integer range <>,integer range <>) of std_logic;

function IsBox(Box:BoxType; VD:VDataType) return boolean;

end;

package body VGApkg is

  function IsBox(Box:BoxType; VD:VDataType) return boolean is
  begin
    if Box.F then
        return (VD.X>=Box.L) and (VD.X< Box.L + Box.W) and (VD.Y>=Box.T) and (VD.Y< Box.T + Box.H);
    else
        return ((VD.X>=Box.L) and (VD.X<Box.L + Box.W) and ((VD.Y=Box.T) or (VD.Y=Box.T + Box.H))) or
               ((VD.Y>=Box.T) and (VD.Y<Box.T + Box.H) and ((VD.X=Box.L) or (VD.X=Box.L + Box.W)));
    end if;
  end IsBox;
  
end VGApkg;
