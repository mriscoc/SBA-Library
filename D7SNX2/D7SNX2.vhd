--------------------------------------------------------------------------------
--
-- D7SNX2
--
-- Title: Seven segments four digits display iP core  for Digilent NEXYS2 board
--
-- Version: 0.5
-- Date: 2015/06/11
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
-- v0.5 2015/06/11
-- Name change, adapt to SBA v1.1 guidelines
--
-- v0.4 2014/12/10
-- Automatic Clock generation for digit multiplexer
--
-- v0.2
-- reassignment of signals to use only a single ROM
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

entity D7SNX2 is
port (
-- Interface for inside FPGA
   RST_I : in std_logic;        -- active high reset
   CLK_I : in std_logic;        -- Main clock
   STB_I : in std_logic;        -- ChipSel, active high
   WE_I  : in std_logic;        -- write, active high
   ADR_I : in std_logic_vector; -- Register Select, Data and decimal point.
   DAT_I : in std_logic_vector; -- Data input Bus (minimun 16 bits)
-- Interface for NEXYS2 4 digits 7 seg Display
   DIG	 : out std_logic_vector(3 downto 0);
   SEG	 : out std_logic_vector(7 downto 0)
);
end D7SNX2;

architecture D7S_NEXYS2 of D7SNX2 is
signal DATi : std_logic_vector(DAT_I'range);
signal dpmask : std_logic_vector(3 downto 0);
type tHEX is Array (0 to 3) of unsigned(3 downto 0);
signal HEXS : tHEX;
signal DREG:unsigned(1 downto 0);
signal MPXCLKEN: std_logic;

type tsegments  is Array (0 to 15) of std_logic_vector(6 downto 0);
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
 
SBA_Interface: process (CLK_I, RST_I)
begin
    if rising_edge(CLK_I) then
      if (RST_I='1') then
        dpmask <= (others =>'1');
      elsif (STB_I='1') and (WE_I='1') then
        if (ADR_I(0)='0') then
          DATi <= DAT_I;
        else
          dpmask <= not DAT_I(3 downto 0);
        end if;
      end if;
    end if;
end process;

MPXCLK: process(CLK_I,RST_I)
variable cnt:unsigned(9 downto 0);
begin
    if rising_edge(CLK_I) then
      if (RST_I='1') then
        cnt := (others =>'1');
      else
        cnt := cnt + 1 ;
      end if;
      if cnt=(cnt'range=>'0') then MPXCLKEN<='1'; else MPXCLKEN<='0'; end if;
    end if;
end process;

DREG_Process:process (CLK_I, RST_I, MPXCLKEN)
begin
  if (RST_I='1') then
    DREG <= (others =>'0');
  elsif rising_edge(CLK_I) then
    if (MPXCLKEN='1') then 
	   DREG <= DREG+1;
    end if;
  end if;
end process;

HEXS(0) <= unsigned(DATi(3  downto  0));
HEXS(1) <= unsigned(DATi(7  downto  4));
HEXS(2) <= unsigned(DATi(11 downto  8));
HEXS(3) <= unsigned(DATi(15 downto 12));
SEG     <= dpmask(to_integer(DREG)) & dig2seg(to_integer(HEXS(to_integer(DREG))));

With to_integer(DREG) select DIG <=
    "1110" When 0,
    "1101" When 1,
    "1011" When 2,
    "0111" When 3,
    (DIG'range =>'1') When Others;

end D7S_NEXYS2;


