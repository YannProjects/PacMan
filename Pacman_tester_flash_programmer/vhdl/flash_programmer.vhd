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
    
    -- CPU data
    -- Port bidirectionnel sur DI_Core et DO_Core
    io_cpu_data_bidir        : inout word(7 downto 0);
    -- Data dir
    o_buffer_dir             : out bit1;
    -- Tri-state buffer enable
    o_buffer_enable_n        : out bit1;
    
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

signal in0_cs, in1_cs, dip_sw_cs, uart_cs, uart_clk : bit1;
signal uart_data, uart_reg : word(7 downto 0);
signal pacman_core_vol, pacman_core_wav : word(3 downto 0);
signal cpu_mreq_0, z80_rst_n : bit1;

type wb_state is (wb_idle, wb_wait_for_ack, wb_wait_for_rd_or_wr_cycle);
signal uart_wb_we, uart_wb_stb, uart_wb_cyc, uart_wb_ack : bit1;
signal wb_bus_state : wb_state;

signal cpu_to_core_data, core_to_cpu_data, regs_data, rom_data : word(7 downto 0);

signal i_clk_52m, vga_clock, clk_6m, clk_6m_star, clk_6m_star_n : bit1;
signal pll_locked, flash_cs_l, uart_cs_l, rom_cs_l, sync_bus_cs_l : bit1;
signal core_to_cpu_en_l, cpu_to_core_en_l, core_to_cpu_n, cpu_to_core_n : bit1;
signal core_rst, hsync_l, vsync_l, csync_l, blank, blank_vga : bit1;
signal video_rgb : word(23 downto 0);
signal o_audio_vol_out, o_audio_wav_out : word(3 downto 0);
signal o_r, o_g, o_b : word(2 downto 0);
signal vga_control_init_done : bit1;

