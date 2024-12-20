# Timings constraints
# Ignore input delays related to input ports (R, G, B,...)





set_false_path -to [get_ports *o_dip*]
set_false_path -to [get_ports *o_in*]

set_property PACKAGE_PIN P17 [get_ports i_clk_main]
set_property PACKAGE_PIN D3 [get_ports i_cpu_m1_l_core]
set_property PACKAGE_PIN J3 [get_ports i_cpu_mreq_l_core]
set_property PACKAGE_PIN G2 [get_ports i_cpu_rd_l_core]
set_property PACKAGE_PIN K1 [get_ports i_cpu_wr_l_core]
set_property PACKAGE_PIN A1 [get_ports o_cpu_clk_core]
set_property PACKAGE_PIN D4 [get_ports o_rom_cs]


# Bus adresses CPU
set_property PACKAGE_PIN A6 [get_ports {i_cpu_a_core[11]}]
set_property PACKAGE_PIN E5 [get_ports {i_cpu_a_core[4]}]
set_property PACKAGE_PIN D8 [get_ports {i_cpu_a_core[12]}]
set_property PACKAGE_PIN B6 [get_ports {i_cpu_a_core[2]}]
set_property PACKAGE_PIN F6 [get_ports {i_cpu_a_core[14]}]
set_property PACKAGE_PIN B7 [get_ports {i_cpu_a_core[10]}]
set_property PACKAGE_PIN C4 [get_ports {i_cpu_a_core[9]}]
set_property PACKAGE_PIN C7 [get_ports {i_cpu_a_core[7]}]
set_property PACKAGE_PIN D7 [get_ports {i_cpu_a_core[5]}]
set_property PACKAGE_PIN C5 [get_ports {i_cpu_a_core[0]}]
set_property PACKAGE_PIN A5 [get_ports {i_cpu_a_core[3]}]
set_property PACKAGE_PIN B4 [get_ports {i_cpu_a_core[1]}]
set_property PACKAGE_PIN E6 [get_ports {i_cpu_a_core[15]}]
set_property PACKAGE_PIN E7 [get_ports {i_cpu_a_core[13]}]

# Bus FPGA vers CPU

# Bus CPU vers FPGA

