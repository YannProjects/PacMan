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
-- 18 Juin 2023         |         Ajout de la ROM dans le FPGA pour simplifier dans un premier temps
--                      |         et eviter d'avoir  a faire le programmateur de flash
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

    -- System clock
    i_clk_main               : in  bit1;
    -- Core reset
    i_rst_sys_n              : in  bit1; -- actif niveau bas

    -- Keyboard, Mouse and Joystick
    -- o_kb_ms_joy           : out   r_KbMsJoy_fm_core;
    -- Conserver les entrées joy_a et joy_b:
    -- BOT 5-Fire2, 4-Fire1, 3-Right 2-Left, 1-Back, 0-Forward (active low)
    -- i_kb_ms_joy           : in    r_KbMsJoy_to_core;
    
    -- Boutons start1 / start2 / credit (active low)
    -- i_kbut                : in    word( 2 downto 0);

    -- Audio/Video
    -- o_av                  : out   r_AV_fm_core;
    
    o_vga                 : out r_VGA_to_core;
    
    i_cpu_a_core          : in word(15 downto 0);
    o_cpu_di_core         : out word(7 downto 0);
    i_cpu_do_core         : in word(7 downto 0);
    
    o_cpu_rst_core        : out bit1;
    o_cpu_clk_core        : out bit1;
    o_uart_clk_core       : out bit1;
    o_cpu_wait_l_core     : out bit1;
    o_cpu_int_l_core      : out bit1;
    i_cpu_m1_l_core       : in bit1;
    i_cpu_mreq_l_core     : in bit1;
    i_cpu_iorq_l_core     : in bit1;
    i_cpu_rd_l_core       : in bit1;
    i_cpu_wr_l_core       : in bit1;
    i_cpu_rfrsh_l_core    : in bit1;
    
    -- Registres I/O
    i_config_reg          : in word(7 downto 0);
    
    o_buffer_enable_n     : out bit1;     -- Validation buffer CPU vers core (ecriture RAM,registres,...)
    o_buffer_dir          : out bit1;     
    
    -- Dip switch, crédits, joystick
    o_in0_l_cs       : out bit1; -- Read IN1
    o_in1_l_cs       : out bit1; -- Read IN2
    o_dip_l_cs       : out bit1; -- Read DIP switches
    
    -- Audio right/left
    o_audio_vol_out  : out word(3 downto 0);
    o_audio_wav_out  : out word(3 downto 0);
    
    i_freeze         : in bit1 -- CPU freeze
  );
end;

architecture RTL of Core_Top is

  signal i_clk_52m, clk_6m, vga_clock                 : bit1;
  signal pll_locked : bit1;
  signal vga_control_init_done : bit1;
  signal clk_6m_star, clk_6m_star_n : bit1;

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
  
  signal ddr_addr               : word( 15 downto 0);
  signal ddr_data               : word( 7 downto 0);

  signal i_kb_ms_joy_stub : r_KbMsJoy_to_core;
  
  signal o_audio : r_AV_fm_core;
  
  signal blank_vga : std_logic;
  signal o_r, o_g, o_b : word(2 downto 0);
  signal regs_data, cpu_data, rom_data : word(7 downto 0);
  
  signal rom_cs_l, rd_regs_core_n : bit1;
  
  signal core_rst : bit1;

begin


end RTL;
