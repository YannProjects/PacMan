vlib modelsim_lib/work
vlib modelsim_lib/msim

<<<<<<< HEAD
vlib modelsim_lib/msim/dist_mem_gen_v8_0_13
vlib modelsim_lib/msim/xil_defaultlib

vmap dist_mem_gen_v8_0_13 modelsim_lib/msim/dist_mem_gen_v8_0_13
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

=======
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/dist_mem_gen_v8_0_13
vlib modelsim_lib/msim/xil_defaultlib

vmap xpm modelsim_lib/msim/xpm
vmap dist_mem_gen_v8_0_13 modelsim_lib/msim/dist_mem_gen_v8_0_13
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu -sv \
"C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93 \
"C:/Xilinx/Vivado/2022.1/data/ip/xpm/xpm_VCOMP.vhd" \

>>>>>>> 8d8951fe53392006346f0a5ba26bbcbabd6294a8
vlog -work dist_mem_gen_v8_0_13  -incr -mfcu \
"../../../ipstatic/simulation/dist_mem_gen_v8_0.v" \

vlog -work xil_defaultlib  -incr -mfcu \
"../../../../Pacman_Artyx7.gen/sources_1/ip/rom_pacman_6j_v2/sim/rom_pacman_6j_v2.v" \

<<<<<<< HEAD

=======
>>>>>>> 8d8951fe53392006346f0a5ba26bbcbabd6294a8
vlog -work xil_defaultlib \
"glbl.v"
