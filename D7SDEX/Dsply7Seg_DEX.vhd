----------------------------------------------------
-- 7Segment Display Module for Terasic DE1
--
-- version 0.1 20110616
--
-- Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- web page: http://mrisco.accesus.com
--
-- SBA
-- It requires Data Bus of 16 bits minimun
-- Use two positions on address space :
-- ADR_I 0 Write Segments Data
-- ADR_I 1 Write Decimal Point Data
--
-- This code, modifications, or based upon,
-- can not be used or distributed without the
-- complete credits on this header and the
-- consent of the author.
--
----------------------------------------------------

Library IEEE;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
use work.SBA_config.all;

entity Dsply7Seg is
port (
-- Interface for inside FPGA
   RST_I : in std_logic;        -- active high reset
   CLK_I : in std_logic;        -- Main clock
   DAT_I : in DATA_Type;        -- Data input Bus (minimun 16 bits)
   STB_I : in std_logic;        -- ChipSel, active high
   ADR_I : in std_logic;        -- Register Select, Data and decimal point.
   WE_I  : in std_logic;        -- write, active high
-- Interface for DE1 4 digits 7 seg Display
   HEX0	 : out std_logic_vector(7 downto 0);
   HEX1	 : out std_logic_vector(7 downto 0);
   HEX2	 : out std_logic_vector(7 downto 0);
   HEX3	 : out std_logic_vector(7 downto 0)
);
end Dsply7Seg;

architecture Dsply7Seg_DE1 of Dsply7Seg is
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
        dpmask <= (others =>'0');
      elsif (STB_I='1') and (WE_I='1') then
        if (ADR_I='0') then
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

end Dsply7Seg_DE1;



