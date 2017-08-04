--------------------------------------------------------------------------------
--
-- RSTX
--
-- Title: Serial Transmitter IPCore for SBA (Simple Bus Architecture)
-- Version: 0.8
-- Date: 2017/08/04
-- Author: Miguel A. Risco Castillo
--
-- sba webpage: http://sba.accesus.com
-- Core webpage: https://github.com/mriscoc/SBA_Library/blob/master/RSTX
--
-- Description: RS232 Serial transmitter IP Core, Flag TXready to read in bit 14
-- of Data bus.
--
-- Release Notes:
--
-- v0.8 2017/08/04
-- Change sysfrec to sysfreq
--
-- v0.7 2016/11/03
-- Added Snippet for RSTX
-- Added INT_O outport, this signal is active when RSTX is ready to send
-- Remove dependency of SBAPackage
--
-- v0.6 2016/06/09
-- Remove dependency of SBAconfig
-- Sysfrec is now a "generic" parameter
-- Follow SBA v1.1 guidelines
--
-- v0.5 
-- Make SBA buses generic std_logic_vectors
-- remove unused bits of DAT_O.
--
-- v0.4 2012/06/21
-- Timing improvements
--
-- v0.3
-- Adjust Baud Clock precision
--
-- v0.21
-- Minor error correct in SBAData process
--
-- v0.2
-- Initial Release
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
use IEEE.std_logic_1164.all;

entity RSTX is
generic (
  debug:positive:=1;
  sysfreq:positive:=50E6;
  baud:positive:=57600
  );
port (
  -- SBA Bus Interface
  CLK_I : in std_logic;
  RST_I : in std_logic;
  STB_I : in std_logic;
  WE_I  : in std_logic;
  DAT_I : in std_logic_vector;
  DAT_O : out std_logic_vector;
  INT_O : out std_logic;
  -- UART Interface;
  TX    : out std_logic
   );
end RSTX;
--------------------------------------------------

architecture RSTX_arch1 of RSTX is

signal BDclk : std_logic;
signal TXRDYi: std_logic;
signal WENi  : std_logic;
signal TxData: std_logic_vector(9 downto 0);
signal TxC   : integer range 0 to 9;
signal TxRun : std_logic;  

constant BaudDV : integer := integer(real(sysfreq)/real(baud))-1;

begin

ShifData: process (RST_I,WENi,CLK_I)
begin
  if (RST_I='1') then
    if (debug=1) then
      Report "TX Baud: " &  integer'image(baud) & " real: " &integer'image(integer(real(sysfreq)/real((BaudDV+1))));
    end if;
    TxData <= (others=>'1');
  elsif rising_edge(CLK_I) then
    if WENi='1' then
      TxData <= DAT_I(7 downto 0) & '0' & '1';   -- Datos & bit de inicio & idle
    elsif BDclk='1' and (TxRun='1') then
      TxData <= '1' & TxData(9 downto 1);
    end if;
  end if;
end process ShifData;

TxProc:process (RST_I,CLK_I,WENi,BDclk)
begin
  if (RST_I='1') then
    TxC   <= 0;
    TxRun <='0';
  elsif rising_edge(CLK_I) then  
    if (WENi='1') then
      TxC<=0;
      TxRun<='1';
    elsif BDclk='1' then
      if (TxC=9) then TxRun<='0'; else TxC<=TxC+1; end if;
    end if;
  end if;
end process TxProc;

BaudGen: process (RST_I,CLK_I,WENi)
Variable cnt: integer range 0 to BaudDV;
begin
  if (RST_I='1') or (WENi='1') then
    BDclk <= '0';
    cnt:=0;
  elsif rising_edge(CLK_I) then
    if cnt=BaudDV then
      BDclk <= '1';
      cnt := 0;
    else   
      BDclk <= '0';
      cnt := cnt+1;
    end if;
  end if;
end process BaudGen;

TX     <= TxData(0);
WENi   <= (STB_I and WE_I and not RST_I);
TXRDYi <= not (WENi or TxRun);
INT_O  <= TXRDYi;
DAT_O(14)<=TXRDYi;

end RSTX_arch1;