set_property IOSTANDARD LVCMOS33 [get_ports {i_cpu_a_core[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_cpu_a_core[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_cpu_a_core[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_cpu_a_core[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_cpu_a_core[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_cpu_a_core[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_cpu_a_core[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_cpu_a_core[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_cpu_a_core[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_cpu_a_core[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_cpu_a_core[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_cpu_a_core[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_cpu_a_core[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_cpu_a_core[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_cpu_a_core[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_cpu_a_core[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports i_clk_main]
set_property IOSTANDARD LVCMOS33 [get_ports i_cpu_m1_l_core]
set_property IOSTANDARD LVCMOS33 [get_ports o_cpu_rst_core]
set_property IOSTANDARD LVCMOS33 [get_ports o_cpu_wait_l_core]
set_property IOSTANDARD LVCMOS33 [get_ports o_rom_cs]
set_property IOSTANDARD LVCMOS33 [get_ports o_cpu_int_l_core]
set_property IOSTANDARD LVCMOS33 [get_ports o_cpu_clk_core]
set_property IOSTANDARD LVCMOS33 [get_ports i_rst_sys_n]
set_property IOSTANDARD LVCMOS33 [get_ports i_cpu_wr_l_core]
set_property IOSTANDARD LVCMOS33 [get_ports i_cpu_rfrsh_l_core]
set_property IOSTANDARD LVCMOS33 [get_ports i_cpu_rd_l_core]
set_property IOSTANDARD LVCMOS33 [get_ports i_cpu_mreq_l_core]
set_property PACKAGE_PIN C2 [get_ports o_cpu_int_l_core]
set_property PACKAGE_PIN B3 [get_ports o_cpu_wait_l_core]
set_property PACKAGE_PIN G1 [get_ports i_cpu_rfrsh_l_core]
set_property PACKAGE_PIN C6 [get_ports {i_cpu_a_core[8]}]
set_property PACKAGE_PIN P5 [get_ports i_rst_sys_n]
set_property PACKAGE_PIN A3 [get_ports o_cpu_rst_core]





set_property PACKAGE_PIN G6 [get_ports {i_cpu_a_core[6]}]

set_property PULLDOWN true [get_ports {i_cpu_a_core[15]}]
set_property PULLDOWN true [get_ports {i_cpu_a_core[14]}]
set_property PULLDOWN true [get_ports {i_cpu_a_core[13]}]
set_property PULLDOWN true [get_ports {i_cpu_a_core[12]}]
set_property PULLDOWN true [get_ports {i_cpu_a_core[11]}]
set_property PULLDOWN true [get_ports {i_cpu_a_core[10]}]
set_property PULLDOWN true [get_ports {i_cpu_a_core[9]}]
set_property PULLDOWN true [get_ports {i_cpu_a_core[8]}]
set_property PULLDOWN true [get_ports {i_cpu_a_core[7]}]
set_property PULLDOWN true [get_ports {i_cpu_a_core[6]}]
set_property PULLDOWN true [get_ports {i_cpu_a_core[5]}]
set_property PULLDOWN true [get_ports {i_cpu_a_core[4]}]
set_property PULLDOWN true [get_ports {i_cpu_a_core[3]}]
set_property PULLDOWN true [get_ports {i_cpu_a_core[2]}]
set_property PULLDOWN true [get_ports {i_cpu_a_core[1]}]
set_property PULLDOWN true [get_ports {i_cpu_a_core[0]}]


set_property IOSTANDARD LVCMOS33 [get_ports {i_config_reg[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_config_reg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_config_reg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_config_reg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_config_reg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_config_reg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_config_reg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_config_reg[0]}]
set_property PACKAGE_PIN V4 [get_ports {i_config_reg[1]}]
set_property PACKAGE_PIN T6 [get_ports {i_config_reg[2]}]
set_property PACKAGE_PIN V6 [get_ports {i_config_reg[3]}]
set_property PACKAGE_PIN T8 [get_ports {i_config_reg[4]}]
set_property PACKAGE_PIN V9 [get_ports {i_config_reg[5]}]
set_property PACKAGE_PIN N6 [get_ports {i_config_reg[6]}]
set_property PACKAGE_PIN U6 [get_ports {i_config_reg[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_audio_vol_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_audio_vol_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_audio_vol_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_audio_vol_out[0]}]
set_property PACKAGE_PIN R5 [get_ports {o_audio_vol_out[3]}]
set_property PACKAGE_PIN V5 [get_ports {o_audio_vol_out[2]}]
set_property PACKAGE_PIN R7 [get_ports {o_audio_vol_out[1]}]
set_property PACKAGE_PIN V7 [get_ports {o_audio_vol_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_audio_wav_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_audio_wav_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_audio_wav_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_audio_wav_out[0]}]
set_property PACKAGE_PIN U7 [get_ports {o_audio_wav_out[3]}]
set_property PACKAGE_PIN M6 [get_ports {o_audio_wav_out[2]}]
set_property PACKAGE_PIN U9 [get_ports {o_audio_wav_out[1]}]
set_property PACKAGE_PIN R8 [get_ports {o_audio_wav_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports i_cpu_iorq_l_core]
set_property PACKAGE_PIN F3 [get_ports i_cpu_iorq_l_core]

set_property IOSTANDARD LVCMOS33 [get_ports o_dip_l_cs]
set_property IOSTANDARD LVCMOS33 [get_ports o_in0_l_cs]
set_property PACKAGE_PIN U1 [get_ports o_in0_l_cs]
set_property PACKAGE_PIN U2 [get_ports o_in1_l_cs]
set_property IOSTANDARD LVCMOS33 [get_ports o_in1_l_cs]

create_clock -period 19.231 -name clk_52M -waveform {0.000 9.616} [get_pins clk_gen_0/clk_52m]
set_clock_groups -name VGA -asynchronous -group [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT1]]
set_clock_groups -name 52M -asynchronous -group [get_clocks clk_52M]
set_clock_groups -name SYSCLK -asynchronous -group [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT2]]

create_clock -period 39.700 -name VGA_CLK -waveform {0.000 19.850} [get_nets clk_gen_0/clk_gen/clk_vga]
create_generated_clock -name CLK_6M -source [get_pins clk_gen_0/clk_gen/clk_sys] -edges {1 5 7} -edge_shift {0.000 0.000 0.000} [get_pins o_clk_6M_inferred_i_1/O]
create_generated_clock -name CLK_6M_STAR -source [get_pins clk_gen_0/clk_gen/clk_sys] -edges {3 5 9} -edge_shift {0.000 0.000 0.000} [get_pins o_clk_6M_star_n_inferred_i_1/O]
create_generated_clock -name CLK_Z80 -source [get_pins clk_gen_0/clk_gen/clk_sys] -edges {1 7 13} -edge_shift {0.000 0.000 0.000} [get_pins o_cpu_clk_core_OBUF_inst/O]

set_property PACKAGE_PIN N1 [get_ports {o_vga[b_vga][2]}]
set_property PACKAGE_PIN R2 [get_ports {o_vga[b_vga][1]}]
set_property PACKAGE_PIN T1 [get_ports {o_vga[b_vga][0]}]
set_property PACKAGE_PIN N4 [get_ports {o_vga[g_vga][2]}]
set_property PACKAGE_PIN T3 [get_ports {o_vga[g_vga][0]}]
set_property PACKAGE_PIN T5 [get_ports {o_vga[r_vga][2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {o_vga[b_vga][2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_vga[b_vga][1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_vga[b_vga][0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_vga[g_vga][2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_vga[g_vga][1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_vga[g_vga][0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_vga[r_vga][2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_vga[r_vga][1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_vga[r_vga][0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_vga[hsync]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_vga[vsync]}]



set_property IOSTANDARD LVCMOS33 [get_ports i_freeze]
set_property PACKAGE_PIN V2 [get_ports i_freeze]
set_property PULLUP true [get_ports i_freeze]


set_property PACKAGE_PIN H1 [get_ports {io_cpu_data_bidir[0]}]
set_property PACKAGE_PIN F1 [get_ports {io_cpu_data_bidir[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_cpu_data_bidir[0]}]
set_property PACKAGE_PIN E2 [get_ports {io_cpu_data_bidir[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_cpu_data_bidir[1]}]
set_property PACKAGE_PIN J2 [get_ports {io_cpu_data_bidir[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_cpu_data_bidir[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_cpu_data_bidir[3]}]

set_property PACKAGE_PIN C1 [get_ports {io_cpu_data_bidir[7]}]
set_property PACKAGE_PIN F4 [get_ports {io_cpu_data_bidir[6]}]
set_property PACKAGE_PIN H2 [get_ports {io_cpu_data_bidir[5]}]
set_property PACKAGE_PIN K2 [get_ports {io_cpu_data_bidir[4]}]
set_property PACKAGE_PIN D2 [get_ports o_buffer_dir]
set_property PACKAGE_PIN E1 [get_ports o_buffer_enable]
set_property IOSTANDARD LVCMOS33 [get_ports o_buffer_dir]
set_property IOSTANDARD LVCMOS33 [get_ports o_buffer_enable]
set_property IOSTANDARD LVCMOS33 [get_ports {io_cpu_data_bidir[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_cpu_data_bidir[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_cpu_data_bidir[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_cpu_data_bidir[4]}]

set_property PACKAGE_PIN P4 [get_ports {o_vga[g_vga][1]}]
set_property PACKAGE_PIN N5 [get_ports {o_vga[r_vga][1]}]
set_property PACKAGE_PIN V1 [get_ports {o_vga[r_vga][0]}]
set_property PACKAGE_PIN U3 [get_ports o_dip_l_cs]
set_property PACKAGE_PIN M3 [get_ports {o_vga[hsync]}]
set_property PACKAGE_PIN M1 [get_ports {o_vga[vsync]}]

set_property PACKAGE_PIN R6 [get_ports {i_config_reg[0]}]


set_property OFFCHIP_TERM NONE [get_ports o_cpu_clk_core]
set_property OFFCHIP_TERM NONE [get_ports o_cpu_int_l_core]
set_property OFFCHIP_TERM NONE [get_ports o_cpu_rst_core]
set_property OFFCHIP_TERM NONE [get_ports o_cpu_wait_l_core]
set_property OFFCHIP_TERM NONE [get_ports o_hb]
set_property OFFCHIP_TERM NONE [get_ports o_rom_cs]
set_property IOSTANDARD LVCMOS33 [get_ports o_hb]
set_property PACKAGE_PIN U4 [get_ports o_hb]
