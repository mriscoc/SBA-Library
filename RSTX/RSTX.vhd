--------------------------------------------------------------------------------
--
-- RSTX
--
-- Title: Serial Transmitter IPCore for SBA (Simple Bus Architecture)
-- Version: 0.9
-- Date: 2019/08/04
-- Author: Miguel A. Risco Castillo
--
-- sba webpage: http://sba.accesus.com
-- Core webpage: https://github.com/mriscoc/SBA_Library/blob/master/RSTX
--
-- Description: RS232 Serial transmitter IP Core, Flag TXready to read in bit 14
-- of Data bus.
--
--------------------------------------------------------------------------------
-- For Copyright and release notes please refer to:
-- https://github.com/mriscoc/SBA-Library/tree/master/RSTX/readme.md
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

type tstate  is (IdleSt, StartSt, DataSt, StopSt);   -- Tx Serial Communication States

signal TxSt  : tstate;
signal BDclk : std_logic;
signal TXRDYi: std_logic;
signal WENi  : std_logic;
signal TxREG : std_logic_vector(7 downto 0);
signal TxShift:std_logic_vector(8 downto 0);

constant BaudDV : integer := integer(real(sysfreq)/real(baud))-1;

begin

DebugGen: if debug=1 generate
begin
process(RST_I)
begin
  if (RST_I='1') then
    Report "TX Baud: " &  integer'image(baud) & " real: " &integer'image(integer(real(sysfreq)/real((BaudDV+1))));
  end if;
end process;
end generate;

TxStProc:process(RST_I,CLK_I)
variable cnt:integer range 0 to 7;
begin
  if (RST_I='1') then
    TxSt<=IdleSt;
    cnt:=0;
  elsif rising_edge(CLK_I) then
    if (BDclk='1') then
      case TxSt is
        When IdleSt  => if WENi='1' then
                          TxSt<=StartSt;
                        end if;
        When StartSt => TxSt<=DataSt;
                        cnt:=0;
        When DataSt  => if cnt>6 then
                          TxSt<=StopSt;
                        else
                          cnt:=cnt+1;
                        end if;
        When StopSt  => TxSt<=IdleSt;
        When others  => TxSt<=IdleSt;
      end case;
    end if;
  end if;
end process TxStProc;


ShifData: process (CLK_I)
begin
  if rising_edge(CLK_I) then
    if (BDclk='1') then
      case TxSt is
        When IdleSt  => TxShift(0) <= '1';        -- Idle
        When StartSt => TxShift <= TxREG & '0';   -- Datos & bit de inicio
        When DataSt  => TxShift <= '1' & TxShift(8 downto 1);  -- Shift
        When StopSt  => TxShift(0) <= '1';        -- Stop bit
        When others  => TxShift(0) <= '1';
      end case;
    end if;
  end if;
end process ShifData;

BaudGen: process (RST_I,CLK_I)
Variable cnt: integer range 0 to BaudDV;
begin
  if (RST_I='1') then
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

SBAProc:process(RST_I,CLK_I)
begin
  if (RST_I='1') then
    TxREG<=(others=>'0');
    WENi <= '0';
  elsif rising_edge(CLK_I) then
    if (TxSt=StartSt) then
      WENi <= '0';
    end if;
    if (STB_I='1' and WE_I='1') then
      TxREG<=DAT_I(7 downto 0);
      WENi <= '1';
    end if;
  end if;
end process SBAProc;

TX     <= TxShift(0);
TXRDYi <= '1' when (TxSt=IdleSt) and (WENi='0') else '0';
INT_O  <= TXRDYi;
DAT_O(14)<=TXRDYi;

end RSTX_arch1;
