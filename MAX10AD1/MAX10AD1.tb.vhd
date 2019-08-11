Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY MAX10AD1_TB IS
END MAX10AD1_TB;

ARCHITECTURE logic OF MAX10AD1_TB IS

CONSTANT freq : positive := 50E6;
CONSTANT CLKPERIOD : time := (real(1000000000)/real(freq)) * 1 ns;

-- Master SBA signals
SIGNAL RSTi  : STD_LOGIC := '1';
SIGNAL CLKi  : STD_LOGIC;
SIGNAL STBi  : STD_LOGIC := '0';
SIGNAL WEi   : STD_LOGIC := '0';
SIGNAL DATIi : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL DATOi : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others=>'0');
signal INTi  : std_logic;


signal data_to_display : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal pll_clk : std_logic;
signal pll_locked : std_logic;

  component pll IS
  PORT(
	inclk0 : IN STD_LOGIC  := '0';
	c0	 : OUT STD_LOGIC ;
	locked : OUT STD_LOGIC
  );
  END component pll;

  component MAX10AD1 is
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
  end component MAX10AD1;

begin

  pll_inst : component pll
  PORT MAP (
	  inclk0 => CLKi,
	  c0     => pll_clk,
	  locked => pll_locked
  );

  AD1_inst: component MAX10AD1
  port map(
    -------------
    RST_I => RSTi,
    CLK_I => CLKi,
    STB_I => STBi,
    WE_I  => WEi,
    DAT_O => DATIi,
    DAT_I => DATOi,
    INT_O => INTi,
  -- PLL Interface
    PLLCLK_I => pll_clk,
    PLLLCK_I => pll_locked
  );

reset : PROCESS
BEGIN
  report "CLK PERIOD: " & time'image(CLKPERIOD);
  RSTi<='1';
  WAIT FOR 4 * CLKPERIOD;
  RSTi<='0';
  WAIT;
END PROCESS reset;


clkproc : PROCESS
BEGIN
  CLKi <= '0';
  WAIT FOR CLKPERIOD/2;
  CLKi <= '1';
  WAIT FOR CLKPERIOD/2;
END PROCESS clkproc;

STBi <= '1';
WEi  <= '1';
DATOi <= x"8000";         -- ANIN & INT enable


END logic;














