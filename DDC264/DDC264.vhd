--------------------------------------------------------------------------------
-- DDC264
--
-- Title: DDC264 IP Core
--
-- Version: 2.5
-- Date: 2025/11/13
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/DDC264
--
-- Description: SBA Slave IP Core adapter for the DDC264
-- The minimum data bus width is 20 bits.
-- The Register Select uses the two least significant bits of the address bus.
--
-- Write:
-- 00 x"0": Control register
--   bit(0) <- start to shift configuration word to DDC_DIN_CFG
--   bit(1) <- start to read data registers from DDC_DOUT
--   bit(8) <- set/reset DDC_CONV
--
-- 01 x"1" : Configuration Word
-- 10 x"2" : bit(5..0) <- Select data register to read (0 to 63)
--
-- Read:
-- 00 x"0" : Status register (FSMs state, DVALID, Data Ready, etc.)
--   bit(15..12) <- Configuration FSM state (0:POWER_UP, 1:IDLE, 2:RESET_PULSE, 3:WAIT_WTRST, 4:PREPARE_CFG, 5:SHIFT_CFG, 6:WAIT_WTWR)
--   bit(11..8)  <- Read FSM state (0:IDLE, 1:START_SQNC, 2:SHIFT_READ, 3:END_SQNC)
--   bit(7)      <- Data ready flag (1: all 64 data registers have been read, 0: not ready)
--   bit(6)      <- DDC_DVALID signal (0: valid data available (active low), 1: data not valid)
--   bit(5..0)   <- Reserved (always 0)
-- 01 x"1" : Read back configuration word
-- 10 x"2" : Read data register selected previously
--
--------------------------------------------------------------------------------
-- Copyright:
--
-- (c) Miguel A. Risco-Castillo
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

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity DDC264 is
  generic (
    debug       : natural := 1;
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

    -- DDC264 CONTROL INTERFACE
    DDC_CLK     : out std_logic;           -- Master/System clock
    DDC_CONV    : out std_logic;           -- DDC264 CONV (Integration control)
    DDC_DIN_CFG : out std_logic;           -- Serial configuration data
    DDC_CLK_CFG : out std_logic;           -- Configuration clock (Max 20 MHz)
    DDC_RESET   : out std_logic;           -- DDC264 RESET (Active low)

    -- DDC264 DATA INTERFACE
    DDC_DVALID  : in  std_logic;           -- Data valid signal active low (indicates when DDC_DOUT is stable and can be sampled)
    DDC_DCLK    : out std_logic;           -- Data clock signal (used to synchronize data transfer)
    DDC_DOUT    : in  std_logic            -- Serial data output from DDC264 (used to read conversion results)
  );
end DDC264;

