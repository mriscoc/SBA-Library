-----------------------------------------------------------
-- File: I2CBC.vhd
-- I2C Bus Controller
--
-- Version 0.2
-- Date: 20150521
-- 16 bits Data Interface
--
-- (c)Juan Vega
-- e-mail: juan.vega25@gmail.com
--
-- v0.2
-- Optimized Core I2C-SBA
--
-- v0.1
-- This version is released under the GNU/GLP license
-- if you use this component for your research please
-- include the appropriate credit of Author.
-- For commercial purposes request the appropriate
-- license from the author. 
-----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity I2CBC is
generic (I2C_ADDRESS   : natural:=7); 
port (
      -- SBA Bus Interface
      CLK_I  : in std_logic;
      RST_I  : in std_logic;
      WE_I  : in std_logic;
      STB_I : in std_logic;
      ACK_O : out std_logic;         
      ADR_I : in std_logic_vector;
      DAT_I : in std_logic_vector(15 downto 0);
      DAT_O : out std_logic_vector;
      -- signals Controller core I2C
      I2C_WR          :   out std_logic;  -- 0 write   1 read
      I2C_ADR_O       :   out std_logic_vector(I2C_ADDRESS-1 downto 0);
      I2C_REG_O       :   out std_logic_vector(15 downto 0);
      I2C_DATA_O      :   out std_logic_vector(15 downto 0);
      I2C_DATA_I      :   in std_logic_vector(7 downto 0);   
      I2C_START_O     :   out std_logic;
      I2C_DATASENT    :   in std_logic;
      I2C_DATARCV     :   in std_logic
      );
end I2CBC ;

Architecture arch_I2C_BusController of I2CBC is

type MainState is ( Minit,StAddr, StWrite,StRead,StRead_w,StReadReg);
signal i2c_st : MainState;

-- Memory Ram 
constant iMax : integer := (2**8)-1;
type TRam is array (0 to iMax) of std_logic_vector(7 downto 0);
signal RAM : TRam;
signal ADRi,adri_ram: integer range 0 to iMax;

-- Register control and data of the CORE I2C
type  SysReg is array (0 to 3) of std_logic_vector(15 downto 0);
signal I2C_REG : SysReg;

Alias Status_Control : 	std_logic_vector(3 downto 0)	is	I2C_REG(0)(3 downto 0);
Alias Dev_Addr       : 	std_logic_vector(6 downto 0)	is	I2C_REG(0)(14 downto 8);
Alias Reg_addr       :  std_logic_vector(15 downto 0) is I2C_REG(1);
Alias nDataReg       : 	std_logic_vector(15 downto 0)	is	I2C_REG(2);  --  #bytes ADDRESS + #bytes data
Alias Data_io        : 	std_logic_vector(15 downto 0)	is	I2C_REG(3);

Alias Start   : std_logic is Status_Control(0);
Alias WrRd    : std_logic is Status_control(1); -- '0'= Write  '1' = read
Alias Addr16  : std_logic is Status_Control(2); -- '0'= 8 bits address  '1' = 16 bits;
Alias ReadReg : std_logic is Status_Control(3); -- '0' = no read Reg  '1'= leer Reg
signal TxSta  : std_logic ; -- '0'= Transmitting  . '1' = Tx finished  
signal RxSta  : std_logic ; -- '0'= Transmitting  . '1' = Rx finished
---
signal DATi,DATi_ram : std_logic_vector(15 downto 0);
signal DATo1,DATo : std_logic_vector (7 downto 0);
signal DataRcv   : std_logic;
signal Starti    : std_logic;
signal WrRdi     : std_logic;
signal I2C_DATAi : std_logic_vector(7 downto 0);
signal FAddr     : std_logic;
signal iReg,CountReg: integer range 0 to 256;

begin

ADRi <= to_integer(unsigned(ADR_I(1 downto 0))); 
DATi <= DAT_I(15 downto 0);

