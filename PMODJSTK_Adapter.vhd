------------------------------------------------------------
-- PMODJSTK_Adapter.vhd
--
-- Versión 0.3 20120703
--
-- 5 byte SPI interface
-- 3 read register: X axis, Y axis and Buttons
-- 1 write register LEDS (lsb)
--
-- SBA Slave
-- Adapter for Digilent Pmod JSTK module
--
-- SBA v1.0 compliant
--
------------------------------------------------------------
--
--
-- Author:
-- (c) Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- web page: http://mrisco.accesus.com
-- sba webpage: http://sba.accesus.com
--
-- This code, modifications, derivate
-- work or based upon, can not be used
-- or distributed without the
-- complete credits on this header and
-- the consent of the author.
--
-- This version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
-- if you use this component for your research please
-- include the appropriate credit of Author.
--
-- For commercial purposes request the appropriate
-- license from the author.
--
--
------------------------------------------------------------
--
-- Notes:
--
-- Rev 0.3
-- Remove SBA_Package dependency
--
-- Rev 0.2
-- Change the SBA DAT_O path from process
--
-- Rev 0.1
-- Initial release
--
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SBA_config.all;

entity PMODJSTK_Adapter is
port(
-- SBA Interface
   RST_I : in  std_logic;        -- active high reset
   CLK_I : in  std_logic;        -- Main clock
   DAT_I : in  std_logic_vector; -- Data input Bus
   DAT_O : out std_logic_vector; -- Data output Bus
   STB_I : in  std_logic;        -- Strobe
   ADR_I : in  std_logic_vector; -- Internal Register two bit Address selector
   WE_I  : in  std_logic;        -- Bus write, active high
-- Interface for PMODJSTK
   SS    : out std_logic;        -- chipselect active low
   MOSI  : out std_logic;        -- SPI out
   MISO  : in  std_logic;        -- SPI in
   SCK   : out std_logic         -- SPI Clock
);
end PMODJSTK_Adapter;

architecture  PMODJSTK_Adapter of  PMODJSTK_Adapter is
type tstate is (IniSt, WaitB, SendB, EndSt); -- SPI Communication States

signal state    : tstate;
signal streamDI : std_logic_vector (39 downto 0);
signal XREG     : std_logic_vector (9 downto 0);
signal YREG     : std_logic_vector (9 downto 0);
signal BREG     : std_logic_vector (2 downto 0);
signal LEDW     : std_logic_vector (7 downto 0);
signal nSCK     : unsigned (3 downto 0);
signal SCKi     : std_logic;

alias XLOW  is XREG(7 downto 0);
alias XHIGH is XREG(9 downto 8);
alias YLOW  is YREG(7 downto 0);
alias YHIGH is YREG(9 downto 8);

begin

SCK1: if (sysfrec>1E6) generate
--CLK Div process (SCKi max 1MHz)
  CLK_Div : entity work.ClkDiv
  Generic map (frec=>1E6)
  Port Map(
    RST_I => RST_I,
    CLK_I => CLK_I,
    CLK_O => SCKi
  );
end generate;

SCK2: if (sysfrec<=1E6) generate
  SCKi <= CLK_I;
end generate;

-- SBA  Write Process
  process (CLK_I, RST_I)
  begin
    if rising_edge(CLK_I) then
      if (RST_I='1') then
        LEDW <= (others => '0');
      elsif (STB_I='1' and WE_I='1') then
        LEDW <= "000000" & DAT_I(1 downto 0);
      end if;
    end if;
  end process;

-- SPI BUS Proccess
  process (SCKi, RST_I)
  variable NB : integer range 0 to 4;
  begin
    if (RST_I='1') then
      state   <= IniSt;
      streamDI<= (OTHERS =>'0');
      XREG <= (others => '0');
      YREG <= (others => '0');
      BREG <= (others => '0');
      SS      <= '1';
      nSCK <= (others => '0');
      MOSI <= '0';
    elsif rising_edge(SCKi) then
      case State is
        when IniSt  => SS    <='0';
                       state <= WaitB;
                       NB    := 0;
                       nSCK  <= (others => '0');

        when WaitB  => if (nSCK = 15) then
                         state <= SendB;
                       end if;
                       nSCK <= nSCK+1;

        when SendB  => streamDI <= streamDI(38 downto 0) & MISO;
                       if NB = 0 then
                         MOSI <= LEDW(to_integer(nSCK(2 downto 0)));
                       else
                         MOSI <= '0';
                       end if;
                       if (nSCK = 7) then
                         if NB<4 then
                           NB   := NB+1;
                           nSCK <= x"5";
                           state<= WaitB;
                         else
                           state<= EndSt;
                         end if;
                       else 
                         nSCK <= nSCK+1;
                       end if;

        when EndSt  => SS <='1';
                       XHIGH <= StreamDI(25 downto 24);
                       XLOW  <= StreamDI(39 downto 32);
                       YHIGH <= StreamDI(9  downto 8);
                       YLOW  <= StreamDI(23 downto 16);
                       BREG  <= StreamDI(2 downto 0);
                       state <= IniSt;
      end case;
    end if;
  end process;

-- Interface signals
  SCK   <= not SCKi When state=SendB else '0';
  With ADR_I(1 downto 0) select DAT_O <=
    "000000" & XREG  When "00",
    "000000" & YREG  When "01",
    (DAT_O'high downto BREG'high+1 =>'0') & BREG When "10",
    (DAT_O'range =>'0') When Others; 	 

end  PMODJSTK_Adapter;

