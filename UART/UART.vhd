--------------------------------------------------------------------------------
--
-- UART
--
-- Title: RS232 Universal Asynchronous Receiver Transmitter IPCore for SBA
-- Version: 4.0
-- Date: 2017/08/04
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- uart webpage: https://github.com/mriscoc/SBA-Library/tree/master/UART
--
-- Description:
-- 16 bits minimum width Data Interface
-- Requires RSTX and RSRX IPCores
--
-- Release Notes:
--
-- v4.0 2017/08/04
-- Change sysfrec to sysfreq
-- complete generic map for RSTX and RSRX
--
-- v3.5 2016/11/03
-- Bug corrections in snippet
-- Added connections for INT lines of RSTX and RSRX
--
-- v3.4 2015/06/06
-- Entities name change, remove "adapter"
-- Follow SBA v1.1 Guidelines
--
-- v3.3 2012/07/04
-- Remove dependency of SBAconfig
-- Make address and data generic buses
--
-- v3.2 2012/06/19
-- Only use one RX Merged (v0.4 and up) core
--
-- v3.1 2011/06/09
-- Add ADR_I signal to read Status without clear flags and
-- buffer, RXBuf_Adapter (v0.3) requirements
--
-- v3.0
-- Adding RX buffer
--
-- v2.0 2010/11/12
-- Own TX and RX Cores 
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
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART is
generic (
  debug:positive:=1;
  sysfreq:positive:=50E6;
  baud:positive:=115200;
  rxbuff:positive:=8
);
port (
  -- SBA Bus Interface
  CLK_I : in std_logic;
  RST_I : in std_logic;
  WE_I  : in std_logic;
  STB_I : in std_logic;
  ADR_I : in std_logic_vector;      -- Control/Status and Data reg select
  DAT_I : in std_logic_vector;
  DAT_O : out std_logic_vector;
  INT_O : out std_logic;            -- Interrupt request
  -- UART Interface;
  TX    : out std_logic;
  RX    : in std_logic
  );
end UART;
--------------------------------------------------

architecture UART_structural of UART is

signal TXDATi : std_logic_vector(DAT_O'Range);
alias  TXRDYi : std_logic is TXDATi(14);
signal RXDATi : std_logic_vector(DAT_I'Range);
alias  RXRDYi : std_logic is RXDATi(15);
signal TXINTi : std_logic;
signal RXINTi : std_logic;

begin

TXCore: entity work.RSTX
generic map(
  debug   => debug,
  sysfreq => sysfreq,
  baud    => baud
  )
port map(
  -- SBA Bus Interface
  CLK_I => CLK_I,
  RST_I => RST_I,
  WE_I  => WE_I,
  STB_I => STB_I,
  DAT_I => DAT_I,
  DAT_O => TXDATi,
  INT_O => TXINTi,
  -- UART Interface;
  TX    => TX       -- TX UART Output
  );

RXCore: entity work.RSRX
generic map(
  debug   => debug,
  sysfreq => sysfreq,
  baud    => baud,
  buffsize=> rxbuff
  )
port map(
  -- SBA Bus Interface
  CLK_I => CLK_I,
  RST_I => RST_I,
  WE_I  => WE_I,
  ADR_I => ADR_I,
  STB_I => STB_I,
  DAT_O => RXDATi,
  INT_O => RXINTi,
  -- UART Interface;
  RX    => RX       -- RX UART input
  );

DAT_O (15 downto 8) <= (15=>RXRDYi, 14=>TXRDYi,others=>'0');
DAT_O (7 downto 0) <= RXDATi(7 downto 0);
INT_O <= RXINTi or TXINTi;

end UART_structural;
