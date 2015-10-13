--------------------------------------------------------------------------------
--
-- ADCRVILP
--
-- Title: ADC RVI low performance daughter board
--
-- Version: 7.1.2
-- Date: 2015/09/08
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/ADCRVILP
--
-- Description: Dual Channel, 16bits Data interface, 10bits resolution right
-- aligned ADC. SBA Slave adapter for ADC: AD9201
--
-- Follow SBA v1.1 Guidelines
--
-- Release Notes:
--
-- 7.1.2 2015/09/08
-- adapt to SBA v1.1 guidelines: ADR_I is vector
--
-- v7.1 2015/06/14
-- Name change, adapt to SBA v1.1 guidelines
--
-- v7.0 2011/04/13
-- ADC output is latched following datasheet typical
-- demux Ref:Fig.30
--
-- v6.1
-- Use config values from SBA_config and SBA_package
--
-- v6.0
-- SBA v1.0 compliant
-- Remove I,Q Channels DEMUX
-- Automatic calculus of internal clock frequency
--
-- v5.0
-- remove the z state for output bus for make this
-- compatible with block gen in Actel designer
--
-- v4.6
-- Remove ACK_O
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADCRVILP is
generic(
  debug:positive:=1;
  sysfrec:positive:=25E6
);
port(
-- Interface for inside FPGA
   RST_I : in  std_logic;       -- active high reset
   CLK_I : in  std_logic;       -- Main clock
   STB_I : in  std_logic;       -- ADC ChipSelect, active high
   ADR_I : in  std_logic_vector;-- Select internal Register Channel I or Q
   WE_I  : in  std_logic;       -- ADC read at low
   DAT_O : out std_logic_vector;-- ADC Data Bus
-- Interface for AD9201
   CLOCK : out std_logic;       -- ADC Sample Rate Clock
   SLECT : out std_logic;       -- Hi I Channel Out, Lo Q Channel Out
   DAT   : in  std_logic_vector(9 downto 0); -- Data Bus ADC
   SLEEP : out std_logic;       -- Hi Power Down, Low Normal Operation
   CHPSEL: out std_logic        -- Chip Select
);
end ADCRVILP;

architecture ADCRVILP_Arch of ADCRVILP is

Signal CLKi : std_logic;             -- Internal Clock
Signal AD0L : unsigned(9 downto 0);  -- AD0 Latch
Signal AD1L : unsigned(9 downto 0);  -- AD1 Latch
Signal DATOi: unsigned(9 downto 0);  -- Intermediate aux signal

begin

CLK1: if (sysfrec>20E6) generate

--CLK Div process (CLKi max 20MHz)

  CLK_Div : entity work.ClkDiv
  Generic map (
    debug  => debug,
    infrec => sysfrec,
    outfrec=> 20E6
  )
  Port Map(
    RST_I => RST_I,
    CLK_I => CLK_I,
    CLK_O => CLKi
  );

end generate;

CLK2: if (sysfrec<=20E6) generate
  CLKi <= CLK_I;
end generate;

AD0_Latch: process (CLKi)
begin
  if rising_edge(CLKi) then AD0L <= unsigned(DAT); end if;
end process;

AD1_Latch: process (CLKi)
begin
  if falling_edge(CLKi) then AD1L <= unsigned(DAT); end if;
end process;

  CLOCK <= CLKi;
  SLECT <= CLKi;
  DATOi <= AD0L when ADR_I(0)='0' else AD1L;
  DAT_O <= std_logic_vector(resize(DATOi,DAT_O'length));
  SLEEP <= '0';
  CHPSEL<= '0';

end ADCRVILP_Arch;


