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

