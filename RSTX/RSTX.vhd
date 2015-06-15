-----------------------------------------------------------
--
-- RSTX
--
-- TX
-- for SBA v1.0 (Simple Bus Architecture)
--
-- Version 0.6
-- Date: 2016/06/09
-- 16 bits Data Interface
--
--
-- Author:
-- (c) Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- web page: http://mrisco.accesus.com
-- sba webpage: http://sba.accesus.com
--
-- This code, modifications, derivate
-- work or based upon, can not be used
-- or distributed without the
-- complete credits on this header and
-- the consent of the author.
--
-- This version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
-- if you use this component for your research please
-- include the appropriate credit of Author.
--
-- For commercial purposes request the appropriate
-- license from the author.
--
--
-- Notes:
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
-- v0.4 20120621
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
-----------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use work.SBApackage.all;

entity RSTX is
generic (
  debug:positive:=1;
  sysfrec:positive:=50E6;
  baud:positive:=57600
  );
port (
      -- SBA Bus Interface
      CLK_I : in std_logic;
      RST_I : in std_logic;
      WE_I  : in std_logic;
      STB_I : in std_logic;
      DAT_I : in std_logic_vector;
      DAT_O : out std_logic_vector;
      -- UART Interface;
      TX     :out std_logic
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

constant BaudDV : integer := integer(real(sysfrec)/real(baud))-1;

begin

ShifData: process (RST_I,WENi,CLK_I)
begin
  if (RST_I='1') then
    if (debug=1) then
      Report "TX Baud: " &  integer'image(baud) & " real: " &integer'image(integer(real(sysfrec)/real((BaudDV+1))));
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
      cnt:=cnt+1;
    end if;
  end if;
end process BaudGen;

TX     <= TxData(0);
WENi   <= (STB_I and WE_I and not RST_I);
TXRDYi <= not (WENi or TxRun);
DAT_O(14) <= TXRDYi;

end RSTX_arch1;