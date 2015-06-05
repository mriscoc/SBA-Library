-- /SBA: Program Details -------------------------------------------------------
--
-- Program: I2C Demo
-- Version: 1.0
-- Date: 20150604
-- Author: Juan S. Vega Martinez
-- Description: Snippet for I2C demo SBA Project
--
-- /SBA: End -------------------------------------------------------------------

-- /SBA: User Registers and Constants ------------------------------------------
   constant I2C_TXSTA   : integer:=15;				        --Tx Ready
   constant I2C_RXSTA   : integer:=14;				        --Rx Ready
   constant I2C_ReadMEMORY   : unsigned(7 downto 0):=x"08"; --Enable Read Data from internal memory
   variable I2C_DEVICE_ADR   : unsigned(7 downto 0);     	--I2C Address Device
   variable I2C_DAT          : unsigned(7 downto 0);     	--Data to Write or Read
   variable I2C_ADR_REG      : unsigned(7 downto 0);     	--Initial address register to Write or Read 
   variable I2C_NumberBytesRead: unsigned(7 downto 0);		--Number of bytes to Write or Read
   variable I2C_ADR_MEMORY   : unsigned(7 downto 0);        --Address Memory to Multiple Write 
   variable I2CFlg           : std_logic;	                --Flag status
   variable reg1 : unsigned(15 downto 0);       -- General purpose register
   variable reg2 : unsigned(15 downto 0);       -- General purpose register
   variable reg3 : unsigned(15 downto 0);       -- General purpose register
   variable reg4 : unsigned(15 downto 0);       -- General purpose register
   variable reg5 : unsigned(15 downto 0);       -- General purpose register
   variable reg6 : unsigned(15 downto 0);       -- General purpose register
   variable reg7 : unsigned(2 downto 0);        -- General purpose register
   variable Dlytmp  : unsigned(15 downto 0);    -- Delay 16 bit register

-- /SBA: End -------------------------------------------------------------------

-- /SBA: User Program ----------------------------------------------------------

=> SBAjump(Init);

-------------------------------- RUTINES ---------------------------------------
-- /L:Delay
=> if Dlytmp/=0 then
     dec(Dlytmp);
     SBAjump(Delay);
   else
     SBARet;
   end if;

-- /L:I2Cwait
-- Read Status I2C Module
=> SBARead(I2C);
=> I2CFlg := dati(I2C_TXSTA) or dati(I2C_RXSTA);
=> if I2CFlg ='1' then
     SBARead(I2C);
     SBAjump(I2Cwait+1);
   else SBARet;
   end if;

---------------------- Init I2CWriteByte Routine  ----------------------------
-- /L:I2CWritebyte
=> SBARead(I2C);                                 -- Read Status I2C Module
=> I2CFlg := dati(I2C_TXSTA) or dati(I2C_RXSTA);
=> if I2CFlg ='1' then
     SBARead(I2C);
     SBAjump(I2CWritebyte+1);
   end if;
=> SBAWrite(I2C_REG3,x"00" & I2C_DAT);           -- x"00"& I2C_DAT --> x"00"   = position within the RAM
                				                  --               --> I2C_DAT = Data to write
=> SBAWrite(I2C_REG2,x"0000");                   -- Write One Byte
=> SBAWrite(I2C_REG1,x"00" & I2C_ADR_REG);       -- I2C_ADR_REG --> Initial register address
=> SBAWrite(I2C_REG0,I2C_DEVICE_ADR & x"01" );   -- I2C_DEVICE_ADR & 000000011
                                                 --                  000000011 = "000000" & Write & Start
=> SBAwait;
=> SBARet;                                       -- Return
---------------------- End I2CWriteByte Routine -------------------------------


---------------------- Init I2CReadByte Routine -------------------------------
-- /L:I2CReadbyte
=> SBARead(I2C);                                -- Read Status I2C Module
=> I2CFlg := dati(I2C_TXSTA) or dati(I2C_RXSTA);
=> if I2CFlg ='1' then
     SBARead(I2C);
     SBAjump(I2CReadbyte+1);
   end if;
=> SBAWrite(I2C_REG2,x"0000");                   -- Read One byte
=> SBAWrite(I2C_REG1,x"00" & I2C_ADR_REG);       -- I2C_ADR_REG(Initial  address register)
=> SBAWrite(I2C_REG0, I2C_DEVICE_ADR & x"03" );  -- I2C_DEVICE_ADR & 000000011
                                                 --                  000000011 = "000000" & Write & Start
=> SBAwait;
=> SBARead(I2C);                                 -- Read Status I2C Module
=> I2CFlg := dati(I2C_TXSTA) or dati(I2C_RXSTA);
=> if I2CFlg ='1' then
     SBARead(I2C);
     SBAjump(I2CReadbyte+8);
   end if;
