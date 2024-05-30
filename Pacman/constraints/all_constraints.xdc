
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

# Ignore input delays related to input ports (R, G, B,...)

set_false_path -to [get_ports o_r*]
set_false_path -to [get_ports o_g*]
set_false_path -to [get_ports o_b*]
set_false_path -to [get_ports o_vsync]
set_false_path -to [get_ports o_hsync]

# set_false_path -from [get_pins vga_control0/i_vga_controller_ok_reg/C] -to [get_pins i_vga_control_init_done_0_reg/D]


#set_false_path -from [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins clk_gen_0/clk_gen/inst/mmcm_adv_inst/CLKOUT2]]
create_generated_clock -name cpu_clock -source [get_pins clk_gen_0/clk_gen/clk_sys] -multiply_by 1 [get_pins {u_Core/hcnt_reg[0]/Q}]


set_clock_groups -name vga_and_system_clock_group -asynchronous -group [get_clocks clk_vga_clk_wiz_0] -group [get_clocks clk_52m_clk_wiz_0] -group [get_clocks clk_sys_clk_wiz_0]

