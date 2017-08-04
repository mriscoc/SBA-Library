--------------------------------------------------------------------------------
--
-- RSRX
--
-- Title: Buffered RX IPCore for SBA
-- Version: 0.9
-- Date: 2017/08/04
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/RSRX
-- 
-- Description: RS232 Serial reception IP Core. Flag RXready is read in bit 15
-- of Data bus. The length of input FIFO buffer is configurable. 
-- Read on ADR_I(0)='1' give status of RXready, on ADR_I(0)='0' pull data from
-- fifo. Rxready flag is clear when fifo is empty.
--
-- Release Notes:
--
-- v0.9 2017/08/04
-- Change sysfrec to sysfreq
--
-- v0.8 2016/11/03
-- Added Snippet for RSRX
-- Added INT_O outport, this signal is active when RSRX buffer have data
-- Remove dependency of SBAPackage
--
-- v0.7 2015/06/14
-- Entities rename, remove "adapter"
-- Removed dependency of sbaconfig
-- Follow SBA v1.1 Guidelines
--
-- v0.6 20141210
-- Modify of Baud Clock Process
-- Move some variables to signals
--
-- v0.4
-- Merge the two versions of RSRX, with and without fifo buffer
--
-- v0.3.1
-- Minor error about RxData assign corrected
--
-- v0.3
-- Add Address to read Status without clear flags and buffer
--
-- v0.2
-- Fist version cloned from RSRX v0.2, adding buffer
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

library IEEE;
use IEEE.std_logic_1164.all;

entity RSRX is
generic (
  debug:positive:=1;
  sysfreq:positive:=50E6;
  baud:positive:=57600;
  buffsize:positive:=8
);
port (
  -- SBA Bus Interface
  CLK_I : in std_logic;
  RST_I : in std_logic;
  STB_I : in std_logic;
  WE_I  : in std_logic;
  ADR_I : in std_logic_vector;
  DAT_O : out std_logic_vector;
  INT_O : out std_logic;
  -- UART Interface;
  RX    : in std_logic    -- RX UART input
);
end RSRX;

architecture RX_Arch of RSRX is

constant BaudDV : integer := integer(real(sysfreq)/real(baud))-1;
type tstate  is (IdleSt, CheckSt ,StartSt, DataSt, StopSt);   -- Rx Serial Communication States

signal RXSt   : tstate;
signal BDclk  : std_logic;
signal RxShift: std_logic_vector(7 downto 0);
alias  RxData : std_logic_vector(7 downto 0) is DAT_O(7 downto 0);
signal BitCnt : integer range 0 to 9;
signal RXRDYi : std_logic;
signal RXi    : std_logic;

-- FIFO types and signals ------
type TBufData is array (0 to buffsize-1) of std_logic_vector(7 downto 0);
signal BufData : TBufData;
signal InP, OutP : natural range 0 to buffsize-1;
signal BufLen : natural range 0 to buffsize;
--------------------------------

begin

------------------------------------------------------------------------------
RX0: if buffsize>0 generate
begin

RxFifoProc: process (RST_I,CLK_I)
Variable cnt : integer range 0 to BaudDV/2;
Variable BufEmpt, BufFull : Boolean;

-- FIFO Procedures -------------
procedure Push(data:in std_logic_vector) is
begin
  if not BufFull then
    BufData(InP) <= data;
    if (InP < BuffSize-1) then InP<=InP+1; else InP<=0; end if;
    BufLen<=BufLen+1;
  end if;
end;

procedure Pull is
begin
  if not BufEmpt then
    if (OutP < BuffSize-1) then OutP<=OutP+1; else OutP<=0; end if;
    BufLen<=BufLen-1;
  end if;
end;
--------------------------------

begin
  if RST_I='1' then
    RxSt <= IdleSt;
    cnt := 0;
    RxRDYi<='0';
    BufFull:=false;
    BufEmpt:=true;

