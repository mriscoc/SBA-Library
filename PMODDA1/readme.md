# **Demo for IP Cores**
- - - 
![](image.png)   

*SBA Slave IP Core adapter for Digilent Pmod DA1 module*

The PMod DA1 module have two AD7303, this chip is a dual 8-bit voltage out DAC SPI interface. 
Write 16 bits word: MSB:LSB = DAC2:DAC1, 
Read 16 bits word: LSbit (bit0) is '0' after write into register and '1' at the end of conversion.

Version: 0.3.2  
Date: 2015/09/06  
Author: Miguel A. Risco-Castillo  
CodeURL: https://github.com/mriscoc/SBA_Library/blob/master/PMODDA1/PMODDA1.vhd  

```vhdl
entity PMODDA1 is
generic(
  debug:positive:=1;
  sysfrec:positive:=50E6
);
port(
-- SBA Interface
   RST_I : in  std_logic;        -- active high reset
   CLK_I : in  std_logic;        -- Main System clock
   STB_I : in  std_logic;        -- Strobe/Chip Select, active high
   WE_I  : in  std_logic;        -- Bus Write enable: active high, Read: active low
   DAT_I : in  std_logic_vector; -- Data input Bus
   DAT_O : out std_logic_vector; -- Data output Bus
--Pmod interface signals
   nSYNC : out std_logic;
   D0    : out std_logic;
   D1    : out std_logic;
   SCLK  : out std_logic
   );
end PMODDA1;
vhdl
