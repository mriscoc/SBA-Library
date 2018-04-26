RAM
===

![](image.png)

**Title:** Generic RAM IP Core  

**Description:** 
RAM core, infer internal RAM Blocks for most of FPGA families.

**Version:** 0.5  
**Date:** 2018/04/25  
**Author:** Miguel A. Risco-Castillo  
**RepositoryURL:** <https://github.com/mriscoc/SBA_Library/blob/master/RAM>  

Based on SBA v1.1 guidelines

Release Notes:
--------------
- v0.5 2018/04/25  
  Minor bug correction in Ini file

- v0.4 2015/06/14  
  Entity rename from SBARam to RAM
- Remove false dependency of SBApackage
  Following SBA v1.1 guidelines

- v0.3 2012/06/12  
  Configurable width and depth bits, the width must be
  equal or lower the SBA Data bus width

- v0.2  
  Minor changes in address and ACK_O signals

- v0.1  
  Inspirated by DOULOS - designer: JK (2008)

Interface of the VHDL module
----------------------------

```vhdl
entity RAM is
generic(
      width:positive:=8;
      depth:positive:=8
     );
port (
      -- SBA Bus Interface
      CLK_I : in std_logic;
      RST_I : in std_logic;
      WE_I  : in std_logic;
      STB_I : in std_logic;
      ACK_O : out std_logic;         -- Strobe Acknoledge
      ADR_I : in std_logic_vector;
      DAT_I : in std_logic_vector;
      DAT_O : out std_logic_vector
     );
end RAM;
```
*Generics:*
- width: positive, size of the data bus
- depth: positive, size of the address bus
