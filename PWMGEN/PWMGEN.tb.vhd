-- Generated on "03/20/2017 20:41:59"
-- Vhdl Test Bench template for design  :  PWMGEN


LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                
use ieee.numeric_std.all;

ENTITY PWMGEN_test IS
END PWMGEN_test;

ARCHITECTURE PWMGEN_arch OF PWMGEN_test IS

SIGNAL ADR_I : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL PWM_O : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL CLK_I : STD_LOGIC;
SIGNAL DAT_I : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL RST_I : STD_LOGIC;
SIGNAL STB_I : STD_LOGIC;
SIGNAL WE_I : STD_LOGIC;

constant chans : positive:= 4;

COMPONENT PWMGEN
generic (
  chans:positive;
  pwmfreq:positive
  );
PORT (
  -- SBA Bus Interface
  CLK_I : in std_logic;            -- SBA Main System Clock
  RST_I : in std_logic;            -- SBA System reset
  WE_I  : in std_logic;            -- SBA Write/Read Enable control signal
  STB_I : in std_logic;            -- SBA Strobe/chip select
  ADR_I : in std_logic_vector;     -- SBA Address bus / Register select
  DAT_I : in std_logic_vector;     -- SBA Data input bus / Duty cycle register
  -- PORT Interface;
  PWM_O : out std_logic_vector(chans-1 downto 0)  -- PWM output Channels
);
END COMPONENT;

BEGIN
	i1 : PWMGEN
    GENERIC MAP (
      chans => chans,
      pwmfreq => 10E3
    )
    PORT MAP (
-- list connections between master ports and signals
	CLK_I => CLK_I,
	RST_I => RST_I,
	WE_I  => WE_I,
	STB_I => STB_I,
	ADR_I => ADR_I,
	DAT_I => DAT_I,
	PWM_O => PWM_O(chans-1 DOWNTO 0)
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
  STB_I <= '1';
  WE_I  <= '1';
  ADR_I <= (others=>'0');
  DAT_I <= (8 downto 0=>'1',others=>'0');
WAIT;
END PROCESS control;

END PWMGEN_arch;
