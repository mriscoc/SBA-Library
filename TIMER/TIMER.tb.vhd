-- File Name: TIMER.tb.vhd
-- Title: Testbench
-- Version: 1.0
-- Date: 2017/05/12
-- Author: Miguel A. Risco Castillo
-- Description: Vhdl Test Bench for IP Core TIMER
--------------------------------------------------------------------------------

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                
use ieee.numeric_std.all;

ENTITY TIMER_test IS
END TIMER_test;

ARCHITECTURE TIMER_arch OF TIMER_test IS

constant chans : positive:= 4;                   -- Four channels

SIGNAL ADR_I : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others=>'0');
SIGNAL TOUT : STD_LOGIC_VECTOR(chans-1 DOWNTO 0);
SIGNAL CLK_I : STD_LOGIC;
SIGNAL DAT_O : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL DAT_I : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL RST_I : STD_LOGIC := '1';
SIGNAL STB_I : STD_LOGIC := '0';
SIGNAL WE_I : STD_LOGIC  := '0';
SIGNAL INT_O : STD_LOGIC;

COMPONENT TIMER
generic (
  chans:positive
  );
  PORT (
	ADR_I : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	CLK_I : IN STD_LOGIC;
	DAT_O : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	DAT_I : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    INT_O : OUT STD_LOGIC;
	RST_I : IN STD_LOGIC;
	STB_I : IN STD_LOGIC;
	WE_I : IN STD_LOGIC;
  -- PORT Interface;
    TOUT  : out std_logic_vector(chans-1 downto 0) -- Timer Output Channels
  );
END COMPONENT;

BEGIN
	i1 : TIMER
    GENERIC MAP (
      chans => chans
    )
    PORT MAP (
-- list connections between master ports and signals
	ADR_I => ADR_I,
	CLK_I => CLK_I,
	DAT_O => DAT_O,
    DAT_I => DAT_I,
	RST_I => RST_I,
	STB_I => STB_I,
	WE_I => WE_I,
    INT_O => INT_O,
    TOUT => TOUT
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
  wait for 50 ns;                                -- Reset time
  STB_I <= '1';                                  -- Select Core
  WE_I  <= '1';                                  -- Write to bus
--
  ADR_I(1 downto 0) <= "11";                     -- Select TMRCHS
  DAT_I <= x"0000";                              -- Select Timer 0
  wait for 20 ns;
--
  ADR_I(1 downto 0) <= "00";                     -- Select TMRDATL
  DAT_I <= x"0032";                              -- Write 50 to TimerL(0)
  wait for 20 ns;
--
  ADR_I(1 downto 0) <= "01";                     -- Select TMRDATH
  DAT_I <= x"0000";                              -- Write 0 to TimerH(0)
  wait for 20 ns;
--
  ADR_I(1 downto 0) <= "10";                     -- Select TMRCFG
  DAT_I <= x"000"& '1'&'0'&'0'&'1';              -- Enable Timer(0), Output and Interrupt
  wait for 20 ns;
--
  wait for 3 us;
  WE_I  <= '0';                                  -- Enable read from bus
  ADR_I(1 downto 0) <= "00";                     -- Select TMRDATL
  WAIT;
END PROCESS control;

END TIMER_arch;
