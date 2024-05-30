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
use work.core_pack.all;

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
    
    -- Registres I/O
    i_config_reg          : in word(7 downto 0);
    
    -- Dip switch, crédits, joystick
    o_in0_l_cs       : out bit1; -- Read IN1
    o_in1_l_cs       : out bit1; -- Read IN2
    o_dip_l_cs       : out bit1; -- Read DIP switches
    
    -- Audio right/left
    o_audio_vol_out  : out word(3 downto 0);
    o_audio_wav_out  : out word(3 downto 0)
    
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
  signal regs_data, rom_data : word(7 downto 0);
  signal config_reg : word(7 downto 0);
  signal dip_l_cs : bit1;
  
  signal rom_cs_l : bit1;
  
  signal core_rst : bit1;
  
  signal cpu_addr          : word(15 downto 0);
  signal cpu_data_in       : word(7 downto 0);
  signal cpu_data_out      : word(7 downto 0);

  signal cpu_rst_core   : bit1;
  signal cpu_clk_core   : bit1;
  signal cpu_wait_l     : bit1;
  signal cpu_int_l      : bit1;
  signal cpu_m1_l       : bit1;
  signal cpu_mreq_l     : bit1;
  signal cpu_iorq_l     : bit1;
  signal cpu_rd_l       : bit1;
  signal cpu_wr_l       : bit1;
  signal cpu_rfrsh_l, watchdog_reset_l, cpu_clk    : bit1;  

begin

  --
  -- Single clock domain used for system / video and audio
  --
  
  clk_gen_0 : entity work.Clocks_gen
  port map (
      -- 12 MHz CMOD S7
      i_clk_main => i_clk_main,
      o_clk_52m => i_clk_52m,
      o_clk_vga => vga_clock,
      o_clk_6M => clk_6m,
      o_clk_6M_star => clk_6m_star,
      o_clk_6M_star_n => clk_6m_star_n,
<<<<<<< HEAD
      i_rst => not i_rst_sys_n,
      o_pll_locked => pll_locked
  );
 
=======
      -- i_rst => not i_rst_sys_n,
      i_rst => not pll_locked,
      o_pll_locked => pll_locked
  );
 
 -- core_rst <= '1' when i_rst_sys_n = '0' or  vga_control_init_done = '0' else '0';
>>>>>>> 8d8951fe53392006346f0a5ba26bbcbabd6294a8
 core_rst <= '1' when pll_locked = '0' or  vga_control_init_done = '0' else '0';
    
  --
  -- The Core
  --
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
        
    -- Registres de configuration (INO, IN1, DIP SW)
    i_config_reg          => i_config_reg,
    
    -- Z80 code ROM
    i_cpu_a               => cpu_addr,
    o_cpu_di              => regs_data,
    i_cpu_do              => cpu_data_out,
    
    o_cpu_rst             => watchdog_reset_l,
    o_cpu_clk             => cpu_clk,
    o_cpu_wait_l          => cpu_wait_l,
    o_cpu_int_l           => cpu_int_l,
    i_cpu_m1_l            => cpu_m1_l,
    i_cpu_mreq_l          => cpu_mreq_l,
    i_cpu_iorq_l          => cpu_iorq_l,
    i_cpu_rd_l            => cpu_rd_l,
    i_cpu_rfsh_l          => cpu_rfrsh_l,
    
    o_in0_cs_l            => o_in0_l_cs,
    o_in1_cs_l            => o_in1_l_cs,
    o_dip_sw_cs_l         => dip_l_cs,

    -- Z80 code ROM
    o_rom_cs_l            => rom_cs_l
  );
  
  -- Les Timings du T80se ne sont pas les mêmes que ceux du T80a.
  u_cpu : entity work.T80se
  port map (
       RESET_n => watchdog_reset_l,
       CLK_n   => cpu_clk,
       CLKEN   => '1',
       WAIT_n  => cpu_wait_l,
       INT_n   => cpu_int_l,
       NMI_n   => '1',
       BUSRQ_n => '1',
       M1_n    => cpu_m1_l,
       MREQ_n  => cpu_mreq_l,
       IORQ_n  => cpu_iorq_l,
       RD_n    => cpu_rd_l,
       WR_n    => cpu_wr_l,
       RFSH_n  => cpu_rfrsh_l,
       A       => cpu_addr,
       DI      => cpu_data_in,
       DO      => cpu_data_out
  );
   
  u_crom : entity work.ROM
  port map (
     A => cpu_addr(13 downto 0),
     D => rom_data,
     OEn => '0',
     CSn => rom_cs_l
  );  
  
  -- En attendant le PCB final car les pistes du DIP switch ont été coupées sur le PCB.
  -- p_mux_in0_in1_dip : process(dip_l_cs, i_config_reg)
  -- begin
    -- config_reg <= (i_config_reg or X"10");
  --   config_reg <= X"40";
  --   if dip_l_cs = '0' then
  --       config_reg <= X"40";
  --   end if;
  -- end process;
  -- config_reg <= X"FF";
  
  o_dip_l_cs <= dip_l_cs;
  
  -- Lecture par le CPU du registre tampon ou registre d'interruption
  cpu_data_in <= rom_data when rom_cs_l = '0' else regs_data;
 
  -- Controlleur VGA
  u_vga_ctrl : entity work.vga_control_top
  port map ( 
<<<<<<< HEAD
=======
     -- i_reset => not i_rst_sys_n,
>>>>>>> 8d8951fe53392006346f0a5ba26bbcbabd6294a8
     i_reset => not pll_locked,
     i_clk_52m => i_clk_52m,
     i_vga_clk => vga_clock,
     i_sys_clk => clk_6m,
    
     -- Signaux video core Pacman
<<<<<<< HEAD
=======
     i_hsync => hsync_l,
>>>>>>> 8d8951fe53392006346f0a5ba26bbcbabd6294a8
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
    
  o_vga.r_vga <= o_r when blank_vga = '0' else "000";
  o_vga.g_vga <= o_g when blank_vga = '0' else "000";
  o_vga.b_vga <= o_b when blank_vga = '0' else "000";

end RTL;
