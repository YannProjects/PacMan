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
-- This file is licensed for use ONLY with Replay hardware from FPGAArcade.com
--

--
-- This package wraps up the signals used in the library wrapper and allows
-- a common interface to the core. We can add signals later to the records here
-- without changing the plumbing to all the cores.
--
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;

  use std.textio.ALL;

  use work.Replay_Pack.all;

Package Replay_Lib_Wrap_Pack is

  --
  -- Clocks and control signals
  --
  type r_Ctrl_to_core is record
    -- System clock, enable and reset, generated from Clk A
    clk_sys                 : bit1;
    ena_sys                 : bit1;
    cph_sys                 : word(3 downto 0); -- four phased enables. (3) = ena_sys
    rst_sys                 : bit1;
    -- Aux Clock, generated from Clk B. Can be used for Audio
    clk_aux                 : bit1;
    rst_aux                 : bit1;
    rst_aux_hard            : bit1;
    --
    clk_ram                 : bit1;
    rst_ram                 : bit1;

    -- Video clock, generated from Clk C. Used for all OSD Video/PHY data path.
    clk_vid                 : bit1;
    ena_vid                 : bit1; -- looped back from fm_core.ena_vid
    rst_vid                 : bit1;
    --
    tick_1us                : bit1; -- on clk_sys with ena
    tick_100us              : bit1; -- on clk_sys with ena
    --
    halt                    : bit1;
    --
    dram_ready              : bit1;
    dram_ref_panic          : bit1;
  end record;

  constant z_Ctrl_to_core : r_Ctrl_to_core := (
    '0',
    '0',
    (others => '0'),
    '0',
    '0', '0', '0',
    '0', '0',
    '0', '0','0',
    '0', '0',
    '0',
    '0', '0'
    );

  type r_Ctrl_fm_core is record
    ena_vid                 : bit1;  -- optional, tie high if not neeed
    --
    clk_aud                 : bit1;  -- clock   -- 49.152MHz gives 192KHz
    ena_aud                 : bit1;  -- enable  -- one in four enable gives 48KHz
    rst_aud                 : bit1;  -- reset
    --
    rst_soft                : bit1;
  end record;

  constant z_Ctrl_fm_core : r_Ctrl_fm_core := (
    '0',
    '0', '0', '0',
    '0'
    );
  --
  -- configuration / status
  --
  type r_Cfg_to_core is record
    --
    cfg_static              : word(31 downto 0);
    cfg_dynamic             : word(31 downto 0);
  end record;

  constant z_Cfg_to_core : r_Cfg_to_core := (
    (others => '0'),
    (others => '0')
    );

  type r_Cfg_fm_core is record
    --
    cfg_status              : word(15 downto 0); -- status feedback to ARM
  end record;

  constant z_Cfg_fm_core : r_Cfg_fm_core := (
    cfg_status => (others => '0')
    );
  --
  -- Keyboard, Mouse and Joystick
  --
  type r_KbMsJoy_to_core is record
    --
    joy_a_l                 : word( 5 downto 0); -- BOT 5-Fire2, 4-Fire1, 3-Right 2-Left, 1-Back, 0-Forward
    joy_b_l                 : word( 5 downto 0); -- TOP NOTE ACTIVE LOW
    --
    kb_ps2_we               : bit1;
    kb_ps2_data             : word( 7 downto 0);
    kb_inhibit              : bit1; -- OSD active
    --
    ms_we                   : bit1;
    ms_posx                 : word(11 downto 0);
    ms_posy                 : word(11 downto 0);
    ms_posz                 : word( 7 downto 0);
    ms_butn                 : word( 2 downto 0);
  end record;

  constant z_KbMsJoy_to_core : r_KbMsJoy_to_core := (
    (others => '0'),
    (others => '0'),
    '0',
    (others => '0'),
    '0',
    '0',
    (others => '0'),
    (others => '0'),
    (others => '0'),
    (others => '0')
    );

  type r_KbMsJoy_fm_core is record
    --
    kb_ps2_leds             : word( 2 downto 0);
    --
    ms_load                 : bit1;
    ms_posx                 : word( 7 downto 0);
    ms_posy                 : word( 7 downto 0);
  end record;

  constant z_KbMsJoy_fm_core : r_KbMsJoy_fm_core := (
    (others => '0'),
    '0',
    (others => '0'),
    (others => '0')
    );
  --
  -- DDR Memory
  --
  type r_DDR_to_core is record
    --
    ddr_hp_to_core          : r_DDR_hp_to_core;
    ddr_vp_to_core          : r_DDR_vp_to_core;
  end record;

  constant z_DDR_to_core : r_DDR_to_core := (
    z_DDR_hp_to_core,
    z_DDR_vp_to_core
    );

  type r_DDR_fm_core is record
    --
    ddr_hp_fm_core          : r_DDR_hp_fm_core; -- connect to z_DDR_hp_fm_core if not used
    ddr_vp_fm_core          : r_DDR_vp_fm_core; -- connect to z_DDR_vp_fm_core if not used
  end record;

  constant z_DDR_fm_core : r_DDR_fm_core := (
    z_DDR_hp_fm_core,
    z_DDR_vp_fm_core
    );

  --
  -- IO - transfers to / from the ARM CPU
  --
  type r_IO_to_core is record
    -- Fileio A
    fcha_cfg                : r_Cfg_fileio;
    fcha_to_core            : r_Fileio_to_core;
    -- Fileio B
    fchb_cfg                : r_Cfg_fileio;
    fchb_to_core            : r_Fileio_to_core;
    -- Fileio Mem
    memio_to_core           : r_Memio_to_core;
  end record;

  constant z_IO_to_core : r_IO_to_core := (
    z_Cfg_fileio,
    z_Fileio_to_core,
    z_Cfg_fileio,
    z_Fileio_to_core,
    z_Memio_to_core
    );

  type r_IO_fm_core is record
    -- Fileio A
    fcha_fm_core            : r_Fileio_fm_core;   -- connect to z_Fileio_fm_core if not used
    -- Fileio B
    fchb_fm_core            : r_Fileio_fm_core;   -- connect to z_Fileio_fm_core if not used
    -- Fileio Mem
    memio_fm_core           : r_Memio_fm_core;    -- connect to z_Memio_fm_core if not used
  end record;

  constant z_IO_fm_core : r_IO_fm_core := (
    z_Fileio_fm_core,
    z_Fileio_fm_core,
    z_Memio_fm_core
    );

  --
  -- Audio Video
  --
  type r_AV_to_core is record
    audio_taken             : bit1;  -- audio sample ack
  end record;

  constant z_AV_to_core : r_AV_to_core := (
    audio_taken => '0' -- workaround for single item record
    );

  type r_AV_fm_core is record
    -- Video (clk_vid / ena_vid)
    vid_rgb                 : word(23 downto 0); -- 23..16 RED 15..8 GREEN 7..0 BLUE
    -- Audio (clk_aud / ena_aud)
    audio_l                 : word(23 downto 0); -- left  sample
    audio_r                 : word(23 downto 0); -- right sample
  end record;

end;

package body Replay_Lib_Wrap_Pack is

end;
