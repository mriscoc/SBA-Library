GPIO
====
![](image.png)   

SBA General Purpose Input Output IPCore
----------------------------------------

**Version:** 2.4.2  
**Date:** 2019/12/16  
**Author:** Miguel A. Risco-Castillo  
**Repository URL:** <https://github.com/mriscoc/SBA_Library/tree/master/GPIO>  

Interface of the VHDL module
----------------------------

```vhdl
Entity GPIO is
generic (size:positive:=8);
port (
  -- SBA Bus Interface
  CLK_I : in std_logic;
  RST_I : in std_logic;
  STB_I : in std_logic;
  WE_I  : in std_logic;
  DAT_I : in std_logic_vector;
  DAT_O : out std_logic_vector;
  -- PORT Interface;
  P_I   : in std_logic_vector(size-1 downto 0);
  P_O   :out std_logic_vector(size-1 downto 0)
  );
end GPIO;
```
Description
-----------
Generic Input/Output parallel port. Inputs and Outputs are latched on rising
edge of CLK.

Release Notes:
--------------
- v2.4.2 2019/12/16   
  Removed release notes and copyright text from vhdl file.  

- v2.4.1 2016/09/23   
  Added Latch for the input port 

- v2.3 2015/06/14   
  Rename of entity removing "Adapter"   
  Following SBA v1.1 guidelines

- v2.2 20120626   
  Removed dependency of SBA_config

- v2.1   
  Synchronous Reset, SBA 1.0 compliant

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

