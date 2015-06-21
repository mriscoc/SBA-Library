# **Seven segments four digits display iP core  for RVI board**
- - - 
![](image.png)   

Description: Seven segments four digits LED display. It requires Data Bus of 16 bits and a low speed <1KHz clock (DCLK) for digit multiplexing. Use two positions on address map: ADR_I=0 Write Segments Data, ADR_I=1 Write Decimal Point mask Data.  
Version: 4.2  
Date: 2015/06/19  
Author: Miguel A. Risco-Castillo
CodeURL: https://github.com/mriscoc/SBA_Library/blob/master/D7SRVI/D7SRVI.vhd  


```vhdl
entity D7SRVI is
port (
-- Interface for inside FPGA
   RST_I : in std_logic;        -- active high reset
   CLK_I : in std_logic;        -- Main clock
   STB_I : in std_logic;        -- ChipSel, active high
   WE_I  : in std_logic;        -- write, active high
   ADR_I : in std_logic;        -- Register Select, Data and decimal point.
   DAT_I : in std_logic_vector; -- Data input Bus
-- Interface for RVI 4 digits 7 seg Display
   DCLK    : in  std_logic;     -- Clock for Digit Multiplexing
   SEG     : out std_logic_vector(8 downto 0)
);
end D7SRVI;
```
