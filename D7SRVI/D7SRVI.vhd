--------------------------------------------------------------------------------
--
-- D7SRVI
--
-- Title: 7Segment Display Module for RVI
--
-- Version 4.1
-- Date: 2015/06/14
-- Author: Miguel A. Risco Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/D7SRVI
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
-- v4.1 2015/06/14
-- Name change, remove dependency of SBAconfig
-- adapt to SBA v1.1 guidelines
--
-- Rev 4.0 20100803
-- Synchronous reset, SBA 1.0 compliant
--
-- Rev 3.8
-- Remotion of some redundant registers
--
-- Rev 3.7
-- Now is possible to control the position of
-- the decimal point using an additional register
--
-- Rev 3.6
-- Change to SBA Compliant
--
-- Rev 3.5
-- Remove ACK_O
--
-- Rev 3.4
-- Complete some sensitivity list
--
--------------------------------------------------------------------------------
-- Copyright:
--
-- (c) 2008-2015 Miguel A. Risco Castillo
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

entity D7SRVI is
port (
-- Interface for inside FPGA
   RST_I : in std_logic;        -- active high reset
   CLK_I : in std_logic;        -- Main clock
   DAT_I : in std_logic_vector; -- Data input Bus
   STB_I : in std_logic;        -- ChipSel, active high
   ADR_I : in std_logic;        -- Register Select, Data and decimal point.
   WE_I  : in std_logic;        -- write, active high
-- Interface for RVI 4 digits 7 seg Display
   DCLK    : in  std_logic;     -- Clock for Digit Multiplexing
   DIG_SEG : out std_logic_vector(8 downto 0)
);
end D7SRVI;


architecture D7SRVI_arch of D7SRVI is
type tstate is (OffSt, OnSt);  -- Segments States
subtype tsegimg is std_logic_vector(6 downto 0);
type tsegments  is Array (0 to 15) of tsegimg;

signal state : tstate;
signal DATi : std_logic_vector(DAT_I'range);
signal dpmask : std_logic_vector(3 downto 0);

constant dig2seg : tsegments := (
 "111111Z",
 "Z11ZZZZ",
 "11Z11Z1",
 "1111ZZ1",
 "Z11ZZ11",
 "1Z11Z11",
 "1Z11111",
 "111ZZZZ",
 "1111111",
 "1111Z11",
 "111Z111",
 "ZZ11111",
 "1ZZ111Z",
 "Z1111Z1",
 "1ZZ1111",
 "1ZZZ111"
);

function getZ(b:std_logic) return std_logic is
begin
  if (b='1') then return '1'; else return 'Z'; end if;
end function getZ;

begin
 
  SBA_Interface: process (CLK_I)
  begin
    if rising_edge(CLK_I) then
      if (RST_I='1') then
        state <= OffSt;
        DATi <= (others =>'0');
        dpmask <= (others =>'0');
      elsif (STB_I='1') and (WE_I='1') then
        if (ADR_I='0') then
          DATi <= DAT_I;
          state<=OnSt;
        else
          dpmask <= DAT_I(3 downto 0);
        end if;
      end if;
    end if;
  end process;

  Internal: process (DCLK, state)
  variable n:integer range 0 to 3;
  variable segimg : tsegimg;
  begin
    if (state = OffSt) then
      DIG_SEG<= (others => '0');
      n:=0;
    elsif rising_edge(DCLK) then
      segimg := dig2seg(to_integer(unsigned(DATi(3+4*n downto 4*n))));
      case n is
        when 0 => DIG_SEG <= segimg(6 downto 2) &'0'& segimg(1 downto 0) & getZ(dpmask(0)) ;
        when 1 => DIG_SEG <= segimg(6 downto 1) &'0'& segimg(0) & getZ(dpmask(1)) ;
        when 2 => DIG_SEG <= segimg(6 downto 0) &'0'& getZ(dpmask(2)) ;
        when 3 => DIG_SEG <= segimg(6 downto 0) & getZ(dpmask(3)) &'0';
      end case;
      if n=3 then n:=0; else n:= n+1; end if;
    end if;
  end process;

end D7SRVI_arch;


