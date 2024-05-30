#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# 

echo "This script was generated under a different operating system."
echo "Please update the PATH and LD_LIBRARY_PATH variables below, before executing this script"
exit

if [ -z "$PATH" ]; then
  PATH=C:/Xilinx/Vivado/2022.1/ids_lite/ISE/bin/nt64;C:/Xilinx/Vivado/2022.1/ids_lite/ISE/lib/nt64:C:/Xilinx/Vivado/2022.1/bin
else
  PATH=C:/Xilinx/Vivado/2022.1/ids_lite/ISE/bin/nt64;C:/Xilinx/Vivado/2022.1/ids_lite/ISE/lib/nt64:C:/Xilinx/Vivado/2022.1/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

<<<<<<< HEAD
HD_PWD='C:/Users/yannv/Documents/Projets_HW/PacMan/PacMan_v2_AIO/Pacman_Artyx7/Pacman_Artyx7.runs/rom_pacman_6e_v2_synth_1'
=======
HD_PWD='C:/Users/yannv/Documents/Projets_HW/PacMan/PacMan_v2/Pacman_Artyx7/Pacman_Artyx7.runs/rom_pacman_6e_v2_synth_1'
>>>>>>> 8d8951fe53392006346f0a5ba26bbcbabd6294a8
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log rom_pacman_6e_v2.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source rom_pacman_6e_v2.tcl
