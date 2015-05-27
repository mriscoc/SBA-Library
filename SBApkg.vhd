------------------------------------------------------------
-- SBA Package
--
-- version 4.8 20120824
--
-- General constants and functions definitions
-- for SBA v1.0
--
------------------------------------------------------------
--
--
-- Author:
-- (c) Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- web page: http://mrisco.accesus.com
-- sba webpage: http://sba.accesus.com
--
-- This code, modifications, derivate
-- work or based upon, can not be used
-- or distributed without the
-- complete credits on this header and
-- the consent of the author.
--
-- This version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
-- if you use this component for your research please
-- include the appropriate credit of Author.
--
-- For commercial purposes request the appropriate
-- license from the author.
--
--
-- Notes
--
-- v4.8 added random n bits vector and integer number generator functions.
-- v4.7 removed the stb function and type definitions
-- v4.6 minor change on function hex (resize of result)
-- v4.5 minor change on function stb
-- v4.4 added inc and dec procedures for integers
-- v4.3 added Greatest common divisor function
-- v4.2 change stb() function for Xilinx ISE compatibility
-- v4.1 add internal Data Type to unsigned
-- v4.0 Transfer config values to SBA_config package
-- added multiple conversion functions
--
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package SBA_package is

  function trailing(slv:std_logic_vector;len:positive;value:std_logic) return std_logic_vector;
  function rndv(n:natural) return std_logic_vector;
  function rndi(n:integer) return integer;
  function chr2uns(chr: character) return unsigned;
  function chr2int(chr: character) return integer;
  function chr(uns: unsigned) return character;
  function chr(int: integer) return character;
  function hex2uns(hex: unsigned) return unsigned;
  function hex(uns: unsigned) return unsigned;
  function hex(int: integer) return integer;
  function hex(int: integer) return character;
  function int2str(int: integer) return string;
  function gcd(dat1,dat2:integer) return integer;  -- Greatest common divisor
  procedure clr(signal val: inout std_logic_vector);
  procedure clr(variable val:inout unsigned);
  procedure inc(variable val:inout unsigned); 
  procedure inc(variable val:inout integer);
  procedure inc(signal val:inout std_logic_vector);
  procedure dec(variable val:inout unsigned);
  procedure dec(variable val:inout integer);
  procedure dec(signal val:inout std_logic_vector);

end;

package body SBA_package is

  function trailing(slv:std_logic_vector;len:positive;value:std_logic) return std_logic_vector is
  variable s:integer;
  variable v:unsigned(len-1 downto 0);
  variable d:unsigned(0 downto 0);
  begin
    s:=slv'length;
    d(0):=value;
    if (len>s) then
      v:= unsigned(slv) & resize(d,len-s);
    else
      v:= unsigned(slv(slv'high downto s-len));
    end if;
    return std_logic_vector(v);
  end;


  function rndi(n:integer) return integer is
  variable R: real;
  variable S1, S2: positive := 69;
  begin
    uniform(S1, S2, R);
    Return integer(R*real(n+1));
  end;

  function rndv(n:natural) return std_logic_vector is
  begin
    return std_logic_vector(to_unsigned(rndi(2**n-1),n));
  end;

  function chr2uns(chr: character) return unsigned is
  begin
    return to_unsigned(character'pos(chr),8);
  end;

  function chr2int(chr: character) return integer is
  begin
    return character'pos(chr);
  end;

  function chr(uns: unsigned) return character is
  begin
    return character'val(to_integer(uns));
  end;

  function chr(int: integer) return character is
  begin
    return character'val(int);
  end;

  function hex2uns(hex: unsigned) return unsigned is
  variable ret:unsigned(hex'range);
  begin
    if (hex>=chr2uns('0')) and (hex<=chr2uns('9')) then
      ret:= hex - chr2uns('0');
    elsif (hex>=chr2uns('A')) and (hex<=chr2uns('F')) then
      ret:= hex - chr2uns('A') + 10;
    else
      ret:= (others=>'0');
    end if;
    return ret;
  end;

  function hex(uns: unsigned) return unsigned is
  variable ret:unsigned(uns'range);
  begin
    if (uns<=9) then
      ret:= uns + resize(chr2uns('0'),uns'length);
    elsif (uns>=10) and (uns<=15) then
      ret:= uns + resize(chr2uns('A'),uns'length) - 10;
    else
      ret:= resize(chr2uns('?'),uns'length);
    end if;
    return ret;     
  end;

  function hex(int: integer) return integer is
  variable ret:integer;
  begin
    if (int<=9) then
      ret:= int + chr2int('0');
    elsif (int>=10) and (int<=15) then
      ret:= int + chr2int('A') - 10;
    else
      ret:= chr2int('?');
    end if;
    return ret;     
  end;

  function hex(int: integer) return character is
  begin
    return chr(hex(int));
  end;  

   -- convert integer to string using specified base
   -- (adapted from Steve Vogwell's posting in comp.lang.vhdl)

  function int2str(int: integer) return string is
    variable temp:      string(1 to 10);
    variable num:       integer;
    variable abs_int:   integer;
    variable len:       integer := 1;
    variable power:     integer := 1;
    constant base : integer := 10;
  begin
    -- bug fix for negative numbers
    abs_int := abs(int);
    num     := abs_int;
    while num >= base loop                     -- Determine how many
      len := len + 1;                          -- characters required
      num := num / base;                       -- to represent the
    end loop ;                                 -- number.
    for i in len downto 1 loop                 -- Convert the number to
      temp(i) := hex(abs_int/power mod base);  -- a string starting
      power := power * base;                   -- with the right hand
    end loop ;                                 -- side.
    -- return result and add sign if required
    if int < 0 then
       return '-'& temp(1 to len);
     else
       return temp(1 to len);
    end if;
  end int2str;

  function gcd(dat1,dat2:integer) return integer is  -- Greatest common divisor
  variable tmp_X, tmp_Y: integer;
  begin
    tmp_X := dat1;
    tmp_Y := dat2;
    while (tmp_X/=tmp_Y) loop
      if (tmp_X/=tmp_Y) then
        if (tmp_X < tmp_Y) then
          tmp_Y := tmp_Y - tmp_X;
        else
          tmp_X := tmp_X - tmp_Y;
        end if;
      end if;
    end loop;
    return tmp_X;
  end;

  procedure clr(signal val:inout std_logic_vector) is
  begin
    val <= std_logic_vector(to_unsigned(0, val'length));
  end;

  procedure clr(variable val:inout unsigned) is
  begin
    val := to_unsigned(0,val'length);
  end;

  procedure inc(signal val:inout std_logic_vector) is
  begin
    val<= std_logic_vector(unsigned(val) + 1);
  end;

  procedure inc(variable val:inout unsigned) is
  begin
    val := val + 1;
  end;

  procedure inc(variable val:inout integer) is
  begin
    val := val + 1;
  end;

  procedure dec(signal val:inout std_logic_vector) is
  begin
    val<= std_logic_vector(unsigned(val) - 1);
  end;

  procedure dec(variable val:inout unsigned) is
  begin
    val := val - 1;
  end;

  procedure dec(variable val:inout integer) is
  begin
    val := val - 1;
  end;

end;