begin

  --
  -- Single clock domain used for system / video and audio
  --
  clk_gen_0 : entity work.Clocks_gen
  port map (
      -- 12 MHz CMOD S7
      i_clk_main => i_clk_sys,
      o_clk_52m => i_clk_52m,
      o_clk_vga => vga_clock,
      o_clk_6M => clk_6m,
      o_clk_18M => uart_clk,
      o_clk_6M_star => clk_6m_star,
      o_clk_6M_star_n => clk_6m_star_n,
      i_rst => not pll_locked,
      o_pll_locked => pll_locked
  );
  
  --
  -- primary addr decode
  --
  -- Memory mapping:
  -- Gere par le core PacMan
  -- 0x0000 - 0x3FFF : Code programme du programmeur de flash (execute par le Z80) (16 K).
  -- 0x4000 - 0x43FF : RAM video tile (via pacman core et sync_bus_cs_l)
  -- 0x4400 - 0x47FF : RAM video palette (via pacman core et sync_bus_cs_l)
  -- 0x4800 - 0x4FEF : RAM Z80 (via pacman core et sync_bus_cs_l)
  -- 0x4FF0 - 0x4FFF : Registres de sprites (via pacman core et sync_bus_cs_l)
  -- 0x5000 - 0x50FF : Mapped registers (via pacman core et sync_bus_cs_l)
  --
  -- 0x6000 - 0x6005 : UART
  -- 0x8000 - 0xFFFF : Memoire flash
  -- Les adresses avec A15 = 0 sont prises en charge par le core PacMan
   p_data_decoder : process(i_cpu_a_core, i_cpu_mreq_l_core, i_cpu_rfrsh_l_core, regs_data, uart_reg, rom_data)
   begin
      flash_cs_l <= '1';
      uart_cs_l <= '1';
      rom_cs_l <= '1';
      sync_bus_cs_l <= '1';
      if ((i_cpu_mreq_l_core = '0') and (i_cpu_rfrsh_l_core = '1')) then
         case i_cpu_a_core(15 downto 13) is
            -- UART (0x6)
            when "011" =>
                uart_cs_l <= '0';
                core_to_cpu_data <= uart_reg;
            -- Test rom
            when "000" =>
                rom_cs_l <= '0';
                core_to_cpu_data <= rom_data;
            -- PacMan core
            when "001"|"010" =>
                sync_bus_cs_l <= '0';
                core_to_cpu_data <= regs_data;
            -- Flash memory
            when "100" => flash_cs_l <= '0';
            when others => core_to_cpu_data <= (others => 'X');
         end case;
      end if;
   end process;
   
   
  -- Gestion buffer bidir
  core_to_cpu_en_l <= '0' when ((core_to_cpu_n = '0') or (((uart_cs_l = '0') or (rom_cs_l = '0')) and (i_cpu_rd_l_core = '0'))) else '1';
  cpu_to_core_en_l <= '0' when ((cpu_to_core_n = '0') or (uart_cs_l = '0' and i_cpu_wr_l_core = '0')) else '1';
  
  io_cpu_data_bidir <= core_to_cpu_data when core_to_cpu_en_l = '0' else (others => 'Z');
  cpu_to_core_data <= io_cpu_data_bidir when cpu_to_core_en_l = '0' else (others => 'Z');
  
  o_buffer_enable_n <= core_to_cpu_en_l and cpu_to_core_en_l;
  o_buffer_dir <= '1' when cpu_to_core_en_l = '0' else '0';  
    
  ---------------------
  -- PacMan core --
  ---------------------
  u_Core : entity work.Pacman_Top
  port map (
    --
    i_clk_pacman_core     => clk_6m,
    i_clk_6M_star         => clk_6m_star,
    i_clk_6M_star_n       => clk_6m_star_n,
    i_core_reset          => core_rst,  

    -- Signaux video PacMan core
    o_video_rgb           => video_rgb,
    o_hsync_l             => hsync_l,
    o_vsync_l             => vsync_l,
    o_csync_l             => csync_l,
    o_blank               => blank,

    -- Audio
    o_audio_vol_out       => o_audio_vol_out,
    o_audio_wav_out       => o_audio_wav_out,
    
    i_cpu_a               => i_cpu_a_core,
    
    o_cpu_di              => regs_data,
    i_cpu_do              => cpu_to_core_data,  
    
    o_cpu_rst             => z80_rst_n,
    o_cpu_clk             => o_cpu_clk_core,
    o_cpu_wait_l          => o_cpu_waitn,
    o_cpu_int_l           => o_cpu_intn,
    i_cpu_m1_l            => i_cpu_m1_l_core,
    i_cpu_mreq_l          => i_cpu_mreq_l_core,
    i_cpu_iorq_l          => i_cpu_iorq_l,
    i_cpu_rd_l            => i_cpu_rd_l_core,
    i_cpu_rfsh_l          => i_cpu_rfrsh_l_core,
    i_halt                => '0',
    
    -- Registres de configuration (INO, IN1, DIP SW)
    i_config_reg          => i_config_reg,
    
    -- Sync bus
    i_sync_bus_cs_l       => sync_bus_cs_l,
    
    -- Z80 code ROM
    o_core_to_cpu_en_l    => core_to_cpu_n,
    o_cpu_to_core_en_l    => cpu_to_core_n,
    
    o_in0_cs_l            => o_in0_l_cs,
    o_in1_cs_l            => o_in1_l_cs,
    o_dip_sw_cs_l         => o_dip_l_cs,
    
    i_freeze              => i_freeze
  );
  
 
  -- Controlleur VGA
  u_vga_ctrl : entity work.vga_control_top
  port map ( 
     -- i_reset => not i_rst_sys_n,
     i_reset => not pll_locked,
     i_clk_52m => i_clk_52m,
     i_vga_clk => vga_clock,
     i_sys_clk => clk_6m,
    
     -- Signaux video core Pacman
     i_vsync => vsync_l,
     i_blank => blank,
     i_rgb => video_rgb,
        
     -- Signaux video VGA
     o_hsync => o_vga.hsync,
     o_vsync => o_vga.vsync,
     o_blank => blank_vga,
     o_r => o_r,
     o_g => o_g,
     o_b => o_b,             
    
     o_vga_control_init_done => vga_control_init_done
  );

    
  u_pacman_tester_rom : entity work.hw_tester_rom
  port map (
    a => i_cpu_a_core(13 downto 0),
    spo => rom_data
  );  
    
  p_wb_manager : process(uart_clk, z80_rst_n)
  begin
	   if (z80_rst_n = '0') then
	       wb_bus_state <= wb_idle;
            uart_wb_we <= '0';
            uart_wb_stb <= '0';
            uart_wb_cyc <= '0';
	   elsif rising_edge(uart_clk) then
	       cpu_mreq_0 <= i_cpu_mreq_l_core;
           if (wb_bus_state = wb_idle) then
                -- Declenchement d'un cycle WB sur validation MREQn
                if (uart_cs_l = '0' and cpu_mreq_0 = '1' and i_cpu_mreq_l_core = '0' and i_cpu_m1_l_core = '1') then
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
	   wb_rst_i => not z80_rst_n,
	   wb_adr_i => i_cpu_a_core(2 downto 0),
	   wb_dat_i => cpu_to_core_data,
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
    
    o_vga.r_vga <= o_r when blank_vga = '0' else "000";
    o_vga.g_vga <= o_g when blank_vga = '0' else "000";
    o_vga.b_vga <= o_b when blank_vga = '0' else "000";
        
    o_vol <= pacman_core_vol;
    o_wav <= pacman_core_wav;
    
    o_in0_l_cs <= in0_cs;
    o_in1_l_cs <= in1_cs;
    o_dip_l_cs <= dip_sw_cs;
    
    o_flash_cs_l_core <= flash_cs_l;
    
    o_cpu_rst_core <= z80_rst_n;

    core_rst <= '1' when i_rst_sysn = '0' or  vga_control_init_done = '0' else '0';

end Behavioral;

