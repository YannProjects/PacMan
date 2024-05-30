
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

# Ignore input delays related to input ports (R, G, B,...)

set_false_path -to [get_ports *hsync*]
set_false_path -to [get_ports *vsync*]
set_false_path -to [get_ports *r_vga*]
set_false_path -to [get_ports *g_vga*]
set_false_path -to [get_ports *b_vga*]

# set_false_path -from [get_pins vga_control0/i_vga_controller_ok_reg/C] -to [get_pins i_vga_control_init_done_0_reg/D]


create_clock -period 19.231 -name clk_52M -waveform {0.000 9.616} [get_pins clk_gen_0/clk_52m]
#create_clock -period 162.117 -name clk_sys -waveform {0.000 81.059} [get_pins clk_gen_0/clk_gen/clk_sys]
#create_clock -period 39.702 -name clk_vga -waveform {0.000 19.851} [get_pins clk_gen_0/clk_gen/clk_vga]


set_clock_groups -name 52M -asynchronous -group [get_clocks clk_52M]



set_false_path -to [get_ports *o_audio*]
set_false_path -to [get_ports *o_dip*]
set_false_path -to [get_ports *o_in*]




set_property IOSTANDARD LVCMOS33 [get_ports i_clk_main]

set_property PACKAGE_PIN P17 [get_ports i_clk_main]


set_property PACKAGE_PIN N6 [get_ports {i_config_reg[6]}]
set_property PACKAGE_PIN T8 [get_ports {i_config_reg[4]}]
set_property PACKAGE_PIN T6 [get_ports {i_config_reg[2]}]
set_property PACKAGE_PIN P2 [get_ports {i_cpu_do_core[7]}]
set_property PACKAGE_PIN N2 [get_ports {i_cpu_do_core[6]}]
set_property PACKAGE_PIN L1 [get_ports {i_cpu_do_core[5]}]
set_property PACKAGE_PIN M2 [get_ports {i_cpu_do_core[4]}]
set_property PACKAGE_PIN R1 [get_ports {i_cpu_do_core[3]}]
set_property PACKAGE_PIN R3 [get_ports {i_cpu_do_core[2]}]
set_property PACKAGE_PIN P3 [get_ports {i_cpu_do_core[1]}]
set_property PACKAGE_PIN M4 [get_ports {i_cpu_do_core[0]}]
set_property PACKAGE_PIN U7 [get_ports {o_audio_wav_out[3]}]
set_property PACKAGE_PIN U9 [get_ports {o_audio_wav_out[1]}]
set_property PACKAGE_PIN F4 [get_ports {o_cpu_di_core[6]}]
set_property PACKAGE_PIN H2 [get_ports {o_cpu_di_core[5]}]
set_property PACKAGE_PIN K2 [get_ports {o_cpu_di_core[4]}]
set_property PACKAGE_PIN J2 [get_ports {o_cpu_di_core[3]}]
set_property PACKAGE_PIN E2 [get_ports {o_cpu_di_core[2]}]
set_property PACKAGE_PIN F1 [get_ports {o_cpu_di_core[1]}]
set_property PACKAGE_PIN H1 [get_ports {o_cpu_di_core[0]}]
set_property PACKAGE_PIN T5 [get_ports {o_vga[b_vga][2]}]
set_property PACKAGE_PIN V1 [get_ports {o_vga[b_vga][0]}]
set_property PACKAGE_PIN T1 [get_ports {o_vga[g_vga][1]}]
set_property PACKAGE_PIN M1 [get_ports {o_vga[r_vga][2]}]
set_property PACKAGE_PIN N1 [get_ports {o_vga[r_vga][1]}]
set_property PACKAGE_PIN R2 [get_ports {o_vga[r_vga][0]}]
set_property PACKAGE_PIN P5 [get_ports i_rst_sys_n]
set_property PACKAGE_PIN A1 [get_ports o_cpu_clk_core]
set_property PACKAGE_PIN A3 [get_ports o_cpu_rst_core]
set_property PACKAGE_PIN U2 [get_ports o_dip_l_cs]
set_property PACKAGE_PIN U1 [get_ports o_in0_l_cs]
set_property PACKAGE_PIN P4 [get_ports {o_vga[hsync]}]
set_property PACKAGE_PIN T3 [get_ports {o_vga[vsync]}]
set_property PACKAGE_PIN V6 [get_ports {i_config_reg[3]}]
set_property PACKAGE_PIN V7 [get_ports {o_audio_vol_out[0]}]

create_clock -period 39.700 -name VGA_CLK -waveform {0.000 19.850} [get_pins clk_gen_0/clk_gen/clk_vga]
create_clock -period 54.600 -name SYS_CLK -waveform {0.000 27.300} [get_pins clk_gen_0/clk_gen/clk_sys]

create_generated_clock -name CLK_6M -source [get_pins clk_gen_0/clk_gen/clk_sys] -edges {1 5 7} -edge_shift {0.000 0.000 0.000} [get_nets clk_6m]
create_generated_clock -name CLK_6M_STAR -source [get_pins clk_gen_0/clk_gen/clk_sys] -edges {3 5 9} -edge_shift {0.000 0.000 0.000} [get_nets clk_6m_star]
create_generated_clock -name CLK_6M_STAR_N -source [get_pins clk_gen_0/clk_gen/clk_sys] -edges {5 9 11} -edge_shift {0.000 0.000 0.000} [get_nets clk_6m_star_n]


set_clock_groups -name VGA -asynchronous -group [get_clocks VGA_CLK]
set_clock_groups -name SYSCLK_GROUP -asynchronous -group [get_clocks SYS_CLK]

create_generated_clock -name CLK_Z80 -source [get_pins clk_gen_0/clk_gen/clk_sys] -edges {1 7 13} -edge_shift {0.000 0.000 0.000} [get_pins u_Core/o_cpu_clk_core_OBUF]
set_input_delay -clock [get_clocks -regexp -nocase .*CLK_Z80.*] -max 57.000 [get_ports -regexp -nocase -filter { NAME =~  ".*i_cpu_a_core.*" && DIRECTION == "IN" }]
set_input_delay -clock [get_clocks -regexp -nocase .*CLK_Z80.*] -clock_fall -max 40.000 [get_ports -regexp -nocase -filter { NAME =~  ".*mreq.*" && DIRECTION == "IN" }]
set_input_delay -clock [get_clocks -regexp -nocase .*CLK_Z80.*] -clock_fall -max 40.000 [get_ports -regexp -nocase -filter { NAME =~  ".*i_cpu_rd_l.*" && DIRECTION == "IN" }]
set_input_delay -clock [get_clocks -regexp -nocase .*CLK_Z80.*] -max 45.000 [get_ports -regexp -nocase -filter { NAME =~  ".*i_cpu_m1_l.*" && DIRECTION == "IN" }]
set_input_delay -clock [get_clocks -regexp -nocase .*CLK_Z80.*] -max -12.000 [get_ports -regexp -nocase -filter { NAME =~  ".*i_cpu_do.*" && DIRECTION == "IN" }]


set_property PULLUP true [get_ports {i_config_reg[7]}]
set_property PULLUP true [get_ports {i_config_reg[6]}]
set_property PULLUP true [get_ports {i_config_reg[5]}]
set_property PULLUP true [get_ports {i_config_reg[4]}]
set_property PULLUP true [get_ports {i_config_reg[3]}]
set_property PULLUP true [get_ports {i_config_reg[2]}]
set_property PULLUP true [get_ports {i_config_reg[1]}]
set_property PULLUP true [get_ports {i_config_reg[0]}]
