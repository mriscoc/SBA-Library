------------------------------------------------------------
-- SBA Push Button Adapter
--
-- Versión 3.1 20100803
--
-- Push Button Adapter not unbounced
-- Capture Press of buttons and clear after read
--
-- Rev 3.1
-- Synchronous Reset
--
-- Rev 3.0
-- non Tristate DAT_O bus
--
-- Rev 2.3
-- Correct the name of the entity from PusbB to PushB
-- Generic number of buttons
--
-- Rev 2.2
-- Remove ACK_O
------------------------------------------------------------
--
-- (c) Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- webpage: http://mrisco.accesus.com
--
-- This code, modifications, derivate
-- work or based upon, can not be used
-- or distributed without the
-- complete credits on this header and
-- the consent of the author.
--
------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SBA_package.all;

entity PushB_Adapter is
generic(numB : natural := 4); -- number of buttons
port(
   RST_I : in  std_logic;                     -- active high reset
   CLK_I : in  std_logic;                     -- Base frecuency clock
   DAT_O : out DATA_type;                     -- Data output
   STB_I : in  std_logic;                     -- Strobe In
   WE_I  : in  std_logic;                     -- Read Data active Low
--
   Buttons : in std_logic_vector(numB-1 downto 0)  -- 4 Buttons
);
end;

architecture PushB_Adapter_arch of PushB_Adapter is
signal BReg : std_logic_vector(Buttons'range);
begin

process (CLK_I,RST_I)
variable BMem: std_logic_vector(Buttons'range);
begin
  if rising_edge(CLK_I) then
    if (RST_I='1') then
      BReg <= (others=>'0');
      BMem := (others=>'0');
    elsif (STB_I='1') and (WE_I='0') then   -- Clear Memory on Read
       BMem := (others=>'0');
    end if;
    BMem := BMem or Buttons;                -- Memorize Button press
    BReg <= BMem;
  end if;
end process;

DAT_O <= std_logic_vector(resize(unsigned(BReg),DAT_O'length));

end PushB_Adapter_arch;

