RSTX
====
![](image.png)  

RSTX: Serial Transmitter IPCore for SBA  
---------------------------------------

**Version:** 0.9  
**Date:** 2019/08/04  
**Author:** Miguel A. Risco-Castillo  
**Repository URL:** <https://github.com/mriscoc/SBA_Library/tree/master/RSTX>  

Interface of the VHDL module
----------------------------

```vhdl
entity RSTX is
generic (
  debug:positive:=1;
  sysfreq:positive:=50E6;
  baud:positive:=57600
  );
port (
  -- SBA Bus Interface
  CLK_I : in std_logic;
  RST_I : in std_logic;
  STB_I : in std_logic;
  WE_I  : in std_logic;
  DAT_I : in std_logic_vector;
  DAT_O : out std_logic_vector;
  INT_O : out std_logic;
  -- UART Interface;
  TX    : out std_logic
   );
end RSTX; 
```

**Description:**
RS232 Serial transmitter IP Core, Flag TXready to read in bit 14 of Data bus.


Release Notes:
--------------

- v0.9 2019/08/04  
  Improve Timming  

- v0.8 2017/08/04  
  Change sysfrec to sysfreq  

- v0.7 2016/11/03  
  Added Snippet for RSTX  
  Added INT_O outport, this signal is active when RSTX is ready to send  
  Remove dependency of SBAPackage  

- v0.6 2016/06/09  
  Remove dependency of SBAconfig  
  Sysfrec is now a "generic" parameter  
  Follow SBA v1.1 guidelines  

- v0.5  
  Make SBA buses generic std_logic_vectors  
  remove unused bits of DAT_O.  

- v0.4 2012/06/21  
  Timing and code improvements  

- v0.3  
  Adjust Baud Clock precision  

- v0.21 
  Minor error correct in SBAData process  

- v0.2 
  Initial Release  

--------------------------------------------------------------------------------
 **Copyright:**  

 (c) 2008-2015 Miguel A. Risco Castillo

 This code, modifications, derivate work or based upon, can not be used or
 distributed without the complete credits on this header.

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
