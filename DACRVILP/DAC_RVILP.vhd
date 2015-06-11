------------------------------------------------------------
-- DAC_Adapter.vhd
--
-- Versión 11.6 20101014
--
-- 16 bits Data Interface, 14bits DAC right aligned
-- Automatic generation of Control Word
-- Status available on high or low level of ADR_I
-- Start of SPI write to DAC Device
-- Reserved two address for two channels
--
-- Reading of DAT_O allways get IPCore Status
-- bit 0 of Status is SPIbf='SPI bus free' (1 free, 0 busy)
-- if this bit is 1, then the master can write into the DAC's
--
-- Writing to DAT_I:
--   if ADR_I='0' : Write to DAC 0
--   if ADR_I='1' : Write to DAC 1
--
-- SBA Slave
-- Adapter for DAC LCT1654
--
-- SBA v1.0 system
--
------------------------------------------------------------
--
-- (c) Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- webpage: http://mrisco.accesus.com
--
-- This code, modifications, derivate
-- work or based upon, can not be used
-- or distributed without the
-- complete credits on this header and
-- the consent of the author.
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
-- Rev 11.7
-- Adding more comments
--
-- Rev 11.6
-- Use configuration values from SBA_config and SBA_package
--
-- Rev 11.5
-- Out of the conditional test: streamD <= controlW & DataW & "00"
--
-- Rev 11.0
-- Is not necessary anymore that the main system to
-- generate the control words for program each DAC channel
-- the IP Core assume Fast Mode
--
-- Rev 10.1
-- Add IniData to the combinatory result of SPIbf
--
-- Rev 10.0
-- SBA v1.0 compliant
-- Synchronous Reset
-- Automatic calculus of SCK frequency based in sysfrec
--
-- Rev 9.0
-- remove the tri-state for output bus for make this
-- compatible with Actel designer block generator
--
-- Rev 8.4
-- Remove ACK_O
--
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SBA_config.all;
use work.SBA_package.all;

entity DAC_Adapter is
port(
-- Interface for inside FPGA
   RST_I : in  std_logic;        -- active high reset
   CLK_I : in  std_logic;        -- Main clock
   DAT_I : in  DATA_type;        -- Data input Bus
   DAT_O : out DATA_type;        -- Data output Bus
   STB_I : in  std_logic;        -- DAC ChipSel, active high
   ADR_I : in  std_logic;        -- Select internal Registers
   WE_I  : in  std_logic;        -- DAC write, active high
-- Interface for DAC LTC1654
   CLR   : out std_logic;        -- Reset active low
   SDI   : out std_logic;        -- Serial out
   CS_LD : out std_logic;        -- Enable Serial interface / Load internal register,
   SCK   : out std_logic         -- Serial Interface Clock
);
end DAC_Adapter;

architecture  DAC_Adapter_LTC1654 of  DAC_Adapter is
type tstate is (ResetSt, CfgChASt, PauseSt, CfgChBSt, WaitSt, SerialSt, EndSt); -- SPI DAC Communication States
signal state    : tstate;
signal streamD  : std_logic_vector (23 downto 0);         --
signal ControlW : std_logic_vector (7 downto 0);
signal DataW    : std_logic_vector (13 downto 0);
signal nSCK     : unsigned (4 downto 0);
signal SCKi     : std_logic;
signal CSLDi    : std_logic;
signal IniData  : std_logic;

constant ChAccw  : std_logic_vector (7 downto 0) := x"50";           -- Channel A Config Control Word
constant ChBccw  : std_logic_vector (7 downto 0) := x"51";           -- Channel B Config Control Word

signal Status   : std_logic_vector (15 downto 0);
alias  SPIbf    : std_logic is Status(0);                            -- SPI bus free

  Component ClkDiv is
  generic (frec:positive);
  port(
    CLK_I : in std_logic;
    RST_I : in std_logic;
    CLK_O : out std_logic
  );
  end Component ClkDiv;

begin

SCK1: if (sysfrec>25E6) generate
--CLK Div process (SCKi max 25MHz)
  CLK_Div : ClkDiv
  Generic map (frec=>25E6)
  Port Map(
    RST_I => RST_I,
    CLK_I => CLK_I,
    CLK_O => SCKi
  );
end generate;

SCK2: if (sysfrec<=25E6) generate
  SCKi <= CLK_I;
end generate;

-- FPGA Internal Bus communication Process
  process (CLK_I, RST_I)
  variable dat:DATA_type;
  variable adr:std_logic;
  variable ena:std_logic;
  begin
    if rising_edge(CLK_I) then
      dat:=DAT_I;
      adr:=ADR_I;
      ena:=STB_I and WE_I;
      if (RST_I='1') then
        ControlW <= "0011" & "0000";
        DataW <= (others => '0');
        IniData<='0';
      elsif ena='1' then
        if (adr='0') then
          ControlW <= "0011" & "0000";
          DataW <= dat(13 downto 0);
          IniData <= '1';
        else
          ControlW <= "0011" & "0001";
          DataW <= dat(13 downto 0);
          IniData <= '1';
        end if;
      end if;
      if (state=SerialSt) then IniData<='0'; end if;
    end if;
  end process;

-- SPI BUS Proccess
  process (SCKi, RST_I)
  begin
    if (RST_I='1') then
      state <= ResetSt;
      streamD <= (OTHERS =>'0');
      nSCK<="00000";
    elsif rising_edge(SCKi) then
      case State is
        when ResetSt  => streamD <= ChAccw & x"0000";
                         state   <= CfgChASt;
        when CfgChASt => if (nSCK < 23) then
                           streamD <= streamD(22 downto 0) & '0';
                           state   <= CfgChASt;
                           nSCK    <= nSCK+1;
                         else
                           state <= PauseSt;
                         end if;
        when PauseSt  => streamD <= ChBccw & x"0000";
                         state   <= CfgChBSt;
                         nSCK  <= (others => '0');
        when CfgChBSt => if (nSCK < 23) then
                           streamD <= streamD(22 downto 0) & '0';
                           state   <= CfgChBSt;
                           nSCK    <= nSCK+1;
                         else
                           state <= WaitSt;
                           nSCK  <= (others => '0');
                         end if;
        when WaitSt   => streamD <= controlW & DataW & "00";
                         if (IniData='1') then
                           state   <= SerialSt;
                         else state <= WaitSt;
                         end if;
        when SerialSt => if (nSCK < 23) then
                           streamD <= streamD(22 downto 0) & '0';
                           state   <= SerialSt;
                           nSCK    <= nSCK+1;
                         else
                           state <= EndSt;
                         end if;
        when EndSt    => state <= WaitSt;
                         nSCK  <= "00000";
      end case;
    end if;
  end process;

-- DAC Interface Process
  process (RST_I, SCKi)
  begin
    if (RST_I='1') then
      CSLDi <= '1';
    elsif falling_edge(SCKi) then
      if ((state = CfgChASt) or (state = CfgChBSt) or (state = SerialSt)) then
        CSLDi <= '0';
      else
        CSLDi <= '1';
      end if;
    end if;
  end process;

  Status(15 downto 1) <= (others=>'0');      -- Filling unused bits
  SPIbf <= '1' When (state = WaitSt) and (IniData='0') else '0';
  DAT_O <= Status;

-- DAC Interface signals
  CLR   <= not RST_I;
  CS_LD <= CSLDi;
  SCK   <= SCKi When CSLDi='0' else '0';
  SDI   <= '0' When (state = ResetSt) or (state = WaitSt) else StreamD(23);


end  DAC_Adapter_LTC1654;

