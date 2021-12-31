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

entity PacMan_sim is
--  Port ( );
end PacMan_sim;

architecture Behavioral of PacMan_sim is

signal sim_ctrl : r_Ctrl_to_core;
signal sim_config : r_Cfg_to_core;
signal sim_joystick : r_KbMsJoy_to_core;
signal sim_start_credit_buttons : word( 2 downto 0);
signal i_main_clk : std_logic;

signal i_ena_sys_cntr : natural range 0 to 3 := 0;

constant clk_period : time := 162760 ps; -- 6 MHz
-- constant clk_period : time := 40690 ps; -- 24 MHz

begin

   -- 24.576 MHz CLK
   clk_process :process
   begin
        i_main_clk <= '0';
        wait for clk_period / 2;
        i_main_clk <= '1';
        wait for clk_period / 2;
   end process;
   
   core_top_0 : entity work.Core_Top
   port map (
        -- Paramètres de gestion du core:
        -- garder ena_sys, rst_sys, halt, sys_clk => A configurer dans la partie simulation
        i_ctrl        =>    sim_ctrl,
        i_cfg         =>    sim_config,
        -- Keyboard, Mouse and Joystick
        -- Conserver les entrées joy_a et joy_b:
        -- BOT 5-Fire2, 4-Fire1, 3-Right 2-Left, 1-Back, 0-Forward (active low)
        i_kb_ms_joy   =>    sim_joystick,
        
        -- Boutons start1 / start2 / credit (active low)
        i_kbut        =>    sim_start_credit_buttons
    
        -- Audio/Video
        -- o_av                  : out   r_AV_fm_core
    );
    
    p_ena_sys : process(i_main_clk)
    begin
        if rising_edge(i_main_clk) then
            i_ena_sys_cntr <= i_ena_sys_cntr + 1;
            if i_ena_sys_cntr = 3 then
                i_ena_sys_cntr <= 0;
            end if;
        end if;
    end process;
    
    -- cfg_static:
    -- cfg_static(0) : 1 for pengo, 0 for name
    -- cfg_static(3 downto 1) : "001" for Mr TNT
    --
    -- cfg_dynamic:
    -- cfg_dynamic(31-24) : dipsw2 -- Pengo only
    -- cfg_dynamic(15) : freeze (active high)
    -- cfg_dynamic(11) : service  -- Pengo only
    -- cfg_dynamic(10) : dip_test (active low) -- Pengo only
    -- cfg_dynamic(9) : table (active low)
    -- cfg_dynamic(8) : test (active low)
    -- cfg_dynamic(7-0) : dipsw1 (active low)
    
    sim_config.cfg_static <= B"00000000000000000000000000000000";
    sim_config.cfg_dynamic <= B"00000000000000000000001111111111";
    
    sim_ctrl.clk_sys <= i_main_clk;
    -- sim_ctrl.ena_sys <= '1' when i_ena_sys_cntr = 0 else '0';
    -- sim_ctrl.ena_sys <= '1' when i_ena_sys_cntr = 0 else '0';
    sim_ctrl.ena_sys <= '1';
    sim_ctrl.rst_sys <= '1', '0' after 100 us;
    sim_ctrl.halt <= '0';
    
    -- BOT 5-Fire2, 4-Fire1, 3-Right 2-Left, 1-Back, 0-Forward (active low)
    sim_joystick.joy_a_l <= (others => '1');
    sim_joystick.joy_b_l <= (others => '1');
    
    -- Boutons start1 / start2 / credit (active low)
    sim_start_credit_buttons(0) <= '1';
    sim_start_credit_buttons(1) <= '1';
    sim_start_credit_buttons(2) <= '1'; 

end Behavioral;
