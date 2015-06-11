-----------------------------------------------------------
-- SawTooth Generator
--
-- Versión 6.4 20120611
--
-- Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- webpage: http://mrisco.accesus.com
--
-- SawTooth Generator
--
-- SBA v1.0
--
-- De usar este programa favor de respetar
-- los créditos del autor original
--
-- Notes:
--
-- v6.4
-- Add Number of samples in generics
--
-- v6.3
-- Synchronic Reset
-- Add resolution in generics (width of output)
--
-----------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SBA_config.all;
use work.SBA_package.all;

entity SawToothGen is
generic(
   res:positive:=8;          -- Output width in bits
   smpl:positive:=256        -- Samples by wave
);
port(
   RST_I : in  std_logic;                     -- active high reset
   CLK_I : in  std_logic;                     -- Base frecuency clock
   DAT_O : out DATA_type;                     -- Data output
   STB_I : in  std_logic;                     -- Strobe In
   WE_I  : in  std_logic                      -- Read and Get next Data active Low
);
end SawToothGen;

architecture SawToothGen_Arch of SawToothGen is

constant chinc : integer := (2**res)/smpl;
Signal enable : std_logic;

begin

  Sawtooth: Process (RST_I, CLK_I)
  Variable Q : unsigned(res-1 downto 0);
  Variable i : integer range 0 to smpl-1;
  Begin
    if rising_Edge(CLK_I) Then
      if (RST_I='1') then
        Q:=(others=>'0');
        i:=0;
      elsif (enable='1') then
        if i<smpl-1 then
          Q:=Q+chinc;
          i:=i+1;
        else
          Q:=(others=>'0');
          i:=0;
        end if;
      end if;
      DAT_O <= std_logic_vector(resize(Q,DAT_O'length));
    end if;
  end process;
  
  enable  <= STB_I and (not WE_I);

end SawToothGen_Arch;
