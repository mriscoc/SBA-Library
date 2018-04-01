DPSRAM
======

![](image.png)   

**Title:** SBA Dual Port SRAM IPCore  

**Description:**  
DPSRAM is a double port single clock RAM, it can be used to join multiple
SBA systems. There are two versions, with and without registered data output.
The version is chosen through the value of `registered` generic, the default
value is true.

**Version:** 0.4  

**Date:** 2018/03/30   

**Author:** Miguel A. Risco-Castillo   

**RepositoryURL:** <https://github.com/mriscoc/SBA_Library/blob/master/DPSRAM>

Based on SBA v1.1 guidelines

Release Notes:
--------------

- v0.4 2018/03/30  
  Add generics for generate registered and unregistered data output versions  

- v0.3 2016/02/07  
  Add RST_I line, for SBA v.1.1 compliant  

- v0.2 2015/05/28  
  remove ACK lines: not in use  

- v0.1 2012/06/12  
  Initial release  
  Inspirated in Altera examples  

Interface of the VHDL module
---------------------------- 

```vhdl
entity DPSram is
generic(
      width:positive:=8;
      depth:positive:=8;
      registered:boolean:=true
     );
port (
      -- SBA Bus Interface
      RST_I  : in std_logic;
      CLK_I  : in std_logic;
      -- Output Port 0
      ADR0_I : in std_logic_vector;
      DAT0_O : out std_logic_vector;
      -- Input Port 1
      STB1_I : in std_logic;
      WE1_I  : in std_logic;
      ADR1_I : in std_logic_vector;
      DAT1_I : in std_logic_vector
     );
end DPSram;
```
*Generics:*
- width: positive, size of the data bus
- depth: positive, size of the address bus
- registered: boolean, true for generate registered data output

