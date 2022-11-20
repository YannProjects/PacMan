--
-- WWW.FPGAArcade.COM
--
-- REPLAY Retro Gaming Platform
-- No Emulation No Compromise
--
-- All rights reserved
-- Mike Johnson 2015
--
-- Redistribution and use in source and synthezised forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- Redistributions of source code must retain the above copyright notice,
-- this list of conditions and the following disclaimer.
--
-- Redistributions in synthesized form must reproduce the above copyright
-- notice, this list of conditions and the following disclaimer in the
-- documentation and/or other materials provided with the distribution.
--
-- Neither the name of the author nor the names of other contributors may
-- be used to endorse or promote products derived from this software without
-- specific prior written permission.
--
-- THIS CODE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
--
-- You are responsible for any legal issues arising from your use of this code.
--
-- The latest version of this file can be found at: www.FPGAArcade.com
--
-- Email support@fpgaarcade.com
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library UNISIM;
use UNISIM.Vcomponents.all;

use work.replay_pack.all;
use work.replay_lib_wrap_pack.all;
-- use work.pacman_core_pack.all;

use std.textio.all;

entity Core_Top is
  port (
    ------------------------------------------------------
    -- To Lib
    ------------------------------------------------------

    -- Clocks
    -- o_ctrl                : out   r_Ctrl_fm_core;
    -- Paramètres de gestion du core:
    -- garder ena_sys, rst_sys, halt => A configurer dans la partie simulation
    -- l'horloge sera configurée à part
    i_ctrl                : in    r_Ctrl_to_core;
    -- Config
    -- i_cfg                 : in    r_Cfg_to_core;

    -- Keyboard, Mouse and Joystick
    -- o_kb_ms_joy           : out   r_KbMsJoy_fm_core;
    -- Conserver les entrées joy_a et joy_b:
    -- BOT 5-Fire2, 4-Fire1, 3-Right 2-Left, 1-Back, 0-Forward (active low)
    -- i_kb_ms_joy           : in    r_KbMsJoy_to_core;
    
    -- Boutons start1 / start2 / credit (active low)
    -- i_kbut                : in    word( 2 downto 0);

    -- Audio/Video
    -- o_av                  : out   r_AV_fm_core;
    
    o_hsync               : out std_logic;
    o_vsync               : out std_logic;
    o_r_vga               : out std_logic_vector (2 downto 0);
    o_g_vga               : out std_logic_vector (2 downto 0);
    o_b_vga               : out std_logic_vector (2 downto 0)
    );
end;

architecture RTL of Core_Top is

  signal i_clk_52m, i_clk_6m, i_vga_clock                 : bit1;
  signal i_pll_locked : bit1;
  signal i_ena_sys                : bit1;
  signal i_rst_sys                : bit1;
  signal vga_control_init_done    : bit1;

  signal cfg_dblscan            : bit1;

  -- keyboard
  signal key_code               : word( 8 downto 0);
  signal key_rel                : bit1;
  signal key_strobe             : bit1;
  signal key_state_rel          : bit1;
  signal key_state_ext          : bit1;

  signal kjoy                   : word( 9 downto 0);

  signal joy_a                  : word( 5 downto 0);
  signal joy_b                  : word( 5 downto 0);

  -- video from core
  signal hsync_l                : bit1;
  signal vsync_l                : bit1;
  signal csync_l                : bit1;
  signal blank                  : bit1;
  signal video_rgb              : word(23 downto 0);  
  
  signal ddr_valid              : bit1;
  signal ddr_addr               : word( 15 downto 0);
  signal ddr_data               : word( 7 downto 0);

  signal i_kb_ms_joy_stub : r_KbMsJoy_to_core;
  
  -- Stubs en attendant le HW final
  signal i_kbut, i_kcoins: word( 2 downto 0);
  signal i_cfg : r_Cfg_to_core;
  signal o_av_stub : r_AV_fm_core;
  
  signal blank_vga : std_logic;
  signal o_r, o_g, o_b : std_logic_vector(2 downto 0);

