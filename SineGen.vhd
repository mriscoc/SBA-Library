-----------------------------------------------------------
-- SineWave Generator
--
-- Versión 6.0 20120611
--
-- Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- webpage: http://mrisco.accesus.com
--
-- SineWave Generator
--
-- SBA v1.0 compatible
--
-- You are welcome to use the source code
-- we provide but you must keep the copyright
-- notice with the code
--
-- Notes:
--
-- v6.0
-- Automatic Generation of Sine values
--
-----------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.SBA_config.all;
use work.SBA_package.all;

entity SineGen is
generic(
   res:positive:=8;          -- Output width in bits
   smpl:positive:=256        -- Samples by wave
);
port(
   RST_I : in  std_logic;    -- active high reset
   CLK_I : in  std_logic;    -- System clock
   DAT_O : out DATA_type;    -- Data output
   STB_I : in  std_logic;    -- Strobe In
   WE_I  : in  std_logic     -- Read and Get next Data active Low
);
end SineGen;

architecture arch1 of SineGen is

  constant max_table_value: integer := (2**res)/2-1;
  type twavetable is array (0 to smpl/4) of unsigned(res-1 downto 0);
  type   TSineSt is ( Q0,Q1,Q2,Q3 );
  signal sine_st: TSineSt;
  signal table_index: integer range 0 to smpl/4;
  signal sinetable : twavetable;
  signal SineO : unsigned(res-1 downto 0);
  
begin


  SineTableIndex: process(RST_I, CLK_I)
  variable enable:std_logic;
  begin
    if RST_I = '1' then
      table_index <= 0;
      enable:='0';
    elsif rising_edge( CLK_I ) then 
      enable:= STB_I and (not WE_I);    
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
        if table_index = smpl/4-1 then
          sine_st <= Q1;
        end if;
      when Q1 =>
        if table_index = 1 then
          sine_st <= Q2;
        end if;
      when Q2 =>
        if table_index = smpl/4-1 then
          sine_st <= Q3;
        end if;
      when others => -- Q3
        if table_index = 1 then
          sine_st <= Q0;
        end if;
    end case;
    end if;
  end process;


  SineCalc: process(RST_I,table_index)
  variable S : unsigned(res-1 downto 0);
  begin
    if RST_I = '1' then
      S := (others=>'0');
    else
      case Sine_st is
      when Q0 | Q1 =>
        S := max_table_value+sinetable(table_index);
      when Q2 | Q3 =>
        S := max_table_value-sinetable(table_index);
      end case;
    end if;
    SineO <= S;
  end process;

GENROM:
FOR idx in 0 TO smpl/4 GENERATE
  CONSTANT x: REAL := SIN(real(idx)*MATH_PI/real(2*(smpl/4)));
BEGIN
  Sinetable(idx) <= to_unsigned(INTEGER(x*real(max_table_value)),res);	
END GENERATE;   


DAT_O <= std_logic_vector(resize(SineO,DAT_O'length)) ;

end;