architecture DDC264_arch of DDC264 is

  -- Dynamic timing constants calculation (Minimum required cycles)
  -- Time is based on the CLK_I period (1 / infreq).
  constant F_MHZ : integer := infreq / 1000000;

  -- 1. tPOR: Time between power-up and first reset = 250 ms = 250,000 µs.
  -- Cycles = (250,000 µs) / (1 / infreq) = 250,000 * infreq / 1,000,000
  constant T_POWER_UP_US : integer := 3;  -- 3 us
  -- constant T_POWER_UP_US : integer := 250E3;  -- 250 ms
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

  -- SBA Address Definitions
  alias s_address         : std_logic_vector is ADR_I(1 downto 0);
  constant ADDR_CTRL      : std_logic_vector(1 downto 0) := "00";
  constant ADDR_CFG_WORD  : std_logic_vector(1 downto 0) := "01";
  constant ADDR_DATA_REG  : std_logic_vector(1 downto 0) := "10";

  -- Stores the 16-bit Configuration Word and status register
  signal Config_Word_Reg : std_logic_vector(15 downto 0) := (others => '0');
  signal Status_Reg      : std_logic_vector(15 downto 0) := (others => '0');

  -- DDC264 Control Signals
  signal s_ddc_clk_o     : std_logic;
  signal s_ddc_conv_o    : std_logic;
  signal s_ddc_clk_cfg_o : std_logic;
  signal s_ddc_reset_o   : std_logic;

  -- DDC264 Data Signals
  signal s_ddc_dvalid_i : std_logic;
  signal s_ddc_dclk_o   : std_logic;
  signal s_ddc_dout_i   : std_logic;

  -- FSM for Configuration Sequence
  type t_cfg_state is (
      POWER_UP, IDLE, RESET_PULSE, WAIT_WTRST, PREPARE_CFG, SHIFT_CFG, WAIT_WTWR
  );
  signal config_state : t_cfg_state := IDLE;

  -- Counters limited by the maximum wait cycle
  signal cfg_counter   : natural range 0 to POWER_UP_CYCLES := 0;

  -- Bit counter for the configuration word shift register
  signal cfg_shift_counter   : natural range 0 to 16 := 0;

  -- Shift register for the configuration word
  signal s_ddc_din_cfg_reg : std_logic_vector(15 downto 0) := (others => '0');

  -- Commands captured from the SBA bus
  signal start_config_cmd : std_logic := '0';

  -- Storage of previous DDC_CLK_CFG state
  signal clk_cfg_prev : std_logic := '0';


  -- FSM for Read Sequence
  type t_read_state is (
      IDLE, START_SQNC, SHIFT_READ, END_SQNC
  );
  signal read_state : t_read_state := IDLE;

  -- Register counter
  signal data_reg_counter   : natural range 0 to 64 := 0;

  -- Bit counter for the data read shift register
  signal read_shift_counter   : natural range 0 to 20 := 0;

  -- Array for the data registers
  type t_data_array is array (0 to 63) of std_logic_vector(19 downto 0);
  signal s_ddc_din_reg : t_data_array := (others => (others => '0'));
  signal Data_Reg : std_logic_vector(19 downto 0);

   -- Read sequence started from the SBA bus
  signal start_read_cmd : std_logic := '0';

  -- Data ready flag
  signal data_ready : std_logic := '0';

  -- Data format
  signal data_format : std_logic := '1';

  -- Select register to read
  signal reg_to_read : natural range 0 to 63 := 0;

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
      if (config_state = SHIFT_CFG) and (cfg_shift_counter > 0) then
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
      cfg_shift_counter <= 0;
    elsif rising_edge(CLK_I) then
      if config_state = PREPARE_CFG then
        s_ddc_din_cfg_reg <= Config_Word_Reg;
        cfg_shift_counter <= 16;
      elsif config_state = SHIFT_CFG then
        -- falling edge (falling_edge not used, signal comes from logic)
        if s_ddc_clk_cfg_o = '0' and clk_cfg_prev = '1' then
          if cfg_shift_counter > 0 then
            s_ddc_din_cfg_reg <= s_ddc_din_cfg_reg(14 downto 0) & '0';
            cfg_shift_counter <= cfg_shift_counter - 1;
          end if;
        end if;
      end if;
    end if;
  end process;

  -- Process for DDC_RESET signal
  process(RST_I, config_state)
  begin
    if RST_I = '1' then
      s_ddc_reset_o <= '0';
    elsif config_state = RESET_PULSE then
      s_ddc_reset_o <= '0';
    else
      s_ddc_reset_o <= '1';
    end if;
  end process;

  -- Configuration State Machine
  process(RST_I, CLK_I)
  begin
    if RST_I = '1' then
      config_state <= POWER_UP;
      cfg_counter   <= 0;
    elsif rising_edge(CLK_I) then
      clk_cfg_prev <= s_ddc_clk_cfg_o;
      case config_state is

        when POWER_UP =>
          -- tPOR >= 250 ms
          if cfg_counter < POWER_UP_CYCLES then
            cfg_counter <= cfg_counter + 1;
          else
            cfg_counter <= 0;
            config_state <= IDLE;
          end if;

        when IDLE =>
          if start_config_cmd = '1' then
              config_state <= RESET_PULSE;
          end if;

        when RESET_PULSE =>
          -- tRST >= 1 µs
          if cfg_counter < RST_PULSE_CYCLES then
            cfg_counter <= cfg_counter + 1;
          else
            cfg_counter <= 0;
            config_state <= WAIT_WTRST;
          end if;

        when WAIT_WTRST =>
          -- tWTRST >= 2 µs
          if cfg_counter < WTRST_WAIT_CYCLES then
            cfg_counter <= cfg_counter + 1;
          else
            cfg_counter <= 0;
            config_state <= PREPARE_CFG;
          end if;

        when PREPARE_CFG =>
          config_state <= SHIFT_CFG;

        when SHIFT_CFG =>
          if cfg_shift_counter = 0 then
            config_state <= WAIT_WTWR;
          end if;

        when WAIT_WTWR =>
          -- tWTWR >= 2 µs
          if cfg_counter < WTWR_WAIT_CYCLES then
            cfg_counter <= cfg_counter + 1;
          else
            cfg_counter <= 0;
            config_state <= IDLE;
          end if;

        when others =>
          config_state <= IDLE;

      end case;
    end if;
  end process;


  -- Generator for DCLK = CLK_I/2
  process(RST_I, CLK_I)
  begin
    if RST_I = '1' then
      s_ddc_dclk_o <= '0';
    elsif rising_edge(CLK_I) then
      if (read_state = SHIFT_READ) and (read_shift_counter > 0) then
        s_ddc_dclk_o <= not s_ddc_dclk_o;
      else
        s_ddc_dclk_o <= '0';
      end if;
    end if;
  end process;

  -- Shift process for the data register array
  process(RST_I, CLK_I)
  variable s_ddc_dclk_prev : std_logic := '0';
  begin
    if RST_I = '1' then
      s_ddc_dclk_prev := '0';
      s_ddc_din_reg <= (others => (others => '0'));
      read_shift_counter <= 0;
    elsif rising_edge(CLK_I) then
      if read_state = START_SQNC then
        s_ddc_din_reg(data_reg_counter) <= (others => '0');
        if data_format = '0' then
          read_shift_counter <= 16;
        else
          read_shift_counter <= 20;
        end if;
      elsif read_state = SHIFT_READ then
        if s_ddc_dclk_o = '1' and s_ddc_dclk_prev = '0' then
          s_ddc_din_reg(data_reg_counter) <= s_ddc_din_reg(data_reg_counter)(18 downto 0) & s_ddc_dout_i;
          read_shift_counter <= read_shift_counter - 1;
        end if;
      end if;
      s_ddc_dclk_prev := s_ddc_dclk_o;
    end if;
  end process;

  -- Read Data State Machine
  process(RST_I, CLK_I)
  begin
    if RST_I = '1' then
      read_state <= IDLE;
      data_ready <= '0';
      data_reg_counter <= 63;
    elsif rising_edge(CLK_I) then
      if STB_I = '1' and WE_I = '0' and s_address = ADDR_DATA_REG then
        data_ready <= '0';  -- Reset data_ready when register are readed
      end if;
      case read_state is

        when IDLE =>
          if start_read_cmd = '1' then
              data_reg_counter <= 63;
              read_state <= START_SQNC;
          end if;

        when START_SQNC =>
          read_state <= SHIFT_READ;

        when SHIFT_READ =>
          if read_shift_counter = 0 then
            read_state <= END_SQNC;
          end if;

        when END_SQNC =>
          if data_reg_counter > 0 then
            read_state <= START_SQNC;
            data_reg_counter <= data_reg_counter - 1;
          else
            data_ready <= '1';
            read_state <= IDLE;
            if debug>0 then report "Data is ready to read"; end if;
          end if;

        when others =>
          read_state <= IDLE;

      end case;
    end if;
  end process;


  -- SBA Interface Write Process
  process(RST_I, CLK_I)
  begin
    if (RST_I='1') then
      Config_Word_Reg  <= (others => '0');
      start_config_cmd <= '0';
      s_ddc_conv_o <= '0';
    elsif rising_edge(CLK_I) then
      if STB_I = '1' and WE_I = '1' then -- SBA Write
        case s_address is
          when ADDR_CTRL =>
            if DAT_I(0) = '1' then
              start_config_cmd <= '1'; -- Bit 0 starts configuration sequence
              if debug>0 then report "Config command received"; end if;
            end if;
            if DAT_I(1) = '1' then
              start_read_cmd <= '1';   -- Bit 1 starts read sequence
              if debug>0 then report "Read command received"; end if;
            end if;
            s_ddc_conv_o <= DAT_I(8);  -- Bit 8 sets CONV state
          when ADDR_CFG_WORD =>
            Config_Word_Reg <= DAT_I(Config_Word_Reg'range);
            data_format <= DAT_I(8);   -- Bit 8 sets data format
            if debug>0 then report "Configuration word (hex): " & to_hstring(DAT_I); end if;
          when ADDR_DATA_REG =>
            reg_to_read <= to_integer(unsigned(DAT_I(5 downto 0)));
            if debug>1 then report "Channel selected: " & integer'image(to_integer(unsigned(DAT_I(5 downto 0)))); end if;
          when others =>
            null;
        end case;
      else
        if config_state = RESET_PULSE then
          start_config_cmd <= '0';
          s_ddc_conv_o <= '0';
        end if;
        if read_state = START_SQNC then
           start_read_cmd <= '0';
        end if;
      end if;
    end if;
  end process;

  -- Physical output port mapping
  DDC_CLK        <= s_ddc_clk_o;
  DDC_CONV       <= s_ddc_conv_o;
  DDC_DIN_CFG    <= s_ddc_din_cfg_reg(15);  -- MSB
  DDC_CLK_CFG    <= s_ddc_clk_cfg_o;
  DDC_RESET      <= s_ddc_reset_o;
  s_ddc_dvalid_i <= DDC_DVALID;
  DDC_DCLK       <= s_ddc_dclk_o;
  s_ddc_dout_i   <= DDC_DOUT;

  -- SBA Read Data Output
  Status_Reg(15 downto 12) <= std_logic_vector(to_unsigned(t_cfg_state'pos(config_state), 4));
  Status_Reg(11 downto 8)  <= std_logic_vector(to_unsigned(t_read_state'pos(read_state), 4));
  Status_Reg(7)            <= data_ready;
  Status_Reg(6)            <= s_ddc_dvalid_i;
  Status_Reg(5 downto 0)   <= (others => '0');

  Data_Reg <= s_ddc_din_reg(reg_to_read);

  DAT_O <= std_logic_vector(resize(unsigned(Status_Reg), DAT_O'length)) when s_address = ADDR_CTRL else
           std_logic_vector(resize(unsigned(Config_Word_Reg), DAT_O'length))  when s_address = ADDR_CFG_WORD else
           std_logic_vector(resize(unsigned(Data_reg), DAT_O'length)) when s_address = ADDR_DATA_REG else
           (DAT_O'range => '0');

end DDC264_arch;
