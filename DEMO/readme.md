DEMO
====
![](image.png)   

Demo IPCore for use as template
-------------------------------

**Version:** 0.3  
**Date:** 2019/08/11  
**Author:** Miguel A. Risco-Castillo  
**Repository URL:** <https://github.com/mriscoc/SBA_Library/tree/master/DEMO>  

Based upon SBA v1.2 guidelines

Interface of the VHDL module
----------------------------

```vhdl
entity DEMO is
generic(
  debug:positive:=1;
  sysfreq:positive:=25E6
);
port(
-- SBA Bus Interface
   RST_I : in  std_logic;       -- active high reset
   CLK_I : in  std_logic;       -- Main clock
   STB_I : in  std_logic;       -- Strobe/ChipSelect, active high
   WE_I  : in  std_logic;       -- Write enable: active high, Read: active low
   ADR_I : in  std_logic_vector;-- Address bus
   DAT_I : in  std_logic_vector;-- Data in bus
   DAT_O : out std_logic_vector;-- Data Out bus
   INT_O : out std_logic;       -- Interrupt request output
-- Aditional Interface
   P_O   : out std_logic_vector(7 downto 0);
   P_I   : in  std_logic_vector(7 downto 0)
);
end DEMO;
```
Description
-----------
The folder Demo contains template files for construct IPCores for SBA. Use this
file as template for the datasheet.


*Generics:*  
- `sysfreq`: frequency of the main clock in hertz
- `debug`: debug flag, 1:print debug information, 0:hide debug information
  

Release Notes:
--------------
- v0.3 2019/08/11
  Removed release notes and copyright text from vhdl file.  

- v0.2 2016/11/04  
  Added INT_O output and REQUERIMENTS/UserFiles in Ini file  

- v0.1 2015/06/19  
  First release

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
  
==End of datasheet demo==  
  
--------------------------------------------------------------------------------
  
  
Example of ini file
===================

