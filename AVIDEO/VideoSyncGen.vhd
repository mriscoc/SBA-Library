--------------------------------------------------------------------------------
-- File Name: VideoSyncGen.vhd
-- Title: Video Synchronism Signals Generator
-- Version: 0.3
-- Date: 2016/12/21
-- Author: Miguel A. Risco Castillo
-- web page: http://sba.accesus.com
--
-- Description and Notes:
-- Analog video clock and synchronism signals generator, part of AVIDEO IPCore.
--
-- Release Notes:
--
-- v0.3 2016/12/21
-- Origibal release
--
--------------------------------------------------------------------------------
-- Copyright:
--
-- (c) Miguel A. Risco-Castillo
--
-- This code, modifications, derivate work or based upon, can not be used or
-- distributed without the complete credits on this header.
--
-- This version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
-- if you use this component for your research please include the appropriate
-- credit of Author.
--
-- The code may not be included into ip collections and similar compilations
-- which are sold. If you want to distribute this code for money then contact me
-- first and ask for my permission.
--
-- These copyright notices in the source code may not be removed or modified.
-- If you modify and/or distribute the code to any third party then you must not
-- veil the original author. It must always be clearly identifiable.
--
-- Although it is not required it would be a nice move to recognize my work by
-- adding a citation to the application's and/or research.
--
-- FOR COMMERCIAL PURPOSES REQUEST THE APPROPRIATE LICENSE FROM THE AUTHOR.
--------------------------------------------------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Videopackage.all;

entity VideoSyncGen is
  Generic(
    VParams:TVideoParams:=VGAParams
  );
  port (
      -- Host Interface
      VCK_I    : in std_logic;          -- Video Pixel Clock
      RST_I    : in std_logic;          -- Video Reset
      -- Video Interface
      VD_O     : out TVData
   );
end VideoSyncGen;


architecture Video_Arch of VideoSyncGen is

-- Horizontal  Parameter
Constant H_BLANK  :  integer:= VParams.H_FRONT+VParams.H_SYNC+VParams.H_BACK;
Constant H_TOTAL  :  integer:= VParams.H_FRONT+VParams.H_SYNC+VParams.H_BACK+VParams.H_ACT;

-- Vertical Parameter
Constant V_BLANK  :  integer:= VParams.V_FRONT+VParams.V_SYNC+VParams.V_BACK;
Constant V_TOTAL  :  integer:= VParams.V_FRONT+VParams.V_SYNC+VParams.V_BACK+VParams.V_ACT;

-- Internal Registers
Signal H_Cont : integer range 0 to H_TOTAL; 
Signal V_Cont : integer range 0 to V_TOTAL; 
Signal Video_HSi: std_logic;
Signal Video_VSi: std_logic;

begin

-- Horizontal Generator: Refer to the pixel clock
HGen: process(VCK_I)
begin
  if rising_edge(VCK_I) then
    if (RST_I='1') then
      H_Cont <= 0;
      Video_HSi <= '1';
    else
      if (H_Cont<H_TOTAL-1) then
        H_Cont <= H_Cont+1;
      else
        H_Cont <= 0;
      end if;
      -- Horizontal Sync
      if (H_Cont=VParams.H_FRONT-1) then        -- Front porch end
        Video_HSi <= '0';
      end if;
      if (H_Cont=VParams.H_FRONT+VParams.H_SYNC-1) then -- Sync pulse end
        Video_HSi <= '1';
      end if;
    end if;
  end if;
end process HGen;

-- Vertical Generator: Refer to the horizontal sync
VGen: process(Video_HSi)
begin
  if rising_edge(Video_HSi) then
    if(RST_I='1') then
      V_Cont <= 0;
      Video_VSi <= '1';
    else
      if (V_Cont<V_TOTAL-1) then
        V_Cont <= V_Cont+1;
      else
        V_Cont <= 0;
      end if;
      -- Vertical Sync
      if (V_Cont=VParams.V_FRONT-1) then        -- Front porch end
        Video_VSi <= '0';
      end if;
      if (V_Cont=VParams.V_FRONT+VParams.V_SYNC-1) then -- Sync pulse end
        Video_VSi <= '1';
      end if;
    end if;
  end if;
end  process VGen;

VD_O.X  <= H_Cont-H_BLANK when (H_Cont>H_BLANK) else 0;
VD_O.Y  <= V_Cont-V_BLANK when (V_Cont>V_BLANK) else 0;
VD_O.HS <= Video_HSi;
VD_O.VS <= Video_VSi;
VD_O.BK <= '0' when ((H_Cont<H_BLANK) or (V_Cont<V_BLANK)) else '1';
VD_O.Color <= clblack;

end architecture Video_Arch;