-- FIFO
    InP<=0;
    OutP<=0;
    BufLen<=0;

    if (debug=1) then
      Report "RX Baud: " &  integer'image(baud) & " real: " &integer'image(integer(real(sysfreq)/real((BaudDV+1))));
    end if;

  elsif rising_edge(CLK_I) then
    case RxSt is
      when IdleSt  => if RXi = '0' then
                        RxSt <= CheckSt;
                        cnt := 0;
                      end if;
      when CheckSt => if RXi = '1' then
                        RxSt <= IdleSt;
                      elsif cnt = BaudDV/2 then
                        RxSt <= StartSt;
                      else
                        cnt := cnt+1;
                      end if;
      when StartSt => if BitCnt = 1 then
                        RxSt <= DataSt;
                      end if;
      when DataSt  => if BitCnt = 8 then
                        Push(RxShift);
                        RxSt <= StopSt;
                      end if;
      when StopSt  => if RXi = '1' then
                        RxSt <= IdleSt;
                      end if;  
    end case;                     

    if BufEmpt then RXRDYi <= '0'; else RXRDYi <= '1'; end if;
    RxData <= BufData(OutP);
    if STB_I = '1' and WE_I= '0' and ADR_I(0)='0' and  RXRDYi='1' then Pull; end if;
    if BufLen = BuffSize then BufFull := true; else BufFull := false; end if;
    if BufLen = 0 then BufEmpt := true; else BufEmpt := false; end if;

  end if;
end process RxFifoProc;

end generate;

------------------------------------------------------------------------------

RX1: if buffsize=0 generate
begin

RxStProc: process (RST_I,CLK_I)
Variable cnt : integer range 0 to BaudDV/2;
begin
  if RST_I='1' then
    RxSt <= IdleSt;
    RxData <= (others=>'0');
    RXRDYi <= '0';
    cnt := 0;

    if (debug=1) then
      Report "RX Baud: " &  integer'image(baud) & " real: " &integer'image(integer(real(sysfreq)/real((BaudDV+1))));
    end if;

  elsif rising_edge(CLK_I) then
    case RxSt is
      when IdleSt  => if RXi = '0' then
                        RxSt <= CheckSt;
                        cnt := 0;
                      end if;
      when CheckSt => if RXi = '1' then
                        RxSt <= IdleSt;
                      elsif cnt = BaudDV/2 then
                        RxSt <= StartSt;
                      else
                        cnt := cnt+1;
                      end if;
      when StartSt => if BitCnt = 1 then
                        RxSt <= DataSt;
                      end if;
      when DataSt  => if BitCnt = 8 then
                        RxData <= RxShift;
                        RXRDYi <= '1';
                        RxSt <= StopSt;
                      end if;
      when StopSt  => if RXi = '1' then
                        RxSt <= IdleSt;
                      end if;
    end case;

    if STB_I = '1' and WE_I= '0' and RXRDYi='1' then RXRDYi <= '0'; end if;

  end if;
end process RxStProc;

end generate;

------------------------------------------------------------------------------

RxShiftProc:process (CLK_I, RxSt, BDclk)
begin
  if RxSt=IdleSt then
    RxShift<= (others=>'0');
    BitCnt <= 0;
  elsif rising_edge(CLK_I) then
    if (BDclk='1') then 
      RxShift <= RXi & RxShift(7 downto 1);
      BitCnt <= BitCnt + 1;
    end if;
  end if;
end process;


-- Sync incoming RX (anti metastable) ---
syncproc: process(RST_I, CLK_I) is
begin
  if RST_I='1' then
    RXi <= '1';
  elsif rising_edge(CLK_I) then
    RXi <= RX;
  end if;
end process;

BaudGen: process (RxSt,CLK_I)
Variable cnt: integer range 0 to BaudDV;
begin
  if (RxSt=IdleSt) or (RxSt=CheckSt) or (RxSt=StopSt)then
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

INT_O <= RXRDYi;
DAT_O(15) <= RXRDYi;

end architecture RX_Arch;
