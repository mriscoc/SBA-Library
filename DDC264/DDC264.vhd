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
-- Escritura:
-- 0000 : Control register
--   bit(0) <- start to shift configuration word to DDC_DIN_CFG
--   bit(1) <- set/reset DDC_CONV
-- 0001 : Configuration Word
--
-- Lectura:
-- 0000 : Status register (Estado de la FSM)
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
    infreq      : positive := 50E6         -- Frecuencia principal del CLK_I (50 MHz)
  );
  port (
    -- PUERTOS DE LA INTERFAZ SBA (ESCLAVO)
    RST_I       : in  std_logic;           -- Reset asíncrono del sistema FPGA
    CLK_I       : in  std_logic;           -- Reloj principal del sistema FPGA (50 MHz)
    STB_I       : in  std_logic;           -- Chip Select (Habilitación del esclavo)
    WE_I        : in  std_logic;           -- Write Enable (Activo alto)
    ADR_I       : in  std_logic_vector;    -- Dirección de entrada (del Maestro)
    DAT_I       : in  std_logic_vector;    -- Datos de entrada (del Maestro)
    DAT_O       : out std_logic_vector;    -- Datos de salida (hacia el Maestro)

    -- SEÑALES DE CONTROL DDC264
    DDC_CLK     : out std_logic;           -- Reloj Maestro/Sistema
    DDC_CONV    : out std_logic;           -- CONV DDC264 (Control de integración)
    DDC_DIN_CFG : out std_logic;           -- Data de configuración serial
    DDC_CLK_CFG : out std_logic;           -- Clock de configuración (Máx 20 MHz)
    DDC_RESET   : out std_logic            -- RESET DDC264 (Activo bajo)
  );
end DDC264;


architecture DDC264_arch of DDC264 is

  -- Cálculo de constantes de tiempo dinámicas (Mínimo de ciclos requeridos)
  -- El tiempo se basa en el periodo del CLK_I (1 / infreq).
  constant F_MHZ : integer := infreq / 1000000;

  -- 1. tPOR: Tiempo entre el encendido y el primer reset = 250 ms = 250 000 µs.
  -- Ciclos = (250 000 µs) / (1 / infreq) = 250 000 * infreq / 1,000,000
  constant T_POWER_UP_US : integer := 3;
  -- constant T_POWER_UP_US : integer := 250E3;
  constant POWER_UP_CYCLES : natural := T_POWER_UP_US * F_MHZ;

  -- 2. tRST: Minimum pulse width for RESET active = 1 µs.
  -- Ciclos = (1 µs) / (1 / infreq) = infreq / 1,000,000
  constant T_RST_US : integer := 1;
  constant RST_PULSE_CYCLES : natural := T_RST_US * F_MHZ;

  -- 3. tWTRST: Wait Required from Reset High to First Rising Edge of CLK_CFG = 2 µs.
  -- Ciclos = (2 µs) / (1 / infreq) = 2 * infreq / 1,000,000
  constant T_WTRST_US : integer := 2;
  constant WTRST_WAIT_CYCLES : natural := T_WTRST_US * F_MHZ;

  -- 4. tWTWR: Wait Required from Last CLK_CFG of Write Operation to First DCLK of Read Operation = 2 µs.
  -- Ciclos = (2 µs) / (1 / infreq) = 2 * infreq / 1,000,000
  constant T_WTWR_US : integer := 2;
  constant WTWR_WAIT_CYCLES : natural := T_WTWR_US * F_MHZ;

  -- Definición de Registros Internos SBA
  constant ADDR_CTRL      : std_logic_vector(3 downto 0) := x"0";
  constant ADDR_CFG_WORD  : std_logic_vector(3 downto 0) := x"1";

  -- Almacena la Palabra de Configuración de 16 bits
  signal Config_Word_Reg : std_logic_vector(15 downto 0) := (others => '0');

  -- Señales de Control para el DDC264
  signal s_ddc_clk_o     : std_logic;
  signal s_ddc_conv_o    : std_logic;
  signal s_ddc_clk_cfg_o : std_logic;
  signal s_ddc_reset_o   : std_logic;
  signal s_ddc_reg_sel   : std_logic_vector(3 downto 0);

  -- FSM para la Secuencia de Configuración
  type t_state is (
      POWER_UP, IDLE, RESET_PULSE, WAIT_WTRST, PREPARE_CFG, SHIFT_CFG, WAIT_WTWR
  );
  signal current_state : t_state := IDLE;

  -- Contadores limitado por el máximo ciclo de espera
  signal cfg_counter   : natural range 0 to POWER_UP_CYCLES := 0;

  -- Contador del registro de desplazamiento de la palabra de control
  signal bit_counter   : natural range 0 to 16 := 0;

  -- Registro de desplazamiento para la palabra de control
  signal s_ddc_din_cfg_reg : std_logic_vector(15 downto 0) := (others => '0');

  -- Comandos capturados desde el bus SBA
  signal start_config_cmd : std_logic := '0';

  -- Almacenamiento del estado previo de DDC_CLK_CFG
  signal clk_cfg_prev : std_logic := '0';

begin

  -- DDC_CLK sebe ser un reloj de máximo 10 MHz para el caso del DDC264CK
  -- Se habilitará el divisor del CLK para el DDC264 por lo que la frecuencia
  -- máxima de DDC_CLK es 40MHz. Se deriva DDC_CLK desde CLK_I, si este último
  -- es mayor a 40 MHz se le divide entre 2, sino, se le asigna directamente.

  -- División por 2 si infreq > 40 MHz
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

  -- Asignación directa si infreq ≤ 40 MHz
  gen_clk_direct : if infreq <= 40000000 generate
    s_ddc_clk_o <= CLK_I;
  end generate;


  -- Generador de la señal DDC_CLK_CFG = CLK_I/4
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


  -- Proceso de desplazamiento del registro de control
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
        -- flanco de bajada (no se usa falling_edge, señal proviene de lógica)
        if s_ddc_clk_cfg_o = '0' and clk_cfg_prev = '1' then
          if bit_counter > 0 then
            s_ddc_din_cfg_reg <= s_ddc_din_cfg_reg(14 downto 0) & '0';
            bit_counter <= bit_counter - 1;
          end if;
        end if;

      end if;
    end if;
  end process;


  -- Proceso de la señal DDC_RESET
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


  -- Máquina de Estados
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

  -- Proceso de interfaz SBA (Read/Write)
  process(CLK_I)
  begin
    if (RST_I='1') then
      Config_Word_Reg  <= (others => '0');
      start_config_cmd <= '0';
      s_ddc_conv_o <= '0';
    elsif rising_edge(CLK_I) then
      if STB_I = '1' and WE_I = '1' then -- Escritura SBA
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

  -- Mapeo de puertos de salida física
  DDC_CLK     <= s_ddc_clk_o;
  DDC_CONV    <= s_ddc_conv_o;
  DDC_DIN_CFG <= s_ddc_din_cfg_reg(15);  -- MSB
  DDC_CLK_CFG <= s_ddc_clk_cfg_o;
  DDC_RESET   <= s_ddc_reset_o;

  -- Lógica de Selección de registro y Salida de Datos (Read SBA)
  s_ddc_reg_sel <= ADR_I(3 downto 0);

  DAT_O <= std_logic_vector(to_unsigned(t_state'pos(current_state), 16)) when s_ddc_reg_sel = ADDR_CTRL else
           std_logic_vector(resize(unsigned(Config_Word_Reg),DAT_O'length))  when s_ddc_reg_sel = ADDR_CFG_WORD else
           (DAT_O'range => '0');


end DDC264_arch;


