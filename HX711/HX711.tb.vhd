-- File Name: HX711.tb.vhd
-- Title: Testbench
-- Version: 1.0
-- Date: 2019/07/12
-- Author: Miguel A. Risco Castillo
-- Description: Vhdl Test Bench for IP Core HX711
--------------------------------------------------------------------------------

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                
use ieee.numeric_std.all;

ENTITY HX711_test IS
END HX711_test;

ARCHITECTURE HX711_arch OF HX711_test IS

-- Master SBA signals
SIGNAL RSTi  : STD_LOGIC := '1';
SIGNAL CLKi  : STD_LOGIC;
SIGNAL STBi  : STD_LOGIC := '0';
SIGNAL WEi   : STD_LOGIC := '0';
SIGNAL ADRi  : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others=>'0');
SIGNAL DATIi : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal INTi  : std_logic;

-- Interface signals
SIGNAL MISO  : std_logic;        -- Master In Slave Out
SIGNAL SCK   : std_logic;        -- SPI Clock

-- Results
signal RESULT : STD_LOGIC_VECTOR(23 DOWNTO 0) := (others=>'0');

-- System clock frequency
CONSTANT freq : positive := 50E6;
CONSTANT CLKPERIOD : time := (real(1000000000)/real(freq)) * 1 ns;

-- Utility constants
constant SPIDATA : std_logic_vector(23 downto 0) := x"123456";

COMPONENT HX711
generic(
  debug:positive:=1;
  sysfreq:positive:=freq
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
   MISO  : in  std_logic;        -- Master In Slave Out
   SCK   : out std_logic         -- SPI Clock
);
END COMPONENT;

BEGIN
	i1 : HX711
    PORT MAP (
-- list connections between master ports and signals
	RST_I => RSTi,
	CLK_I => CLKi,
	STB_I => STBi,
	WE_I  => WEi,
	ADR_I => ADRi,
	DAT_O => DATIi,
    INT_O => INTi,
 --
    MISO => MISO,
    SCK  => SCK
	);

reset : PROCESS
BEGIN
  report "CLK PERIOD: " & time'image(CLKPERIOD);
  RSTi<='1';
  WAIT FOR 4 * CLKPERIOD;
  RSTi<='0';
  WAIT;
END PROCESS reset;


clkproc : PROCESS
BEGIN
  CLKi <= '0';
  WAIT FOR CLKPERIOD/2;
  CLKi <= '1';
  WAIT FOR CLKPERIOD/2;
END PROCESS clkproc;

control : PROCESS
BEGIN
  wait until INTi='1';                          -- Wait for end of conversion
  wait until rising_edge(CLKi);
  STBi <= '1';                                  -- Select Core
  WEi  <= '0';                                  -- Enable read from bus
  ADRi(0) <= '0';                               -- Select REG0
  wait until rising_edge(CLKi);
  RESULT <= x"00" & DATIi;
  STBi <= '0';                                  -- deselect Core
  wait for 5 us;
  wait until rising_edge(CLKi);
  STBi <= '1';                                  -- Select Core
  ADRi(0) <= '1';                               -- Select REG1
  wait until rising_edge(CLKi);
  RESULT <= DATIi(7 downto 0) & RESULT(15 downto 0);
  STBi <= '0';                                  -- deselect Core
  WAIT;
END PROCESS control;


hx711_spi: PROCESS
BEGIN
  MISO <= '1';
  wait until RSTi='0';
  wait for 30 us;
  MISO <= '0';
  for i in 23 downto 0 loop
    wait until rising_edge(SCK);
    MISO <= SPIDATA(i);
  end loop;
  wait until rising_edge(SCK);
  MISO <= '1';
  wait;
END PROCESS hx711_spi;

END HX711_arch;
