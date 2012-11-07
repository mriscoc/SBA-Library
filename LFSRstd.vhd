----------------------------------------------------------------------------
-- Copyright (c) 1996, Ben Cohen.   All rights reserved.
-- This model can be used in conjunction with the Kluwer Academic book
-- "VHDL Coding Styles and Methodologies", ISBN: 0-7923-9598-0
-- "VHDL Amswers to Frequently Asked Questions", Kluwer Academic
-- which discusses guidelines and testbench design issues.
-- email: vhdlcohen@aol.com
--
-- This source file for the Linear Feedback Shift Register package
-- may be used and distributed without restriction provided
-- that this copyright statement is not removed from the file
-- and that any derivative work contains this copyright notice.

-------------------------------------------------------------------------------
--
--   File name   :  lfsrstd.vhd
--   Title       :  Linear Feedback Shift Register Package
--   Description :  for registers of lengths 2 through 64
--               :  and  100, 132, 164, 200, 300 bits.
--               :  Initial actual value should be a not zero vector.
--               :  If is it, this function will return the value of 1.
--               :  Data should NOT contain any of the following values:
--               :  'U' | 'X' | 'Z' | 'W' | '-'
--               : Actual parameter can be either a variable or a signal.
--               : Size of vector can be between 2 to 64, 100. 132. 164. 200, or 300.
--               : Function detects size of actual and returns a value of the same size as
--               : the actual parameter.  Example of application:
--               :          signal R32_s : Std_Logic_Vector(31 downto 0) :=
--               :                            "00101100010101111110001010100110";
--               :            ....
--               :          R32_s <= LFSR(R32_s);
--               :
--   Source of   :  "Built-In Test for VLSI: Pseudorandom Techniques",
--   equations   :  Paul H. Bardell, William H. McAnney, Jacob Savir,
--               :  John Wiley and Sons, 1987.
--               :  Equations are described in Appendix, and provide
--               :  the polynomials for degrees 2 through 300.
--               :
--   Synthesis   :  This code is synthesizable.  Pragmas are written for
--               :  Synopsys synthesizer to ignore the assert statement
--               :  written for error detection
-------------------------------------------------------------------------------
--   Revisions   :
--          Date                Author          Revision        Comments
--   March 10,  1996            cohen           Rev A           Creation
-------------------------------------------------------------------------------

library IEEE;
  use IEEE.Std_Logic_1164.all;

package LfsrStd_Pkg is
  function LFSR(S : Std_Logic_Vector) return Std_Logic_Vector;
  function LFSR(S : Std_uLogic_Vector) return Std_uLogic_Vector;
end LfsrStd_Pkg;


