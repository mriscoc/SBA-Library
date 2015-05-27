-----------------------------------------------------------
-- UART_Adapter.vhd
-- UART for SBA
--
-- Version 3.2
-- Date: 20120619
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
-- v3.2
-- Only use one RX Merge (v0.4 and up) core
--
-- v3.1
-- Add ADR_I signal to read Status without clear flags and
-- buffer, RXBuf_Adapter (v0.3) requeriments
--
-- v3.0
-- Adding RX buffer
--
-- v2.0
-- Own TX and RX Cores 
-----------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_Adapter is
generic (baud:positive:=115200; rxbuff:positive:=8);
port (
      -- SBA Bus Interface
      CLK_I : in std_logic;
      RST_I : in std_logic;
      WE_I  : in std_logic;
      INT_O : out std_logic;            -- Interrupt request
      STB_I : in std_logic;
      ADR_I : in std_logic_vector;      -- Control/Status and Data reg select
      DAT_I : in std_logic_vector;
      DAT_O : out std_logic_vector;
      -- UART Interface;
      TX     :out std_logic;
      RX     : in std_logic
   );
end UART_Adapter;
--------------------------------------------------

architecture arch1 of UART_Adapter is

signal TXDATi : std_logic_vector(DAT_O'Range);
alias  TXRDYi : std_logic is TXDATi(14);
signal RXDATi : std_logic_vector(DAT_I'Range);
alias  RXRDYi : std_logic is RXDATi(15);

begin

TXCore: entity work.TX_Adapter
generic map(baud=>baud)
port map(
      -- SBA Bus Interface
      CLK_I => CLK_I,
      RST_I => RST_I,
      WE_I  => WE_I,
      STB_I => STB_I,
      DAT_I => DAT_I,  
      DAT_O => TXDATi,  
      -- UART Interface;
      TX    => TX       -- TX UART Output
   );

RXCore: entity work.RX_Adapter
generic map(baud=>baud, buffsize=>rxbuff)
port map(
      -- SBA Bus Interface
      CLK_I => CLK_I,
      RST_I => RST_I,
      WE_I  => WE_I,
      ADR_I => ADR_I,
      STB_I => STB_I,
      DAT_O => RXDATi,  
      -- UART Interface;
      RX    => RX       -- RX UART input
   );


DAT_O (15 downto 8) <= (15=>RXRDYi, 14=>TXRDYi,others=>'0');
DAT_O (7 downto 0) <= RXDATi(7 downto 0);
INT_O <= RXRDYi or TXRDYi;
end arch1;