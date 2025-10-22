--------------------------------------------------------------------------------
-- DDC264
--
-- Title: DDC264 IP Core
--
-- Version: 1.1
-- Date: 2025/10/21
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/DDC264
--
-- Description: Preliminary version of SBA Slave IP Core adapter for the DDC264
-- The minimum data bus width is 16 bits.
-- The Register Select uses the four least significant bits of the address bus.
--
-- Write:
-- 0000 : Control register
--   bit(0) <- start to shift configuration word to DDC_DIN_CFG
--   bit(1) <- set/reset DDC_CONV
-- 0001 : Configuration Word
--
-- Read:
-- 0000 : Status register (FSM state)
-- 0001 : Read back configuration word
--
--------------------------------------------------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity DDC264 is
  generic (
    debug       : positive :=1;
    infreq      : positive := 50E6         -- Main frequency of CLK_I (50 MHz)
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
    DDC_CLK     : out std_logic;           -- Master/System clock
    DDC_CONV    : out std_logic;           -- DDC264 CONV (Integration control)
    DDC_DIN_CFG : out std_logic;           -- Serial configuration data
    DDC_CLK_CFG : out std_logic;           -- Configuration clock (Max 20 MHz)
    DDC_RESET   : out std_logic            -- DDC264 RESET (Active low)
  );
end DDC264;

architecture DDC264_arch of DDC264 is

  -- Dynamic timing constants calculation (Minimum required cycles)
  -- Time is based on the CLK_I period (1 / infreq).
  constant F_MHZ : integer := infreq / 1000000;

  -- 1. tPOR: Time between power-up and first reset = 250 ms = 250,000 µs.
  -- Cycles = (250,000 µs) / (1 / infreq) = 250,000 * infreq / 1,000,000
  constant T_POWER_UP_US : integer := 3;
  -- constant T_POWER_UP_US : integer := 250E3;
  constant POWER_UP_CYCLES : natural := T_POWER_UP_US * F_MHZ;

  -- 2. tRST: Minimum pulse width for RESET active = 1 µs.
  -- Cycles = (1 µs) / (1 / infreq) = infreq / 1,000,000
  constant T_RST_US : integer := 1;
  constant RST_PULSE_CYCLES : natural := T_RST_US * F_MHZ;

  -- 3. tWTRST: Wait Required from Reset High to First Rising Edge of CLK_CFG = 2 µs.
  -- Cycles = (2 µs) / (1 / infreq) = 2 * infreq / 1,000,000
  constant T_WTRST_US : integer := 2;
  constant WTRST_WAIT_CYCLES : natural := T_WTRST_US * F_MHZ;

  -- 4. tWTWR: Wait Required from Last CLK_CFG of Write Operation to First DCLK of Read Operation = 2 µs.
  -- Cycles = (2 µs) / (1 / infreq) = 2 * infreq / 1,000,000
  constant T_WTWR_US : integer := 2;
  constant WTWR_WAIT_CYCLES : natural := T_WTWR_US * F_MHZ;

  -- SBA Internal Register Definitions
  constant ADDR_CTRL      : std_logic_vector(3 downto 0) := x"0";
  constant ADDR_CFG_WORD  : std_logic_vector(3 downto 0) := x"1";

  -- Stores the 16-bit Configuration Word
  signal Config_Word_Reg : std_logic_vector(15 downto 0) := (others => '0');

  -- DDC264 Control Signals
  signal s_ddc_clk_o     : std_logic;
  signal s_ddc_conv_o    : std_logic;
  signal s_ddc_clk_cfg_o : std_logic;
  signal s_ddc_reset_o   : std_logic;
  signal s_ddc_reg_sel   : std_logic_vector(3 downto 0);

  -- FSM for Configuration Sequence
  type t_state is (
      POWER_UP, IDLE, RESET_PULSE, WAIT_WTRST, PREPARE_CFG, SHIFT_CFG, WAIT_WTWR
  );
  signal current_state : t_state := IDLE;

  -- Counters limited by the maximum wait cycle
  signal cfg_counter   : natural range 0 to POWER_UP_CYCLES := 0;

  -- Bit counter for the configuration word shift register
  signal bit_counter   : natural range 0 to 16 := 0;

  -- Shift register for the configuration word
  signal s_ddc_din_cfg_reg : std_logic_vector(15 downto 0) := (others => '0');

  -- Commands captured from the SBA bus
  signal start_config_cmd : std_logic := '0';

  -- Storage of previous DDC_CLK_CFG state
  signal clk_cfg_prev : std_logic := '0';