begin

  i_cfg.cfg_static <= B"00000000000000000000000000000000";
  -- cfg_dynamic:
  -- cfg_dynamic(7..0): DIP switch 1 (ON = 0, OFF = 1) (https://www.arcade-museum.com/manuals-videogames/S/SuperABC.pdf)
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
  i_cfg.cfg_dynamic <= B"00000000000000000000111111111111";
  -- i_cfg.cfg_dynamic <= c_2_coins_1_credit | c_5_pacman | c_no_bonus | c_normal_rack | c_normal_video;
 
  
  -- BOT 5-Fire2, 4-Fire1, 3-Right 2-Left, 1-Back, 0-Forward (active low)
  i_kb_ms_joy_stub.joy_a_l <= (others => '1');
  i_kb_ms_joy_stub.joy_b_l <= (others => '1');
  i_kbut <= (others => '1');
  i_kcoins <= (others => '1');

  --
  -- Single clock domain used for system / video and audio
  --

  clk_gen_0 : entity work.Clocks_gen
  port map (
      -- 12 MHz CMOD S7
      i_clk_main => i_ctrl.clk_sys,
      o_clk_52m => i_clk_52m,
      o_clk_sys => i_clk_6m,
      o_clk_vga => i_vga_clock,
      i_rst => i_ctrl.rst_sys,
      o_pll_locked => i_pll_locked
  );
 
 -- i_ena_sys <= '1' when (i_vga_control_init_done = '1' and i_ctrl.rst_sys = '0') else '0';
 -- i_rst_sys <= '1' when (i_vga_control_init_done = '1' and i_ctrl.rst_sys = '0') else '0';
 i_ena_sys <= '1' when i_ctrl.rst_sys = '0' else '0';
 i_rst_sys <= '0' when i_ctrl.rst_sys = '0' and  vga_control_init_done = '1' else '1';
    
  --
  -- The Core
  --
  u_Core : entity work.Pacman_Top
  port map (
    --
    i_clk_sys             => i_clk_6m,
    -- i_ena_sys             => i_ena_sys,
    i_ena_sys             => '1',
    i_rst_sys             => i_rst_sys,

    --
    i_cfg_static          => i_cfg.cfg_static,
    i_cfg_dynamic         => i_cfg.cfg_dynamic,

    -- i_halt                => i_ctrl.halt,
    i_halt                => '0',

    --
    i_joy_a               => i_kb_ms_joy_stub.joy_a_l,
    i_joy_b               => i_kb_ms_joy_stub.joy_b_l,

    --
    i_button              => i_kbut,
    i_coins               => i_kcoins,

    --
    o_rom_read            => ddr_valid,
    o_rom_addr            => ddr_addr,
    i_rom_data            => ddr_data,

    --
    o_video_rgb           => video_rgb,
    o_hsync_l             => hsync_l,
    o_vsync_l             => vsync_l,
    o_csync_l             => csync_l,
    o_blank               => blank,

    --
    o_audio_l             => o_av_stub.audio_l,
    o_audio_r             => o_av_stub.audio_r
    );
  
  u_prom_pacman : entity work.Pacman_Program_ROM
  port map (
    i_ena => i_ena_sys,
    -- Taille ROM = 2048 octets. Il y a 3 bits de plus sur l'interface
    i_addr => ddr_addr(13 downto 0),
    o_data => ddr_data
  );

  
  u_vga_ctrl : entity work.vga_control_top
  port map ( 
     i_reset => i_ctrl.rst_sys,
     i_clk_52m => i_clk_52m,
     i_vga_clk => i_vga_clock,
     i_sys_clk => i_clk_6m,
    
     i_hsync => hsync_l,
     i_vsync => vsync_l,
     i_csync => csync_l,
     i_blank => blank,
     i_rgb => video_rgb,
        
     o_hsync => o_hsync,
     o_vsync => o_vsync,
     o_blank => blank_vga,
     o_r => o_r,
     o_g => o_g,
     o_b => o_b,             
    
     o_vga_control_init_done => vga_control_init_done
  );
    
  o_r_vga <= o_r when blank_vga = '0' else "000";
  o_g_vga <= o_g when blank_vga = '0' else "000";
  o_b_vga <= o_b when blank_vga = '0' else "000";

end RTL;
