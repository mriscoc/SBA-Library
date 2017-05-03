--------------------------------------------------------------------------------
-- File Name: BitMapROMpkg.vhd
-- Title: BitMap ROM arrays
-- Version: 0.3
-- Date: 2016/12/19
-- Author: Miguel A. Risco Castillo
-- web page: http://sba.accesus.com
--
-- Description and Notes:
-- Package with bitmap images and character ROM for the SBA analog
-- video system.
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

package BitMapROMPackage is

type TROM is Array(integer range <>,integer range <>) of std_logic_vector(7 downto 0);
type TBitRom is Array(integer range <>,integer range <>) of std_logic;

constant NumDigits:Integer:=16;

--NUMBER 5x7
constant Num5x7Rom : TBitRom(0 to 6,0 to 95) :=(
       "011100001000011100111110000100111110001100111110011100011100011100111100011100111100111110111110",
       "100010011000100010000100001100100000010000000010100010100010100010100010100010100010100000100000",
       "100110001000000010001000010100111100100000000100100010100010100010100010100000100010100000100000",
       "101010001000000100000100100100000010111100001000011100011110111110111100100000100010111100111100",
       "110010001000001000000010111110000010100010010000100010000010100010100010100000100010100000100000",
       "100010001000010000100010000100100010100010010000100010000100100010100010100010100010100000100000",
       "011100011100111110011100000100011100011100010000011100011000100010111100011100111100111110100000"
);

end BitMapROMPackage;

