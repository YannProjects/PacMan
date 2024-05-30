@echo off
REM ****************************************************************************
REM Vivado (TM) v2022.1 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Mon Feb 12 16:42:22 +0100 2024
REM SW Build 3526262 on Mon Apr 18 15:48:16 MDT 2022
REM
REM IP Build 3524634 on Mon Apr 18 20:55:01 MDT 2022
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
REM simulate design
echo "xsim PacMan_sim_behav -key {Behavioral:sim_1:Functional:PacMan_sim} -tclbatch PacMan_sim.tcl -view C:/Users/yannv/Documents/Projets_HW/PacMan/PacMan_v2_AIO/wcfg/PacMan_sim_behav.wcfg -log simulate.log"
call xsim  PacMan_sim_behav -key {Behavioral:sim_1:Functional:PacMan_sim} -tclbatch PacMan_sim.tcl -view C:/Users/yannv/Documents/Projets_HW/PacMan/PacMan_v2_AIO/wcfg/PacMan_sim_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
