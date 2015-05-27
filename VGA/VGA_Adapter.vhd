-----------------------------------------------------------
-- VGA_Adapter.vhd
-- Generic VGA Adapter
--
-- Version 0.2
-- Date: 20120807
--
-- Miguel A. Risco Castillo
-- email: mrisco@gmail.com
-- web page: http://mrisco.accesus.com
--
-- Notes:
--
-- 640x480 VGA Controller, RGB 4 4 4
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

entity VGA_Adapter is
--generic (hres:positive:=640; vres:positive:=480);
port (
      -- Host Interface
      CLK_I   : in std_logic;							-- 25MHz (640x480)
      RST_I   : in std_logic;
      CX_O    : out std_logic_vector(9 downto 0);	    -- X pixel output address
      CY_O    : out std_logic_vector(9 downto 0);		-- Y pixel output address
      Red_I   : in std_logic_vector(3 downto 0);		-- Red data
      Green_I : in std_logic_vector(3 downto 0);		-- Green data
      Blue_I  : in std_logic_vector(3 downto 0);		-- Blue data
      -- VGA Interface;
      VGA_R    : out std_logic_vector(3 downto 0);
      VGA_G    : out std_logic_vector(3 downto 0);
      VGA_B    : out std_logic_vector(3 downto 0);
      VGA_HS   : buffer std_logic;
      VGA_VS   : out std_logic;
      VGA_SYNC : out std_logic;
      VGA_BLANK: out std_logic;
      VGA_CLOCK: out std_logic
   );
end VGA_Adapter;


architecture VGA_Arch of VGA_Adapter is

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
Signal VGAEn  : std_logic;

-- Aux Signals
Signal CLKi : std_logic;
Signal RSTi : std_logic;

begin

-- Horizontal Generator: Refer to the pixel clock
HGen: process(CLKi, RSTi)
begin
  if rising_edge(CLKi) then
    if (RSTi='1') then
      H_Cont <= 0;
      VGA_HS <= '1';
    else
      if (H_Cont<H_TOTAL-1) then
        H_Cont <= H_Cont+1;
      else
        H_Cont <= 0;
      end if;
      -- Horizontal Sync
      if (H_Cont=H_FRONT-1) then        -- Front porch end
        VGA_HS <= '0';
      end if;
      if (H_Cont=H_FRONT+H_SYNC-1) then -- Sync pulse end
        VGA_HS <= '1';
      end if;
    end if;
  end if;
end process HGen;

-- Vertical Generator: Refer to the horizontal sync
VGen: process(VGA_HS, RSTi)
begin
  if rising_edge(VGA_HS) then
    if(RSTi='1') then
      V_Cont <= 0;
      VGA_VS <= '1';
    else
      if (V_Cont<V_TOTAL-1) then
        V_Cont <= V_Cont+1;
      else
        V_Cont <= 0;
      end if;
      -- Vertical Sync
      if (V_Cont=V_FRONT-1) then        -- Front porch end
        VGA_VS <= '0';
      end if;
      if (V_Cont=V_FRONT+V_SYNC-1) then -- Sync pulse end
        VGA_VS <= '1';
      end if;
    end if;
  end if;
end  process VGen;

RSTi <= RST_I;
CLKi <= CLK_I;

VGA_SYNC  <= '1';        -- This pin is unused.
VGAEn     <= '0' when ((H_Cont<H_BLANK) or (V_Cont<V_BLANK)) else '1';
VGA_BLANK <= VGAEn;
VGA_CLOCK <= not CLKi;
CX_O      <= std_logic_vector(to_unsigned(H_Cont-H_BLANK,CX_O'length)) when (H_Cont>=H_BLANK) else (others=>'0');
CY_O      <= std_logic_vector(to_unsigned(V_Cont-V_BLANK,CY_O'length)) when (V_Cont>=V_BLANK) else (others=>'0');
VGA_R     <= Red_I when (VGAEn='1') else (others=>'0');
VGA_G     <= Green_I when (VGAEn='1') else (others=>'0');
VGA_B     <= Blue_I when (VGAEn='1') else (others=>'0');

end architecture VGA_Arch;









