CLKDIV
======
![](image.png)   

**Title:** IPCore for divide an Input clock signal  

**Description:**  
CLKDIV is a simple Clock divider. It automatically calculates the divisor for giving a signal of 'outfreq' in Hz. 

**Version**: 4.6  
**Date**: 2018/06/02  
**Author**: Miguel A. Risco-Castillo  
**RepositoryURL:** <https://github.com/mriscoc/SBA_Library/blob/master/CLKDIV>  

Based upon SBA v1.1 guidelines

Release Notes:
--------------

- v4.6 2018/06/02  
  Minor correction in generics, infrec to infreq, outfrec to outfreq
 
- v4.5 2017/03/22  
  Correct bug in debug generic type (positive to natural)
 
- v4.4 2015/05/26  
  Start to follow SBA v1.1 guidelines, remove SBAconfig dependency
 
- v4.3 2011-04-12  
  Debug messages, change variables to signals to improve performance
 
- v4.2 2010-10-14  
  Change Config file from SBA_package to SBA_config
 
- v4.1 2010-09-21  
  Improve calc divider for guarantee equal or lower frequencies
 
- v4.0 2010-08-03  
  Synchronous Reset
 
- v3.0 2009-09-24  
  Initial release.

Interface of the VHDL module
----------------------------

```vhdl
entity ClkDiv is
generic (
 infreq:positive:=50E6;         -- 50MHz default system frequency
 outfreq:positive:=1000;        -- 1KHz output frequency
 debug:natural:=1               -- Debug mode 1=on, 0:off
);
port (
    CLK_I : in std_logic;
    RST_I : in std_logic;
    CLK_O : out std_logic
);
end ClkDiv;
```
*Generics:*  
- `infreq`: is the frequency of the input clock to be divide  
- `outfreq`: is the frequency of the divided output clock  
- `debug`: debug flag, 1:print debug information, 0:hide debug information

