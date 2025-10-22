@echo off
REM Run simulation using GHDL and Surfer
REM (c) Miguel Risco-Castillo
REM v2.1 2025-10-21

if [%1]==[] goto help

echo Analyzing VHDL files...
ghdl --remove
if exist work-*.cf del work-*.cf
ghdl -a --std=08 --work=work *.vhd
if %ERRORLEVEL% NEQ 0 goto error

echo Elaborating testbench...
ghdl -e --std=08 --work=work testbench
if %ERRORLEVEL% NEQ 0 goto error

echo Running simulation...
ghdl -r --std=08 testbench --vcd=tb.vcd

echo Opening Surfer with saved configuration...
surfer tb.vcd -s tb.surf.ron
goto exit

:error
echo There are some errors in your vhdl files.
REM exit %ERRORLEVEL%
goto exit

:help
echo Usage:
echo run_sim [proyect_name]

:exit
