--------------------------------------------------------------------------------
--
-- D7SDEX
--
-- Title: 7Segment Display Module for Terasic DE0 y DE1
--
-- Version 0.3
-- Date: 2015/06/21
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/D7SDEX
--
-- Description: Seven segments four digits LED display
-- It requires Data Bus of 16 bits and low speed <1KHz clock (DCLK) for
-- digit multiplexing. Use two positions on address map :
-- ADR_I=0 Write Segments Data
-- ADR_I=1 Write Decimal Point Data
--
-- Follow SBA v1.1 Guidelines
--
-- Release Notes:
--
-- v0.3 2015/06/21
-- * Invert default value of dpmask at reset, before was 0 (0n) now 1 (off)
--
-- v0.2 2015/06/14
-- * Name change, remove dependency of SBAconfig
-- * Adapt to SBA v1.1 guidelines
--
-- v0.1 20110616
--
--------------------------------------------------------------------------------
-- Copyright:
--
-- (c) 2008-2015 Miguel A. Risco-Castillo
--
-- This code, modifications, derivate work or based upon, can not be used or
-- distributed without the complete credits on this header.
--
-- This version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
-- if you use this component for your research please include the appropriate
-- credit of Author.
--
-- The code may not be included into ip collections and similar compilations
-- which are sold. If you want to distribute this code for money then contact me
-- first and ask for my permission.
--
-- These copyright notices in the source code may not be removed or modified.
-- If you modify and/or distribute the code to any third party then you must not
-- veil the original author. It must always be clearly identifiable.
--
-- Although it is not required it would be a nice move to recognize my work by
-- adding a citation to the application's and/or research.
--
-- FOR COMMERCIAL PURPOSES REQUEST THE APPROPRIATE LICENSE FROM THE AUTHOR.
--------------------------------------------------------------------------------

Library IEEE;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

entity D7SDEX is
port (
-- Interface for inside FPGA
   RST_I : in std_logic;        -- active high reset
   CLK_I : in std_logic;        -- Main clock
   STB_I : in std_logic;        -- ChipSel, active high
   WE_I  : in std_logic;        -- write, active high
   ADR_I : in std_logic_vector; -- Register Select, Data and decimal point.
   DAT_I : in std_logic_vector; -- Data input Bus (minimun 16 bits)
-- Interface for DE1 4 digits 7 seg Display
   HEX0	 : out std_logic_vector(7 downto 0);
   HEX1	 : out std_logic_vector(7 downto 0);
   HEX2	 : out std_logic_vector(7 downto 0);
   HEX3	 : out std_logic_vector(7 downto 0)
);
end D7SDEX;

architecture D7SDEX_arch1 of D7SDEX is
subtype tsegimg is std_logic_vector(6 downto 0);
type tsegments  is Array (0 to 15) of tsegimg;
signal DATi : std_logic_vector(DAT_I'range);
signal dpmask : std_logic_vector(3 downto 0);

constant dig2seg : tsegments := (
 "1000000",
 "1111001",
 "0100100",
 "0110000",
 "0011001",
 "0010010",
 "0000010",
 "1111000",
 "0000000",
 "0011000",
 "0001000",
 "0000011",
 "1000110",
 "0100001",
 "0000110",
 "0001110"
);

begin
 
SBA_Interface: process (CLK_I)
begin
    if rising_edge(CLK_I) then
      if (RST_I='1') then
        DATi <= (others =>'0');
        dpmask <= (others =>'1');
      elsif (STB_I='1') and (WE_I='1') then
        if (ADR_I(0)='0') then
          DATi <= DAT_I;
        else
          dpmask <= DAT_I(3 downto 0);
        end if;
      end if;
    end if;
end process;

HEX0 <= dpmask(0) & dig2seg(to_integer(unsigned(DATi(3  downto  0))));
HEX1 <= dpmask(1) & dig2seg(to_integer(unsigned(DATi(7  downto  4))));
HEX2 <= dpmask(2) & dig2seg(to_integer(unsigned(DATi(11 downto  8))));
HEX3 <= dpmask(3) & dig2seg(to_integer(unsigned(DATi(15 downto 12))));

end D7SDEX_arch1;



