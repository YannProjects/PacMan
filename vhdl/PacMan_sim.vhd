----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.12.2021 19:54:58
-- Design Name: 
-- Module Name: PacMan_sim - Behavioral
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

use work.replay_pack.all;
use work.replay_lib_wrap_pack.all;
use work.Core_Pack.all;

entity PacMan_sim is
--  Port ( );
end PacMan_sim;

architecture Behavioral of PacMan_sim is

signal main_clk, rst_sys : bit1;

signal pacman_rom_addr : word(13 downto 0);
signal pacman_rom_data : word(7 downto 0);

constant clk_period : time := 81380 ps; -- 6 MHz
-- constant clk_period : time := 40690 ps; -- 24 MHz
constant z80_delay : time := 70 ns;

signal z80_a : word(15 downto 0);
signal z80_di, z80_do, D_bidir : word(7 downto 0);
signal z80_rst, z80_clk, z80_wait_l, z80_int_l, z80_nmi_l : bit1;
signal z80_busrq_l, z80_busack_l, z80_m1_l : bit1;
signal z80_mreq_l, z80_iorq_l, z80_rd_l, z80_wr_l: bit1;
signal z80_rfrsh_l, z80_halt_l, crom_cs : bit1;
signal in0_cs, in1_cs, dip_sw_cs : bit1;

signal z80_mreq_delay_l, z80_iorq_delay_l, z80_rd_delay_l, z80_wr_delay_l: bit1;
signal z80_rfrsh_delay_l, z80_m1_delay_l, z80_halt_delay_l: bit1;

signal cfg_dip_sw, in0_reg, in1_reg, config_reg : word(7 downto 0);

signal joy_a, joy_b : word(3 downto 0);
signal coins, buttons : word(1 downto 0);
signal credit, table, test : bit1;

