-----------------------------------------------------------
-- VGA_SyncGen_v0.1.vhd
-- VGA Synchronism Signals Generator
--
-- Version 0.1
-- Date: 20131013
--
-- Miguel A. Risco Castillo
-- email: mrisco@gmail.com
-- web page: http://mrisco.accesus.com
--
-- Notes:
--
-- 640x480 VGA Resolution,  24bits RGB Color
--
-- This version is released under the GNU/GLP license
-- if you use this component for your research please
-- include the appropriate credit of Author.
-- For commercial purposes request the appropriate
-- license from the author. 
-----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.VGApkg.all;

entity VGA_SyncGen is
--generic (hres:positive:=640; vres:positive:=480);
port (
      -- Host Interface
      CLK_I    : in std_logic;                         -- 25MHz (640x480)
      RST_I    : in std_logic;
      VD_O     : out VDataType
   );
end VGA_SyncGen;


architecture VGA_Arch of VGA_SyncGen is

-- Horizontal  Parameter
Constant H_FRONT  :  integer:= 16;
Constant H_SYNC   :  integer:= 96;
Constant H_BACK   :  integer:= 48;
Constant H_ACT    :  integer:= 640;
Constant H_BLANK  :  integer:= H_FRONT+H_SYNC+H_BACK;
Constant H_TOTAL  :  integer:= H_FRONT+H_SYNC+H_BACK+H_ACT;

-- Vertical Parameter
Constant V_FRONT  :  integer:= 10;
Constant V_SYNC   :  integer:= 2;
Constant V_BACK   :  integer:= 33;
Constant V_ACT    :  integer:= 480;
Constant V_BLANK  :  integer:= V_FRONT+V_SYNC+V_BACK;
Constant V_TOTAL  :  integer:= V_FRONT+V_SYNC+V_BACK+V_ACT;

-- Internal Registers
Signal H_Cont : integer range 0 to H_TOTAL; 
Signal V_Cont : integer range 0 to V_TOTAL; 
Signal VGA_HSi: std_logic;
Signal VGA_VSi: std_logic;

-- Aux Signals
Signal CLKi : std_logic;
Signal RSTi : std_logic;

begin

-- Horizontal Generator: Refer to the pixel clock
HGen: process(CLKi)
begin
  if rising_edge(CLKi) then
    if (RSTi='1') then
      H_Cont <= 0;
      VGA_HSi <= '1';
    else
      if (H_Cont<H_TOTAL-1) then
        H_Cont <= H_Cont+1;
      else
        H_Cont <= 0;
      end if;
      -- Horizontal Sync
      if (H_Cont=H_FRONT-1) then        -- Front porch end
        VGA_HSi <= '0';
      end if;
      if (H_Cont=H_FRONT+H_SYNC-1) then -- Sync pulse end
        VGA_HSi <= '1';
      end if;
    end if;
  end if;
end process HGen;

-- Vertical Generator: Refer to the horizontal sync
VGen: process(VGA_HSi)
begin
  if rising_edge(VGA_HSi) then
    if(RSTi='1') then
      V_Cont <= 0;
      VGA_VSi <= '1';
    else
      if (V_Cont<V_TOTAL-1) then
        V_Cont <= V_Cont+1;
      else
        V_Cont <= 0;
      end if;
      -- Vertical Sync
      if (V_Cont=V_FRONT-1) then        -- Front porch end
        VGA_VSi <= '0';
      end if;
      if (V_Cont=V_FRONT+V_SYNC-1) then -- Sync pulse end
        VGA_VSi <= '1';
      end if;
    end if;
  end if;
end  process VGen;

RSTi <= RST_I;
CLKi <= CLK_I;
VD_O.X  <= H_Cont-H_BLANK when (H_Cont>H_BLANK) else 0;
VD_O.Y  <= V_Cont-V_BLANK when (V_Cont>V_BLANK) else 0;
VD_O.HS <= VGA_HSi;
VD_O.VS <= VGA_VSi;
VD_O.BK <= '0' when ((H_Cont<H_BLANK) or (V_Cont<V_BLANK)) else '1';
VD_O.R  <= 0;
VD_O.G  <= 0;
VD_O.B  <= 0;

end architecture VGA_Arch;