Ctrl_SysReg:process(CLK_I,RST_I)
begin
  if (RST_I='1') then
    I2C_REG <= ((others=> (others=>'0'))); 
    i2c_st <= Minit; 
    DataRcv <='0';
    WrRdi<='0';
    Starti<='0';
    TxSta<='0';
    RxSta<='0';
  elsif(rising_edge(CLK_I)) then
    
	 if (STB_I='1') and (WE_I = '1') then I2C_REG(ADRi)<=DATi;
    end if; 
	 
    DataRcv<='0';       
    
	 case (i2c_st) is

      when Minit 	=> iReg<=0;
		               CountReg   <=  to_integer(unsigned (nDataReg (7 downto 0)));  
                     if (ReadReg='1') then i2c_st<=StReadReg;
                     elsif (Start='1') then 
                       Starti<='1';
                       Start<='0'; 
                       i2c_st<=StAddr;
                       WrRdi<=WrRd;
                       TxSta<=not WrRd;
                       RxSta<=WrRd;
						   else Starti<='0';i2c_st<=Minit;
                     end if;
                    
						   FAddr<='0';

       when StAddr => if (FAddr='1' and WrRd='0') then i2c_st<=StWrite;
                      elsif (WrRd='1') then i2c_st<=StRead;FAddr<='0';
                      else FAddr<='1';
                      end if;                           
                             
                                
       when StWrite => FAddr<='0';
                       if I2C_DATASENT='1' then 
                         if (iReg = CountReg)then i2c_st<= Minit;Starti<='0';RxSta<='0';TxSta<='0';
                         else iReg <= iReg+1; i2c_st<= StWrite;Starti<='1';
                         end if;
                       end if; 
                            
                                                   
       when StRead => DataRcv<='1';FAddr<='0';
                      if I2C_DATARCV='1' then 
                        if (iReg= CountReg)then i2c_st<= Minit;Starti<='0';RxSta<='0';TxSta<='0';
                        else  i2c_st<= StRead_w;Starti<='1';
                        end if;
                      else i2c_st<= StRead;
                      end if;

       when StRead_w => DataRcv<='0';iReg<=iReg+1;i2c_st<= StRead;

       when StReadReg => FAddr<='0';
                         if (iReg= CountReg)then i2c_st<= Minit;ReadReg<='0';
                         else iReg<=iReg+1; i2c_st<= StReadReg;
                         end if;
     end case;
  end if;
end process;	
 
 I2C_ADR_O  <=Dev_Addr;      -- Address Dispositive
 I2C_WR     <= WrRdi;           -- Write or Read
 I2C_DATA_O <= std_logic_vector(resize(unsigned(RAM(iReg)),I2C_DATA_O'length)) when (i2c_st = StWrite) else (others=>'0'); -- salida de datos para el I2C
 I2C_DATAi  <= I2C_DATA_I;  -- Data in I2C
 I2C_START_O <= Starti;     -- Start process writing or reading
 I2C_REG_O   <= Reg_addr;     -- Address Register


-- Input Process Data I2C
I2CData:process(CLK_I)
begin
  if(rising_edge(CLK_I)) then
    if ( (STB_I='1') and (WE_I = '1') and Starti='0' and (ADRi=3)) or (DataRcv='1') then
		RAM(ADRi_ram) <= DATi_ram(7 downto 0);
    end if;
  end if;
end process;

DATi_ram<= DAT_I(15 downto 0) when (WE_I = '1' and DataRcv='0') else  x"00" & I2C_DATAi ;
ADRi_ram <= to_integer(unsigned(DAT_I(15 downto 8))) when (WE_I = '1' and DataRcv='0' and ReadReg='0')  else iReg;
	

-- Output lectura de los registros
process(RST_I,CLK_I)
  begin
    if (RST_I = '1')then DATo<=(others=> '0');
    elsif(rising_edge(CLK_I)) then
      if (WE_I='0' and STB_I='1') then DATo<= DATo1;
      else DATo<=DATo;  
	   end if;    
    end if;
end process;

DATo1 <= RAM(iReg);
DAT_O(15)<= TxSta;
DAT_O(14)<= RxSta;
DAT_O(7 downto 0)<=DATo1;

end arch_I2C_BusController;
