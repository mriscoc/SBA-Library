----------------------------------------------------
-- 7Segment Display Module for Digilent NEXYS2 board
--
-- version 0.1 20120607
--
-- Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- web page: http://mrisco.accesus.com
--
-- SBA
-- It requires Data Bus of 16 bits minimun
-- Use two positions on address space :
-- ADR_I 0 Write hexadecimal Segments Data
-- ADR_I 1 Write Decimal Point Data
--
-- This code, modifications, or based upon,
-- can not be used or distributed without the
-- complete credits on this header and the
-- consent of the author.
--
-- Notes:
-- v0.2
-- reassignment of signals to use only a single ROM
--
----------------------------------------------------

Library IEEE;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

entity Dsply7Seg is
port (
-- Interface for inside FPGA
   RST_I : in std_logic;        -- active high reset
   CLK_I : in std_logic;        -- Main clock
   DAT_I : in std_logic_vector; -- Data input Bus (minimun 16 bits)
   STB_I : in std_logic;        -- ChipSel, active high
   ADR_I : in std_logic_vector; -- Register Select, Data and decimal point.
   WE_I  : in std_logic;        -- write, active high
-- Interface for NEXYS2 4 digits 7 seg Display
   DCLK  : in std_logic;
   DIG	 : out std_logic_vector(3 downto 0);
   SEG	 : out std_logic_vector(7 downto 0)
);
end Dsply7Seg;

architecture Dsply7Seg_NEXYS2 of Dsply7Seg is
signal DATi : std_logic_vector(DAT_I'range);
signal dpmask : std_logic_vector(3 downto 0);
type tHEX is Array (0 to 3) of unsigned(3 downto 0);
signal HEXS : tHEX;
signal DREG:unsigned(1 downto 0);

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

DREG_Process:process (DCLK, RST_I)
begin
  if (RST_I='1') then
    DREG <= (others =>'0');
  elsif rising_edge(DCLK) then
    DREG <= DREG+1;
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

end Dsply7Seg_NEXYS2;


