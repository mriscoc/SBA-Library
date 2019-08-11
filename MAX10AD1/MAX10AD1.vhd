--------------------------------------------------------------------------------
-- MAX10AD1
--
-- Title: MAX10 Single ADC IP Core adapter
--
-- Version: 0.3
-- Date: 2019/08/06
-- Author: Miguel A. Risco-Castillo
--
-- sba webpage: http://sba.accesus.com
-- core webpage: https://github.com/mriscoc/SBA-Library/tree/master/MAX10AD1
--
-- Description: Preliminary version of SBA Slave IP Core adapter for MAX10 Single
-- ADC. Use a faster CLK_I system clock than the PLL clock input. Use the Quartus
-- IP Catalog to Add a PLL and a Modular ADC core to your proyect, name the last
-- as MAX10ADC and configure the core variant as ADC control core only.
--
-- Follow SBA v1.2 Guidelines
--
--------------------------------------------------------------------------------
-- For Copyright and release notes please refer to:
-- https://github.com/mriscoc/SBA-Library/tree/master/MAX10AD1/readme.md
--------------------------------------------------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MAX10AD1 is
port(
-- SBA Interface
   RST_I : in  std_logic;        -- Active high reset
   CLK_I : in  std_logic;        -- Main clock
   STB_I : in  std_logic;        -- Strobe
   WE_I  : in  std_logic;        -- Bus write, active high
   DAT_I : in  std_logic_vector; -- Data input Bus
   DAT_O : out std_logic_vector; -- Data output Bus
   INT_O : out std_logic;        -- Interrupt on data valid
-- PLL Interface
   PLLCLK_I : in std_logic;      -- PLL clock input
   PLLLCK_I : in std_logic       -- PLL locked input
);
end MAX10AD1;


architecture MAX10AD1_arch of MAX10AD1 is

signal reset_reset_n : STD_LOGIC;
signal command_valid : STD_LOGIC;
signal command_channel : STD_LOGIC_VECTOR(4 DOWNTO 0);
signal command_startofpacket : STD_LOGIC;
signal command_endofpacket : STD_LOGIC;
signal command_ready : STD_LOGIC;
signal response_valid : STD_LOGIC;
signal response_channel : STD_LOGIC_VECTOR(4 DOWNTO 0);
signal response_data : STD_LOGIC_VECTOR(11 DOWNTO 0);
signal response_startofpacket : STD_LOGIC;
signal response_endofpacket : STD_LOGIC;

signal ADDAT:std_logic_vector(response_data'range);
signal ADREG:std_logic_vector(response_data'range);
signal chsel:std_logic_vector(command_channel'range):=(others=>'0');
signal chval:std_logic_vector(command_channel'range):=(others=>'0');
signal intf:std_logic;
signal inte:std_logic;

component MAX10ADC is
port (
	adc_pll_clock_clk      : in  std_logic;                    -- clk
	adc_pll_locked_export  : in  std_logic;                    -- export
	clock_clk              : in  std_logic;                    -- clk
	command_valid          : in  std_logic;                    -- valid
	command_channel        : in  std_logic_vector(4 downto 0); -- channel
	command_startofpacket  : in  std_logic;                    -- startofpacket
	command_endofpacket    : in  std_logic;                    -- endofpacket
	command_ready          : out std_logic;                    -- ready
	reset_sink_reset_n     : in  std_logic;                    -- reset_n
	response_valid         : out std_logic;                    -- valid
	response_channel       : out std_logic_vector(4 downto 0); -- channel
	response_data          : out std_logic_vector(11 downto 0);-- data
	response_startofpacket : out std_logic;                    -- startofpacket
	response_endofpacket   : out std_logic                     -- endofpacket
);
end component MAX10ADC;

begin

adc : component MAX10ADC
port map (
	clock_clk              => CLK_I,                           --          clock.clk
	reset_sink_reset_n     => reset_reset_n,                   --     reset_sink.reset_n
	adc_pll_clock_clk      => PLLCLK_I,                        --  adc_pll_clock.clk
	adc_pll_locked_export  => PLLLCK_I,                        -- adc_pll_locked.export
	command_valid          => command_valid,                   --    command.valid
	command_channel        => command_channel,                 --           .channel
	command_startofpacket  => command_startofpacket,           --           .startofpacket
	command_endofpacket    => command_endofpacket,             --           .endofpacket
	command_ready          => command_ready,                   --           .ready
	response_valid         => response_valid,                  --   response.valid
	response_channel       => response_channel,                --           .channel
	response_data          => response_data,                   --           .data
	response_startofpacket => response_startofpacket,          --           .startofpacket
	response_endofpacket   => response_endofpacket             --           .endofpacket
);

process(CLK_I)
begin
  if rising_edge(CLK_I) then
    if (response_valid = '1') then
      ADDAT <= response_data;
      chval <= response_channel;
      command_channel <= std_logic_vector(chsel);
    end if;
  end if;
end process;

process(RST_I, CLK_I)
begin
  if RST_I='1' then
    chsel<=(others=>'0');
  elsif rising_edge(CLK_I) then
    if (STB_I='1') and (WE_I='1') then
      chsel <= DAT_I(chsel'range);
      inte  <= DAT_I(15);
    end if;
  end if;
end process;

process(RST_I, CLK_I)
begin
  if RST_I='1' then
    intf <='0';
    ADREG<=(others=>'0');
  elsif rising_edge(CLK_I) then
    if (chval=chsel) then
      intf <='1';
      ADREG<=ADDAT;
    end if;
    if (STB_I='1') then
      intf<='0';
    end if;
  end if;
end process;

command_valid <= '1';
command_startofpacket <= '1';
command_endofpacket <= '0';
reset_reset_n <= not RST_I;

DAT_O <= intf & "000" & ADREG;
INT_O <= intf and inte;

end MAX10AD1_arch;

