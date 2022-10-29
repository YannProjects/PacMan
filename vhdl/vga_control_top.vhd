----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.07.2021 10:42:27
-- Design Name: 
-- Module Name: vga_control_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
-- Composant chargé de l'initialisation du controller VGA et de l'interface entre l'affichage 
-- issu du PacMan core et le controller VGA OpenCore
-- Principe:
-- On écrit les données vidéo du PacMan dans une RAM de 768 octets (224*288) sur 8 (3 bits de R, G, 2 bits de bleu) bits avec l'horloge i_sys_clk
-- L'adresse d'écriture est resetté si i_vsync = 1 (synchro trame côté PacMan core)
-- Le controller VGA utilise une résolution de 640 x 480
-- La RAM vidéo est lue par le controller VGA avec l'horloge i_clk_52m
-- Les bits sont dupliqués pour doubler la longueur de ligne pour (288 * 2 =  576 pixels < 640)
-- A chaque Hsync controller VGA, on revient au début de la ligne 1 fois sur 2 pour doubler l'affichage vertical (224 * 2 = 448 lignes < 480)

library ieee;
library work;
use ieee.std_logic_1164.ALL;
-- use ieee.std_logic_arith.all;
-- use ieee.std_logic_unsigned.all;
-- use ieee.numeric_std.shift_left;
use ieee.numeric_std.all;
use work.VGA_control_pack.all;

library UNISIM;
use UNISIM.VComponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_control_top is
    Port ( 
        i_reset : in STD_LOGIC;
        i_clk_52m : in std_logic; -- 52 MHz
        i_vga_clk : in std_logic; -- 25.18750 Mhz
        i_sys_clk : in std_logic; -- 6.144 Mhz (18.432 MHz / 3)

        i_hsync : in std_logic; -- HSYNC Pacman core
        i_vsync : in std_logic; -- VSYNC Pacman core
        i_csync : in std_logic; -- CSYNC Pacman core
        i_blank : in std_logic; -- Video BLANK Pacman core
        i_rgb : in std_logic_vector(23 downto 0); -- RGB PacMan core
        
        o_hsync : out std_logic; -- HSYNC output from controller VGA (vers connecteur VGA)
        o_vsync : out std_logic; -- VSYNC output from controller VGA (vers connecteur VGA)
        o_csync : out std_logic; -- CSYNC output from controller VGA (vers connecteur VGA)
        o_blank : out std_logic; -- BLANK output from controller VGA (vers connecteur VGA)
        o_r : out std_logic_vector(2 downto 0); -- R controller VGA
        o_g : out std_logic_vector(2 downto 0); -- G controller VGA
        o_b : out std_logic_vector(1 downto 0); -- B controller VGA                

        o_vga_control_init_done : out std_logic
    );
end vga_control_top;

