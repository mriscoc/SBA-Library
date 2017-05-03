--------------------------------------------------------------------------------
-- File Name: NumberLayer.vhd
-- Title: Hexadecimal display layer
-- Version: 0.4
-- Date: 2016/12/19
-- Author: Miguel A. Risco Castillo
-- Description: Display four digits hexadecimal number in a Video layer
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
use work.VideoPackage.all;
use work.Num16x24ROMPackage.all;

entity NumberLayer is
    Generic (Loc:TPoint:=(1,1);
             Color:tColor:=(0,128,255)
            );
    Port ( -- SBA interface
           RST_I : in STD_LOGIC;
           CLK_I : in STD_LOGIC;
           WE_I  : in std_logic;
           STB_I : in std_logic;
           DAT_I : in std_logic_vector;
           -- Video interface
           VCK_I : in std_logic;            -- Video Clock
           VD_I  : in TVData;               -- Video data in
           VD_O  : out TVData               -- Video data out
         );
end NumberLayer;

architecture Behavioral of NumberLayer is

signal Number : unsigned(15 downto 0);
signal Pixel : std_logic;

begin

VGADataProc: process(VCK_I)
begin
  if rising_edge(VCK_I) then
-- Get previous layer values
    VD_O<=VD_I;

-- overlay
    if (pixel/='0') then
       VD_O.Color <= Color;
    end if;
  end if;
end process VGADataProc;

PixelProc: Process (VD_I, Number)
variable tsel:std_logic;
begin
  tsel := '0';
  if isRect(VD_I,Loc.Y,Loc.X,ChrW*Number'length/4,ChrH) then
      tsel := '1';
  end if;
  if (tsel='1') then
    Pixel <=NumPx(VD_I.X-Loc.X,VD_I.Y-Loc.Y,Number);
  else
    Pixel <= '0';
  end if;
end process PixelProc;

NumberProc:process(RST_I,CLK_I)
begin
  if rising_edge(CLK_I) then
    if RST_I='1' then
      Number <= (others=>'0');
    elsif (STB_I='1') and (WE_I='1') then
      Number <= unsigned(DAT_I);
    end if;
  end if;
end process NumberProc;

end Behavioral;