begin

  -- DDC_CLK must be a clock of maximum 10 MHz for the DDC264CK
  -- A clock divider will be enabled for the DDC264 so the maximum
  -- frequency of DDC_CLK is 40 MHz. DDC_CLK is derived from CLK_I;
  -- if CLK_I is greater than 40 MHz, it is divided by 2, otherwise assigned directly.

  -- Divide by 2 if infreq > 40 MHz
  gen_clk_select : if infreq > 40000000 generate
  signal clkdiv2 : std_logic := '0';
  begin
    process(CLK_I)
    begin
      if rising_edge(CLK_I) then
        clkdiv2 <= not clkdiv2;
      end if;
    end process;
    s_ddc_clk_o <= clkdiv2;
  end generate;

  -- Direct assignment if infreq ≤ 40 MHz
  gen_clk_direct : if infreq <= 40000000 generate
    s_ddc_clk_o <= CLK_I;
  end generate;

  -- Generator for DDC_CLK_CFG = CLK_I/4
  process(RST_I, CLK_I)
    variable clk_cfg_div : unsigned(1 downto 0);
  begin
    if RST_I = '1' then
      clk_cfg_div := (others => '0');
    elsif rising_edge(CLK_I) then
      if (current_state = SHIFT_CFG) and (bit_counter > 0) then
        clk_cfg_div := clk_cfg_div + 1;
      else
        clk_cfg_div := (others => '0');
      end if;
    end if;
    s_ddc_clk_cfg_o <= clk_cfg_div(1);
  end process;

  -- Shift process for the control register
  process(RST_I, CLK_I)
  begin
    if RST_I = '1' then
      s_ddc_din_cfg_reg <= (others => '0');
      bit_counter <= 0;
    elsif rising_edge(CLK_I) then
      if current_state = PREPARE_CFG then
        s_ddc_din_cfg_reg <= Config_Word_Reg;
        bit_counter <= 16;
      elsif current_state = SHIFT_CFG then
        -- falling edge (falling_edge not used, signal comes from logic)
        if s_ddc_clk_cfg_o = '0' and clk_cfg_prev = '1' then
          if bit_counter > 0 then
            s_ddc_din_cfg_reg <= s_ddc_din_cfg_reg(14 downto 0) & '0';
            bit_counter <= bit_counter - 1;
          end if;
        end if;
      end if;
    end if;
  end process;

  -- Process for DDC_RESET signal
  process(RST_I, current_state)
  begin
    if RST_I = '1' then
      s_ddc_reset_o <= '0';
    elsif current_state = RESET_PULSE then
      s_ddc_reset_o <= '0';
    else
      s_ddc_reset_o <= '1';
    end if;
  end process;

  -- State Machine
  process(RST_I, CLK_I)
  begin
    if RST_I = '1' then
      current_state <= POWER_UP;
      cfg_counter   <= 0;
    elsif rising_edge(CLK_I) then
      clk_cfg_prev <= s_ddc_clk_cfg_o;
      case current_state is

        when POWER_UP =>
          -- tPOR >= 250 ms
          if cfg_counter < POWER_UP_CYCLES then
            cfg_counter <= cfg_counter + 1;
          else
            cfg_counter <= 0;
            current_state <= IDLE;
          end if;

        when IDLE =>
          if start_config_cmd = '1' then
              current_state <= RESET_PULSE;
          end if;

        when RESET_PULSE =>
          -- tRST >= 1 µs
          if cfg_counter < RST_PULSE_CYCLES then
            cfg_counter <= cfg_counter + 1;
          else
            cfg_counter <= 0;
            current_state <= WAIT_WTRST;
          end if;

        when WAIT_WTRST =>
          -- tWTRST >= 2 µs
          if cfg_counter < WTRST_WAIT_CYCLES then
            cfg_counter <= cfg_counter + 1;
          else
            cfg_counter <= 0;
            current_state <= PREPARE_CFG;
          end if;

        when PREPARE_CFG =>
          current_state <= SHIFT_CFG;

        when SHIFT_CFG =>
          if bit_counter = 0 then
            current_state <= WAIT_WTWR;
          end if;

        when WAIT_WTWR =>
          -- tWTWR >= 2 µs
          if cfg_counter < WTWR_WAIT_CYCLES then
            cfg_counter <= cfg_counter + 1;
          else
            cfg_counter <= 0;
            current_state <= IDLE;
          end if;

        when others =>
          current_state <= IDLE;

      end case;
    end if;
  end process;

  -- SBA Interface Process (Read/Write)
  process(CLK_I)
  begin
    if (RST_I='1') then
      Config_Word_Reg  <= (others => '0');
      start_config_cmd <= '0';
      s_ddc_conv_o <= '0';
    elsif rising_edge(CLK_I) then
      if STB_I = '1' and WE_I = '1' then -- SBA Write
        case s_ddc_reg_sel is
          when ADDR_CTRL =>
            if DAT_I(0) = '1' then
              start_config_cmd <= '1';
            end if;
            s_ddc_conv_o <= DAT_I(1);
          when ADDR_CFG_WORD =>
            Config_Word_Reg <= DAT_I(Config_Word_Reg'range);
          when others =>
            null;
        end case;
      elsif current_state = RESET_PULSE then
        start_config_cmd <= '0';
        s_ddc_conv_o <= '0';
      end if;
    end if;
  end process;

  -- Physical output port mapping
  DDC_CLK     <= s_ddc_clk_o;
  DDC_CONV    <= s_ddc_conv_o;
  DDC_DIN_CFG <= s_ddc_din_cfg_reg(15);  -- MSB
  DDC_CLK_CFG <= s_ddc_clk_cfg_o;
  DDC_RESET   <= s_ddc_reset_o;

  -- Register selection logic and SBA Read Data Output
  s_ddc_reg_sel <= ADR_I(3 downto 0);

  DAT_O <= std_logic_vector(to_unsigned(t_state'pos(current_state), 16)) when s_ddc_reg_sel = ADDR_CTRL else
           std_logic_vector(resize(unsigned(Config_Word_Reg),DAT_O'length))  when s_ddc_reg_sel = ADDR_CFG_WORD else
           (DAT_O'range => '0');

end DDC264_arch;
