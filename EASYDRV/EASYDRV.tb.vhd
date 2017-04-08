-- File Name: EASYDRV.tb.vhd
-- Title: Testbench
-- Version: 1.0
-- Date: 2017/04/05
-- Author: Miguel A. Risco Castillo
-- Description: Vhdl Test Bench for IP Core EASYDRV, run for ...
--------------------------------------------------------------------------------

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                
use ieee.numeric_std.all;

ENTITY EASYDRV_test IS
END EASYDRV_test;

ARCHITECTURE EASYDRV_arch OF EASYDRV_test IS

SIGNAL ADR_I : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others=>'0');
SIGNAL CLK_I : STD_LOGIC;
SIGNAL DAT_I : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others=>'0');
SIGNAL DAT_O : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL RST_I : STD_LOGIC := '1';
SIGNAL STB_I : STD_LOGIC := '0';
SIGNAL WE_I  : STD_LOGIC := '0';
SIGNAL INT_O : STD_LOGIC;

Signal ENABLE : std_logic;
Signal DIR    : std_logic;
Signal STEP   : std_logic;
Signal RSTPOS : std_logic := '0';

COMPONENT EASYDRV is
generic (
  minspd:positive;
  maxspd:positive
  );
port (
  -- SBA Bus Interface
  CLK_I : in std_logic;           -- SBA Main System Clock
  RST_I : in std_logic;           -- SBA System reset
  WE_I  : in std_logic;           -- SBA Write/Read Enable control signal
  STB_I : in std_logic;           -- SBA Strobe/chip select
  ADR_I : in std_logic_vector;    -- SBA Address bus / Register select
  DAT_I : in std_logic_vector;    -- SBA Data input bus / Write Control/Position
  DAT_O : out std_logic_vector;   -- SBA Data output bus / Read Status/Position
  INT_O	: out std_logic;          -- Interrupt request output
  -- PORT Interface;
  ENABLE : out std_logic;
  DIR    : out std_logic;
  STEP   : out std_logic;
  RSTPOS : in std_logic
  );
END COMPONENT;

BEGIN
	i1 : EASYDRV
    GENERIC MAP (
      minspd=>1E5,
      maxspd=>1E6
    )
    PORT MAP (
    CLK_I => CLK_I,
    RST_I => RST_I,
    WE_I  => WE_I ,
    STB_I => STB_I,
    ADR_I => ADR_I,
    DAT_I => DAT_I,
    DAT_O => DAT_O,
    INT_O => INT_O,
    --
    ENABLE => ENABLE,
    DIR    => DIR,
    STEP   => STEP,
    RSTPOS => RSTPOS
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
  wait for 50 us;                                -- Wait time
  STB_I <= '1';                                  -- Select Core
  ADR_I(0) <= '0';                               -- Select SetPos register
  WE_I  <= '1';                                  -- Write to bus
  DAT_I <= x"0020";                              -- Write 0x20 to SetPos
  wait for 50 us;                                -- Wait time
  ADR_I(0) <= '1';                               -- Select Control register
  DAT_I <= (1=>'1',Others=>'0');                 -- Set ENACTRL bit (Enable steps)
  wait for 400 us;                               -- Wait time
  RSTPOS <= '1';                                 -- Enable external Reset Position
  wait for 1 us;                                 -- Wait time
  RSTPOS <= '0';                                 -- Disable external Reset Position
  WAIT;
END PROCESS control;

END EASYDRV_arch;
