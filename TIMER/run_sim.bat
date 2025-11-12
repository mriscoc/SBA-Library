@echo off
REM Run simulation using GHDL and Surfer
REM (c) Miguel Risco-Castillo
REM v2.2 2025/10/22

if "%~1"=="-?" goto help
if "%~1"=="-h" goto help
if "%~1"=="--help" goto help
if not exist ".\tb" goto help

echo Analyzing VHDL files...
ghdl --remove
if exist work-*.cf del work-*.cf
if exist %~1_SBAcfg.vhd ghdl -a --std=08 --work=work %1_SBAcfg.vhd
ghdl -a --std=08 --work=work .\lib\*.vhd
ghdl -a --std=08 --work=work *.vhd
ghdl -a --std=08 --work=work .\tb\tb.vhd
if %ERRORLEVEL% NEQ 0 goto error

echo Elaborating testbench...
ghdl -e --std=08 --work=work testbench
if %ERRORLEVEL% NEQ 0 goto error

echo Running simulation...
ghdl -r --std=08 testbench --vcd=.\tb\tb.vcd --stop-time=100us

echo Opening Surfer with saved configuration...
surfer .\tb\tb.vcd -s .\tb\tb.surf.ron
goto exit

:error
echo There are some errors in your vhdl files.
REM exit %ERRORLEVEL%
goto exit

:help
echo Usage:
echo run_sim [proyect_name]
echo Testbench files must reside in the .\tb\ folder
:exit
