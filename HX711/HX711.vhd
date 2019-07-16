--------------------------------------------------------------------------------
-- HX711
--
-- Title: SBA Slave IP Core adapter for the HX711 module
--
-- Versión 0.2
-- Date 2019/07/16
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/HX711
--
-- Description: The HX711 is an SBA IPCore designed to driver the HX711 module,
-- a precision 24-bit analog-to-digital converter (ADC) designed for weigh scales
-- and industrial control applications to interface directly with a bridge sensor.
-- The SBA core has 2 register of 16 bits, selected by  ADR_I to access the
-- 24 bits of the HX711, MSW register:ADR_I(0)=1 and LSW register:ADR_I(0)=0,
-- the INT flag can be readed in the bit 15 of the MSW, reading the MSW also
-- clear the INT condition.
--
--
-- Follow SBA v1.1 guidelines
--
--------------------------------------------------------------------------------
-- For Copyright and release notes please refer to:
-- https://github.com/mriscoc/SBA-Library/tree/master/HX711/readme.md
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HX711 is
generic(
  debug:positive:=1;             -- debugging flag
  sysfreq:positive:=25E6         -- CLK_I main clock frequency
);
port(
-- SBA Interface
   RST_I : in  std_logic;        -- active high reset
   CLK_I : in  std_logic;        -- Main clock
   STB_I : in  std_logic;        -- Strobe
   WE_I  : in  std_logic;        -- Bus write, active high
   ADR_I : in  std_logic_vector; -- Register AD0/AD1 selector
   DAT_O : out std_logic_vector; -- Data output Bus
   INT_O : out std_logic;        -- End of conversión
-- Interface for HX711
   MISO  : in  std_logic;        -- Master In / Slave Out (DT in HX711)
   SCK   : out std_logic         -- SPI Clock
);
end HX711;

architecture  HX711_Arch of  HX711 is
type tstate is (IniSt, DataSt, EndSt); -- SPI Communication States

signal state    : tstate;
signal streami  : std_logic_vector (23 downto 0);  -- Serial input register
signal RDREG    : std_logic_vector (23 downto 0);  -- Read Data register
signal SCKN     : unsigned (4 downto 0);           -- SCK bit counter
signal SCKi     : std_logic;                       -- SCK SPI Clock
signal INTF     : std_logic;                       -- Interrupt Flag
signal EOCi     : std_logic;                       -- End of Convertion

begin

-- SPI Clock generator of 500 kHz:

SCK1: if (sysfreq>500E3) generate
  CLK_Div : entity work.ClkDiv
  Generic map (
    debug=>debug,
    infreq=>sysfreq,
    outfreq=>500E3
    )
  Port Map(
    RST_I => RST_I,
    CLK_I => CLK_I,
    CLK_O => SCKi
  );
end generate;

SCK2: if (sysfreq<=500E3) generate
  SCKi <= CLK_I;
end generate;

-- SPI BUS Proccess
  
SPIState:process (SCKi, RST_I)
  begin
    if (RST_I='1') then
      state <= IniSt;
      RDREG <= (others => '0');
    elsif falling_edge(SCKi) then
      case State is
        when IniSt => if (MISO='0') then
                        state <= DataSt;
                      end if;

        when DataSt=> if (SCKN > 22) then
                        state <= EndSt;
                      end if;

        when EndSt => state <= IniSt;
                      RDREG <= streami;
      end case;
    end if;
  end process SPIState;

SPIbitcounter:process(SCKi, State)
  begin
    if (State=IniSt) then
      SCKN  <= (others => '0');
    elsif falling_edge(SCKi) then
      SCKN <= SCKN+1;
    end if;
  end process SPIbitcounter;


SPIDataProcess:process(SCKi, State)
  begin
    if (State=IniSt) then
      streami <= (others =>'0');
    elsif rising_edge(SCKi) then
      streami <= streami(streami'high-1 downto 0) & MISO;
    end if;
  end process SPIDataProcess;

EOCiProcess:process(RST_I,SCKi,INTF)
  begin
    if (RST_I='1') or (INTF='1') then
      EOCi <= '0';
    elsif falling_edge(SCKi) and (State = EndSt) then
      EOCi <= '1';
    end if;
  end process EOCiProcess;

SBAProcess:process(RST_I, CLK_I)
  begin
    if (RST_I='1') then
      INTF <= '0';
    elsif rising_edge(CLK_I) then
      if (EOCi='1') then
        INTF <= '1';
      elsif (STB_I='1' and WE_I='0' and ADR_I(0)='1') then
        INTF <= '0';
      end if;
    end if;
  end process SBAProcess;

-- Interface signals
  SCK   <= '0' When State=IniSt else SCKi;
  DAT_O <= std_logic_vector(resize(signed(RDREG(15 downto 0)),DAT_O'length)) when ADR_I(0)='0' else
           INTF & std_logic_vector(resize(signed(RDREG(23 downto 16)),DAT_O'length-1));
  INT_O <= INTF;

end  HX711_Arch;
