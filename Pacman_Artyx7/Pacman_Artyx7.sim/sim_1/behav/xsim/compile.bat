@echo off
REM ****************************************************************************
REM Vivado (TM) v2022.1 (64-bit)
REM
REM Filename    : compile.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for compiling the simulation design source files
REM
REM Generated by Vivado on Sat Apr 27 22:47:35 +0200 2024
REM SW Build 3526262 on Mon Apr 18 15:48:16 MDT 2022
REM
REM IP Build 3524634 on Mon Apr 18 20:55:01 MDT 2022
REM
REM usage: compile.bat
REM
REM ****************************************************************************
REM compile Verilog/System Verilog design sources
echo "xvlog --incr --relax -prj PacMan_sim_vlog.prj"
call xvlog  --incr --relax -prj PacMan_sim_vlog.prj -log xvlog.log
call type xvlog.log > compile.log
REM compile VHDL design sources
echo "xvhdl --incr --relax -prj PacMan_sim_vhdl.prj"
call xvhdl  --incr --relax -prj PacMan_sim_vhdl.prj -log xvhdl.log
call type xvhdl.log >> compile.log
if "%errorlevel%"=="1" goto END
if "%errorlevel%"=="0" goto SUCCESS
:END
exit 1
:SUCCESS
exit 0
