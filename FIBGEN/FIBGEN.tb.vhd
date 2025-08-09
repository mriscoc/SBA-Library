--------------------------------------------------------------------------------
-- Title: Testbench for FIBGEN
-- Version: 0.1.0
-- Date: 2025/08/02
-- Description: Testbench for FIBGEN entity with 10 MHz clock simulation
--------------------------------------------------------------------------------

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.Fibonacci_SBAconfig.all;

entity testbench is
end testbench;

architecture behavioral of testbench is

    -- Clock period for 10 MHz (100 ns)
    constant CLK_PERIOD : time := 100 ns;

    -- Testbench signals
    signal clk_i_tb   : std_logic := '0';
    signal rst_i_tb   : std_logic := '1';  -- Start with reset active
    signal we_i_tb    : std_logic := '0';  -- Start in read mode
    signal stb_i_tb   : std_logic := '0';  -- Start with strobe disabled
    signal dato_i_tb  : DATA_type;

    -- Clock counter for reset timing
    signal clk_count  : integer := 0;

begin

    -- Unit Under Test (UUT)
    uut: entity work.FIBGEN
    port map (
        CLK_I => clk_i_tb,
        RST_I => rst_i_tb,
        WE_I  => we_i_tb,
        STB_I => stb_i_tb,
        DAT_O => dato_i_tb
    );

    -- Clock generation process (10 MHz)
    clk_process: process
    begin
        clk_i_tb <= '0';
        wait for CLK_PERIOD/2;
        clk_i_tb <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Clock counter process
    clk_counter: process(clk_i_tb)
    begin
        if rising_edge(clk_i_tb) then
            clk_count <= clk_count + 1;
        end if;
    end process;

    -- Reset control process
    reset_process: process
    begin
        -- Keep reset active for 3 clock cycles
        rst_i_tb <= '1';
        wait until rising_edge(clk_i_tb);
        wait until rising_edge(clk_i_tb);
        wait until rising_edge(clk_i_tb);

        -- Release reset
        rst_i_tb <= '0';
        wait;
    end process;

    -- Stimulus process
    stim_process: process
    begin

        -- Wait for reset to be released
        wait until rst_i_tb = '0';

        -- Wait for a few more clock cycles to observe behavior
        for i in 0 to 5 loop
            wait until rising_edge(clk_i_tb);
        end loop;

        -- Read cycle, enable core with stb
        we_i_tb <= '0';
        stb_i_tb <= '1';


        -- End simulation
        wait for 2 us;

        report "Simulation completed successfully" severity note;
        wait;
    end process;

end behavioral;
