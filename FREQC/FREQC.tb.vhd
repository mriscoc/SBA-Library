-- File Name: FREQC.tb.vhd
-- Title: Testbench
-- Version: 1.0
-- Date: 2017/03/30
-- Author: Miguel A. Risco Castillo
-- Description: Vhdl Test Bench for IP Core FREQC, run for 2 ms
--------------------------------------------------------------------------------

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                
use ieee.numeric_std.all;

ENTITY FREQC_test IS
END FREQC_test;

ARCHITECTURE FREQC_arch OF FREQC_test IS

SIGNAL ADR_I : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others=>'0');
SIGNAL FC : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL CLK_I : STD_LOGIC;
SIGNAL DAT_O : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL RST_I : STD_LOGIC := '1';
SIGNAL STB_I : STD_LOGIC := '0';
SIGNAL WE_I : STD_LOGIC  := '0';
SIGNAL INT_O : STD_LOGIC;

constant chans : positive:= 4;                   -- Four channels

COMPONENT FREQC
generic (
  chans:positive;
  wsizems:positive
  );
	PORT (
	ADR_I : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	FC : IN STD_LOGIC_VECTOR(chans-1 DOWNTO 0);
	CLK_I : IN STD_LOGIC;
	DAT_O : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    INT_O : OUT STD_LOGIC;
	RST_I : IN STD_LOGIC;
	STB_I : IN STD_LOGIC;
	WE_I : IN STD_LOGIC
	);
END COMPONENT;

BEGIN
	i1 : FREQC
    GENERIC MAP (
      chans => chans,
      wsizems => 1                               -- Adquisition window of 1ms
    )
    PORT MAP (
-- list connections between master ports and signals
	ADR_I => ADR_I,
	FC => FC(chans-1 DOWNTO 0),
	CLK_I => CLK_I,
	DAT_O => DAT_O,
	RST_I => RST_I,
	STB_I => STB_I,
	WE_I => WE_I,
    INT_O => INT_O
	);

reset : PROCESS
BEGIN
  RST_I<='1';
  WAIT FOR 40 ns;
  RST_I<='0';
  WAIT;
END PROCESS reset;


clkproc : PROCESS
BEGIN
  CLK_I <= '0';
  WAIT FOR 10 ns;
  CLK_I <= '1';
  WAIT FOR 10 ns;
END PROCESS clkproc;

control : PROCESS
BEGIN
  wait for 40 ns;                                -- Reset time
  wait for 1 ms;                                 -- Wait for wsizems
  STB_I <= '1';                                  -- Select Core
  WE_I  <= '0';                                  -- Enable read from bus
  ADR_I(1 downto 0) <= "00";                     -- Select channel 0
  wait for 250 us;
  ADR_I(1 downto 0) <= "01";                     -- Select channel 1
  wait for 250 us;
  ADR_I(1 downto 0) <= "10";                     -- Select channel 2
  wait for 250 us;
  ADR_I(1 downto 0) <= "11";                     -- Select channel 3
  WAIT;
END PROCESS control;

InputStimuli: PROCESS
variable COUNT:unsigned(FC'range):=(others=>'0');
BEGIN
  COUNT := COUNT+1;
  FC <= STD_LOGIC_VECTOR(COUNT);
  WAIT FOR 5 us;                                 -- 5 us for 100KHz en FC(0)
END PROCESS InputStimuli;

END FREQC_arch;