=> SBAWrite(I2C_REG0,x"00" & I2C_ReadMEMORY);    -- Enable read memory RAM
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
=> SBAWrite(I2C_REG2,x"00" & I2C_ADR_MEMORY);     -- Write the number of bytes
=> SBAWrite(I2C_REG1,x"00" & I2C_ADR_REG);        -- Initial  address register to Write
=> SBAWrite(I2C_REG0,I2C_DEVICE_ADR & x"01" );    -- I2C_DEVICE_ADR & 000000001
                                                  --                  000000001 = "000000" & Write & Start
=> SBAwait;
=> clr(I2C_ADR_MEMORY);
   SBARet;                                        -- Return
---------------------- Init I2CwriteBytes Routine ------------------------------

---------------------- Init I2CreadBytes Routine ------------------------------
-- /L:I2CReadbytes
=> if (I2C_NumberBytesRead>0) then dec(I2C_NumberBytesRead);
   else SBARet;
   end if;
=> SBAWrite(I2C_REG2,x"00" & I2C_NumberBytesRead); -- Read the number of bytes
=> SBAWrite(I2C_REG1,x"00" & I2C_ADR_REG);         -- Initial  address register
=> SBAWrite(I2C_REG0, I2C_DEVICE_ADR & x"03" );    -- I2C_DEVICE_ADR & 000000011
                                                   --                  000000011 = "000000" & Write & Start
=> SBAwait;
=> SBARead(I2C);                                   -- Read Status I2C Module
=> I2CFlg := dati(I2C_TXSTA) or dati(I2C_RXSTA);
=> if I2CFlg ='1' then
     SBARead(I2C);
     SBAjump(I2CReadbytes+6);
   end if;
=> SBAWrite(I2C_REG0,x"00" & I2C_ReadMEMORY);      -- Enable read memory RAM
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
=> I2C_DEVICE_ADR:=x"53";
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
=> SBAcall(I2Cwait);             -- Is the I2C module avaliable?
=> I2C_ADR_MEMORY:=x"00";        -- Reset address internal memory.
   I2C_DAT:=x"00";
   SBAcall(I2CLoadbyteToMEMORY); -- Load data within internal memory
=> I2C_DAT:=x"02";
   SBAcall(I2CLoadbyteToMEMORY); -- Load data within internal memory
=> I2C_DAT:=x"25";
   SBAcall(I2CLoadbyteToMEMORY); -- Load data within internal memory
=> I2C_DEVICE_ADR :=x"53";
   I2C_ADR_REG:=x"1E";
   SBAcall(I2CWritebytes);       -- Call routine I2CWriteBytes

-- Multiple Read I2C of ADXL345
=> SBAcall(I2Cwait);             -- Is the I2C module avaliable?
=> I2C_DEVICE_ADR :=x"53";
   I2C_ADR_REG:=x"32";
-- /L:ReadBucle
=> I2C_NumberBytesRead:=x"06";   -- Numbers bytes to Read
   SBACall(I2CReadbytes);        -- Call I2CReadBytes Routine
=> SBARead(I2C);
=> SBAwait;  reg1:= x"00" & dati(7 downto 0);  -- first data    X (LSB)
=> SBAwait;  reg2:= x"00" & dati(7 downto 0);  -- second data   X (MSB)
=> SBAwait;  reg3:= x"00" & dati(7 downto 0);  -- third data    Y (LSB)
=> SBAwait;  reg4:= x"00" & dati(7 downto 0);  -- Fourth data   Y (MSB)
=> SBAwait;  reg5:= x"00" & dati(7 downto 0);  -- fifth data    Z (LSB)
=> SBAwait;  reg6:= x"00" & dati(7 downto 0);  -- sixth data    Z (MSB)
=> SBARead(GPIO2);					           -- Read the status of the switches
=> reg7:= dati(2 downto 0);      
=> case reg7 is                                -- Evaluating the status of the switches
	  when "000" => SBAWrite(GPIO,reg1);       -- Displaying X(LSB) data to the LEDs
      when "001" => SBAWrite(GPIO,reg2);       -- Displaying X(MSB) data to the LEDs
 	  when "010" => SBAWrite(GPIO,reg3);       -- Displaying Y(LSB) data to the LEDs
	  when "011" => SBAWrite(GPIO,reg4);       -- Displaying Y(MSB) data to the LEDs
	  when "100" => SBAWrite(GPIO,reg5);       -- Displaying Z(LSB) data to the LEDs
	  when "101" => SBAWrite(GPIO,reg6);       -- Displaying Z(MSB) data to the LEDs
	  when others => SBAWrite(GPIO,x"0055");   -- Any data
   end case;

=> SBAjump(ReadBucle);

-- /SBA: End -------------------------------------------------------------------
