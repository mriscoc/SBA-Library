-----------------------------------------------------------
-- I2C.vhd
-- I2C Adapter for SBA v1.1 (Simple Bus Architecture)
--
-- Version 0.3
-- Date: 2017/08/04
-- 16 bits Data Interface
--
-- (c)Juan Vega Martinez
-- e-mail: juan.vega25@gmail.com
--
-- v0.3 2017/08/04
-- Change sysfrec to sysfreq
--
-- v0.2 2015/05/21
-- Code Optimized
--
-- v0.1
-- This version is released under the GNU/GLP license
-- if you use this component for your research please
-- include the appropriate credit of Author.
-- For commercial purposes request the appropriate
-- license from the author. 
-----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_std.all;
use work.SBApackage.all;

Entity I2C is
generic ( 
  sysfreq : integer:= 50e6;
  FREQ_SCL: natural:= 100e3); 
port (
      -- SBA Bus Interface
      CLK_I : in std_logic;
      RST_I : in std_logic;
      WE_I  : in std_logic;
      STB_I : in std_logic;
      ACK_O : out std_logic;        
      ADR_I : in std_logic_vector;
      DAT_I : in std_logic_vector;
      DAT_O : out std_logic_vector;
      -- I2C Interface
      I2C_SCL : inout std_logic;
      I2C_SDA : inout std_logic
      );
end I2C;

Architecture I2C_Adapter_arch of I2C is

constant I2C_ADDRESS : natural:= 7;  --Support dipositives with 10 bits address
signal CLKi : std_logic;
signal RSTi : std_logic;
signal DATo : std_logic_vector(15 downto 0);
signal I2C_WRi      : std_logic;
signal I2C_ADRi     : std_logic_vector (I2C_ADDRESS-1 downto 0);
signal I2C_DATAo    : std_logic_vector(15 downto 0);
signal I2C_REGi     : std_logic_vector(15 downto 0);
signal I2C_DATAi    : std_logic_vector(7 downto 0);
signal I2C_STARTi   : std_logic;
signal I2C_DATASENTi: std_logic;
signal I2C_DATARCVi : std_logic;

begin

U1: entity work.I2CBC
    generic map (I2C_ADDRESS => I2C_ADDRESS )
    port map
    (
       -- SBA Bus Interface
      CLK_I  => CLKi,
      RST_I  => RSTi,
      WE_I   => WE_I,
      STB_I  => STB_I,
      ACK_O  => ACK_O,
      ADR_I  => ADR_I,
      DAT_I  => DAT_I,
      DAT_O  => DATo,
      -- signals for Bus controller core i2C
      I2C_WR          => I2C_WRi,
      I2C_ADR_O       => I2C_ADRi,
      I2C_REG_O       => I2C_REGi,
      I2C_DATA_O      => I2C_DATAo, 
      I2C_DATA_I      => I2C_DATAi,    
      I2C_START_O     => I2C_STARTi,
      I2C_DATASENT    => I2C_DATASENTi,
      I2C_DATARCV     => I2C_DATARCVi       
);

U2: entity work.I2CSG 
generic map(
      sysfreq		=> sysfreq,
      I2C_ADDRESS   => I2C_ADDRESS,
      I2C_CLK       => FREQ_SCL      -- Frequency KHZ
  )  
port map(
    CLK_I  => CLKi,
    RST_I  => RSTi,
     -- I2C controller signals
    I2C_WR          => I2C_WRi,   
    I2C_ADR_I       => I2C_ADRi,
    I2C_REG_I       => I2C_REGi,
    I2C_DATA_I      => I2C_DATAo,
    I2C_DATA_O      => I2C_DATAi,  
    I2C_START_I     => I2C_STARTi,
    I2C_DATASENT    => I2C_DATASENTi,
    I2C_DATARCV     => I2C_DATARCVi,
    I2C_ERROR_O     => open,
    -- External signals out for I2C
    I2C_SCL         => I2C_SCL,
    I2C_SDA         => I2C_SDA
         
);

CLKi<=CLK_I;
RSTi<=RST_I;
DAT_O<= std_logic_vector( resize(unsigned(DATo),DAT_O'length));


end I2C_Adapter_arch;