architecture Behavioral of vga_control_top is

    -- Controller VGA Opencores
    component vga_enh_top is
	port(
		wb_clk_i   : in std_logic;                         -- wishbone clock input
		wb_rst_i   : in std_logic;                         -- synchronous active high reset
		rst_i  : in std_logic;                  -- asynchronous active low reset
		wb_inta_o  : out std_logic;                        -- interrupt request output

		-- slave signals
		wbs_adr_i : in std_logic_vector(11 downto 0);          -- addressbus input (only 32bit databus accesses supported)
		wbs_dat_i : in std_logic_vector(31 downto 0);  -- Slave databus output
		wbs_dat_o : out std_logic_vector(31 downto 0); -- Slave databus input
		wbs_sel_i : in std_logic_vector(3 downto 0);   -- byte select inputs
		wbs_we_i  : in std_logic;                      -- write enabel input
		wbs_stb_i : in std_logic;                      -- vga strobe/select input
		wbs_cyc_i : in std_logic;                      -- valid bus cycle input
		wbs_ack_o : out std_logic;                     -- bus cycle acknowledge output
		wbs_rty_o : out std_logic;                     -- bus cycle retry output
		wbs_err_o : out std_logic;                     -- bus cycle error output
		
		-- master signals
		wbm_adr_o : out std_logic_vector(31 downto 0);              -- addressbus output
		wbm_dat_i : in std_logic_vector(31 downto 0);      -- Master databus input
		wbm_sel_o : out std_logic_vector(3 downto 0);       -- byte select outputs
		wbm_we_o  : out std_logic;                           -- write enable output
		wbm_stb_o : out std_logic;                          -- strobe output
		wbm_cyc_o : out std_logic;                          -- valid bus cycle output
		wbm_cti_o : out std_logic_vector(2 downto 0);       -- cycle type bus
		wbm_bte_o : out std_logic_vector(1 downto 0);       -- burst type extensions
		wbm_ack_i : in std_logic;                           -- bus cycle acknowledge input
		wbm_err_i : in std_logic;                           -- bus cycle error input

		-- VGA signals
		clk_p_i     : in std_logic;                            -- pixel clock
		clk_p_o     : out std_logic;                            -- pixel clock
		hsync_pad_o : out std_logic;                          -- horizontal sync
		vsync_pad_o : out std_logic;                          -- vertical sync
		csync_pad_o : out std_logic;                          -- composite sync
		blank_pad_o : out std_logic;                          -- blanking signal
		r_pad_o,g_pad_o,b_pad_o : out std_logic_vector(7 downto 0)        -- RGB color signals
	);
    end component vga_enh_top;
    
	-- Mémoire dual port de taille 224 x 288 x  x 8 bits
    component blk_mem_gen_video_ram is
    port (
        clka : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- PacMan core write side
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        clkb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- VGA core read side
    );
    end component;    

	type states is (wait_init, chk_stop, gen_cycle, wait_for_ack, idle);
	type vector_type is 
    record
        adr   : std_logic_vector(31 downto 0); -- wishbone address output
        dat   : std_logic_vector(31 downto 0); -- wishbone data output (write) or input compare value (read)
        stop  : std_logic;                     -- last field, stop wishbone activities
    end record;
    
    type vector_list is array(0 to 262) of vector_type;

	-- signal declarations
	signal state : states;
	signal icnt, init_timer : natural := 0;
	signal vga_controller_ok : std_logic;
	signal video_mem_addr_pacman : unsigned(15 downto 0);
	signal video_dpram_vga_core_addr_l : std_logic_vector(31 downto 0);
	signal video_dpram_vga_core_addr : std_logic_vector(14 downto 0);
	signal video_mem_pacman_data : std_logic_vector(7 downto 0);
	signal video_mem_vga_core_data : std_logic_vector(15 downto 0);
	
    -- wishbone host
	signal s_cyc_o, s_we_o : std_logic;
	signal s_adr_o                  : std_logic_vector(31 downto 0);
	signal s_dat_o                  : std_logic_vector(31 downto 0);
	signal s_sel_o                  : std_logic_vector(3 downto 0);
	signal s_ack_i                  : std_logic;
	signal s_stb_vga_o : std_logic;
	
    -- vga master
	signal vga_adr_o                       : std_logic_vector(31 downto 0);
	signal vga_addr_even_line_start        : unsigned(31 downto 0);
	signal vga_frame_offset                : unsigned(31 downto 0);
	signal vga_odd_line : std_logic;
	signal vga_dat_i                       : std_logic_vector(31 downto 0);
	signal vga_stb_o, vga_cyc_o, vga_ack_i : std_logic;
	signal vga_we_o                        : std_logic;
	
    signal hsync_vga, vsync_vga : std_logic;
    
    signal r_vgac, g_vgac, b_vgac: std_logic_vector(7 downto 0);
        
    -- attribute ASYNC_REG : string;
	
	shared variable vectors : vector_list :=
    (
        -- Mode Resolution Refresh Pulse Back porch Active time Front porch Line Total
        --              rate  MHz       usec    pix     pix     pix     pix     pix
        -- QVGA 320x240 60 Hz
        -- VGA 640x480  60 Hz 25.175    3.81    96      45      646     13      800        <<<===
        -- VGA 640x480  72 Hz 31.5      1.27    40      125     646     21      832
        -- SVGA 800x600 56 Hz 36        2       72      125     806     21      1024
        -- SVGA 800x600 60 Hz 40        3.2     128     85      806     37      1056
        -- SVGA 800x600 72 Hz 50        2.4     120     61      806     53      1040

        -- program vga controller
        (VBARa_REG_ADDR,x"00000000", '0'), --   program video base address 0 register (VBARa)
        (VBARb_REG_ADDR,x"00100000", '0'), --   program video base address 0 register (VBARb). Pas utilisé
        -- Pour le cas du PacMan, le mode choisit et une résolution de 576 x 448 avec un affichage de:
        -- Thsync : 96 pixels
        -- Thgdel (back porch) : 50 pixels
        -- Thgate : 576 pixels
        -- Front porch = 800 - (96+50+576) = 78 pixels
        (HTIM_REG_ADDR,x"5F48023F", '0'), -- program horizontal timing register ((288*2)*(224*2))
        
        -- Vertical timings
        -- QVGA 320x240 60 Hz
        -- VGA 640x480 60 Hz 31.78 63 2 953 30 15382 484 285 9 16683 525        <<<===
        -- VGA 640x480 72 Hz 26.41 79 3 686 26 12782 484 184 7 13735 520
        -- SVGA 800x600 56 Hz 28.44 56 1 568 20 17177 604 -1* 17775 625
        -- SVGA 800x600 60 Hz 26.40 106 4 554 21 15945 604 -1* 16579 628
        -- SVGA 800x600 72 Hz 20.80 125 6 436 21 12563 604 728 35 13853 AIE_NOC_M_AXI
        --
        -- Pour les lignes, il y a en tout 600 lignes
        -- => Sync pulse = 2 lignes
        -- => active time = 448 lignes
        -- => back porch = 30
        -- => front porch = 600 - (2+30+448) = 120 lignes
        (VTIM_REG_ADDR,x"013201BF", '0'), --   program vertical timing register
        (HVLEN_REG_ADDR,x"031F020C", '0'), --   program horizontal/vertical length register (800 x 525).
        
        -- On n'utilise que 2 couleurs: la première en index 0 et la dernière en index 255 sur la CLUT 0 (CLUT 1 pas utilisée)
        -- CLUT_REG_ADDR_1: Couleur de fond
        -- CLUT_REG_ADDR_2: Couleur de premier plan
        -- 0x00E0E0E0 : R G B sur un octet. Par rapport au circuit, seuls les 3 bits de poids fort sont utilisés:
        -- Blanc:  0x00E0E0E0
        -- Noir:   0x00000000
        -- Bleu:   0x000000E0
        -- Vert:   0x0000E000
        -- Rouge:  0x00E00000
        -- Violet: 0x00800080
        -- Jaune:  0x00e0e000
        (X"00000800", x"00000000", '0'),
        (X"00000804", x"00000040", '0'),
        (X"00000808", x"00000080", '0'),
        (X"0000080C", x"000000C0", '0'),
        (X"00000810", x"00002000", '0'),
        (X"00000814", x"00002040", '0'),
        (X"00000818", x"00002080", '0'),
        (X"0000081C", x"000020C0", '0'),
        (X"00000820", x"00004000", '0'),
        (X"00000824", x"00004040", '0'),
        (X"00000828", x"00004080", '0'),
        (X"0000082C", x"000040C0", '0'),
        (X"00000830", x"00006000", '0'),
        (X"00000834", x"00006040", '0'),
        (X"00000838", x"00006080", '0'),
        (X"0000083C", x"000060C0", '0'),
        (X"00000840", x"00008000", '0'),
        (X"00000844", x"00008040", '0'),
        (X"00000848", x"00008080", '0'),
        (X"0000084C", x"000080C0", '0'),
        (X"00000850", x"0000A000", '0'),
        (X"00000854", x"0000A040", '0'),
        (X"00000858", x"0000A080", '0'),
        (X"0000085C", x"0000A0C0", '0'),
        (X"00000860", x"0000C000", '0'),
        (X"00000864", x"0000C040", '0'),
        (X"00000868", x"0000C080", '0'),
        (X"0000086C", x"0000C0C0", '0'),
        (X"00000870", x"0000E000", '0'),
        (X"00000874", x"0000E040", '0'),
        (X"00000878", x"0000E080", '0'),
        (X"0000087C", x"0000E0C0", '0'),
        (X"00000880", x"00200000", '0'),
        (X"00000884", x"00200040", '0'),
        (X"00000888", x"00200080", '0'),
        (X"0000088C", x"002000C0", '0'),
        (X"00000890", x"00202000", '0'),
        (X"00000894", x"00202040", '0'),
        (X"00000898", x"00202080", '0'),
        (X"0000089C", x"002020C0", '0'),
        (X"000008A0", x"00204000", '0'),
        (X"000008A4", x"00204040", '0'),
        (X"000008A8", x"00204080", '0'),
        (X"000008AC", x"002040C0", '0'),
        (X"000008B0", x"00206000", '0'),
        (X"000008B4", x"00206040", '0'),
        (X"000008B8", x"00206080", '0'),
        (X"000008BC", x"002060C0", '0'),
        (X"000008C0", x"00208000", '0'),
        (X"000008C4", x"00208040", '0'),
        (X"000008C8", x"00208080", '0'),
        (X"000008CC", x"002080C0", '0'),
        (X"000008D0", x"0020A000", '0'),
        (X"000008D4", x"0020A040", '0'),
        (X"000008D8", x"0020A080", '0'),
        (X"000008DC", x"0020A0C0", '0'),
        (X"000008E0", x"0020C000", '0'),
        (X"000008E4", x"0020C040", '0'),
        (X"000008E8", x"0020C080", '0'),
        (X"000008EC", x"0020C0C0", '0'),
        (X"000008F0", x"0020E000", '0'),
        (X"000008F4", x"0020E040", '0'),
        (X"000008F8", x"0020E080", '0'),
        (X"000008FC", x"0020E0C0", '0'),
        (X"00000900", x"00400000", '0'),
        (X"00000904", x"00400040", '0'),
        (X"00000908", x"00400080", '0'),
        (X"0000090C", x"004000C0", '0'),
        (X"00000910", x"00402000", '0'),
        (X"00000914", x"00402040", '0'),
        (X"00000918", x"00402080", '0'),
        (X"0000091C", x"004020C0", '0'),
        (X"00000920", x"00404000", '0'),
        (X"00000924", x"00404040", '0'),
        (X"00000928", x"00404080", '0'),
        (X"0000092C", x"004040C0", '0'),
        (X"00000930", x"00406000", '0'),
        (X"00000934", x"00406040", '0'),
        (X"00000938", x"00406080", '0'),
        (X"0000093C", x"004060C0", '0'),
        (X"00000940", x"00408000", '0'),
        (X"00000944", x"00408040", '0'),
        (X"00000948", x"00408080", '0'),
        (X"0000094C", x"004080C0", '0'),
        (X"00000950", x"0040A000", '0'),
        (X"00000954", x"0040A040", '0'),
        (X"00000958", x"0040A080", '0'),
        (X"0000095C", x"0040A0C0", '0'),
        (X"00000960", x"0040C000", '0'),
        (X"00000964", x"0040C040", '0'),
        (X"00000968", x"0040C080", '0'),
        (X"0000096C", x"0040C0C0", '0'),
        (X"00000970", x"0040E000", '0'),
        (X"00000974", x"0040E040", '0'),
        (X"00000978", x"0040E080", '0'),
        (X"0000097C", x"0040E0C0", '0'),
        (X"00000980", x"00600000", '0'),
        (X"00000984", x"00600040", '0'),
        (X"00000988", x"00600080", '0'),
        (X"0000098C", x"006000C0", '0'),
        (X"00000990", x"00602000", '0'),
        (X"00000994", x"00602040", '0'),
        (X"00000998", x"00602080", '0'),
        (X"0000099C", x"006020C0", '0'),
        (X"000009A0", x"00604000", '0'),
        (X"000009A4", x"00604040", '0'),
        (X"000009A8", x"00604080", '0'),
        (X"000009AC", x"006040C0", '0'),
        (X"000009B0", x"00606000", '0'),
        (X"000009B4", x"00606040", '0'),
        (X"000009B8", x"00606080", '0'),
        (X"000009BC", x"006060C0", '0'),
        (X"000009C0", x"00608000", '0'),
        (X"000009C4", x"00608040", '0'),
        (X"000009C8", x"00608080", '0'),
        (X"000009CC", x"006080C0", '0'),
        (X"000009D0", x"0060A000", '0'),
        (X"000009D4", x"0060A040", '0'),
        (X"000009D8", x"0060A080", '0'),
        (X"000009DC", x"0060A0C0", '0'),
        (X"000009E0", x"0060C000", '0'),
        (X"000009E4", x"0060C040", '0'),
        (X"000009E8", x"0060C080", '0'),
        (X"000009EC", x"0060C0C0", '0'),
        (X"000009F0", x"0060E000", '0'),
        (X"000009F4", x"0060E040", '0'),
        (X"000009F8", x"0060E080", '0'),
        (X"000009FC", x"0060E0C0", '0'),
        (X"00000A00", x"00800000", '0'),
        (X"00000A04", x"00800040", '0'),
        (X"00000A08", x"00800080", '0'),
        (X"00000A0C", x"008000C0", '0'),
        (X"00000A10", x"00802000", '0'),
        (X"00000A14", x"00802040", '0'),
        (X"00000A18", x"00802080", '0'),
        (X"00000A1C", x"008020C0", '0'),
        (X"00000A20", x"00804000", '0'),
        (X"00000A24", x"00804040", '0'),
        (X"00000A28", x"00804080", '0'),
        (X"00000A2C", x"008040C0", '0'),
        (X"00000A30", x"00806000", '0'),
        (X"00000A34", x"00806040", '0'),
        (X"00000A38", x"00806080", '0'),
        (X"00000A3C", x"008060C0", '0'),
        (X"00000A40", x"00808000", '0'),
        (X"00000A44", x"00808040", '0'),
        (X"00000A48", x"00808080", '0'),
        (X"00000A4C", x"008080C0", '0'),
        (X"00000A50", x"0080A000", '0'),
        (X"00000A54", x"0080A040", '0'),
        (X"00000A58", x"0080A080", '0'),
        (X"00000A5C", x"0080A0C0", '0'),
        (X"00000A60", x"0080C000", '0'),
        (X"00000A64", x"0080C040", '0'),
        (X"00000A68", x"0080C080", '0'),
        (X"00000A6C", x"0080C0C0", '0'),
        (X"00000A70", x"0080E000", '0'),
        (X"00000A74", x"0080E040", '0'),
        (X"00000A78", x"0080E080", '0'),
        (X"00000A7C", x"0080E0C0", '0'),
        (X"00000A80", x"00A00000", '0'),
        (X"00000A84", x"00A00040", '0'),
        (X"00000A88", x"00A00080", '0'),
        (X"00000A8C", x"00A000C0", '0'),
        (X"00000A90", x"00A02000", '0'),
        (X"00000A94", x"00A02040", '0'),
        (X"00000A98", x"00A02080", '0'),
        (X"00000A9C", x"00A020C0", '0'),
        (X"00000AA0", x"00A04000", '0'),
        (X"00000AA4", x"00A04040", '0'),
        (X"00000AA8", x"00A04080", '0'),
        (X"00000AAC", x"00A040C0", '0'),
        (X"00000AB0", x"00A06000", '0'),
        (X"00000AB4", x"00A06040", '0'),
        (X"00000AB8", x"00A06080", '0'),
        (X"00000ABC", x"00A060C0", '0'),
        (X"00000AC0", x"00A08000", '0'),
        (X"00000AC4", x"00A08040", '0'),
        (X"00000AC8", x"00A08080", '0'),
        (X"00000ACC", x"00A080C0", '0'),
        (X"00000AD0", x"00A0A000", '0'),
        (X"00000AD4", x"00A0A040", '0'),
        (X"00000AD8", x"00A0A080", '0'),
        (X"00000ADC", x"00A0A0C0", '0'),
        (X"00000AE0", x"00A0C000", '0'),
        (X"00000AE4", x"00A0C040", '0'),
        (X"00000AE8", x"00A0C080", '0'),
        (X"00000AEC", x"00A0C0C0", '0'),
        (X"00000AF0", x"00A0E000", '0'),
        (X"00000AF4", x"00A0E040", '0'),
        (X"00000AF8", x"00A0E080", '0'),
        (X"00000AFC", x"00A0E0C0", '0'),
        (X"00000B00", x"00C00000", '0'),
        (X"00000B04", x"00C00040", '0'),
        (X"00000B08", x"00C00080", '0'),
        (X"00000B0C", x"00C000C0", '0'),
        (X"00000B10", x"00C02000", '0'),
        (X"00000B14", x"00C02040", '0'),
        (X"00000B18", x"00C02080", '0'),
        (X"00000B1C", x"00C020C0", '0'),
        (X"00000B20", x"00C04000", '0'),
        (X"00000B24", x"00C04040", '0'),
        (X"00000B28", x"00C04080", '0'),
        (X"00000B2C", x"00C040C0", '0'),
        (X"00000B30", x"00C06000", '0'),
        (X"00000B34", x"00C06040", '0'),
        (X"00000B38", x"00C06080", '0'),
        (X"00000B3C", x"00C060C0", '0'),
        (X"00000B40", x"00C08000", '0'),
        (X"00000B44", x"00C08040", '0'),
        (X"00000B48", x"00C08080", '0'),
        (X"00000B4C", x"00C080C0", '0'),
        (X"00000B50", x"00C0A000", '0'),
        (X"00000B54", x"00C0A040", '0'),
        (X"00000B58", x"00C0A080", '0'),
        (X"00000B5C", x"00C0A0C0", '0'),
        (X"00000B60", x"00C0C000", '0'),
        (X"00000B64", x"00C0C040", '0'),
        (X"00000B68", x"00C0C080", '0'),
        (X"00000B6C", x"00C0C0C0", '0'),
        (X"00000B70", x"00C0E000", '0'),
        (X"00000B74", x"00C0E040", '0'),
        (X"00000B78", x"00C0E080", '0'),
        (X"00000B7C", x"00C0E0C0", '0'),
        (X"00000B80", x"00E00000", '0'),
        (X"00000B84", x"00E00040", '0'),
        (X"00000B88", x"00E00080", '0'),
        (X"00000B8C", x"00E000C0", '0'),
        (X"00000B90", x"00E02000", '0'),
        (X"00000B94", x"00E02040", '0'),
        (X"00000B98", x"00E02080", '0'),
        (X"00000B9C", x"00E020C0", '0'),
        (X"00000BA0", x"00E04000", '0'),
        (X"00000BA4", x"00E04040", '0'),
        (X"00000BA8", x"00E04080", '0'),
        (X"00000BAC", x"00E040C0", '0'),
        (X"00000BB0", x"00E06000", '0'),
        (X"00000BB4", x"00E06040", '0'),
        (X"00000BB8", x"00E06080", '0'),
        (X"00000BBC", x"00E060C0", '0'),
        (X"00000BC0", x"00E08000", '0'),
        (X"00000BC4", x"00E08040", '0'),
        (X"00000BC8", x"00E08080", '0'),
        (X"00000BCC", x"00E080C0", '0'),
        (X"00000BD0", x"00E0A000", '0'),
        (X"00000BD4", x"00E0A040", '0'),
        (X"00000BD8", x"00E0A080", '0'),
        (X"00000BDC", x"00E0A0C0", '0'),
        (X"00000BE0", x"00E0C000", '0'),
        (X"00000BE4", x"00E0C040", '0'),
        (X"00000BE8", x"00E0C080", '0'),
        (X"00000BEC", x"00E0C0C0", '0'),
        (X"00000BF0", x"00E0E000", '0'),
        (X"00000BF4", x"00E0E040", '0'),
        (X"00000BF8", x"00E0E080", '0'),
        (X"00000BFC", x"00E0E0C0", '0'),
        (CTRL_REG_ADDR,x"00000901", '0'), --   program control register (VEN=1 (video enabled), PC=1 (pseudo-color), CD=11 (32 bits))                                                
        -- end list
        (x"00000000",x"00000000", '1')  --38 stop testbench
    );
    
    constant PACMAN_LINE_RESOLUTION : integer := 288;

