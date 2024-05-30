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
--
-- 18 Juin 2023         |         Ajout de la ROM dans le FPGA pour simplifier dans un premier temps
--                      |         et eviter d'avoir  a faire le programmateur de flash

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.replay_pack.all;
use work.replay_lib_wrap_pack.all;
use work.Core_Pack.all;

entity PacMan_sim is
--  Port ( );
end PacMan_sim;

architecture Behavioral of PacMan_sim is

signal main_clk, rst_sys_n : bit1;

signal pacman_rom_addr : word(13 downto 0);
signal pacman_rom_data : word(7 downto 0);

constant clk_period : time := 10000 ps; -- component MHz

signal cfg_dip_sw, in0_reg, in1_reg, config_reg : word(7 downto 0);

signal joy_a, joy_b : word(3 downto 0);
signal coins, buttons : word(1 downto 0);
signal credit, table, test, in0_cs, in1_cs, dip_sw_cs : bit1;

begin
   -- A implémenter avec des switch sur la carte ou avec les joysticks / boutons
   joy_a <= b"1111";
   joy_b <= b"1111";
   coins <= b"11";
   buttons <= b"11";
   credit <= '1';
   table <= '1';
   test <= '1';

   -- 12 MHz CLK
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
                
        -- Registres de configuration (IN0, IN1, DIP SW)
        i_config_reg        => config_reg,
    
        -- Z80 code ROM
        o_in0_l_cs          => in0_cs,   -- Asynchrone ???
        o_in1_l_cs          => in1_cs, -- Asynchrone ???
        o_dip_l_cs          => dip_sw_cs -- Asynchrone ???
    );
        
    config_reg <= in0_reg when in0_cs = '0' else (others => 'Z');
    config_reg <= in1_reg when in1_cs = '0' else (others => 'Z');
    config_reg <= cfg_dip_sw when dip_sw_cs = '0' else (others => 'Z');
        
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
  
    rst_sys_n <= '0', '1' after 100 us;
    
end Behavioral;
