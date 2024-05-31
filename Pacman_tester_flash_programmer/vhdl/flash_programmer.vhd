----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.06.2023 20:33:05
-- Design Name: 
-- Module Name: flash_programmer - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.replay_pack.all;
use work.replay_lib_wrap_pack.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PacMan_HW_Tester is
  port (

    -- System clock
    i_clk_sys             : in  std_logic;
    -- Core reset
    i_rst_sysn            : in  std_logic;
    
    i_cpu_a_core          : in std_logic_vector(15 downto 0);
    o_cpu_di_core         : out std_logic_vector(7 downto 0);
    i_cpu_do_core         : in std_logic_vector(7 downto 0);
    
    o_cpu_rst_core        : out std_logic;
    o_cpu_clk_core        : out std_logic;
    i_cpu_m1_l_core       : in std_logic;
    i_cpu_mreq_l_core     : in std_logic;
    i_cpu_rd_l_core       : in std_logic;
    i_cpu_wr_l_core       : in std_logic;
    i_cpu_rfrsh_l_core    : in std_logic;
    i_cpu_iorq_l          : in std_logic;
    o_cpu_waitn           : out std_logic;
    o_cpu_intn            : out std_logic;
        
    -- Z80 pacman code en memoire flash
    o_flash_cs_l_core       : out std_logic; -- Flash CS
    -- Buffer enable data core vers CPU/
    o_do_core_enable_n       : out std_logic; -- Flash CS
    
    -- VGA
    o_vga                 : out r_VGA_to_core;
    
    -- Son
    o_vol : out std_logic_vector(3 downto 0); 
    o_wav : out std_logic_vector(3 downto 0);
    
    -- UART
    o_uart_tx : out std_logic;
    i_uart_rx : in std_logic;
    
    -- Registres I/O
    i_config_reg     : in std_logic_vector(7 downto 0);
    
    -- Dip switch, crédits, joystick
    o_in0_l_cs       : out std_logic; -- Read IN1
    o_in1_l_cs       : out std_logic; -- Read IN2
    o_dip_l_cs       : out std_logic; -- Read DIP switches 
    
    -- CPU freeze
    i_freeze         : in std_logic -- CPU freeze switch
  );
end PacMan_HW_Tester;

architecture Behavioral of PacMan_HW_Tester is

signal z80_clk, z80_rst, z80_wait_n, z80_int_n, z80_m1_n, z80_mreq_n, z80_iorq_n : std_logic;
signal z80_rd_n, z80_wr_n, z80_rfrsh_n, main_clk, rst_sys_n : std_logic;
signal in0_cs, in1_cs, dip_sw_cs, uart_cs, uart_clk : std_logic;
signal pacman_core_data, z80_data, uart_data, uart_reg, pacman_roms_data : std_logic_vector(7 downto 0);
signal pacman_core_vol, pacman_core_wav : std_logic_vector(3 downto 0);
signal cpu_mreq_0 : std_logic;

signal z80_a : std_logic_vector(15 downto 0);

type wb_state is (wb_idle, wb_wait_for_ack, wb_wait_for_rd_or_wr_cycle);
signal uart_wb_we, uart_wb_stb, uart_wb_cyc, uart_wb_ack : std_logic;
signal wb_bus_state : wb_state;