begin
    -- Partie destinée à configurer le controlleur VGA
    -- Une fois le controlleur initialisé, on met VGA_CONTROL_INIT_DONE = 1 
    -- ce qui permettra de démarrer les autres composants (Z80, ULA,...).
    
	process(i_clk_52m, i_reset)
	begin
        if (i_reset = '1') then
            state <= chk_stop;
            icnt <= 0;
            s_cyc_o <= '0';
            s_stb_vga_o <= '0';
            s_adr_o <= X"FFFFFFFF";
            s_dat_o <= (others => 'X');
            s_we_o  <= 'X';
            s_sel_o <= (others => 'X');
            vga_controller_ok <= '0';
            init_timer <= 0;
            
        elsif rising_edge(i_clk_52m) then    
              case state is
                when wait_init =>
                    init_timer <= init_timer + 1;
                    if init_timer = 500 then
                        state <= chk_stop;
                    end if;
                when chk_stop =>
                    s_cyc_o <= '0';
                    s_stb_vga_o <= 'X';
                    s_adr_o <= (others => 'X');
                    s_dat_o <= (others => 'X');
                    s_we_o  <= 'X';
                    s_sel_o <= (others => 'X');
                    if (vectors(icnt).stop = '0') then
                        state <= gen_cycle;
                    else
                        state <= idle;
                    end if;
               when gen_cycle =>
                    s_cyc_o <= '1';
                    s_stb_vga_o <= '1';
                    s_adr_o <= vectors(icnt).adr;
                    s_dat_o <= vectors(icnt).dat;
                    s_we_o <= '1';
                    s_sel_o <= "1111";
                    state <= wait_for_ack;
               when wait_for_ack =>
                    if s_ack_i = '1' then
                        state <= chk_stop;
                        icnt <= icnt + 1;
                    end if;
               when idle =>
                    s_stb_vga_o <= '0';
                    s_cyc_o <= '0';
                    s_we_o  <= '0';
                    vga_controller_ok <= '1';
               end case;
        end if;
    end process;
    
    -- PortA : Côté écriture (8 bits)
    -- PortB : Côté lecture (16 bits)
    u1: blk_mem_gen_video_ram port map (
        clka => i_sys_clk, -- Write side 6,144 MHz
        wea(0) => '1',
        addra => std_logic_vector(video_mem_addr_pacman),
        dina => video_mem_pacman_data,
        clkb => not i_clk_52m, -- Read side 52 MHz
        web(0) => '0',
        addrb => video_dpram_vga_core_addr,
        dinb => (others => '0'),
        doutb => video_mem_vga_core_data
    );
        
    process(i_sys_clk)
    begin
        -- Reset ou top trame
        if ((i_reset = '1') or (i_vsync = '0')) then
            video_mem_addr_pacman <= (others => '0');
        elsif rising_edge(i_sys_clk) and i_blank = '0' then
            video_mem_addr_pacman <= video_mem_addr_pacman + 1;
        end if;
    end process;

    video_mem_pacman_data <= i_rgb(18 downto 16) & i_rgb(10 downto 8) & i_rgb(1 downto 0);
	
    -- Détection ligne paires/impaires pour le doublement des lignes
    -- L'image VGA est configurée en 288*2 horizontalement et 224*2 verticalement.
    -- Le controlleur VGA lit 4 pixels par 4 pixels. On lit 2 pixels dans la DPRAM et ils sont dupliqués pour retourner 4 pixels au controlleur VGA
    -- Principe:
    -- Les adresses controlleur VGA vont de N à N + 575
    -- Les adresses DPRAM VGA vont de M à M + 143 (144 * 4 = 576)
    -- L'adresse RAM controlleur VGA est divisée par 4 et on soustrait 0x90 un ligne sur deux pour revenir au debut de la ligne
    -- precedente pour dupliquer les lignes.
    -- vga_adr_o: Adresse côté controlleur VGA
    -- vga_odd_line: indique les lignes paires ou impaires par rapport à l'adresse controlleur VGA
    -- vga_addr_even_line_start: Adresse de debut de la ligne controlleur VGA / 4
    -- Exemples:
    -- Adresse controlleur VGA: (les adresses sont incrementees 4 par 4 et retournent 32 bits)
    -- Ligne 0: 0x000 ... 0x23F
    -- Ligne 1: 0x240 ... 0x47F
    -- Ligne 2: 0x480 ... 0x6BF
    -- Ligne 3: 0x6C0 ... 0x8FF
    -- Ligne 4: 0x900 ... 0xB3F
    -- Ligne 5: 0xB40 ... 0xD7F
    -- ...
    -- Adresse DPRAM : (les adresses sont incrementees 1 par 1 et retournent 16 bits)
    -- Ligne 0: 0x000 ... 0x08F ([0x0..0x23F] / 4 - vga_frame_offset (0x00)
    -- Ligne 1: 0x000 ... 0x08F ([0x240..0x47F] / 4 - vga_frame_offset (0x90))
    -- Ligne 2: 0x090 ... 0x11F  ([0x480..0x6BF] / 4  - vga_frame_offset (0x90))
    -- Ligne 3: 0x090 ... 0x11F  ([0x6C0..0x8FF] / 4  - vga_frame_offset (0x120))
    -- Ligne 4: 0x120 ... 0x1AF  ([0x900..0xB3F] / 4  - vga_frame_offset (0x120))
    -- Ligne 4: 0x120 ... 0x1AF  ([0xB40..0xD7F] / 4  - vga_frame_offset (0x1B0))
    -- ...
	process(i_clk_52m, i_reset)
    begin
        if (i_reset = '1' or vga_adr_o = X"00000000") then
            vga_frame_offset <= (others => '0');
            vga_addr_even_line_start <= (others => '0');
            vga_odd_line <= '0';
        elsif rising_edge(i_clk_52m) then
            if unsigned("00" & vga_adr_o(31 downto 2)) - vga_addr_even_line_start = X"0000090" then
                -- A remplacer par un type std_logic comme on ne regarde qu'un bit ?
                vga_odd_line <= not vga_odd_line;
                vga_addr_even_line_start <= unsigned("00" & vga_adr_o(31 downto 2));
                if vga_odd_line = '0' then
                    vga_frame_offset <= vga_frame_offset + X"0090";
                end if;
            end if;
        end if;
    end process;
    
    video_dpram_vga_core_addr_l <= std_logic_vector(unsigned("00" & vga_adr_o(31 downto 2)) - vga_frame_offset);
    video_dpram_vga_core_addr <= video_dpram_vga_core_addr_l(14 downto 0);
    -- La DPRAM retourne 2 pixels sur 8 bits qui sont dupliqués retournes au controlleur VGA.
    vga_dat_i <=  video_mem_vga_core_data(7 downto 0) & video_mem_vga_core_data(7 downto 0) & video_mem_vga_core_data(15 downto 8) & video_mem_vga_core_data(15 downto 8);

    o_vga_control_init_done <= vga_controller_ok;

	--
	-- hookup vga + clut core
	--
	-- Contrôleur VGA s'interfaçant avec le U3 (vid_mem)
	u2: vga_enh_top port map (
        wb_clk_i => i_clk_52m, wb_rst_i => '0', rst_i => not i_reset,
        
        wbs_adr_i => s_adr_o(11 downto 0), wbs_dat_i => s_dat_o, 
        wbs_sel_i => s_sel_o, wbs_we_i => s_we_o, wbs_stb_i => s_stb_vga_o,
		wbs_cyc_i => s_cyc_o, wbs_ack_o => s_ack_i,
		
		wbm_adr_o => vga_adr_o, wbm_dat_i => vga_dat_i, wbm_stb_o => vga_stb_o,
		wbm_cyc_o => vga_cyc_o, wbm_ack_i => vga_ack_i, wbm_err_i => '0',
		
		clk_p_i => i_vga_clk, hsync_pad_o => hsync_vga, vsync_pad_o => vsync_vga, csync_pad_o => o_csync, blank_pad_o => o_blank,
		r_pad_o => r_vgac, g_pad_o => g_vgac, b_pad_o => b_vgac	
	);    
    
    -- Acquittement immédiat
    vga_ack_i <= '1' when (vga_cyc_o = '1') and (vga_stb_o = '1') else '0'; 
 
    o_hsync <= hsync_vga;
    o_vsync <= vsync_vga;
    o_r <= r_vgac(7 downto 5); 
    o_g <= g_vgac(7 downto 5);
    o_b <= b_vgac(7 downto 6);
    
end architecture Behavioral;
