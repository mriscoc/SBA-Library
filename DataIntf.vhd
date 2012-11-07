----------------------------------------------------------------
-- SBA DataIntf
--
-- version 1.0 20091001
--
-- Data Output Bus interface
-- Use to connect SBA Slave blocks to SBA input data bus
-- Allow to the synthesizer to inferring a bus multiplexer
--
-- Author:
-- (c) Miguel A. Risco Castillo
-- email: mrisco@accesus.com
-- web page: http://mrisco.accesus.com
--
--
-- This code, modifications, derivate
-- work or based upon, can not be used
-- or distributed without the
-- complete credits on this header and
-- the consent of the author.
--
-- This version is released under the GNU/GLP license
-- http://www.gnu.org/licenses/gpl.html
-- if you use this component for your research please
-- include the appropriate credit of Author.
--
-- For commercial purposes request the appropriate
-- license from the author.
--
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity  DataIntf  is
port(
   STB_I: in  std_logic;           -- Strobe input Chip selector
   DAT_I: in  std_logic_vector;    -- Data Bus from slave       
   DAT_O: out std_logic_vector     -- output Data Bus to master
);
end DataIntf;

architecture DataIntf_Arch of DataIntf is
begin
  DAT_O <= DAT_I when STB_I='1' else (DAT_O'Range=>'Z');
end DataIntf_Arch;