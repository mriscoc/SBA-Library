----------------------------------------------------------------
-- SBA_config
-- Constants for system configuration and adress map
--
-- v1.3
-- 20120613
--
-- Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- webpage: http://mrisco.accesus.com
--
-- Notes:
--
-- v1.3
-- Added the type definitions
--
-- v1.2
-- Included constants for STB lines
--
-- v1.1
-- Include constants for address map
--
-- v1.0
-- First version
--
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package SBA_config is

-- System configuration
  constant debug : integer := 0;            -- '1' for Debug reports
  constant Adr_width: integer := 9;         -- Width of address bus
  constant Dat_width: integer := 16;        -- Width of data bus
  constant Stb_width: integer := 7;         -- number of strobe signals (chip select)
  constant max_steps: integer := 60;        -- Max number of steps on SBAController
  constant sysfrec  : integer := 50e6;      -- Main system clock frequency

-- Address Map
  constant LEDS     : integer := 2;
  constant SINE     : integer := 4;
  constant SAWTOOTH : integer := 5;
  constant DSPL7SD  : integer := 6;
  constant DSPL7DP  : integer := 7;
--constant UART_0   : integer := 8;
--constant UART_1   : integer := 9;
  constant DA1      : integer := 10;
  constant JSTK_0   : integer := 12;
  constant JSTK_1   : integer := 13;
  constant JSTK_2   : integer := 14;
--constant RAMBASE  : integer := 256;

--Strobe Lines
  constant STB_LEDS  : integer := 0;
  constant STB_SINE  : integer := 1;
  constant STB_DSPL7 : integer := 2;
--constant STB_UART  : integer := 3;
  constant STB_DA1   : integer := 4;
  constant STB_STGEN : integer := 5;
  constant STB_JSTK  : integer := 6;
--constant STB_RAM   : integer := 7;

-- System Type definitions
  subtype ADDR_type is std_logic_vector(Adr_width-1 downto 0);
  subtype ADRI_type is integer range 0 to (2**Adr_width) - 1;
  subtype DATA_type is std_logic_vector(Dat_width-1 downto 0);
  subtype DATI_type is unsigned(Dat_width-1 downto 0);
  subtype STB_type  is std_logic_vector(Stb_width-1 downto 0);
  subtype step_type is integer range 0 to max_steps;

end SBA_config;
