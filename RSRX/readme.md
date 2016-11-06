# **RSRX: Buffered RX IPCore for SBA**
- - - 
![](image.png)   

**Version:** 0.8

**Date:** 2016/11/03

**Author:** Miguel A. Risco-Castillo

**CodeURL:** https://github.com/mriscoc/SBA_Library/blob/master/RSRX/RSRX.vhd

**Description:**
RS232 Serial reception IP Core, Flag RXready to read in bit 15 of Data bus.
The input FIFO buffer is configurable. Read on ADR_I(0)='1' give status of RXready,
on ADR_I(0)='0' pull data from fifo. Rxready flag is clear when fifo is empty.

**Release Notes:**

v0.8 2016/11/03
- Added Snippet for RSRX
- Added INT_O outport, this signal is active when RSRX buffer have data
- Remove dependency of SBAPackage

v0.7 2015/06/14
- Entities rename, remove "adapter"
- Removed dependency of sbaconfig
- Follow SBA v1.1 Guidelines

v0.6 20141210
- Modify of Baud Clock Process
- Move some variables to signals

v0.4
- Merge the two versions of RSRX, with and without fifo buffer

v0.3.1
- Minor error about RxData assign corrected

v0.3
- Add Address to read Status without clear flags and buffer

v0.2
- Fist version cloned from RSRX v0.2, adding buffer


```vhdl
entity RSRX is
generic (
  debug:positive:=1;
  sysfrec:positive:=50E6;
  baud:positive:=57600;
  buffsize:positive:=8
);
port (
  -- SBA Bus Interface
  CLK_I : in std_logic;
  RST_I : in std_logic;
  STB_I : in std_logic;
  WE_I  : in std_logic;
  ADR_I : in std_logic_vector;
  DAT_O : out std_logic_vector;
  INT_O : out std_logic;
  -- UART Interface;
  RX    : in std_logic    -- RX UART input
);
end RSRX;
```vhdl