package body LfsrStd_Pkg is

  function LFSR(S : Std_logic_vector) return Std_Logic_Vector is
    variable S_v   : Std_Logic_Vector(1 to S'Length);
    constant S_c   : Std_Logic_Vector(1 to S'Length) := (others => '0');

  begin
    -- pragma translate_off
    S_v := To_X01(S);   -- function is in Std_Logic_1164 package
    if Is_X(S_v) then
      assert false
        report "Passed parameter contains one of the following " &
               "characters  'U' | 'X' | 'Z' | 'W' | '-' " 
        severity Warning;
      assert false
        report "Data passed = " &
--               ATEP_Lib.Image_Pkg.Image(S)
        severity Note;
       return S;     -- Return unchanged value
    end if;
    -- pragma translate_on
    S_v := S;
    if  S_v = S_c then
      return (S_c(1 to S_c'length - 1) & '1');
    else
      case S'Length is
        when 2 =>   --  X^2 + X^1 + 1
          return (S_v(2) xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 3 =>   -- X^3 + X^1 + 1
          return (S_v(3) xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 4 =>   -- X^4 + X^1 + 1
          return (S_v(4) xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 5 =>   -- X^5 + X^2 + 1
          return (S_v(5) xor S_v(2)
                 ) & S_v(1 to S'Length - 1);

        when 6 =>   -- X^6 + X^1 + 1
          return (S_v(6) xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 7 =>   -- X^7 + X^1 + 1
          return (S_v(7) xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 8 =>   -- X^8 + X^6 + X^5  + X^1 + 1
          return (S_v(8) xor S_v(6) xor
                  S_v(5)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 9 =>   --  X^9 + X^4 + 1
          return (S_v(9) xor S_v(4)
                 ) & S_v(1 to S'Length - 1);

        when 10 =>  -- X^10 + X^3 + 1
          return (S_v(10) xor S_v(3)
                 ) & S_v(1 to S'Length - 1);

        when 11 =>  -- X^11 + X^2 + 1
          return (S_v(11) xor S_v(2)
                 ) & S_v(1 to S'Length - 1);

        when 12 =>  --X^12 + X^7 + X^4 +X^3 + 1
          return (S_v(12) xor S_v(7) xor
                  S_v(4)  xor S_v(3)
                 ) & S_v(1 to S'Length - 1);

        when 13 =>  -- X^13 + X^4 + X^3 + X^1 + 1
          return (S_v(13) xor S_v(4) xor
                  S_v(3)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 14 =>  -- X^14 + X^12 + X^11 + X^1 + 1
          return (S_v(14) xor S_v(12) xor
                  S_v(11)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 15 =>  -- X^15 + X^1 + 1
          return (S_v(15) xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 16 =>  -- X^16 + X^5 + X^3 + X^2 + 1
          return (S_v(16) xor S_v(5) xor
                  S_v(3)  xor S_v(2)
                 ) & S_v(1 to S'Length - 1);

        when 17 =>  --X^17 + X^3 + 1
          return (S_v(17) xor S_v(3)
                 ) & S_v(1 to S'Length - 1);

        when 18 =>  -- X^18 + X^7 + 1
          return (S_v(18) xor S_v(7)
                 ) & S_v(1 to S'Length - 1);

        when 19 =>  -- X^19 + X^6 + X^5 + X^1 + 1
          return (S_v(19) xor S_v(6) xor
                  S_v(5)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 20 =>  --X^20 + X^3 + 1
          return (S_v(20) xor S_v(3)
                 ) & S_v(1 to S'Length - 1);

        when 21 =>  --X^21 + X^2 + 1
          return (S_v(21) xor S_v(2)
                 ) & S_v(1 to S'Length - 1);

        when 22 =>  --X^22 + X^1 + 1
          return (S_v(22) xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 23 =>  --X^23 + X^5 + 1
          return (S_v(23) xor S_v(5)
                 ) & S_v(1 to S'Length - 1);

        when 24 =>  -- X^24 + X^4 + X^3 + X^1 + 1
          return (S_v(24) xor S_v(4) xor
                  S_v(3)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 25 =>  -- X^25 + X^3 + 1
          return (S_v(25) xor S_v(3)
                 ) & S_v(1 to S'Length - 1);

        when 26 =>  -- X^26 + X^8 + X^7 + X^1 + 1
          return (S_v(26) xor S_v(8) xor
                  S_v(7)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 27 =>  -- X^27 + X^8 + X^7 + X^1 + 1
          return (S_v(27) xor S_v(8) xor
                  S_v(7)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 28 =>  --X^28 + X^3 + 1
          return (S_v(28) xor S_v(3)
                 ) & S_v(1 to S'Length - 1);

        when 29 =>  --X^29 + X^2 + 1
          return (S_v(29) xor S_v(2)
                 ) & S_v(1 to S'Length - 1);

        when 30 =>  -- X^30 + X^16 + X^15 + X^1 + 1
          return (S_v(30) xor S_v(16) xor
                  S_v(15)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 31 =>  -- X^31 + X^3 + 1
          return (S_v(31) xor S_v(3)
                 ) & S_v(1 to S'Length - 1);

        when 32 =>  -- X^32 + X^28 + X^27 + X^1 + 1
          return (S_v(32) xor S_v(28) xor
                  S_v(27)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 33 =>  -- X^33 + X^13 + 1
          return (S_v(33) xor S_v(13)
                 ) & S_v(1 to S'Length - 1);

        when 34 =>  -- X^34 + X^15 + X^14 + X^1 + 1
          return (S_v(34) xor S_v(15) xor
                  S_v(14)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 35 =>  -- X^35 + X^2 + 1
          return (S_v(35) xor S_v(2)
                 ) & S_v(1 to S'Length - 1);

        when 36 =>  -- X^36 + X^11 + 1
          return (S_v(36) xor S_v(11)
                 ) & S_v(1 to S'Length - 1);

        when 37 =>  -- X^37 + X^12 + X^10 + X^2 + 1
          return (S_v(37) xor S_v(12) xor
                  S_v(10)  xor S_v(2)
                 ) & S_v(1 to S'Length - 1);

        when 38 =>  -- X^38 + X^6 + X^5 + X^1 + 1
          return (S_v(38) xor S_v(6) xor
                  S_v(5)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 39 =>  -- X^39 + X^4 + 1
          return (S_v(39) xor S_v(4)
                 ) & S_v(1 to S'Length - 1);

        when 40 =>  -- X^40 + X^21 + X^19 + X^2 + 1
          return (S_v(40) xor S_v(21) xor
                  S_v(19)  xor S_v(2)
                 ) & S_v(1 to S'Length - 1);

        when 41 =>  -- X^41 + X^3 + 1
          return (S_v(41) xor S_v(3)
                 ) & S_v(1 to S'Length - 1);

        when 42 =>  -- X^42 + X^23 + X^22 + X^1 + 1
          return (S_v(42) xor S_v(23) xor
                  S_v(22)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 43 =>  -- X^43 + X^6 + X^5 + X^1 + 1
          return (S_v(43) xor S_v(6) xor
                  S_v(5)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 44 =>  -- X^44 + X^27 + X^26 + X^1 + 1
          return (S_v(44) xor S_v(27) xor
                  S_v(26)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 45 =>  -- X^45 + X^4 + X^3 + X^1 + 1
          return (S_v(45) xor S_v(4) xor
                  S_v(3)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 46 =>  -- X^46 + X^21 + X^20 + X^1 + 1
          return (S_v(46) xor S_v(21) xor
                  S_v(20)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 47 =>  -- X^47 + X^5 + 1
          return (S_v(47) xor S_v(5)
                 ) & S_v(1 to S'Length - 1);

        when 48 =>  -- X^48 + X^28 + X^27 + X^1 + 1
          return (S_v(48) xor S_v(28) xor
                  S_v(27)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 49 =>  -- X^49 + X^9 + 1
          return (S_v(49) xor S_v(9)
                 ) & S_v(1 to S'Length - 1);

        when 50 =>  -- X^50 + X^27 + X^26 + X^1 + 1
          return (S_v(50) xor S_v(27) xor
                  S_v(26)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 51 =>  -- X^51 + X^16 + X^15 + X^1 + 1
          return (S_v(51) xor S_v(16) xor
                  S_v(15)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 52 =>  -- X^52 + X^3 + 1
          return (S_v(52) xor S_v(3)
                 ) & S_v(1 to S'Length - 1);

        when 53 =>  -- X^53 + X^16 + X^15 + X^1 + 1
          return (S_v(53) xor S_v(16) xor
                  S_v(15)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 54 =>  -- X^54 + X^37 + X^36 + X^1 + 1
          return (S_v(54) xor S_v(37) xor
                  S_v(36)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 55 =>  -- X^55 + X^24 + 1
          return (S_v(55) xor S_v(24)
                 ) & S_v(1 to S'Length - 1);

        when 56 =>  -- X^56 + X^22 + X^21 + X^1 + 1
          return (S_v(56) xor S_v(22) xor
                  S_v(21)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 57 =>  -- X^57 + X^7 + 1
          return (S_v(57) xor S_v(7)
                 ) & S_v(1 to S'Length - 1);

        when 58 =>  -- X^58 + X^19 + 1
          return (S_v(58) xor S_v(19)
                 ) & S_v(1 to S'Length - 1);

        when 60 =>  -- X^60 + X^1 + 1
          return (S_v(60) xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 61 =>  -- X^61 + X^16 + X^15 + X^1 + 1
          return (S_v(61) xor S_v(16) xor
                  S_v(15)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 62 =>  -- X^62 + X^57 + X^56 + X^1 + 1
          return (S_v(62) xor S_v(57) xor
                  S_v(56)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 63 =>  -- X^63 + X^1 + 1
          return (S_v(63) xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 64 =>  -- X^64 + X^4 + X^3 + X^1 + 1
          return (S_v(64) xor S_v(4) xor
                  S_v(3)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 100 =>  -- X^100 + X^37 + 1
          return (S_v(100) xor S_v(37)
                 ) & S_v(1 to S'Length - 1);

        when 132 =>  -- X^132 + X^29 + 1
          return (S_v(132) xor S_v(29)
                 ) & S_v(1 to S'Length - 1);

        when 164 =>  -- X^164 + X^14 + X^13 + X^1 + 1
          return (S_v(164) xor S_v(14) xor
                  S_v(13)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 200 =>  -- X^200 + X^163 + X^2 + X^1 + 1
          return (S_v(200) xor S_v(163) xor
                  S_v(2)  xor S_v(1)
                 ) & S_v(1 to S'Length - 1);

        when 300 =>  -- X^300 + X^7 + 1
          return (S_v(300) xor S_v(7)
                 ) & S_v(1 to S'Length - 1);


        when others =>
          -- pragma translate_off 
          assert False
            report "Length of vector is NOT in proper range"
            severity Warning;
          -- pragma translate_on
          return S_v;
      end case;
    end if;
  end LFSR;

  function LFSR(S : Std_uLogic_Vector) return Std_uLogic_Vector is
  begin
    return To_StdULogicVector(LFSR(To_StdLogicVector(S)));
  end LFSR;


end LfsrStd_Pkg;