```ini
[MAIN]
;Esta sección establece los valores principales del núcleo, el valor de "Title"
;se usará como una descripción corta del mismo, "Description" permite ampliar la
;descripción del núcleo así como dar algunas breves indicaciones sobre su uso
;el valor "version" es muy importante, permite comparar la versión en la librería
;local con la del repositorio remoto. Usar el último digito de versión exclusivamente
;para forzar la actualización del núcleo, por ejemplo en correcciones de
;documentación, cosmética, ortografía, etc; es decir, que no afectan a la funcionalidad
;del código vhdl. "Date" debe de contener la fecha de la última modificación del
;núcleo y está en correspondencia con la versión. "Author" almacena el nombre
;del autor original del núcleo. "RepositoryURL" es la dirección web del repositorio
;remoto en donde se encuentra el archivo VHDL. "DataSheetURL" debe de apuntar hacia
;la dirección en donde se encuentra la hoja de datos del núcleo en donde se debe
;encontrar toda la documentación para su correcto uso. "Image" le permite al sistema
;encontrar una imágen en bloque de la entidad principal definida en el núcleo.
;"Categories" permitirá en el futuro agrupar los núcleos por categoríás para una mejor
;ubicación y búsqueda. "SBAversion" indica la versión de SBA con la que se asegura
;total compatibilidad. "ConfigApp" establece el nombre de una aplicación de
;configuración si la hubiere, no se debe de colocar la extensión sólo el nombre
;el sistema automáticamente añadirá la extensión ".exe" en la plataforma Windows.
;La aplicación de configuración deberá realizar cambios al archivo ini propio
;del núcleo con la finalidad de otorgar mayor flexibilidad, no debe de
;alterar al archivo fuente (vhdl).
Title=Demo Ini for IP Cores
Description=This file is a demostration of the INI files for IP Cores
Version=0.3.1
Date=2019/08/11
Author=Miguel A. Risco-Castillo
RepositoryURL=https://github.com/mriscoc/SBA_Library/tree/master/DEMO
Testbench=DEMO.tb.vhd
DataSheet=readme.md
Image=image.png
Categories= 
SBAversion=1.2
ConfigApp=

[CONFIG]
;Esta sección establece la configuración del bus SBA. En general los puertos
;de datos deben definirse en el núcleo de forma genérica:
;DAT_I:std_logic_vector; es decir sin el rango, siguiendo la guía de diseño del 
;SBA v1.1, de modo que los valores en bits de los puertos de datos en esta
;sección son por el momento informativos y le permiten al usuario conocer el ancho
;de bus mínimo que necesita el IpCore, por ejemplo, el SBA establece por defecto
;un bus de datos de 16 bits, si el valor de DATILNES para éste IPCore se
;establece a 32, significa que el usuario deberá cambiar en correspondencia
;el valor de "Dat_width" en el archivo *_SBAcfg.vhd a un valor igual o mayor a 32.
;La necesidad de un multiplexor es inferida del valor de DATOLINES>0. Si no se
;especifica explícitamente la anulación (=0) de un puerto, se considera que debe
;de existir y su valor es el por defecto del SBA, es decir, 1 bit para las
;líneas WE, STB, ADR y 16 bits para los datos. Si el núcleo usa la linea de
;interrupción deberá adicionarse la línea: INT=1. Si usa la linea de reconocimiento
;de transacción "acknowledge" de deberá adicionar ACK=1.
;Los núcleos con más de una interfaz SBA como la memoria dual port usan el valor
;de SBAPORTS. Si no existe SBAPORTS se asume que sólo hay un interfaz SBA.
;Si SBAPORTS>1 los buses se numerarán en la interfaz siguiendo la nomenclatura:
;STBn_I, ADRn_I, WEn_I, DATn_I, DATn_O; donde n inicia en 0 hasta SBAPORTS-1
;el bus por defecto que se asociará al diseño será el 0 pero el diseñador puede
;cambiarlo manualmente según necesite, además sólo el puerto 0 será incluído
;automáticamente en la instanciación, los puertos adicionales deberán agregarse
;manualmente o definirse en las secciones [INTERFACE] y/o [EXTERNAL], creando las
;señales adicionales de interconexión en la sección [SIGNALS] de ser necesario.
SBAPORTS=1
STB=1
WE=1
INT=0
ACK=0
ADRLINES=2
DATILINES=16
DATOLINES=16

[ADDRESS]
;Los valores de las direcciones representan un Offset respecto de la dirección
;base. La dirección base es calculada de acuerdo al número de líneas de dirección
;establecidas en ADRLINES (sección CONFIG), el sistema almacena un puntero hacia
;la siguiente posición disponible en el mapa de direcciones, este puntero es
;redondeado hacia adelante según el valor de ADRLINES, así por ejemplo, si el núcleo
;tiene un valor de ADRLINES=2 entonces su dirección base debe de terminar en el
;valor binario "00", reservando así 2^2=4 direcciones (00,01,10,11) en el mapa
;de direcciones, si la próxima dirección disponible es el valor 6 ("0110")
;el indice se redonderá a 8 ("1000") para asegurar que la dirección base cumpla
;con el requerimiento de ADRLINES. Por ejemplo, si un núcleo inicia con la dirección
;base "1000" y tiene direcciones establecidas en esta sección con valores DEMO0 = 0 y
;DEMO1 = 1, las direcciones finales reales en el mapa serán DEMO0=1000 y DEMO1=1001.
;Pueden asignarse rangos, por ejemplo "RAM=start,end" asigna (end-start+1) posiciones. 
;Aunque el sistema normalmente asigna automáticamente las direcciones de forma
;correcta, es importante revisar los valores establecidos en el *_SBAcfg.vhd con la
;finalidad de ganar eficiencia.
DEMO0=0
DEMO1=1
RAM=128,255

[GENERIC]
;En esta sección deben colocarse los valores que necesita para sus genéricos
;si el núcleo necesita tomar el valor de reloj del sistema puede asignar
;el valor de la constante sysfrec a un genérico
debug=debug
sysfreq=sysfreq
size=8

[INTERFACE]
;Aquí se pueden añadir puertos adicionales al interfaz SBA que el núcleo pueda
;requerir, además se puede sugerir una conexión como ejemplo.
P_I=x"FFFF"
P_O=LEDS

[EXTERNAL]
;Esta sección se usa cuando el núcleo ip ha sido diseñado para manejar
;dispositivos externos como Displays, ADC, DAC, RS232, I2C, etc. Permite definir
;puertos externos en la entidad principal y sugerir una asignación predeterminada.
;no es necesario establecer el tipo ya que se asume std_logic(_vector), pero si
;la dirección. Si no se especifíca rango se asume que su ancho es 1.
BUTTON=in
LEDS=out(15:0)

[SIGNALS]
;Si el núcleo requiere la creación de señales adicionales de interconexión se pueden
;definir aquí
LEDSe = std_logic_vector(15 downto 0)

[REQUIREMENTS]
;incluír aquí los archivos vhdl (archivos, paquetes y/o núcleos) adicionales que
;se deban copiar junto con el núcleo principal, usar una lista separada por comas.
;La búsqueda de los archivos se realiza primero en la carpeta del núcleo, si
;no se encuentra se busca en la librería y se incluye en el proyecto.
;Dejar vacío si no es necesario.
;Los archivos son copiados a la carpeta lib del proyecto a excepción de los
;archivos listados en UserFiles, estos son copiados a la carpeta user para que
;puedan ser modificados y personalizados por el diseñador, los userfiles no son
;eliminados automáticamente cuando se remueve un núcleo del proyecto, ni son
;sobreescritos. Se asume que los archivos tienen la extensión ".vhd"
IPCores=CORE1,CORE2
Packages=PACK
UserFiles=UFILE
```
