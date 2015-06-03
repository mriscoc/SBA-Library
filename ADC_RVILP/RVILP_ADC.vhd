-----------------------------------------------------------
-- ADC_Adapter.vhd
--
-- Versión 7.0 20110413
--
-- Dual Channel
-- 16bits Data interface, 10bits resolution right aligned
--
-- SBA Slave
-- Adapter for ADC: AD9201
--
-- for SBA v1.0
------------------------------------------------------------
--
-- (c) Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- webpage: http://mrisco.accesus.com
--
-- This code, modifications, derivate work or
-- based upon, can not be used or distributed
-- without the complete credits on this header.
--
-- This version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
-- if you use this component for your research please
-- include the appropriate credit of Author.
--
-- For commercial purposes request the appropriate
-- license from the author.
--
-- RVI Hardware developers -  MLAB, ICTP
-- http://mlab.ictp.it/research/rvi.html
--
-- Cicuttin, Andrés
-- Crespo, Maria Liz
-- Shapiro, Alex
--
------------------------------------------------------------
--
-- Notes:
--
-- Rev 7.0
-- ADC output is latched following datasheet typical
-- demux Ref:Fig.30
--
-- Rev 6.1
-- Use config values from SBA_config and SBA_package
--
-- Rev 6.0
-- SBA v1.0 compliant
-- Remove I,Q Channels DEMUX
-- Automatic calculus of internal clock frequency
--
-- Rev 5.0
-- remove the z state for output bus for make this
-- compatible with block gen in Actel designer
--
-- Rev 4.6
-- Remove ACK_O
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SBA_config.all;
use work.SBA_package.all;

entity ADC_Adapter is
port(
-- Interface for inside FPGA
   RST_I : in  std_logic;       -- active high reset
   CLK_I : in  std_logic;       -- Main clock
   DAT_O : out DATA_type;       -- Data Bus ADC
   STB_I : in  std_logic;       -- ADC ChipSel, active high
   ADR_I : in  std_logic;       -- Select Channel I or Q internal Register
   WE_I  : in  std_logic;       -- ADC read, active low
-- Interface for AD9201
   CLOCK : out std_logic;       -- ADC Sample Rate Clock
   SLECT : out std_logic;       -- Hi I Channel Out, Lo Q Channel Out
   DAT   : in  std_logic_vector(9 downto 0); -- Data Bus ADC
   SLEEP : out std_logic;       -- Hi Power Down, Lo Normal Operation
   CHPSEL: out std_logic        -- Chip Select
);
end ADC_Adapter;

architecture ADC_Adapter_Arch of ADC_Adapter is

Signal CLKi : std_logic;        -- Internal Clock
Signal AD0L : std_logic_vector(9 downto 0);  -- AD0 Latch
Signal AD1L : std_logic_vector(9 downto 0);  -- AD1 Latch

  Component ClkDiv is
  generic (frec:positive);
  port(
    CLK_I : in std_logic;
    RST_I : in std_logic;
    CLK_O : out std_logic
  );
  end Component ClkDiv;

begin

CLK1: if (sysfrec>20E6) generate
--CLK Div process (CLKi max 20MHz)
  CLK_Div : ClkDiv
  Generic map (frec=>20E6)
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
  if rising_edge(CLKi) then AD0L <= DAT; end if;
end process;

AD1_Latch: process (CLKi)
begin
  if falling_edge(CLKi) then AD1L <= DAT; end if;
end process;

  CLOCK <= CLKi;
  SLECT <= CLKi;
  DAT_O (15 downto 10) <= "000000";
  DAT_O (9 downto 0) <= AD0L when ADR_I='0' else AD1L;
  SLEEP <= '0';
  CHPSEL<= '0';

end ADC_Adapter_Arch;