begin

   ---------------------
   -- PacMan core top --
   ---------------------
   core_top_0 : entity work.Core_Top
   port map (
        -- Paramètres de gestion du core:
        -- garder ena_sys, rst_sys_n, halt, sys_clk => A configurer dans la partie simulation
        i_clk_main          =>    main_clk,
        i_rst_sys_n         =>    rst_sys_n,
        -- i_cfg         =>    sim_config,
        -- Keyboard, Mouse and Joystick
        -- Conserver les entrées joy_a et joy_b:
        -- BOT 5-Fire2, 4-Fire1, 3-Right 2-Left, 1-Back, 0-Forward (active low)
        -- i_kb_ms_joy   =>    sim_joystick,
        
        -- Boutons start1 / start2 / credit (active low)
        -- i_kbut        =>    sim_start_credit_buttons
    
        -- Audio/Video
        -- o_av                  : out   r_AV_fm_core
        
        -- z80    
        i_cpu_a_core        => z80_a,
        o_cpu_di_core       => pacman_core_data,
        i_cpu_do_core       => z80_data,
    
        o_cpu_rst_core      => z80_rst,
        o_cpu_clk_core      => z80_clk,
        o_uart_clk_core     => uart_clk, -- 18 MHz
        o_cpu_wait_l_core   => z80_wait_n,
        o_cpu_int_l_core    => z80_int_n,
        i_cpu_m1_l_core     => z80_m1_n,
        i_cpu_mreq_l_core   => z80_mreq_n,
        i_cpu_iorq_l_core   => z80_iorq_n,
        i_cpu_rd_l_core     => z80_rd_n,
        i_cpu_wr_l_core     => z80_wr_n,
        i_cpu_rfrsh_l_core  => z80_rfrsh_n,
        
        -- Registres de configuration (IN0, IN1, DIP SW)
        i_config_reg        => i_config_reg,
    
        -- DIPs
        o_in0_l_cs          => in0_cs,
        o_in1_l_cs          => in1_cs,
        o_dip_l_cs          => dip_sw_cs,
        
        -- Audio right/left
        o_audio_vol_out     => pacman_core_vol,
        o_audio_wav_out     => pacman_core_wav,  
        
        -- Video
        o_vga => o_vga,
        
        -- CPU freeze
        i_freeze => i_freeze
    );
    
    main_clk <= i_clk_sys;
    rst_sys_n <= i_clk_sys;
    
    o_cpu_waitn <= z80_wait_n;
    o_cpu_intn <= z80_int_n;
    o_cpu_clk_core <= z80_clk;
    o_cpu_rst_core <= z80_rst;
    
    z80_m1_n <= i_cpu_m1_l_core;
    z80_mreq_n <= i_cpu_mreq_l_core;
    z80_iorq_n <= i_cpu_iorq_l;
    z80_rd_n <= i_cpu_rd_l_core;
    z80_wr_n <= i_cpu_wr_l_core;
    z80_rfrsh_n <= i_cpu_rfrsh_l_core;
    z80_a <= i_cpu_a_core;
    z80_data <= i_cpu_do_core;
    
    o_vol <= pacman_core_vol;
    o_wav <= pacman_core_wav;
    
    o_in0_l_cs <= in0_cs;
    o_in1_l_cs <= in1_cs;
    o_dip_l_cs <= dip_sw_cs;
    
	 p_wb_manager : process(uart_clk, z80_rst)
	 begin
	   if (z80_rst = '0') then
	       wb_bus_state <= wb_idle;
            uart_wb_we <= '0';
            uart_wb_stb <= '0';
            uart_wb_cyc <= '0';
	   elsif rising_edge(uart_clk) then
	       cpu_mreq_0 <= i_cpu_mreq_l_core;
           if (wb_bus_state = wb_idle) then
                -- Declenchement d'un cycle WB sur validation MREQn
                if (uart_cs = '1' and cpu_mreq_0 = '1' and i_cpu_mreq_l_core = '0' and i_cpu_m1_l_core = '1') then
                    wb_bus_state <= wb_wait_for_rd_or_wr_cycle;
                end if;
           elsif (wb_bus_state = wb_wait_for_rd_or_wr_cycle) then
                if i_cpu_rd_l_core = '0' then
                    uart_wb_stb <= '1';
                    uart_wb_cyc <= '1';
                    wb_bus_state <= wb_wait_for_ack;
                elsif i_cpu_wr_l_core = '0' then
                    uart_wb_stb <= '1';
                    uart_wb_cyc <= '1';
                    uart_wb_we <= '1';
                    wb_bus_state <= wb_wait_for_ack;
                end if;
           elsif (wb_bus_state = wb_wait_for_ack) then
               if (uart_wb_ack = '1')  then
                    uart_wb_we <= '0';
                    uart_wb_stb <= '0';
                    uart_wb_cyc <= '0';
                   -- Memorise le registre de l'UART quand wb_ack = 1 pour la fin du cycle
                   -- du Z80 qui arrive plus tard 
                   uart_reg <= uart_data;
                   wb_bus_state <= wb_idle;
               end if;
           end if;
       end if;
   end process;

   -- 
   -- UART
   -- 
   uart : entity work.uart_top
   port map (
       wb_clk_i =>  uart_clk,
	   -- Wishbone signals
	   wb_rst_i => not z80_rst,
	   wb_adr_i => i_cpu_a_core(2 downto 0),
	   wb_dat_i => i_cpu_do_core,
	   wb_dat_o => uart_data,
	   wb_we_i => uart_wb_we,
	   wb_stb_i => uart_wb_stb, 
	   wb_cyc_i => uart_wb_cyc,
	   wb_ack_o => uart_wb_ack,
	   wb_sel_i => "1111",
	   -- int_o -- interrupt request

	   -- UART	signals
	   -- serial input/output
	   stx_pad_o => o_uart_tx,
	   srx_pad_i => i_uart_rx,

	   -- modem signals
	   -- rts_pad_o
	   cts_pad_i => '0',
	   -- dtr_pad_o
	   dsr_pad_i => '0',
	   ri_pad_i => '0',
	   dcd_pad_i => '0'
	);
                     
   -- Memory mapping:
   -- Gere par le core PacMan
   -- 0x0000 - 0x3FFF : Code programme du programmeur de flash (execute par le Z80) (16 K).
   -- 0x4000 - 0x43FF : RAM video tile.
   -- 0x4400 - 0x47FF : RAM video palette.
   -- 0x4800 - 0x4FEF : RAM Z80.
   -- 0x4FF0 - 0x4FFF : Registres de sprites.
   -- 0x5000 - 0x50FF : Mapped registers.
   --
   -- 0x6000 - 0x6005 : UART
   -- 0x8000 - 0xFFFF : Memoire flash
   -- Les adresses avec A15 = 0 sont prises en charge par le core PacMan
   p_data_decoder : process(i_cpu_a_core, i_cpu_rd_l_core, pacman_core_data, uart_data)
   begin
       o_do_core_enable_n <= '1'; 
       if i_cpu_rd_l_core = '0' then
         case i_cpu_a_core(15 downto 13) is
            -- UART (0x6)
            when "011" => 
                o_do_core_enable_n <= '0';
                o_cpu_di_core <= uart_reg;
            -- PacMan core
            when "000"|"001"|"010" => 
            -- when "001"|"010" => 
                o_do_core_enable_n <= '0';
                o_cpu_di_core <= pacman_core_data;
            when others => 
         end case;
      end if;
   end process;
    
   -- Address decoder
   uart_cs <= '1' when i_cpu_a_core(15 downto 13) = "011" else '0';
   o_flash_cs_l_core <= '0' when i_cpu_a_core(15) = '1' else '1';

end Behavioral;

