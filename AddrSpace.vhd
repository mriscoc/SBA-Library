----------------------------------------------------------------
-- SBA AddrSpace
-- Address Decoder
--
-- v3.2 20120613
--
-- (c) Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- webpage: http://mrisco.accesus.com
--
-- This code, modifications, derivate work or
-- based upon, can not be used or distributed
-- without the complete credits on this header.
--
-- This version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
-- if you use this component for your research please
-- include the appropriate credit of Author.
--
-- For commercial purposes request the appropriate
-- license from the author.
--
-- Notes:
--
-- v3.2
-- Added the stb() function, 
-- change from structural to behavioral design
--
-- v3.1
-- Restored STB_I
--
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sba_config.all;

entity  AddrSpace  is
port(
   STB_I: in std_logic;           -- Address Enabler
   ADR_I: in ADDR_type;           -- Address input Bus
   STB_O: out STB_type 	          -- Strobe Chips selector 
);
end AddrSpace;

architecture AddrSpace_Arch of AddrSpace is

Signal STBi : STB_type;

begin

ADDRProc:process (ADR_I)

  Variable ADRi : ADRi_type;

  function stb(val:natural) return STB_type is
  variable ret : unsigned(STB_Type'range);
  begin
    ret:=(0 => '1', others=>'0');
    return STB_type((ret sll (val)));
  end;

begin
  ADRi := to_integer(unsigned(ADR_I));
  case ADRi is
     When LEDS                    => STBi <= stb(STB_LEDS);  -- GPIO1;
     When DSPL7SD | DSPL7DP       => STBi <= stb(STB_DSPL7); -- Display7Seg
     When JSTK_0 | JSTK_1 |JSTK_2 => STBi <= stb(STB_JSTK);  -- PMOD Joystick
     When DA1                     => STBi <= stb(STB_DA1);   -- PMOD DA1
     When SINE                    => STBi <= stb(STB_SINE);  -- Sine
     When SAWTOOTH                => STBi <= stb(STB_STGEN); -- Sawtooth
--   When UART_0 | UART_1         => STBi <= stb(STB_UART);  -- UART Adapter
--   When RAMBASE to RAMBASE+255  => STBi <= stb(STB_RAM);   -- RAM Adapter, (x0100 - x01FF)
     When OTHERS                  => STBi <= (others =>'0');
  end case;

end process;

  STB_O <= STBi When STB_I='1' else (others=>'0');

end AddrSpace_Arch;

