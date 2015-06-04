
-- /SBA: Program Details -------------------------------------------------------
--
-- Program: I2C Simple Demo
-- Version: 1.0
-- Date: 20150603
-- Author: Juan S. Vega Martinez
-- Description: Snippet for I2C demo SBA Project
--
-- /SBA: End -------------------------------------------------------------------

-- /SBA: User Registers and Constants ------------------------------------------
   constant TXSTA   : integer:=15;
   constant RXSTA   : integer:=14;
   constant I2C_ReadMEMORY   : unsigned(7 downto 0):=x"08";
   variable I2C_DEVICE_ADR   : unsigned(7 downto 0);
   variable I2C_DAT          : unsigned(7 downto 0);
   variable I2C_ADR_REG      : unsigned(7 downto 0);
   variable I2C_NumberBytesRead: unsigned(7 downto 0);
   variable I2C_ADR_MEMORY   : unsigned(7 downto 0);
   variable I2CFlg           : std_logic;
   variable reg1 : unsigned(15 downto 0);       -- General porpoise register
   variable reg2 : unsigned(15 downto 0);       -- General porpoise register
   variable reg3 : unsigned(15 downto 0);       -- General porpoise register
   variable reg4 : unsigned(15 downto 0);       -- General porpoise register
   variable reg5 : unsigned(15 downto 0);       -- General porpoise register
   variable reg6 : unsigned(15 downto 0);       -- General porpoise register
   variable reg7 : unsigned(2 downto 0);        -- General porpoise register
   variable Dlytmp  : unsigned(15 downto 0);      -- Delay 16 bit register

-- /SBA: End -------------------------------------------------------------------

-- /SBA: User Program ----------------------------------------------------------
-- /L:Delay
=> if Dlytmp/=0 then
     dec(Dlytmp);
     SBAjump(Delay);
   else
     SBARet;
   end if;

=> SBAjump(Init);
-------------------------------- RUTINES ---------------------------------------
-- /L:I2Cwait
-- Read Status I2C Module
=> SBARead(I2C);
=> I2CFlg := dati(TXSTA) or dati(RXSTA);
=> if I2CFlg ='1' then
     SBARead(I2C);
     SBAjump(I2Cwait+1);
   else SBARet;
   end if;

---------------------- Init I2CWriteByte Routine  ----------------------------
-- /L:I2CWritebyte
=> SBARead(I2C);                                 -- Read Status I2C Module
=> I2CFlg := dati(TXSTA) or dati(RXSTA);
=> if I2CFlg ='1' then
     SBARead(I2C);
     SBAjump(I2CWritebyte+1);
   end if;
=> SBAWrite(I2C_REG3,x"00" & I2C_DAT);           -- x"00"& I2C_DAT --> x"00"   = position within the RAM
                				                 --                --> I2C_DAT = Data to write
=> SBAWrite(I2C_REG2,x"0000");                   -- Write One Byte
=> SBAWrite(I2C_REG1,x"00" & I2C_ADR_REG);       -- I2C_ADR_REG --> Initial register address
=> SBAWrite(I2C_REG0,I2C_DEVICE_ADR & x"01" );   -- I2C_DEVICE_ADR & x"01"  --> I2C_DEVICE_ADR = Address Device
                                                 --                         --> x"01" = B'0001' = '0' & '0' & Write & Start
=> SBAwait;
=> SBARet;                                       -- Return
---------------------- End I2CWriteByte Routine -------------------------------


---------------------- Init I2CReadByte Routine -------------------------------
-- /L:I2CReadbyte
=> SBARead(I2C);                                -- Read Status I2C Module
=> I2CFlg := dati(TXSTA) or dati(RXSTA);
=> if I2CFlg ='1' then
     SBARead(I2C);
     SBAjump(I2CReadbyte+1);
   end if;
=> SBAWrite(I2C_REG2,x"0000");                   -- Read One byte
=> SBAWrite(I2C_REG1,x"00" & I2C_ADR_REG);       -- I2C_ADR_REG(Initial  address register)
=> SBAWrite(I2C_REG0, I2C_DEVICE_ADR & x"03" );  -- x"1D01"  --> 1D = Device Address
                                                 --          --> x"01" = B'0011' = '0' & '0' & Write & Start
=> SBAwait;
=> SBARead(I2C);                                 -- Read Status I2C Module
=> I2CFlg := dati(TXSTA) or dati(RXSTA);
=> if I2CFlg ='1' then
     SBARead(I2C);
     SBAjump(I2CReadbyte+8);
   end if;
=> SBAWrite(I2C_REG0,x"00" & I2C_ReadMEMORY);    -- I2C_ReadMEMORY = x"08" Enable read memory RAM
=> SBAwait;
=> SBARead(I2C);
=> SBAwait; I2C_DAT:= dati(7 downto 0);          -- Save
=> SBARet;                                       -- Return
---------------------- End I2CReadByte Routine --------------------------------

---------------------- Init I2CwriteBytes Routine ------------------------------
-- /L:I2CWritebytes
=> if (I2C_ADR_MEMORY>0) then dec(I2C_ADR_MEMORY);
   else SBARet;
   end if;
