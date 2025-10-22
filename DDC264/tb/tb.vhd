--------------------------------------------------------------------------------
-- File Name: DDC264.tb.vhd
-- Title: Testbench for IP Core DDC264
-- Version: 1.0
-- Date: 2025/10/20
-- Author: Miguel A. Risco Castillo
-- Description: VHDL Test Bench for IP Core DDC264
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.env.all; -- Include the env package

entity testbench IS
end testbench;

architecture DDC264_arch OF testbench IS

-- SBA signals
signal RST_I : std_logic := '1';
signal CLK_I : std_logic := '0';
signal STB_I : std_logic := '0';
signal WE_I  : std_logic := '0';
signal ADR_I : std_logic_vector(15 DOWNTO 0) := (others=>'0');
signal DAT_I : std_logic_vector(15 DOWNTO 0);
signal DAT_O : std_logic_vector(15 DOWNTO 0);

-- DDC264 testbench signals
signal DDC_CLK     : std_logic;  -- Master/System Clock
signal DDC_CONV    : std_logic;  -- DDC264 CONV (Integration Control)
signal DDC_DIN_CFG : std_logic;  -- Serial configuration data
signal DDC_CLK_CFG : std_logic;  -- Configuration clock (Max 20 MHz)
signal DDC_RESET   : std_logic;  -- DDC264 RESET (Active low)

constant freq : positive := 40E6; -- Main clock: 40MHz
--constant freq : positive := 50E6; -- Main clock: 50MHz
--constant freq : positive := 60E6; -- Main clock: 60MHz
--constant freq : positive := 75E6; -- Main clock: 75MHz
--constant freq : positive := 80E6; -- Main clock: 80MHz
constant CLKPERIOD : time := (real(1000000000)/real(freq)) * 1 ns;

component DDC264
generic(
  debug:positive:=1;
  infreq:positive:=freq
);
port (
    -- SBA INTERFACE PORTS (SLAVE)
    RST_I       : in  std_logic;           -- Asynchronous reset of the FPGA system
    CLK_I       : in  std_logic;           -- Main clock of the FPGA system (50 MHz)
    STB_I       : in  std_logic;           -- Chip Select (Slave enable)
    WE_I        : in  std_logic;           -- Write Enable (Active high)
    ADR_I       : in  std_logic_vector;    -- Input address (from Master)
    DAT_I       : in  std_logic_vector;    -- Input data (from Master)
    DAT_O       : out std_logic_vector;    -- Output data (to Master)

    -- DDC264 CONTROL SIGNALS
    DDC_CLK     : out std_logic;           -- Master/System Clock
    DDC_CONV    : out std_logic;           -- DDC264 CONV (Integration Control)
    DDC_DIN_CFG : out std_logic;           -- Serial configuration data
    DDC_CLK_CFG : out std_logic;           -- Configuration clock (Max 20 MHz)
    DDC_RESET   : out std_logic            -- DDC264 RESET (Active low)
);
end component;

begin

DDC264_control : DDC264
PORT MAP (
-- list connections between master ports and signals
  RST_I => RST_I,
  CLK_I => CLK_I,
  STB_I => STB_I,
  WE_I  => WE_I,
  ADR_I => ADR_I,
  DAT_I => DAT_I,
  DAT_O => DAT_O,
-- list of DDC signals
  DDC_CLK => DDC_CLK,
  DDC_CONV => DDC_CONV,
  DDC_DIN_CFG => DDC_DIN_CFG,
  DDC_CLK_CFG  => DDC_CLK_CFG,
  DDC_RESET  => DDC_RESET
);

-- Reset control process
reset : process
begin
  report "CLK PERIOD: " & time'image(CLKPERIOD);
  RST_I<='1';
  wait FOR 2 * CLKPERIOD;
  RST_I<='0';
  wait;
end process reset;

-- Clock generation process
clkproc : process
begin
  CLK_I <= '0';
  wait FOR CLKPERIOD/2;
  CLK_I <= '1';
  wait FOR CLKPERIOD/2;
end process clkproc;

-- Stimulus process
control : process
begin
  -- wait for reset to be released
  wait until RST_I = '0';

  -- Read DDC264 state and wait for power-up sequence
  report "Reading state";
  ADR_I <= x"0000";  -- ADDR_FSM_STATUS
  wait until rising_edge(CLK_I);
  STB_I <= '1';
  WE_I  <= '0';
  wait until DAT_O = x"0001"; -- State = IDLE
  wait until rising_edge(CLK_I);
  STB_I <= '0';

  -- Write configuration word
  report "Writing Config_Word_Reg with 0xABCD";
  DAT_I <= x"ABCD";
  ADR_I <= x"0001";  -- ADDR_CFG_WORD
  wait until rising_edge(CLK_I);
  STB_I <= '1';
  WE_I  <= '1';
  wait until rising_edge(CLK_I);
  STB_I <= '0';
  WE_I  <= '0';

  -- Start configuration (bit 0 = '1')
  report "Writing start configuration command (start_config_cmd)";
  DAT_I <= x"0001";  -- Bit 0 high
  ADR_I <= x"0000";  -- ADDR_CTRL
  wait until rising_edge(CLK_I);
  STB_I <= '1';
  WE_I  <= '1';
  wait until rising_edge(CLK_I);
  STB_I <= '0';
  WE_I  <= '0';

  -- Wait for configuration to complete
  report "Reading state";
  ADR_I <= x"0000";  -- ADDR_FSM_STATUS
  wait until rising_edge(CLK_I);
  STB_I <= '1';
  WE_I  <= '0';
  wait until DAT_O = x"0001"; -- State = IDLE
  wait until rising_edge(CLK_I);
  STB_I <= '0';

  -- Toggle DDC_CONV
  report "Changing CONV state to 1";
  DAT_I <= x"0002";  -- Bit 1 high
  ADR_I <= x"0000";  -- ADDR_CTRL
  wait until rising_edge(CLK_I);
  STB_I <= '1';
  WE_I  <= '1';
  wait until rising_edge(CLK_I);
  STB_I <= '0';
  WE_I  <= '0';

  wait for 1 us;

  -- Toggle DDC_CONV
  report "Changing CONV state to 0";
  DAT_I <= x"0000";  -- Bit 1 low
  ADR_I <= x"0000";  -- ADDR_CTRL
  wait until rising_edge(CLK_I);
  STB_I <= '1';
  WE_I  <= '1';
  wait until rising_edge(CLK_I);
  STB_I <= '0';
  WE_I  <= '0';

  -- end simulation

  wait for 1 us;
  report "Simulation completed successfully" severity note;
  stop(0); -- Stops the simulation and returns 0 (success)
  wait;

end process control;

end DDC264_arch;
