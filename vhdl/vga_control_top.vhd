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

library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
-- use ieee.numeric_std.shift_left;
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
        
        o_hsync : in std_logic; -- HSYNC output from controller VGA (vers connecteur VGA)
        o_vsync : in std_logic; -- VSYNC output from controller VGA (vers connecteur VGA)
        o_csync : in std_logic; -- CSYNC output from controller VGA (vers connecteur VGA)
        o_blank : in std_logic; -- BLANK output from controller VGA (vers connecteur VGA)
        o_r : out std_logic_vector(7 downto 0); -- R controller VGA
        o_g : in std_logic_vector(7 downto 0); -- G controller VGA
        o_b : in std_logic_vector(7 downto 0); -- B controller VGA                

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
    
    type vector_list is array(0 to 8) of vector_type;

	-- signal declarations
	signal rst_vga : std_logic := '1';
	signal state : states;
	signal icnt, init_timer : natural := 0;
	signal vga_controller_ok : std_logic;
	signal vga_even_line : std_logic;
	signal video_mem_addr_pacman : unsigned(15 downto 0);
	signal video_mem_vga_core_addr : std_logic_vector(14 downto 0);
	signal video_mem_pacman_data : std_logic_vector(7 downto 0);
	signal video_mem_vga_core_data : std_logic_vector(15 downto 0);
	signal hsync_0, hsync_1 : std_logic;
	signal i_vga_even_line : std_logic;
	
    -- wishbone host
	signal s_cyc_o, s_we_o : std_logic;
	signal s_adr_o                  : std_logic_vector(31 downto 0);
	signal s_dat_o, s_dat_i         : std_logic_vector(31 downto 0);
	signal s_sel_o                  : std_logic_vector(3 downto 0);
	signal s_ack_i, s_err_i         : std_logic;
	signal s_stb_vga_o : std_logic;
	
    -- vga master
	signal vga_adr_o                       : std_logic_vector(31 downto 0);
	signal vga_dat_i                       : std_logic_vector(31 downto 0);
	signal vga_stb_o, vga_cyc_o, vga_ack_i : std_logic;
	signal vga_sel_o                       : std_logic_vector(3 downto 0);
	signal vga_we_o                        : std_logic;
	
	signal i_video_addr_0 : std_logic_vector(19 downto 0);
    signal i_video_data_0 : std_logic_vector(1 downto 0);
    signal i_wr_cyc_0 : std_logic;
        
    attribute ASYNC_REG : string;
    attribute ASYNC_REG of i_video_addr_0 : signal is "TRUE";
    attribute ASYNC_REG of i_video_data_0 : signal is "TRUE";
    attribute ASYNC_REG of i_wr_cyc_0 : signal is "TRUE";
	
	shared variable vectors : vector_list :=
    (
        -- Mode Resolution Refresh Pulse Back porch Active time Front porch Line Total
        --              rate  MHz       usec    pix     pix     pix     pix     pix
        -- QVGA 320x240 60 Hz
        -- VGA 640x480  60 Hz 25.175    3.81    96      45      646     13      800
        -- VGA 640x480  72 Hz 31.5      1.27    40      125     646     21      832
        -- SVGA 800x600 56 Hz 36        2       72      125     806     21      1024
        -- SVGA 800x600 60 Hz 40        3.2     128     85      806     37      1056        <<<===
        -- SVGA 800x600 72 Hz 50        2.4     120     61      806     53      1040

        -- program vga controller
        (VBARa_REG_ADDR,x"00000000", '0'), --   program video base address 0 register (VBARa)
        (VBARb_REG_ADDR,x"00100000", '0'), --   program video base address 0 register (VBARb). Pas utilisé
        -- Pour le cas du ZX81, le mode choisit et une résolution de 640 x 480 avec un affichage de:
        -- Thsync : 96 pixels
        -- Thgdel (back porch) : 240 pixels
        -- Thgate : 384 pixels
        -- Front porch = 800 - (96+240+384) = 80 pixels
        -- (HTIM_REG_ADDR,x"5F9F017F", '0'), -- program horizontal timing register (384*480)
        (HTIM_REG_ADDR,x"5F32027F", '0'), -- program horizontal timing register (640*480)
        -- Pour les lignes, il y a en tout 525 lignes
        -- => Sync pulse = 2 lignes
        -- => active time = 479 lignes (il faut une ligne de moins car sinon, on dépasse la mémoire ???)
        -- => back porch = 30
        -- => front porch = 600 - (2+30+479) = 89 lignes
        (VTIM_REG_ADDR,x"011D01DE", '0'), --   program vertical timing register
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
        (CLUT_REG_ADDR_1,x"00E0E0E0", '0'),
        (CLUT_REG_ADDR_2,x"00000000", '0'),
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
        clka => i_sys_clk,
        wea(0) => '1',
        addra => std_logic_vector(video_mem_addr_pacman),
        dina => video_mem_pacman_data,
        clkb => i_clk_52m,
        web(0) => '0',
        addrb => video_mem_vga_core_addr,
        dinb => "0000000000000000",
        doutb => video_mem_vga_core_data
    );
        
    process(i_sys_clk)
    begin
        -- Reset ou top trame
        if ((i_reset = '1') or (i_vsync = '1' and i_blank = '1')) then
            video_mem_addr_pacman <= (others => '0');
        elsif rising_edge(i_sys_clk) then
            video_mem_addr_pacman <= video_mem_addr_pacman + 1;
        end if;
    end process;

    video_mem_pacman_data <= i_rgb(18 downto 16) & i_rgb(10 downto 8) & i_rgb(1 downto 0);
	
    -- Détection ligne paires/impaires pour le doublement des lignes
	process(i_clk_52m, i_reset, o_vsync)
    begin
        if (i_reset = '1' or o_vsync = '1') then
            vga_even_line <= '1';
        elsif rising_edge(i_clk_52m) then
            hsync_0 <= o_hsync;
            hsync_1 <= hsync_0;
            -- Front montant hsync controlleur VGA
            if hsync_0 = '1' and hsync_1 = '0' then
                vga_even_line <= not vga_even_line;
            end if;
        end if;
    end process;
    
    o_vga_control_init_done <= vga_controller_ok;

	--
	-- hookup vga + clut core
	--
	-- Contrôleur VGA s'interfaçant avec le U3 (vid_mem)
	u2: vga_enh_top port map (
        wb_clk_i => i_clk_52m, wb_rst_i => '0', rst_i => not i_reset,
        
        wbs_adr_i => s_adr_o(11 downto 0), wbs_dat_i => s_dat_o, wbs_dat_o => s_dat_i, 
        wbs_sel_i => s_sel_o, wbs_we_i => s_we_o, wbs_stb_i => s_stb_vga_o,
		wbs_cyc_i => s_cyc_o, wbs_ack_o => s_ack_i, wbs_err_o => s_err_i,
		
		wbm_adr_o => vga_adr_o, wbm_dat_i => vga_dat_i, wbm_sel_o => vga_sel_o, wbm_stb_o => vga_stb_o,
		wbm_cyc_o => vga_cyc_o, wbm_ack_i => vga_ack_i, wbm_err_i => '0',
		
		clk_p_i => i_vga_clk, hsync_pad_o => o_hsync, vsync_pad_o => o_vsync, csync_pad_o => o_csync, blank_pad_o => o_blank,
		r_pad_o => o_r, g_pad_o => o_g, b_pad_o => o_b	
	);
                
    video_mem_vga_core_addr <= unsigned(vga_adr_o(15 downto 1)) - PACMAN_LINE_RESOLUTION when i_vga_even_line <= '0' else vga_adr_o(15 downto 1);
    vga_dat_i <= video_mem_vga_core_data & video_mem_vga_core_data;
    
    -- Acquittement immédiat
    vga_ack_i <= '1' when (vga_cyc_o = '1') and (vga_stb_o = '1') else '0';                

end architecture Behavioral;