begin
   -- A implémenter avec des switch sur la carte ou avec les joysticks / boutons
   joy_a <= b"1111";
   joy_b <= b"1111";
   coins <= b"11";
   buttons <= b"11";
   credit <= '1';
   table <= '1';
   test <= '1';

   -- 24.576 MHz CLK
   clk_process :process
   begin
        main_clk <= '0';
        wait for clk_period / 2;
        main_clk <= '1';
        wait for clk_period / 2;
   end process;
   
   core_top_0 : entity work.Core_Top
   port map (
        -- Paramètres de gestion du core:
        -- garder ena_sys, rst_sys, halt, sys_clk => A configurer dans la partie simulation
        i_clk_sys           =>    main_clk,
        i_rst_sys           =>    rst_sys,
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
        i_cpu_a_core        => z80_a, -- Asynchrone ???
        o_cpu_di_core       => z80_di, -- Relative à la virtual clock CPU (z80_clk) *
        i_cpu_do_core       => z80_do, -- sync i_clk_sys *
    
        o_cpu_rst_core      => z80_rst,
        o_cpu_clk_core      => z80_clk,
        o_cpu_wait_l_core   => z80_wait_l, -- Relative à la virtual clock CPU (z80_clk). Mais sur front descendant... *
        o_cpu_int_l_core    => z80_int_l, -- Relative à la virtual clock CPU (z80_clk) *
        i_cpu_m1_l_core     => z80_m1_l, -- sync i_clk_sys *
        i_cpu_mreq_l_core   => z80_mreq_l, -- Asynchrone ??? => i_clk_sys ? *
        i_cpu_iorq_l_core   => z80_iorq_l, -- sync i_clk_sys *
        i_cpu_rd_l_core     => z80_rd_l, -- Asynchrone ??? => i_clk_sys ? *
        i_cpu_wr_l_core     => z80_wr_l, -- Asynchrone ??? => i_clk_sys ? *
        i_cpu_rfrsh_l_core  => z80_rfrsh_l, -- Asynchrone ??? => i_clk_sys ? *
        
        -- Registres de configuration (IN0, IN1, DIP SW)
        i_config_reg        => config_reg,
    
        -- Z80 code ROM
        o_rom_cs_l_core     => crom_cs, -- Asynchrone ???
        o_in0_l_cs          => in0_cs,   -- Asynchrone ???
        o_in1_l_cs          => in1_cs, -- Asynchrone ???
        o_dip_l_cs          => dip_sw_cs -- Asynchrone ???
    );
    
    u_z80 : entity work.T80a
    port map (
		RESET_n	=> z80_rst,
		R800_mode => '0',
		CLK_n => z80_clk,
		WAIT_n => z80_wait_l,
		INT_n => z80_int_l,
		NMI_n => z80_nmi_l,
		BUSRQ_n => z80_busrq_l,
		M1_n => z80_m1_delay_l,
		MREQ_n => z80_mreq_delay_l,
		IORQ_n => z80_iorq_delay_l,
		RD_n => z80_rd_delay_l,
		WR_n => z80_wr_delay_l,
		RFSH_n => z80_rfrsh_delay_l,
		BUSAK_n => z80_busack_l,
		HALT_n => z80_halt_delay_l,
		A => z80_a,
		D => D_bidir
	);    
    
    D_bidir <= z80_di after z80_delay;
    z80_m1_delay_l  <= z80_m1_l after z80_delay;
    z80_mreq_delay_l <= z80_mreq_l after z80_delay;
    z80_iorq_delay_l <= z80_iorq_l after z80_delay;
    z80_rd_delay_l <= z80_rd_l after z80_delay;
    z80_wr_delay_l <= z80_wr_l after z80_delay;
    z80_rfrsh_delay_l <= z80_rfrsh_l after z80_delay;
    z80_halt_delay_l <= z80_halt_l after z80_delay;
    
    config_reg <= in0_reg when in0_cs = '0' else (others => 'Z');
    config_reg <= in1_reg when in1_cs = '0' else (others => 'Z');
    config_reg <= cfg_dip_sw when dip_sw_cs = '0' else (others => 'Z');
    
    z80_do <= D_bidir;
    
    u_crom : entity work.ROM
    port map (
      A => z80_a(13 downto 0),
      D => D_bidir,
      OEn => '0',
      CSn => crom_cs
    );
    
    --
    -- DIP switch 1 (ON = 0, OFF = 1) (https://www.arcade-museum.com/manuals-videogames/S/SuperABC.pdf)
    --                         SW1   SW2   SW3   SW4   SW5   SW6   SW7   SW8
    -- Free Play               ON    ON
    -- 1 Coin 1 Credit *       OFF   ON
    -- 1 Coin 2 Credits        ON    OFF
    -- 2 Coins 1 Credit        OFF   OFF
    ------------------------------------------------------------------------
    -- 1 Pacman Per Game                   ON    ON
    -- 2 Pacman Per Game                   OFF   ON
    -- 3 Pacman Per Game *                 ON    OFF
    -- 5 Pacman Per Game                   OFF   OFF
    ------------------------------------------------------------------------
    -- Bonus Player @ 10000 Pts *                      ON    ON
    -- Bonus Player @ 15000 Pts                        OFF   ON
    -- Bonus Player @ 20000 Pts                        ON    OFF
    -- No Bonus Players                                OFF   OFF
    ------------------------------------------------------------------------
    -- Free Game in ULTRA PAC / Buy-in ON *                  ON
    -- Free Life in ULTRA PAC / Buy-in OFF                   OFF
    ------------------------------------------------------------------------
    -- Auto. Rack Advance (Skip)                                   ON
    -- Normal- Must be off for game play *                         OFF
    ------------------------------------------------------------------------
    -- Freeze Video (Pause)                                              ON
    -- Normal- Must be off for game play *                               OFF
    ------------------------------------------------------------------------
    -- cfg_dynamic(11): Mode "service", seulement utilise dans le cas de Pengo
    -- cfg_dynamic(10) : Utilise pour lire un switch (le 7) qui doit être lu à 1 (OFF)
    -- cfg_dynamic(9) : Mode cocktail (0 = ON)
    -- cfg_dynamic(8) : Mode test (0 = ON)
  
    cfg_dip_sw <= std_logic_vector(c_free_play) or std_logic_vector(c_1_pacman) or
                  std_logic_vector(c_1_pacman) or std_logic_vector(c_bonus_10000) or
                  std_logic_vector(c_free_game) or std_logic_vector(c_auto_rack_advance) or
                  std_logic_vector(c_freeze_video);

    in0_reg(7) <= credit;      -- credit
    in0_reg(6) <= coins(1);    -- coin2
    in0_reg(5) <= coins(0);    -- coin1
    in0_reg(4) <= cfg_dip_sw(6); -- test_l dipswitch (rack advance)
    in0_reg(3) <= joy_a(1);    -- p1 down
    in0_reg(2) <= joy_a(3);    -- p1 right
    in0_reg(1) <= joy_a(2);    -- p1 left
    in0_reg(0) <= joy_a(0);    -- p1 up

    in1_reg(7) <= table;
    in1_reg(6) <= buttons(1);  -- start 2
    in1_reg(5) <= buttons(0);  -- start 1
    in1_reg(4) <= test;       -- test
    in1_reg(3) <= joy_b(1);   -- p2 down
    in1_reg(2) <= joy_b(3);   -- p2 right
    in1_reg(1) <= joy_b(2);   -- p2 left
    in1_reg(0) <= joy_b(0);   -- p2 up
  
    rst_sys <= '1', '0' after 100 us;
    
end Behavioral;