=> SBAWrite(I2C_REG2,x"00" & I2C_ADR_MEMORY);     -- Write the number of bytes - 1
=> SBAWrite(I2C_REG1,x"00" & I2C_ADR_REG);        -- I2C_ADR_REG(Initial  address register)
=> SBAWrite(I2C_REG0,I2C_DEVICE_ADR & x"01" );    -- I2C_DEVICE_ADR & x"01"  --> I2C_DEVICE_ADR = Address Device
                                                  --                         --> x"01" = B'0001' = '0' & '0' & Write & Start
=> SBAwait;
=> clr(I2C_ADR_MEMORY);
   SBARet;                                        -- Return
---------------------- Init I2CwriteBytes Routine ------------------------------

---------------------- Init I2CreadBytes Routine ------------------------------
-- /L:I2CReadbytes
=> if (I2C_NumberBytesRead>0) then dec(I2C_NumberBytesRead);
   else SBARet;
   end if;
=> SBAWrite(I2C_REG2,x"00" & I2C_NumberBytesRead); -- Read the number of bytes - 1
=> SBAWrite(I2C_REG1,x"00" & I2C_ADR_REG);         -- I2C_ADR_REG(Initial  address register)
=> SBAWrite(I2C_REG0, I2C_DEVICE_ADR & x"03" );    -- x"1D01"  --> 1D = Device Address
                                                   --          --> x"01" = B'0011' = '0' & '0' & Write & Start
=> SBAwait;
=> SBARead(I2C);                                   -- Read Status I2C Module
=> I2CFlg := dati(TXSTA) or dati(RXSTA);
=> if I2CFlg ='1' then
     SBARead(I2C);
     SBAjump(I2CReadbytes+6);
   end if;
=> SBAWrite(I2C_REG0,x"00" & I2C_ReadMEMORY);      -- I2C_ReadMEMORY = x"08", Enable read memory RAM
=> clr(I2C_NumberBytesRead);
   SBAwait;
   SBARet;
---------------------- Init I2CReadbytes Routine ------------------------------

-- /L:I2CLoadbyteToMEMORY
=> SBAWrite(I2C_REG3,I2C_ADR_MEMORY & I2C_DAT);
=> inc(I2C_ADR_MEMORY); SBARet;

------------------------------ MAIN PROGRAM ------------------------------------

-- /L:Init
-- Turn On ADXL345, I2C Write Byte Sequence
=> I2C_DEVICE_ADR :=x"53";
   I2C_ADR_REG:=x"2D";
   I2C_DAT:=x"08";
   SBAcall(I2CWritebyte);

-- Read Device ID ADXL345, I2C Read Byte Sequence
=> I2C_DEVICE_ADR :=x"53";
   I2C_ADR_REG:=x"00";
   SBAcall(I2CReadbyte);
=> SBAWrite(GPIO, x"00" & I2C_DAT);

-- /L:SuperDelay
-- Delay 1 second
=> reg1:=x"03E8";   -- 1000 * 50000 = 50E6 cycles = 1 seg
=> Dlytmp:=x"C350"; -- 50,000 cycles
   SBACall(Delay);
=> if reg1/=0 then
    dec(reg1);
    SBAjump(SuperDelay+1);
   end if;

-- Multiple Write I2C
-- Data to write up to 256
=> SBAcall(I2Cwait);             --I want to know if the module is avaliable
=> I2C_ADR_MEMORY:=x"00";
   I2C_DAT:=x"00";
   SBAcall(I2CLoadbyteToMEMORY); --Load data within internal memory
=> I2C_DAT:=x"00";
   SBAcall(I2CLoadbyteToMEMORY); --Load data within internal memory
=> I2C_DAT:=x"00";
   SBAcall(I2CLoadbyteToMEMORY); --Load data within internal memory
=> I2C_DEVICE_ADR :=x"53";
   I2C_ADR_REG:=x"1E";
   SBAcall(I2CWritebytes);       -- Call routine I2CWriteBytes

-- Multiple Read I2C
=> SBAcall(I2Cwait);             --I want to know if the module is avaliable
=> I2C_DEVICE_ADR :=x"53";
   I2C_ADR_REG:=x"32";
-- /L:ReadBucle
=> I2C_NumberBytesRead:=x"06";   -- Numbers bytes To Read
   SBACall(I2CReadbytes);        -- Call I2C Routine
=> SBARead(I2C);
=> SBAwait;  reg1:= x"00" & dati(7 downto 0);  -- first data    X (LSB)
=> SBAwait;  reg2:= x"00" & dati(7 downto 0);  -- second data   X (MSB)
=> SBAwait;  reg3:= x"00" & dati(7 downto 0);  -- third data    Y (LSB)
=> SBAwait;  reg4:= x"00" & dati(7 downto 0);  -- Fourth data   Y (MSB)
=> SBAwait;  reg5:= x"00" & dati(7 downto 0);  -- fifth data    Z (LSB)
=> SBAwait;  reg6:= x"00" & dati(7 downto 0);  -- sixth data    Z (MSB)
=> SBARead(GPIO2);
=> reg7:= dati(2 downto 0);
=> case reg7 is
	 when "000" => SBAWrite(GPIO,reg1);
     when "001" => SBAWrite(GPIO,reg2);
 	 when "010" => SBAWrite(GPIO,reg3);
	 when "011" => SBAWrite(GPIO,reg4);
	 when "100" => SBAWrite(GPIO,reg5);
	 when "101" => SBAWrite(GPIO,reg6);
	 when others => SBAWrite(GPIO,x"0055");
   end case;

=> SBAjump(ReadBucle);

-- /SBA: End -------------------------------------------------------------------
