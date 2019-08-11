MAX10AD1
========
![](image.png)   

MAX10 Single ADC IP Core adapter
-----------------------------------

**Version:** 0.3  
**Date:** 2019/08/06  
**Author:** Miguel A. Risco-Castillo  
**Repository URL:** <https://github.com/mriscoc/SBA_Library/tree/master/MAX10AD1>  

Based upon SBA v1.2 guidelines  

Interface of the VHDL module
----------------------------

```vhdl
entity MAX10AD1 is
port(
-- SBA Interface
   RST_I : in  std_logic;        -- Active high reset
   CLK_I : in  std_logic;        -- Main clock
   STB_I : in  std_logic;        -- Strobe
   WE_I  : in  std_logic;        -- Bus write, active high
   DAT_I : in  std_logic_vector; -- Data input Bus
   DAT_O : out std_logic_vector; -- Data output Bus
   INT_O : out std_logic;        -- Interrupt on data valid
-- PLL Interface
   PLLCLK_I : in std_logic;      -- PLL clock input
   PLLLCK_I : in std_logic       -- PLL locked input
);
end MAX10AD1; 
```
Description
-----------
Preliminary version of SBA Slave IP Core adapter for MAX10 Single ADC.
Use a faster `CLK_I` system clock than the PLL clock input. Use the `Quartus IP 
Catalog` to Add a `PLL` and a `Modular ADC core` to your proyect, name the last
as `MAX10ADC` and configure the core variant as `ADC control core only`.  
  
Release Notes:
--------------

- v0.3 2019/08/06  
  First public release

--------------------------------------------------------------------------------
 **Copyright:**  

 (c) Miguel A. Risco-Castillo  

 This code, modifications, derivate work or based upon, can not be used or
 distributed without the complete credits.

 This version is released under the GNU/GLP license
 http://www.gnu.org/licenses/gpl.html
 if you use this component for your research please include the appropriate
 credit of Author.

 The code may not be included into ip collections and similar compilations
 which are sold. If you want to distribute this code for money then contact me
 first and ask for my permission.

 These copyright notices in the source code may not be removed or modified.
 If you modify and/or distribute the code to any third party then you must not
 veil the original author. It must always be clearly identifiable.

 Although it is not required it would be a nice move to recognize my work by
 adding a citation to the application's and/or research.

 FOR COMMERCIAL PURPOSES REQUEST THE APPROPRIATE LICENSE FROM THE AUTHOR.
--------------------------------------------------------------------------------
