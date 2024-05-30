<<<<<<< HEAD
set_property SRC_FILE_INFO {cfile:C:/Users/yannv/Documents/Projets_HW/PacMan/PacMan_v2_AIO/constraints/all_constraints.xdc rfile:../../../../constraints/all_constraints.xdc id:1} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Users/yannv/Documents/Projets_HW/PacMan/PacMan_v2_AIO/constraints/pinout.xdc rfile:../../../../constraints/pinout.xdc id:2} [current_design]
set_property src_info {type:XDC file:1 line:16 export:INPUT save:INPUT read:READ} [current_design]
create_clock -period 19.231 -name clk_52M -waveform {0.000 9.616} [get_pins clk_gen_0/clk_52m]
set_property src_info {type:XDC file:1 line:19 export:INPUT save:INPUT read:READ} [current_design]
create_generated_clock -name z80_clk -source [get_pins clk_gen_0/clk_gen/clk_sys] -divide_by 2 [get_pins {u_Core/hcnt[1]_i_1/O}]
set_property src_info {type:XDC file:1 line:22 export:INPUT save:INPUT read:READ} [current_design]
set_clock_groups -name VGA -asynchronous -group [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT1]]
set_property src_info {type:XDC file:1 line:23 export:INPUT save:INPUT read:READ} [current_design]
set_clock_groups -name 52M -asynchronous -group [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT1]] -group [get_clocks [list clk_52M [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT0]]]]
set_property src_info {type:XDC file:1 line:24 export:INPUT save:INPUT read:READ} [current_design]
set_clock_groups -name SYSCLK -asynchronous -group [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT1]] -group [get_clocks [list clk_52M [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT0]]]] -group [get_clocks [list i_clk_sys z80_clk [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT2]] [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKFBOUT]]]]
set_property src_info {type:XDC file:1 line:35 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P17 [get_ports i_clk_main]
set_property src_info {type:XDC file:1 line:52 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V9 [get_ports {i_config_reg[2]}]
set_property src_info {type:XDC file:2 line:2 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V6 [get_ports o_dip_l_cs]
set_property src_info {type:XDC file:2 line:3 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T6 [get_ports o_in0_l_cs]
set_property src_info {type:XDC file:2 line:4 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V7 [get_ports o_in1_l_cs]
set_property src_info {type:XDC file:2 line:5 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN M2 [get_ports {o_vga[r_vga][0]}]
set_property src_info {type:XDC file:2 line:6 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN N6 [get_ports {i_config_reg[4]}]
set_property src_info {type:XDC file:2 line:7 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U7 [get_ports {i_config_reg[7]}]
set_property src_info {type:XDC file:2 line:8 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U6 [get_ports {i_config_reg[6]}]
set_property src_info {type:XDC file:2 line:9 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T8 [get_ports {i_config_reg[0]}]
set_property src_info {type:XDC file:2 line:10 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R8 [get_ports {i_config_reg[1]}]
set_property src_info {type:XDC file:2 line:53 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN C6 [get_ports i_rst_sys_n]
set_property src_info {type:XDC file:2 line:54 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U9 [get_ports {i_config_reg[3]}]
set_property src_info {type:XDC file:2 line:55 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN M6 [get_ports {i_config_reg[5]}]
set_property src_info {type:XDC file:2 line:56 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P5 [get_ports {o_audio_vol_out[3]}]
set_property src_info {type:XDC file:2 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R3 [get_ports {o_audio_wav_out[3]}]
set_property src_info {type:XDC file:2 line:58 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P4 [get_ports {o_audio_wav_out[2]}]
set_property src_info {type:XDC file:2 line:59 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P3 [get_ports {o_audio_wav_out[1]}]
set_property src_info {type:XDC file:2 line:60 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN N4 [get_ports {o_audio_wav_out[0]}]
set_property src_info {type:XDC file:2 line:61 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R1 [get_ports {o_vga[b_vga][2]}]
set_property src_info {type:XDC file:2 line:62 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T5 [get_ports {o_audio_vol_out[2]}]
set_property src_info {type:XDC file:2 line:63 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T4 [get_ports {o_audio_vol_out[1]}]
set_property src_info {type:XDC file:2 line:64 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T3 [get_ports {o_audio_vol_out[0]}]
set_property src_info {type:XDC file:2 line:65 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R2 [get_ports {o_vga[b_vga][1]}]
set_property src_info {type:XDC file:2 line:66 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P2 [get_ports {o_vga[b_vga][0]}]
set_property src_info {type:XDC file:2 line:67 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN N1 [get_ports {o_vga[g_vga][2]}]
set_property src_info {type:XDC file:2 line:68 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN N2 [get_ports {o_vga[g_vga][1]}]
set_property src_info {type:XDC file:2 line:69 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN M1 [get_ports {o_vga[g_vga][0]}]
set_property src_info {type:XDC file:2 line:70 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN L1 [get_ports {o_vga[r_vga][2]}]
set_property src_info {type:XDC file:2 line:71 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN M3 [get_ports {o_vga[r_vga][1]}]
set_property src_info {type:XDC file:2 line:72 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T1 [get_ports {o_vga[hsync]}]
set_property src_info {type:XDC file:2 line:73 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN M4 [get_ports {o_vga[vsync]}]
=======
set_property SRC_FILE_INFO {cfile:C:/Users/yannv/Documents/Projets_HW/PacMan/PacMan_v2/constraints/all_constraints.xdc rfile:../../../../constraints/all_constraints.xdc id:1} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Users/yannv/Documents/Projets_HW/PacMan/PacMan_v2/constraints/pinout.xdc rfile:../../../../constraints/pinout.xdc id:2} [current_design]
set_property src_info {type:XDC file:1 line:16 export:INPUT save:INPUT read:READ} [current_design]
create_clock -period 19.231 -name clk_52M -waveform {0.000 9.616} [get_pins clk_gen_0/clk_52m]
set_property src_info {type:XDC file:1 line:21 export:INPUT save:INPUT read:READ} [current_design]
set_clock_groups -name 52M -asynchronous -group [get_clocks clk_52M]
set_property src_info {type:XDC file:1 line:34 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P17 [get_ports i_clk_main]
set_property src_info {type:XDC file:1 line:37 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN N6 [get_ports {i_config_reg[6]}]
set_property src_info {type:XDC file:1 line:38 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T8 [get_ports {i_config_reg[4]}]
set_property src_info {type:XDC file:1 line:39 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T6 [get_ports {i_config_reg[2]}]
set_property src_info {type:XDC file:1 line:40 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P2 [get_ports {i_cpu_do_core[7]}]
set_property src_info {type:XDC file:1 line:41 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN N2 [get_ports {i_cpu_do_core[6]}]
set_property src_info {type:XDC file:1 line:42 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN L1 [get_ports {i_cpu_do_core[5]}]
set_property src_info {type:XDC file:1 line:43 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN M2 [get_ports {i_cpu_do_core[4]}]
set_property src_info {type:XDC file:1 line:44 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R1 [get_ports {i_cpu_do_core[3]}]
set_property src_info {type:XDC file:1 line:45 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R3 [get_ports {i_cpu_do_core[2]}]
set_property src_info {type:XDC file:1 line:46 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P3 [get_ports {i_cpu_do_core[1]}]
set_property src_info {type:XDC file:1 line:47 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN M4 [get_ports {i_cpu_do_core[0]}]
set_property src_info {type:XDC file:1 line:48 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U7 [get_ports {o_audio_wav_out[3]}]
set_property src_info {type:XDC file:1 line:49 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U9 [get_ports {o_audio_wav_out[1]}]
set_property src_info {type:XDC file:1 line:50 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN F4 [get_ports {o_cpu_di_core[6]}]
set_property src_info {type:XDC file:1 line:51 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN H2 [get_ports {o_cpu_di_core[5]}]
set_property src_info {type:XDC file:1 line:52 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN K2 [get_ports {o_cpu_di_core[4]}]
set_property src_info {type:XDC file:1 line:53 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN J2 [get_ports {o_cpu_di_core[3]}]
set_property src_info {type:XDC file:1 line:54 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN E2 [get_ports {o_cpu_di_core[2]}]
set_property src_info {type:XDC file:1 line:55 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN F1 [get_ports {o_cpu_di_core[1]}]
set_property src_info {type:XDC file:1 line:56 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN H1 [get_ports {o_cpu_di_core[0]}]
set_property src_info {type:XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T5 [get_ports {o_vga[b_vga][2]}]
set_property src_info {type:XDC file:1 line:58 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V1 [get_ports {o_vga[b_vga][0]}]
set_property src_info {type:XDC file:1 line:59 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T1 [get_ports {o_vga[g_vga][1]}]
set_property src_info {type:XDC file:1 line:60 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN M1 [get_ports {o_vga[r_vga][2]}]
set_property src_info {type:XDC file:1 line:61 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN N1 [get_ports {o_vga[r_vga][1]}]
set_property src_info {type:XDC file:1 line:62 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R2 [get_ports {o_vga[r_vga][0]}]
set_property src_info {type:XDC file:1 line:63 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P5 [get_ports i_rst_sys_n]
set_property src_info {type:XDC file:1 line:64 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN A1 [get_ports o_cpu_clk_core]
set_property src_info {type:XDC file:1 line:65 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN A3 [get_ports o_cpu_rst_core]
set_property src_info {type:XDC file:1 line:66 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U2 [get_ports o_dip_l_cs]
set_property src_info {type:XDC file:1 line:67 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U1 [get_ports o_in0_l_cs]
set_property src_info {type:XDC file:1 line:68 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P4 [get_ports {o_vga[hsync]}]
set_property src_info {type:XDC file:1 line:69 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T3 [get_ports {o_vga[vsync]}]
set_property src_info {type:XDC file:1 line:70 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V6 [get_ports {i_config_reg[3]}]
set_property src_info {type:XDC file:1 line:71 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V7 [get_ports {o_audio_vol_out[0]}]
set_property src_info {type:XDC file:1 line:84 export:INPUT save:INPUT read:READ} [current_design]
create_generated_clock -name CLK_Z80 -source [get_pins clk_gen_0/clk_gen/clk_sys] -edges {1 7 13} -edge_shift {0.000 0.000 0.000} [get_pins u_Core/o_cpu_clk_core_OBUF]
set_property src_info {type:XDC file:1 line:85 export:INPUT save:INPUT read:READ} [current_design]
set_input_delay -clock [get_clocks -regexp -nocase .*CLK_Z80.*] -max 57.000 [get_ports -regexp -nocase -filter { NAME =~  ".*i_cpu_a_core.*" && DIRECTION == "IN" }]
set_property src_info {type:XDC file:1 line:86 export:INPUT save:INPUT read:READ} [current_design]
set_input_delay -clock [get_clocks -regexp -nocase .*CLK_Z80.*] -clock_fall -max 40.000 [get_ports -regexp -nocase -filter { NAME =~  ".*mreq.*" && DIRECTION == "IN" }]
set_property src_info {type:XDC file:1 line:87 export:INPUT save:INPUT read:READ} [current_design]
set_input_delay -clock [get_clocks -regexp -nocase .*CLK_Z80.*] -clock_fall -max 40.000 [get_ports -regexp -nocase -filter { NAME =~  ".*i_cpu_rd_l.*" && DIRECTION == "IN" }]
set_property src_info {type:XDC file:1 line:88 export:INPUT save:INPUT read:READ} [current_design]
set_input_delay -clock [get_clocks -regexp -nocase .*CLK_Z80.*] -max 45.000 [get_ports -regexp -nocase -filter { NAME =~  ".*i_cpu_m1_l.*" && DIRECTION == "IN" }]
set_property src_info {type:XDC file:1 line:89 export:INPUT save:INPUT read:READ} [current_design]
set_input_delay -clock [get_clocks -regexp -nocase .*CLK_Z80.*] -max -12.000 [get_ports -regexp -nocase -filter { NAME =~  ".*i_cpu_do.*" && DIRECTION == "IN" }]
set_property src_info {type:XDC file:2 line:2 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN A6 [get_ports {i_cpu_a_core[11]}]
set_property src_info {type:XDC file:2 line:3 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN E5 [get_ports {i_cpu_a_core[4]}]
set_property src_info {type:XDC file:2 line:4 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN D8 [get_ports {i_cpu_a_core[12]}]
set_property src_info {type:XDC file:2 line:5 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN B6 [get_ports {i_cpu_a_core[2]}]
set_property src_info {type:XDC file:2 line:6 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN F6 [get_ports {i_cpu_a_core[14]}]
set_property src_info {type:XDC file:2 line:7 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN B7 [get_ports {i_cpu_a_core[10]}]
set_property src_info {type:XDC file:2 line:8 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN C4 [get_ports {i_cpu_a_core[9]}]
set_property src_info {type:XDC file:2 line:9 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN C6 [get_ports {i_cpu_a_core[8]}]
set_property src_info {type:XDC file:2 line:10 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN C7 [get_ports {i_cpu_a_core[7]}]
set_property src_info {type:XDC file:2 line:11 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN G6 [get_ports {i_cpu_a_core[6]}]
set_property src_info {type:XDC file:2 line:12 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN D7 [get_ports {i_cpu_a_core[5]}]
set_property src_info {type:XDC file:2 line:13 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN C5 [get_ports {i_cpu_a_core[0]}]
set_property src_info {type:XDC file:2 line:14 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN A5 [get_ports {i_cpu_a_core[3]}]
set_property src_info {type:XDC file:2 line:15 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN B4 [get_ports {i_cpu_a_core[1]}]
set_property src_info {type:XDC file:2 line:16 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN E6 [get_ports {i_cpu_a_core[15]}]
set_property src_info {type:XDC file:2 line:17 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN E7 [get_ports {i_cpu_a_core[13]}]
set_property src_info {type:XDC file:2 line:18 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN E3 [get_ports {o_cpu_di_core[7]}]
set_property src_info {type:XDC file:2 line:19 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN G1 [get_ports i_cpu_rfrsh_l_core]
set_property src_info {type:XDC file:2 line:20 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN F3 [get_ports i_cpu_iorq_l_core]
set_property src_info {type:XDC file:2 line:21 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN K1 [get_ports i_cpu_wr_l_core]
set_property src_info {type:XDC file:2 line:22 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN B3 [get_ports o_cpu_wait_l_core]
set_property src_info {type:XDC file:2 line:23 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U3 [get_ports o_in1_l_cs]
set_property src_info {type:XDC file:2 line:24 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U6 [get_ports {i_config_reg[7]}]
set_property src_info {type:XDC file:2 line:25 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R6 [get_ports {i_config_reg[0]}]
set_property src_info {type:XDC file:2 line:26 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V4 [get_ports {i_config_reg[1]}]
set_property src_info {type:XDC file:2 line:119 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V9 [get_ports {i_config_reg[5]}]
set_property src_info {type:XDC file:2 line:120 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R5 [get_ports {o_audio_vol_out[3]}]
set_property src_info {type:XDC file:2 line:121 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN M6 [get_ports {o_audio_wav_out[2]}]
set_property src_info {type:XDC file:2 line:122 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R8 [get_ports {o_audio_wav_out[0]}]
set_property src_info {type:XDC file:2 line:123 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V5 [get_ports {o_audio_vol_out[2]}]
set_property src_info {type:XDC file:2 line:124 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R7 [get_ports {o_audio_vol_out[1]}]
set_property src_info {type:XDC file:2 line:125 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN N5 [get_ports {o_vga[b_vga][1]}]
set_property src_info {type:XDC file:2 line:126 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN N4 [get_ports {o_vga[g_vga][2]}]
set_property src_info {type:XDC file:2 line:127 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN M3 [get_ports {o_vga[g_vga][0]}]
set_property src_info {type:XDC file:2 line:128 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN D3 [get_ports i_cpu_m1_l_core]
set_property src_info {type:XDC file:2 line:129 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN J3 [get_ports i_cpu_mreq_l_core]
set_property src_info {type:XDC file:2 line:130 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN G2 [get_ports i_cpu_rd_l_core]
set_property src_info {type:XDC file:2 line:131 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN C2 [get_ports o_cpu_int_l_core]
>>>>>>> 8d8951fe53392006346f0a5ba26bbcbabd6294a8