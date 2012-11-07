-----------------------------------------------------------
-- ADCVirtual.vhd
--
-- Version 0.3 20120222
-- Dual Channel
-- SBA v1.0 compatible
--
-- Generics: (channel X: 0,1)
-- chXres:  Output width in bits (>0, <=DATA bus)
-- chXsmpl: Samples by wave      (>1 in Ch0, >=4 in Ch1)
-- chXnsb:  Bits of noise (LSb)  (<= ChXres)
--
-- (c) Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- web page: http://mrisco.accesus.com
--
-- Notes:
--
-- v0.3
-- State machine changes in Sine generator
-- Configurable resolution, samples and noise for each channel
--
-- v0.2
-- Auto generate Sine ROM table
--
-- v0.1
-- First Release
--
-----------------------------------------------------------
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
-----------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.SBA_config.all;
use work.SBA_package.all;
use work.LfsrStd_Pkg.all;

entity ADCVirtual is
generic (
   ch0res:positive:=8;          -- Output width in bits
   ch0smpl:positive:=256;       -- Samples by wave
   ch0nsb:natural:=2;           -- Bits of noise (LSb)
   ch1res:positive:=8;
   ch1smpl:positive:=256;
   ch1nsb:natural:=2
   );
port(
   RST_I : in  std_logic;       -- active high reset
   CLK_I : in  std_logic;       -- Main clock
   DAT_O : out DATA_type;       -- Data Bus Virtual ADC
   STB_I : in  std_logic;       -- Virtual ADC ChipSel, active high
   ADR_I : in  std_logic;       -- Channel Select
   WE_I  : in  std_logic        -- Virtual ADC read, active low
	);
end ADCVirtual;

architecture ADCVirtual_Arch of ADCVirtual is

  signal random : std_logic_vector(15 downto 0);

  constant max_table_value: integer := (2**ch1res)/2-1;
  type twavetable is array (0 to ch1smpl/4) of unsigned(ch1res-1 downto 0);
  type   TSineSt is ( Q0,Q1,Q2,Q3 );
  signal sine_st: TSineSt;
  signal table_index: integer range 0 to ch1smpl/4;
  signal sinetable : twavetable;
  signal SineO : unsigned(ch1res-1 downto 0);

  constant ch0inc : integer := (2**ch0res)/ch0smpl;
  signal SawTO : unsigned(ch0res-1 downto 0);

  signal DAT0i: unsigned(ch0res-1 downto 0); -- Channel 0 output
  signal DAT1i: unsigned(ch1res-1 downto 0); -- Channel 1 output
  signal enable: std_logic;

begin

  Noise: Process(RST_I, CLK_I)
  begin
    if rising_Edge(CLK_I) Then
      if (RST_I='1') then
  		  Random<=x"ABCD";
      else
        Random<=LFSR(Random);
      end if;
    end if;		
  end process;

  Sawtooth: Process (RST_I, CLK_I)
  Variable Q : unsigned(ch0res-1 downto 0);
  Variable i : integer range 0 to ch0smpl-1;
  Begin
    if rising_Edge(CLK_I) Then
      if (RST_I='1') then
        Q:=(others=>'0');
        i:=0;
      elsif (enable='1') then
        if i<ch0smpl-1 then
          Q:=Q+ch0inc;
          i:=i+1;
        else
          Q:=(others=>'0');
          i:=0;
        end if;
      end if;
      if (ch0nsb>0) Then
        SawTO <= Q XOR resize(unsigned(Random(ch0nsb-1 downto 0)),DAT0i'length);
      else
        SawTO <= Q;
      end if;
    end if;
  end process;

  SawTOutput: process(RST_I,STB_I,WE_I, SawTO)
  begin
    if (RST_I = '1' or STB_I='0' or WE_I='1') then
      DAT0i <= (others=>'0');
    else 
      DAT0i <= SawTO;
    end if;
  end process;


  SineTableIndex: process(RST_I, CLK_I)
  begin
    if RST_I = '1' then
      table_index <= 0;
    elsif rising_edge( CLK_I ) then 
      if enable = '1' then
        case sine_st is
          when Q0 =>
            table_index <= table_index + 1;
          when Q1 =>
            table_index <= table_index - 1;
          when Q2 =>
            table_index <= table_index + 1;
          when Q3 =>
            table_index <= table_index - 1;
        end case;
      end if;
    end if;
  end process;

  SineState: process(RST_I, CLK_I)
  begin
    if RST_I = '1' then
      sine_st <= Q0;
    elsif rising_edge( CLK_I ) then
    case Sine_st is
      when Q0 =>
        if table_index = ch1smpl/4-1 then
          sine_st <= Q1;
        end if;
      when Q1 =>
        if table_index = 1 then
          sine_st <= Q2;
        end if;
      when Q2 =>
        if table_index = ch1smpl/4-1 then
          sine_st <= Q3;
        end if;
      when others => -- Q3
        if table_index = 1 then
          sine_st <= Q0;
        end if;
    end case;
    end if;
  end process;


  SineCalc: process(table_index)
  variable S : unsigned(ch1res-1 downto 0);
  begin
    case Sine_st is
      when Q0 | Q1 =>
        S := max_table_value+sinetable(table_index);
      when Q2 | Q3 =>
        S := max_table_value-sinetable(table_index);
    end case;
    if (ch1nsb>0) Then
      SineO <= S XOR resize(unsigned(Random(ch1nsb-1 downto 0)),DAT1i'length);  
    else
      SineO <= S;
    end if;
  end process;

  SineOutput: process(RST_I,STB_I,WE_I, CLK_I)
  begin
    if (RST_I = '1' or STB_I='0' or WE_I='1') then
      DAT1i <= (others=>'0');
    elsif rising_edge( CLK_I ) then
      DAT1i <= SineO;
    end if;
  end process;

GENROM:
FOR idx in 0 TO ch1smpl/4 GENERATE
  CONSTANT x: REAL := SIN(real(idx)*MATH_PI/real(2*(ch1smpl/4)));
BEGIN
  Sinetable(idx) <= to_unsigned(INTEGER(x*real(max_table_value)),ch1res);	
END GENERATE;   

 
enable<= '1'; -- habilita la generación e muestras lectura a lectura: (not RST_I) and STB_I and (not WE_I);

DAT_O <= std_logic_vector(resize(DAT0i,DAT_O'length)) when ADR_I='0' else std_logic_vector(resize(DAT1i,DAT_O'length)) ;

end ADCVirtual_Arch;