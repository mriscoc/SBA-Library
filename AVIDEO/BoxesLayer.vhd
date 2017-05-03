--------------------------------------------------------------------------------
-- File Name: BoxesLayer.vhd
-- Title: Simple Box display layer
-- Version: 0.2
-- Date: 2016/12/21
-- Author: Miguel A. Risco Castillo
-- Description: Display parametrized box in a Video layer
-- Notes:
--------------------------------------------------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Videopackage.all;

entity BoxesLayer is
Port (
  -- Box Data
  Boxes : in TBoxArray;             -- Box parameters
  -- Video interface
  VCK_I : in std_logic;             -- Video Clock
  VD_I  : in TVData;                -- Video data in
  VD_O  : out TVData                -- Video data out
);
end BoxesLayer;

architecture Behavioral of BoxesLayer is
begin

VGADataProc: process(VCK_I)
begin
  if rising_edge(VCK_I) then
-- Get previous layer values
    VD_O<=VD_I;

-- Boxes
    for I in Boxes'low to Boxes'high loop
        if IsBox(VD_I,Boxes(I)) then
           VD_O.Color <= Boxes(I).Color;
        end if;
    end loop;
  end if;
end process VGADataProc;

end Behavioral;
