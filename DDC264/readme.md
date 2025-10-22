# **DDC264 IP Core for SBA**
- - - 
![](image.png)   

**Version**: 1.1  
**Date**: 2025/10/21  
**Author**: Miguel A. Risco-Castillo  

**sba webpage**: http://sba.accesus.com  
**core webpage**: https://github.com/mriscoc/SBA-Library/tree/master/DDC264  

**Description**: Preliminary version of SBA Slave IP Core adapter for the DDC264.
The minimum data bus width is 16 bits.
The Register Select uses the four least significant bits of the address bus.  

* Escritura:
0000 : Control register  
  bit(0) <- start to shift configuration word to DDC_DIN_CFG  
  bit(1) <- set/reset DDC_CONV  
0001 : Configuration Word  
   
* Lectura:
0000 : Status register (Estado de la FSM)  
0001 : Read back configuration word          


```vhdl
entity DDC264 is
  generic (
    debug       : positive :=1;
    infreq      : positive := 50E6         -- Frecuencia principal del CLK_I (50 MHz)
  );
  port (
    -- PUERTOS DE LA INTERFAZ SBA (ESCLAVO)
    RST_I       : in  std_logic;           -- Reset asíncrono del sistema FPGA
    CLK_I       : in  std_logic;           -- Reloj principal del sistema FPGA (50 MHz)
    STB_I       : in  std_logic;           -- Chip Select (Habilitación del esclavo)
    WE_I        : in  std_logic;           -- Write Enable (Activo alto)
    ADR_I       : in  std_logic_vector;    -- Dirección de entrada (del Maestro)
    DAT_I       : in  std_logic_vector;    -- Datos de entrada (del Maestro)
    DAT_O       : out std_logic_vector;    -- Datos de salida (hacia el Maestro)

    -- SEÑALES DE CONTROL DDC264
    DDC_CLK     : out std_logic;           -- Reloj Maestro/Sistema
    DDC_CONV    : out std_logic;           -- CONV DDC264 (Control de integración)
    DDC_DIN_CFG : out std_logic;           -- Data de configuración serial
    DDC_CLK_CFG : out std_logic;           -- Clock de configuración (Máx 20 MHz)
    DDC_RESET   : out std_logic            -- RESET DDC264 (Activo bajo)
  );
end DDC264;
```
