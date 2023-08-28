
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
create_generated_clock -name z80_clk -source [get_pins clk_gen_0/clk_gen/clk_sys] -divide_by 2 [get_pins {u_Core/hcnt[1]_i_1/O}]

set_input_delay -clock [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT2]] 70.000 [get_ports -filter { NAME =~  "*m1*" && DIRECTION == "IN" }]
set_input_delay -clock [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT2]] 60.000 [get_ports -filter { NAME =~  "*mreq*" && DIRECTION == "IN" }]
set_input_delay -clock [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT2]] 60.000 [get_ports -filter { NAME =~  "*iorq*" && DIRECTION == "IN" }]
set_input_delay -clock [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT2]] 70.000 [get_ports -filter { NAME =~  "*rd_l*" && DIRECTION == "IN" }]
set_input_delay -clock [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT2]] 70.000 [get_ports -filter { NAME =~  "*wr_l*" && DIRECTION == "IN" }]
set_input_delay -clock [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT2]] 90.000 [get_ports -filter { NAME =~  "*rfrsh_l*" && DIRECTION == "IN" }]
set_output_delay -clock [get_clocks z80_clk] -clock_fall 50.000 [get_ports -filter { NAME =~  "*wait_l*" && DIRECTION == "OUT" }]
set_output_delay -clock [get_clocks z80_clk] 50.000 [get_ports -filter { NAME =~  "*cpu_di*" && DIRECTION == "OUT" }]
set_output_delay -clock [get_clocks z80_clk] 50.000 [get_ports -filter { NAME =~  "*cpu_int_l*" && DIRECTION == "OUT" }]

set_input_delay -clock [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT2]] 40.000 [get_ports -filter { NAME =~  "*cpu_do*" && DIRECTION == "IN" }]
set_clock_groups -name VGA -asynchronous -group [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT1]]
set_clock_groups -name 52M -asynchronous -group [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT1]] -group [get_clocks [list clk_52M [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT0]]]]
set_clock_groups -name SYSCLK -asynchronous -group [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT1]] -group [get_clocks [list clk_52M [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT0]]]] -group [get_clocks [list i_clk_sys z80_clk [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT2]] [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKFBOUT]]]]



set_false_path -to [get_ports *o_audio*]
set_false_path -to [get_ports *o_dip*]
set_false_path -to [get_ports *o_in*]

set_property PACKAGE_PIN P17 [get_ports i_clk_sys]


