// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
<<<<<<< HEAD
// Date        : Wed Jan 10 21:10:40 2024
=======
// Date        : Thu Jan 11 08:12:03 2024
>>>>>>> 8d8951fe53392006346f0a5ba26bbcbabd6294a8
// Host        : DESKTOP-SK95JA6 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ rom_pacman_3m_sim_netlist.v
// Design      : rom_pacman_3m
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a15tcsg324-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "rom_pacman_3m,dist_mem_gen_v8_0_13,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2022.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (a,
    spo);
  input [6:0]a;
  output [3:0]spo;

  wire [6:0]a;
  wire [3:0]spo;
  wire [3:0]NLW_U0_dpo_UNCONNECTED;
  wire [3:0]NLW_U0_qdpo_UNCONNECTED;
  wire [3:0]NLW_U0_qspo_UNCONNECTED;

  (* C_FAMILY = "artix7" *) 
  (* C_HAS_D = "0" *) 
  (* C_HAS_DPO = "0" *) 
  (* C_HAS_DPRA = "0" *) 
  (* C_HAS_I_CE = "0" *) 
  (* C_HAS_QDPO = "0" *) 
  (* C_HAS_QDPO_CE = "0" *) 
  (* C_HAS_QDPO_CLK = "0" *) 
  (* C_HAS_QDPO_RST = "0" *) 
  (* C_HAS_QDPO_SRST = "0" *) 
  (* C_HAS_WE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_PIPELINE_STAGES = "0" *) 
  (* C_QCE_JOINED = "0" *) 
  (* C_QUALIFY_WE = "0" *) 
  (* C_REG_DPRA_INPUT = "0" *) 
  (* c_addr_width = "7" *) 
  (* c_default_data = "0" *) 
  (* c_depth = "128" *) 
  (* c_elaboration_dir = "./" *) 
  (* c_has_clk = "0" *) 
  (* c_has_qspo = "0" *) 
  (* c_has_qspo_ce = "0" *) 
  (* c_has_qspo_rst = "0" *) 
  (* c_has_qspo_srst = "0" *) 
  (* c_has_spo = "1" *) 
  (* c_mem_init_file = "rom_pacman_3m.mif" *) 
  (* c_parser_type = "1" *) 
  (* c_read_mif = "1" *) 
  (* c_reg_a_d_inputs = "0" *) 
  (* c_sync_enable = "1" *) 
  (* c_width = "4" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_dist_mem_gen_v8_0_13 U0
       (.a(a),
        .clk(1'b0),
        .d({1'b0,1'b0,1'b0,1'b0}),
        .dpo(NLW_U0_dpo_UNCONNECTED[3:0]),
        .dpra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .i_ce(1'b1),
        .qdpo(NLW_U0_qdpo_UNCONNECTED[3:0]),
        .qdpo_ce(1'b1),
        .qdpo_clk(1'b0),
        .qdpo_rst(1'b0),
        .qdpo_srst(1'b0),
        .qspo(NLW_U0_qspo_UNCONNECTED[3:0]),
        .qspo_ce(1'b1),
        .qspo_rst(1'b0),
        .qspo_srst(1'b0),
        .spo(spo),
        .we(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2022.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
V8j9uZAuTSdcU7d37hOuvR2eN4+hJE0SQi3782LtikYHlIhlhzzBECcQ3wckATmgIOfJCCVEoeRA
ZabxUB0jmkGFcM25pS42us4l8Jw3tzYXg8dRkvx7VRPHyWH9wXwUgy0qFUIqbS1K3ToC2ti3Bihe
SaejkALX/yf7GEmQSeg=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
KjnLJu4SYrpE4qQx0FJobDTHe2g5+n+Q6FObiGTKe0NVy1wB7V+KEJqc+r2xjpEXlquV87+TrOgr
yoeXvSYsOmh/oNv+5lpsb/kdhT5EljdkfqI4rTDdogwIRbF5iSu9dp/2OtVr+nC6QYGDI0YDgcO7
4kn8ghnBESoln4PERbuzfTfbc58lo6Gq5qv7TMTjDZMRiN0CUTCuYzVqRTCRXkgTDhosefVDs6Up
pB5jZ9devajNCsz9yQIQtxvuN9tXVWeuRueNFB14r4rYY7F5/otmDqvKgCWwEXtKqVQNj5hQkSFz
YWx96euGqafcGtIs2W0H2QMov0vrSxi2Wndlrw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
YO2SS3ozlen3bngSMDbc88mazzkono7nFrse2QdBdhm7cHsDiCLJl1u/2ZwIFv3QeEbCn5u5q8hG
TDNHI8nZRuskZLs0BXqig7uplAiktBJEN0l0ei2ciUax4iVnRtCVKfn/M+BUZj+banPiWp9Kpdml
VOrMoFqIXebJq184IVY=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
eDqyXO8M8wAUlkNysOtmW3Ag3h1qUc1ksEfo85mvU5cMYdCjRVYz6OacttNeARjho7fIzXtgtHAi
s4cOsFuah18hkHlPDbWnJcyaBoN1UC3zH5Sq356+JnD/+tnBnq5OlU7W8OrboEfK03go6Zxe/y0y
s5Nz5MFYMngLELHz4vZOYoOsO0xFsbio7vDtFzbgvpvZVLhKvQGtVdJsfIEkBd5elE4tTaYSPadU
6/cHnyXVTNeuDPFYqkX5j61R1m3f4zfnkdWn8CSZWYouhfpOaV32Tgk2834g6THkeV44U6Kee28f
2zM3Vl2Xrsa0SP/3vltYwvfGU5mZYQWr7lVJMg==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
aoJHr9XKFogp3jqb6pnOP1SMdRNgax7PRBVL5oP9u6EBjCyOxasIjony/C5q5NGBilztG19Wtj7R
pSXqIdzborswgHUyJ9bwF4lzJzoJcmlMej18+z1Jpel6fGTc/j055Fdrvxf8H5B0py0ynW0+fDNZ
zPhFWIdVVbPKObUsbSrAF28VEEdjfIanMWusQBga1WgtIzzlY2O5qHroTYp5swOjX4CzofsxuVN6
zxftYABV04wUN095K7HOK1DJ7TAXkfdSXbtZi/YpdsedZqTNxXRNCMIadoaueO+BVfk1QA6R8ep1
QEt/eDqhzxImaL/W5zdRu4iR3rKrxE66765F1g==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_07", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
CgtzskH+mzmGEWqd7KptSOOtqVwPm0tHLX1SSP1oz9rDkV9s3RKi69fpV8a1hfcU7tArjCYftqG0
OvBq65dZs3YMQA33i9lNugkOFd4s4mWuu5Jl7VeYn+9Rbn9WpXfIZp2ZhSebC7u4L3PU9Z/nt268
TK5LXHg27h+Dh/nfSuPBuUJcCfpFrpuNqXFqczDxXmwttNzz/5sbeoeBrELv9ua1vTrye7Ej9hF+
MotLlCmiWkkXoEFD9pgzAoLciXYvcnbqinUVZBh3f4F63hp3dnaF1XRU6BQXb07O2YWHsXMlKNt4
dK69u70ApIkoibr/gnLIZpYXk2Aw8SUE6s7f8g==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
qsF9lZxi/zzJVv67MO9pgWqGUstJe9URVdS4Sv0uoJrhh2rTsivGGCvajhVD4t887objCstZgTrr
GYoUVZ6+g5Wc50Y2H3Lujxr2ttPiAVBcqys8TNKzDd+sqqU9enMiC6oiNqRB47MmOChOBEVYG9po
MWBfSEOoqO1Bo4apr1ti7erpbZIS+vDEvNVBAffYTcjwMJo0YqVrHdgptBq2+soaNLYmiqaRp4+L
E+a1aCRpXco//ur2pwZKefYRj1Pbc3mGa0Db2EKTgzYxLCUc2Ni0MogHDl9nRduLW5okZXPYINE9
ZEibZH4ij3dCb5HI1YitvIlSsbwkthlrTRuwrA==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
Kfvr9uGICBYg+bSLCIkImscNd/d6O5EKsn3LkkEE5OLapxJgQzKOiesn0Ix7C0xi1lWmgjVDszTB
1+4PlhsdxFh2+tLaWEL5PS8Y+wY+Z6QWup4F/pHxKClIEvUeQqoxvy/4LamzYL84Lk6M8riHxELU
+UIySMpujDpmvesYeJcr8406Ky08tXu2ZYhzpI7ssAdevE5a5sv9uGOIE8SIM7hMSJnH+kDqv2XV
DCjIB/nPCxYZc0dpsQlckrpVRPSgn2XaJLX/gv1m3TBeoBxFtKK5IcQEbprjnUtdBRAJSECHzJ99
klwM9H7sQ3olqvcqMgxh7KtmwR1Pk7/BfETOzoythUHTo20xnhDaqT37g+zkKDOX/KMPxPP/+8Mf
v3C54uoO1KJz8iInxtwwu0Gkg+jGF77lLMNhR/s8ZQa0xupnEtjRd7L1H5D1xGuzhnimxL6oJ4lM
f3ToIlUmMffRPBpCLpWb6aeZZQyBMi3q/mdNpJxSTW5p99Bkt8UAcy2n

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kfapcdMik5+2iWCupVkPJLH/966AXOp3PqrBkJuAdqp3INTQeZICoWcyWImOR+Fnd1UbR5M8rJYw
R8Cjv4QYkt8kMqp/W6ZkPKauqc/dV4hHTgNjWmaDEPaIWvhXyVCARs6Kkc1XM9Id1BraWss872xt
GalXd7JXwJwOrBSKRYIZJMAvcqANDFyws1jlxEcuCKaxlT77kayjELqOewDOTN89nkTaPS80mBry
uUoplb7zOYXDvaWu/iVZ/BC1Iq5miXVcNAHb14TeyqXWwAsSVLeUJgrmOaKabKq2FRh66iEmv9wR
IeDmDHY40ooDpK1V7CDq6vBkUhnIeEQ3uiDy7Q==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 3952)
`pragma protect data_block
<<<<<<< HEAD
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
FzB95L0td+/pXIU2rJM15WUrHA==
=======
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
HlEfneMj1ovISQpSMoQ3O6Jl/g==
>>>>>>> 8d8951fe53392006346f0a5ba26bbcbabd6294a8
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
