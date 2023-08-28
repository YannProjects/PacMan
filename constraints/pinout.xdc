

# Video VGA
set_property IOSTANDARD LVCMOS33 [get_ports {o_r_vga[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_r_vga[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_r_vga[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {o_g_vga[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_g_vga[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_g_vga[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {o_b_vga[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_b_vga[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_b_vga[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports o_hsync]
set_property IOSTANDARD LVCMOS33 [get_ports o_vsync]

set_property IOSTANDARD LVCMOS33 [get_ports {i_ctrl[clk_sys]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_ctrl[rst_sys]}]


# PIN 48
set_property PACKAGE_PIN A4 [get_ports {o_r_vga[0]}]
# PIN 47
set_property PACKAGE_PIN A3 [get_ports {o_r_vga[1]}]
# PIN 46
set_property PACKAGE_PIN B4 [get_ports {o_r_vga[2]}]

# PIN 45
set_property PACKAGE_PIN B3 [get_ports {o_g_vga[0]}]
# PIN 44
set_property PACKAGE_PIN C1 [get_ports {o_g_vga[1]}]
# PIN 43
set_property PACKAGE_PIN B1 [get_ports {o_g_vga[2]}]

# PIN 42
set_property PACKAGE_PIN B2 [get_ports {o_b_vga[0]}]
# PIN 41
set_property PACKAGE_PIN A2 [get_ports {o_b_vga[1]}]
# PIN 40
set_property PACKAGE_PIN C5 [get_ports {o_b_vga[2]}]

# PIN 30
set_property PACKAGE_PIN M13 [get_ports o_vsync]
# PIN 31
set_property PACKAGE_PIN J11 [get_ports o_hsync]

# Divers
set_property PACKAGE_PIN M9 [get_ports {i_ctrl[clk_sys]}]
set_property PACKAGE_PIN D2 [get_ports {i_ctrl[rst_sys]}]

# Debug
#set_property IOSTANDARD LVCMOS33 [get_ports {Dbg[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Dbg[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Dbg[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Dbg[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Dbg[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Dbg[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Dbg[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Dbg[0]}]

#set_property PACKAGE_PIN F4 [get_ports {Dbg[7]}]
#set_property PACKAGE_PIN G1 [get_ports {Dbg[6]}]
##set_property PACKAGE_PIN H1 [get_ports {Dbg[5]}]
#set_property PACKAGE_PIN H3 [get_ports {Dbg[4]}]
#set_property PACKAGE_PIN F3 [get_ports {Dbg[3]}]
#set_property PACKAGE_PIN H4 [get_ports {Dbg[2]}]
#set_property PACKAGE_PIN H2 [get_ports {Dbg[1]}]
#set_property PACKAGE_PIN J2 [get_ports {Dbg[0]}]

