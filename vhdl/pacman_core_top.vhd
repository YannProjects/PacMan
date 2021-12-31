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

library UNISIM;
use UNISIM.Vcomponents.all;

use work.replay_pack.all;
use work.replay_lib_wrap_pack.all;

entity Core_Top is
  port (
    ------------------------------------------------------
    -- To Lib
    ------------------------------------------------------

    -- Clocks
    o_ctrl                : out   r_Ctrl_fm_core;
    -- Paramètres de gestion du core:
    -- garder ena_sys, rst_sys, halt => A configurer dans la partie simulation
    -- l'horloge sera configurée à part
    i_ctrl                : in    r_Ctrl_to_core;
    -- Config
    o_cfg                 : out   r_Cfg_fm_core;
    -- Une partie cfg_static et cfg_dynamic => A configurer dans la partie simulation
    -- cfg_static:
    -- cfg_static(0) : 1 for pengo, 0 for name
    -- cfg_static(3 downto 1) : "001" for Mr TNT
    -- cfg_dynamic:
    -- cfg_dynamic(15) : Freeze (active low)
    -- cfg_dynamic(10) : Test (active HIGH)
    -- cfg_dynamic(11) : Test (active HIGH)
    i_cfg                 : in    r_Cfg_to_core;
    -- Keyboard, Mouse and Joystick
    o_kb_ms_joy           : out   r_KbMsJoy_fm_core;
    -- Conserver les entrées joy_a et joy_b:
    -- BOT 5-Fire2, 4-Fire1, 3-Right 2-Left, 1-Back, 0-Forward (active low)
    i_kb_ms_joy           : in    r_KbMsJoy_to_core;
    
    -- Boutons start1 / start2 / credit (active low)
    i_kbut                : in    word( 2 downto 0);

    -- Audio/Video
    o_av                  : out   r_AV_fm_core
    );
end;

architecture RTL of Core_Top is

  signal clk_sys                : bit1;
  signal ena_sys                : bit1;
  signal rst_sys                : bit1;

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

begin
  --
  -- Single clock domain used for system / video and audio
  --
  -- ~24 MHZ
  clk_sys <= i_ctrl.clk_sys;
  rst_sys <= i_ctrl.rst_sys;
  ena_sys <= i_ctrl.ena_sys;

  o_ctrl.clk_aud <= clk_sys;
  o_ctrl.ena_aud <= ena_sys;
  o_ctrl.rst_aud <= rst_sys;
  --
  -- video clock is sys_clock (set as generic)
  --
  o_ctrl.ena_vid <= '1';
  --
  -- CONFIG
  --
  o_ctrl.rst_soft   <= '0';


  --
  -- The Core
  --
  u_Core : entity work.Pacman_Top
  port map (
    --
    i_clk_sys             => clk_sys,
    i_ena_sys             => ena_sys,
    i_rst_sys             => rst_sys,

    --
    i_cfg_static          => i_cfg.cfg_static,
    i_cfg_dynamic         => i_cfg.cfg_dynamic,

    i_halt                => i_ctrl.halt,

    --
    i_joy_a               => joy_a,
    i_joy_b               => joy_b,

    --
    i_button              => i_kbut,

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
    o_audio_l             => o_av.audio_l,
    o_audio_r             => o_av.audio_r
    );
  
  u_prom_pacman : entity work.Pacman_Program_ROM
  port map (
    i_clk => clk_sys,
    i_ena => ena_sys,
    -- Taille ROM = 2048 octets. Il y a 3 bits de plus sur l'interface
    i_addr => ddr_addr(13 downto 0),
    o_data => ddr_data
  );

end RTL;
