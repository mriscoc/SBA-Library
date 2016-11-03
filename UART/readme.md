# **UART: TX and Buffered RX IPCore for SBA**
- - - 
![](image.png)   

Version: 3.5
Date: 2016/11/03
Author: Miguel A. Risco-Castillo
CodeURL: https://github.com/mriscoc/SBA_Library/blob/master/UART/UART.vhd

**Description:**
RS232 Universal Asynchronous Receiver/Transmitter IPCore for SBA.
Flag RXready in bit 15 of Data bus. The RX input FIFO buffer is configurable.
Read on ADR_I(0)='1' give status of RXready, on ADR_I(0)='0' pull data from RX fifo.
Rxready flag is clear when fifo is empty. Flag TXready in bit 14 of Data bus.

**Release Notes**
v3.5 2016/11/03
Bug corrections in snippet

v3.4 2015/06/06
Entities name change, remove "adapter"
Follow SBA v1.1 Guidelines

v3.3 2012/07/04
Remove dependency of SBAconfig
Make address and data generic buses

v3.2 2012/06/19
Only use one RX Merged (v0.4 and up) core

v3.1 2011/06/09
Add ADR_I signal to read Status without clear flags and
buffer, RXBuf_Adapter (v0.3) requirements


```vhdl
entity UART is
generic (
  debug:positive:=1;
  sysfrec:positive:=50E6;
  baud:positive:=115200;
  rxbuff:positive:=8
);
port (
      -- SBA Bus Interface
      CLK_I : in std_logic;
      RST_I : in std_logic;
      STB_I : in std_logic;
      WE_I  : in std_logic;
      ADR_I : in std_logic_vector;      -- Control/Status and Data reg select
      DAT_I : in std_logic_vector;
      DAT_O : out std_logic_vector;
      INT_O : out std_logic;            -- Interrupt request
      -- UART Interface;
      TX     :out std_logic;
      RX     : in std_logic
   );
end UART;
```
