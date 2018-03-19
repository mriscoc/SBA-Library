ADCRVILP
========
![](image.png)   

**Title:** ADCRVILP Analog to Digital converter Adapter for RVI board.  

**Description:**  
Dual Channel, 16bits Data interface, 10bits resolution right aligned ADC.
SBA Slave adapter for ADC: AD9201, this ADC is included in the low performance
daughter board of the RVI board.

**Version:** 7.2

**Date:** 2017/04/21

**Author:** Miguel A. Risco-Castillo

**CodeURL:** <https://github.com/mriscoc/SBA_Library/blob/master/ADCRVILP/ADCRVILP.vhd>

Based on SBA v1.1 guidelines

Release Notes:
--------------

- v7.2 2017/04/21  
  Change sysfrec to sysfreq

- v7.1.2 2015/09/08  
  adapt to SBA v1.1 guidelines: ADR_I is vector

- v7.1 2015/06/14  
  Name change, adapt to SBA v1.1 guidelines

- v7.0 2011/04/13  
  ADC output is latched following datasheet typical demux Ref:Fig.30

- v6.1  
  Use config values from SBA_config and SBA_package

- v6.0  
  SBA v1.0 compliant  
  Remove I,Q Channels DEMUX  
  Automatic calculus of internal clock frequency

- v5.0  
  remove the z state for output bus for make this compatible
  with block gen in Actel designer

- v4.6  
  Remove ACK_O

Interface of the VHDL module
----------------------------

```vhdl
entity ADCRVILP is
generic(
  debug:positive:=1;
  sysfreq:positive:=25E6
);
port(
-- Interface for inside FPGA
   RST_I : in  std_logic;       -- active high reset
   CLK_I : in  std_logic;       -- Main clock
   STB_I : in  std_logic;       -- ADC ChipSelect, active high
   ADR_I : in  std_logic_vector;-- Select internal Register Channel I or Q
   WE_I  : in  std_logic;       -- ADC read at low
   DAT_O : out std_logic_vector;-- ADC Data Bus
-- Interface for AD9201
   CLOCK : out std_logic;       -- ADC Sample Rate Clock
   SLECT : out std_logic;       -- Hi I Channel Out, Lo Q Channel Out
   DAT   : in  std_logic_vector(9 downto 0); -- Data Bus ADC
   SLEEP : out std_logic;       -- Hi Power Down, Low Normal Operation
   CHPSEL: out std_logic        -- Chip Select
);
end ADCRVILP;
```

*Generics:*
- sysfreq: frequency of the main clock in hertz
- debug: debug flag, 1:print debug information, 0:hide debug information
