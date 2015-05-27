-----------------------------------------------------------
-- Triangle Wave Generator
--
-- Versión 6.2 20100324
--
-- Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- webpage: http://mrisco.accesus.com
--
-- Triangle Generator
--
-- SBA
--
-- De usar este programa favor de respetar
-- los créditos del autor original
-----------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SBA_package.all;

entity TriangleGen is
port(
   RST_I : in  std_logic;                     -- active high reset
   CLK_I : in  std_logic;                     -- Base frecuency clock
   DAT_O : out std_logic_vector(15 downto 0); -- Data output
   STB_I : in  std_logic;                     -- Strobe In
   WE_I  : in  std_logic                      -- Read and Get next Data active Low
);
end TriangleGen;

architecture TriangleWave_Arch of TriangleGen is

Signal DATi : std_logic_vector(7 downto 0);
Signal ACTi : std_logic;
Signal Dir  : std_logic;

begin

  Process (CLK_I, RST_I)
  Variable Q : unsigned(7 downto 0);
  Begin
    if (RST_I='1') then
      DATi<=(others=>'0');
      Dir<='0';
    elsif rising_Edge(CLK_I) Then
      If (ACTi='1') then
        if Dir='0' then
          if DATi=(DATi'range=>'1') then Dir<='1'; else inc(DATi); end if;
        else
          if DATi=(DATi'range=>'0') then Dir<='0'; else dec(DATi); end if;
        end if;
      end if;
    end if;
  end process;

  ACTi  <= (not RST_I) and STB_I and (not WE_I);
  DAT_O <= x"00" & DATi;

end TriangleWave_Arch;
