--
-- WWW.FPGAArcade.COM
-- REPLAY 1.0
-- Retro Gaming Platform
-- No Emulation No Compromise
--
-- All rights reserved
-- Mike Johnson 2008/2009
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

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;

  use work.Replay_Pack.all;

entity Pacman_Top is
  port (
    -- System clock
    i_clk_sys             : in  bit1;
    i_ena_sys             : in  bit1;
    i_rst_sys             : in  bit1;

    -- Config/Control
    i_cfg_static          : in  word(31 downto 0);
    i_cfg_dynamic         : in  word(31 downto 0);

    i_halt                : in  bit1; -- used to hold CPU until RAM is loaded with ROM contents

    -- Joystick (active HIGH)
    i_joy_a               : in  word( 5 downto 0);
    i_joy_b               : in  word( 5 downto 0);

    -- Buttons (active HIGH)
    i_button              : in  word( 2 downto 0);

    -- ROM interface
    o_rom_read            : out bit1;
    o_rom_addr            : out word(15 downto 0);
    i_rom_data            : in  word( 7 downto 0);

    -- Video
    o_video_rgb           : out word(23 downto 0); -- 23..16 RED 15..8 GREEN 7..0 BLUE
    o_hsync_l             : out bit1;
    o_vsync_l             : out bit1;
    o_csync_l             : out bit1;
    o_blank               : out bit1;

    -- Audio
    o_audio_l             : out word(23 downto 0); -- left  sample
    o_audio_r             : out word(23 downto 0)  -- right sample
    );
end;

architecture RTL of Pacman_Top is
  -- The original uses a 6.144 MHz clock
  -- base clock 24.576 (x4)
  -- ref clock  98.304

  -- config
  type r_Cfg is record
    --
    hw_pengo         : bit1; -- high for Pengo hardware, low for Pacman
    -- for Pacman hardware :
    hw_type_is_mrtnt : bit1;
    --
    freeze           : bit1;
    service          : bit1;
    dip_test         : bit1;
    table            : bit1;
    test             : bit1;
    --
    dipsw2           : word(7 downto 0);
    dipsw1           : word(7 downto 0);
  end record;
  signal cfg                    : r_Cfg;

  constant c_Type_mr_tnt        : word( 2 downto 0) := "001";
  -- timing
  signal hcnt                   : word( 8 downto 0) := "010000000"; -- 80
  signal vcnt                   : word( 8 downto 0) := "011111000"; -- 0F8

  signal do_hsync               : boolean;
  signal hsync                  : bit1;
  signal vsync                  : bit1;
  signal hblank                 : bit1;
  signal vblank                 : bit1 := '1';
  signal h1_inv                 : bit1;
  signal comp_sync_l            : bit1;

  -- cpu
  signal cpu_ena                : bit1;
  signal cpu_m1_l               : bit1;
  signal cpu_mreq_l             : bit1;
  signal cpu_iorq_l             : bit1;
  signal cpu_rd_l               : bit1;
  signal cpu_wr_l               : bit1;
  signal cpu_rfsh_l             : bit1;
  signal cpu_halt_l             : bit1;
  signal cpu_wait_l             : bit1;
  signal cpu_int_l              : bit1;
  signal cpu_nmi_l              : bit1;
  signal cpu_busrq_l            : bit1;
  signal cpu_busak_l            : bit1;
  signal cpu_addr               : word(15 downto 0);
  signal cpu_data_out           : word( 7 downto 0);
  signal cpu_data_in            : word( 7 downto 0);

  signal memio_program_rom      : r_Memio_fm_core;
  signal memio_video            : r_Memio_fm_core;

  signal program_rom_addr       : word(15 downto 0);
  signal program_rom_data_dec   : word( 7 downto 0); -- to cpu

  signal program_rom_cs_l       : bit1;
  signal sync_bus_cs_l          : bit1;

  signal control_reg            : word( 7 downto 0);
  signal ps_reg                 : word( 2 downto 0); -- Pengo only
  --
  signal vram_addr_ab           : word(11 downto 0);
  signal ab                     : word(11 downto 0);

  signal sync_bus_db            : word( 7 downto 0);
  signal sync_bus_r_w_l         : bit1;
  signal sync_bus_wreq_l        : bit1;
  signal sync_bus_stb           : bit1;

  signal cpu_vec_reg            : word( 7 downto 0);
  signal sync_bus_reg           : word( 7 downto 0);

  signal vram_l                 : bit1;
  signal rams_data_out          : word( 7 downto 0);

  signal wr0_l                  : bit1;
  signal wr1_l                  : bit1;
  signal wr2_l                  : bit1;
  signal iodec_out_l            : bit1;
  signal iodec_wdr_l            : bit1;
  signal iodec_in0_l            : bit1;
  signal iodec_in1_l            : bit1;
  signal iodec_dipsw1_l         : bit1;
  signal iodec_dipsw2_l         : bit1;

  -- watchdog
  signal watchdog_cnt           : word( 3 downto 0);
  signal watchdog_reset_l       : bit1;
  signal freeze                 : bit1;

  -- ip registers
  signal in0_reg                : word( 7 downto 0);
  signal in1_reg                : word( 7 downto 0);
  signal dipsw1_reg             : word( 7 downto 0);
  signal dipsw2_reg             : word( 7 downto 0);

  signal blank                  : bit1;
  signal video_r                : word( 2 downto 0);
  signal video_g                : word( 2 downto 0);
  signal video_b                : word( 1 downto 0);

  signal audio                  : word(15 downto 0);

begin
  --
  -- CONFIG
  --
  cfg.hw_pengo         <= i_cfg_static(0); -- 1 for pengo, 0 for pacman
  cfg.hw_type_is_mrtnt <= '1' when (i_cfg_static(3 downto 1) = c_Type_mr_tnt) else '0'; -- 0 for base pacman, 1 for mr tnt
  --
  cfg.freeze           <= i_cfg_dynamic(15) or i_halt;

  cfg.service          <= i_cfg_dynamic(11);
  cfg.dip_test         <= i_cfg_dynamic(10);
  cfg.table            <= i_cfg_dynamic(9);
  cfg.test             <= i_cfg_dynamic(8);

  cfg.dipsw2           <= i_cfg_dynamic(31 downto 24);
  cfg.dipsw1           <= i_cfg_dynamic( 7 downto  0);

  p_input_registers : process
  begin
    wait until rising_edge(i_clk_sys);
    if (i_ena_sys = '1') then

      freeze <= cfg.freeze;
      dipsw1_reg <= not cfg.dipsw1;
      dipsw2_reg <= not cfg.dipsw2; -- Pengo only

      --dipsw2_reg <= "00110011"; -- 1 coin 1 play

      -- active low inputs
      if (cfg.hw_pengo = '0') then
        -- Pacman
        in0_reg(7) <= '1';              -- credit
        in0_reg(6) <= '1';              -- coin2
        in0_reg(5) <= not i_button(2);  -- coin1
        in0_reg(4) <= not cfg.dip_test; -- test_l dipswitch (rack advance)
        in0_reg(3) <= not i_joy_a(1);   -- p1 down
        in0_reg(2) <= not i_joy_a(3);   -- p1 right
        in0_reg(1) <= not i_joy_a(2);   -- p1 left
        in0_reg(0) <= not i_joy_a(0);   -- p1 up

        in1_reg(7) <= not cfg.table;
        in1_reg(6) <= not i_button(1);  -- start 2
        in1_reg(5) <= not i_button(0);  -- start 1
        in1_reg(4) <= not cfg.test;     -- test
        in1_reg(3) <= not i_joy_b(1);   -- p2 down
        in1_reg(2) <= not i_joy_b(3);   -- p2 right
        in1_reg(1) <= not i_joy_b(2);   -- p2 left
        in1_reg(0) <= not i_joy_b(0);   -- p2 up

        -- modifications for Mr TNT
        if (cfg.hw_type_is_mrtnt = '1') then
          in0_reg(7) <= '1';              -- coin2
          in0_reg(6) <= '1';              -- tilt
          in0_reg(5) <= not i_button(2);  -- coin1
          in0_reg(4) <= not cfg.test;     -- test

          in1_reg(7) <= not i_joy_b(4);   -- p2 button
          in1_reg(4) <= not i_joy_a(4);   -- p1 button
        end if;

      else
        -- Pengo
        in0_reg(7) <= not i_joy_a(4);   -- p1 fire
        in0_reg(6) <= not cfg.service;  -- service
        in0_reg(5) <= '1';              -- coin2
        in0_reg(4) <= not i_button(2);  -- coin1
        in0_reg(3) <= not i_joy_a(3);   -- p1 right
        in0_reg(2) <= not i_joy_a(2);   -- p1 left
        in0_reg(1) <= not i_joy_a(1);   -- p1 down
        in0_reg(0) <= not i_joy_a(0);   -- p1 up

        in1_reg(7) <= not i_joy_b(4);   -- p2 fire
        in1_reg(6) <= not i_button(1);  -- start 2
        in1_reg(5) <= not i_button(0);  -- start 1
        in1_reg(4) <= not cfg.test;     -- test
        in1_reg(3) <= not i_joy_b(3);   -- p2 down
        in1_reg(2) <= not i_joy_b(2);   -- p2 right
        in1_reg(1) <= not i_joy_b(1);   -- p2 left
        in1_reg(0) <= not i_joy_b(0);   -- p2 up
      end if;

    end if;
  end process;

  --
  -- video timing
  --
  p_hvcnt : process
    variable hcarry,vcarry : boolean;
  begin
    wait until rising_edge(i_clk_sys);
    if (i_ena_sys = '1') then
      hcarry := (hcnt = "111111111");
      if hcarry then
        hcnt <= "010000000"; -- 080
      else
        hcnt <= hcnt +"1";
      end if;
      -- hcnt 8 on circuit is 256H_L
      vcarry := (vcnt = "111111111");
      if do_hsync then
        if vcarry then
          vcnt <= "011111000"; -- 0F8
        else
          vcnt <= vcnt +"1";
        end if;
      end if;
    end if;
  end process;

  p_sync_comb : process(hcnt, vcnt)
  begin
    vsync <= not vcnt(8);
    do_hsync <= (hcnt = "010101111"); -- 0AF
  end process;

  p_sync : process
  begin
    wait until rising_edge(i_clk_sys);
    if (i_ena_sys = '1') then
      -- Timing hardware is coded differently to the real hw
      -- to avoid the use of multiple clocks. Result is identical.

      if (hcnt = "010001111") then -- 08F
        hblank <= '1';
      elsif (hcnt = "011101111") then
        hblank <= '0'; -- 0EF
      end if;

      if do_hsync then
        hsync <= '1';
      elsif (hcnt = "011001111") then -- 0CF
        hsync <= '0';
      end if;

      if do_hsync then
        if (vcnt = "111101111") then -- 1EF
          vblank <= '1';
        elsif (vcnt = "100001111") then -- 10F
          vblank <= '0';
        end if;
      end if;
    end if;
  end process;

  p_comp_sync : process(hsync, vsync)
  begin
    comp_sync_l <= (not vsync) and (not hsync);
  end process;
  --
  -- cpu
  --
  p_cpu_wait_comb : process(freeze, sync_bus_wreq_l)
  begin
    cpu_wait_l  <= '1';
    if (freeze = '1') or (sync_bus_wreq_l = '0') then
      cpu_wait_l  <= '0';
    end if;
  end process;

  p_irq_req_watchdog : process
    variable rising_vblank : boolean;
  begin
    wait until rising_edge(i_clk_sys);
    if (i_ena_sys = '1') then
      rising_vblank := do_hsync and (vcnt = "111101111"); -- 1EF
      -- interrupt 8c

      if (control_reg(0) = '0') then
        cpu_int_l <= '1';
      elsif rising_vblank then -- 1EF
        cpu_int_l <= '0';
      end if;

      -- watchdog 8c
      -- note sync reset
      if (i_rst_sys = '1') then
        watchdog_cnt <= "1111";
      elsif (iodec_wdr_l = '0') then
        watchdog_cnt <= "0000";
      elsif rising_vblank and (freeze = '0') then
        watchdog_cnt <= watchdog_cnt + "1";
      end if;

      watchdog_reset_l <= '1';
      if (watchdog_cnt = "1111") then
        watchdog_reset_l <= '0';
      end if;

      -- simulation
      -- pragma translate_off
      watchdog_reset_l <= not i_rst_sys; -- watchdog disable
      -- pragma translate_on
    end if;
  end process;

  -- other cpu signals
  cpu_busrq_l <= '1';
  cpu_nmi_l   <= '1';
  h1_inv      <= not hcnt(0);

  p_cpu_ena : process(hcnt, i_ena_sys)
  begin
    cpu_ena <= '0';
    if (i_ena_sys = '1') then
      cpu_ena <= hcnt(0);
    end if;
  end process;

  u_cpu : entity work.T80se
          port map (
              RESET_n => watchdog_reset_l,
              -- CLK_n   => i_clk_sys,
              CLK_n   => cpu_ena,
              -- CLKEN   => cpu_ena,
              CLKEN   => '1',
              WAIT_n  => cpu_wait_l,
              INT_n   => cpu_int_l,
              NMI_n   => cpu_nmi_l,
              BUSRQ_n => cpu_busrq_l,
              M1_n    => cpu_m1_l,
              MREQ_n  => cpu_mreq_l,
              IORQ_n  => cpu_iorq_l,
              RD_n    => cpu_rd_l,
              WR_n    => cpu_wr_l,
              RFSH_n  => cpu_rfsh_l,
              HALT_n  => cpu_halt_l,
              BUSAK_n => cpu_busak_l,
              A       => cpu_addr,
              DI      => cpu_data_in,
              DO      => cpu_data_out
  );
  --
  -- primary addr decode
  --
  p_mem_decode_comb : process(cfg, cpu_rfsh_l, cpu_rd_l, cpu_mreq_l, cpu_addr)
  begin
    --Normally the Pac-Man ROMs reside at address 0x0000-0x3fff and are mirrored at 0x8000-0xbfff (Z-80 A15 is not used in Pac-Man).
    --The aux board logic modifies the address map and enables the aux board ROMs for addresses 0x3000-0x3fff and 0x8000-0x97ff.

    -- 7M
    -- 7N
    sync_bus_cs_l <= '1';
    --
    if (cpu_mreq_l = '0') and (cpu_rfsh_l = '1') then
      if (cfg.hw_pengo = '1') then
        -- Pengo
        -- syncbus 0x8000 - 0xFFFF
        if (cpu_addr(15) = '1') then
          sync_bus_cs_l <= '0';
        end if;
      else
        -- Pacman
        -- syncbus 0x4000 - 0x7FFF
        if (cpu_addr(14) = '1') then
          sync_bus_cs_l <= '0';
        end if;
      end if;
    end if;

    program_rom_addr  <= cpu_addr(15 downto 0);
    program_rom_cs_l  <= '1';
    --
    if (cfg.hw_pengo = '1') then
      -- Pengo
      -- ROM     0x0000 - 0x7FFF
      if (cpu_addr(15) = '0') then --and (cpu_rd_l = '0') then
        program_rom_cs_l <= '0';
      end if;
    else
      -- Pacman
      -- ROM     0x0000 - 0x3FFF
      if (cpu_addr(14) = '0') and (cpu_rd_l = '0') then
        program_rom_cs_l <= '0';
      end if;
      program_rom_addr(15) <= '0'; -- alias
    end if;
  end process;
  --
  -- sync bus custom ic
  --
  p_sync_bus_reg : process
  begin
    wait until rising_edge(i_clk_sys);
    if (i_ena_sys = '1') then
      -- register on sync bus module that is used to store interrupt vector
      if (cpu_iorq_l = '0') and (cpu_m1_l = '1') then
        cpu_vec_reg <= cpu_data_out;
      end if;

      -- read holding reg
      if (hcnt(1 downto 0) = "01") then
        sync_bus_reg <= cpu_data_in;
      end if;
    end if;
  end process;

  p_sync_bus_comb : process(cpu_rd_l, sync_bus_cs_l, hcnt)
  begin
    -- sync_bus_stb is now an active low clock enable signal
    sync_bus_stb <= '1';
    sync_bus_r_w_l <= '1';

    if (sync_bus_cs_l = '0') and (hcnt(1) = '0') then
      if (cpu_rd_l = '1') then
        sync_bus_r_w_l <= '0';
      end if;
      sync_bus_stb <= '0';
    end if;

    sync_bus_wreq_l <= '1';
    if (sync_bus_cs_l = '0') and (hcnt(1) = '1') and (cpu_rd_l = '0') then
      sync_bus_wreq_l <= '0';
    end if;
  end process;
  --
  -- vram addr custom ic
  --
  u_vram_addr : entity work.Pacman_VRAM_Addr
    port map (
      i_h       => hcnt(8 downto 0),
      i_v       => vcnt(7 downto 0),
      i_flip    => control_reg(3),
      o_ab      => vram_addr_ab
      );

  p_ab_mux_comb : process(hcnt, cpu_addr, vram_addr_ab)
  begin
    --When 2H is low, the CPU controls the bus.
    if (hcnt(1) = '0') then
      ab <= cpu_addr(11 downto 0);
    else
      ab <= vram_addr_ab;
    end if;
  end process;

  p_vram_comb : process(hcnt, cpu_addr, sync_bus_stb)
  begin
    vram_l <= ( (cpu_addr(12) or sync_bus_stb) and not (hcnt(1) and hcnt(0)) );
  end process;

  p_io_decode_comb : process(cfg, sync_bus_r_w_l, sync_bus_stb, ab, cpu_addr)
  begin
    -- PACMAN                           PENGO

    -- WRITE
    -- out_l    0x5000 - 0x503F         0x9040 - 0x904F         control space
    -- wr0_l    0x5040 - 0x504F         0x9000 - 0x900F         sound waveform
    -- wr1_l    0x5050 - 0x505F         0x9010 - 0x901F         sound voice
    -- wr2_l    0x5060 - 0x506F         0x9020 - 0x902F         sprite
    -- wdr_l    0x50C0 - 0x50FF         0x9070 - 0x907F         watchdog reset

    -- READ
    -- in0_l    0x5000 - 0x503F         0x90C0 - 0x90FF         in port 0
    -- in1_l    0x5040 - 0x507F         0x9080 - 0x90BF         in port 1
    -- dipsw1_l 0x5080 - 0x50BF         0x9040 - 0x907F         dip switches 1
    -- dipsw2_l -                       0x9000 - 0x903F         dip switches 2

    -- 7J / 7M
    wr0_l          <= '1';
    wr1_l          <= '1';
    wr2_l          <= '1';
    iodec_out_l    <= '1';
    iodec_wdr_l    <= '1';

    iodec_in0_l    <= '1';
    iodec_in1_l    <= '1';
    iodec_dipsw1_l <= '1';
    iodec_dipsw2_l <= '1';

    if (cpu_addr(12) = '1') and ( sync_bus_stb = '0') then
      if (sync_bus_r_w_l ='0') then -- writes
        if (cfg.hw_pengo = '0') then
          -- Pacman
          if (ab(7 downto 4) = "0100") then wr0_l          <= '0'; end if;
          if (ab(7 downto 4) = "0101") then wr1_l          <= '0'; end if;
          if (ab(7 downto 4) = "0110") then wr2_l          <= '0'; end if;
          if (ab(7 downto 6) = "00"  ) then iodec_out_l    <= '0'; end if;
          if (ab(7 downto 6) = "11"  ) then iodec_wdr_l    <= '0'; end if;
        else
          -- Pengo
          if (ab(7 downto 4) = "0000") then wr0_l          <= '0'; end if;
          if (ab(7 downto 4) = "0001") then wr1_l          <= '0'; end if;
          if (ab(7 downto 4) = "0010") then wr2_l          <= '0'; end if;
          if (ab(7 downto 4) = "0100") then iodec_out_l    <= '0'; end if;
          if (ab(7 downto 4) = "0111") then iodec_wdr_l    <= '0'; end if;
        end if;
      else -- reads
        if (cfg.hw_pengo = '0') then
          -- Pacman
          if (ab(7 downto 6) = "00"  ) then iodec_in0_l    <= '0'; end if;
          if (ab(7 downto 6) = "01"  ) then iodec_in1_l    <= '0'; end if;
          if (ab(7 downto 6) = "10"  ) then iodec_dipsw1_l <= '0'; end if;
        else
          -- Pengo
          if (ab(7 downto 6) = "11"  ) then iodec_in0_l    <= '0'; end if;
          if (ab(7 downto 6) = "10"  ) then iodec_in1_l    <= '0'; end if;
          if (ab(7 downto 6) = "01"  ) then iodec_dipsw1_l <= '0'; end if;
          if (ab(7 downto 6) = "00"  ) then iodec_dipsw2_l <= '0'; end if;
        end if;
      end if;
    end if;
  end process;


  p_control_reg : process
    variable ena : std_logic_vector(7 downto 0);
  begin
    -- 8 bit addressable latch 7K
    -- (made into register)

    --   PACMAN                         PENGO
    --
    -- 0 interrupt ena                  interrupt ena
    -- 1 sound ena                      sound ena
    -- 2 not used                       ps(1)
    -- 3 flip                           flip
    -- 4 1 player start lamp            coin 1 meter
    -- 5 2 player start lamp            coin 2 meter
    -- 6 coin lockout                   ps(2)
    -- 7 coin counter                   ps(3)

    wait until rising_edge(i_clk_sys);
    if (i_ena_sys = '1') then
      ena := "00000000";
      if (iodec_out_l = '0') then
        case ab(2 downto 0) is
          when "000" => ena := "00000001";
          when "001" => ena := "00000010";
          when "010" => ena := "00000100";
          when "011" => ena := "00001000";
          when "100" => ena := "00010000";
          when "101" => ena := "00100000";
          when "110" => ena := "01000000";
          when "111" => ena := "10000000";
          when others => null;
        end case;
      end if;

      if (watchdog_reset_l = '0') then
        control_reg <= (others => '0');
      else
        for i in 0 to 7 loop
          if (ena(i) = '1') then
            control_reg(i) <= cpu_data_out(0);
          end if;
        end loop;
      end if;
    end if;
  end process;
  ps_reg <= (control_reg(7) & control_reg(6) & control_reg(2)) when (cfg.hw_pengo = '1') else "000";

  p_db_mux_comb : process(hcnt, cpu_data_out, rams_data_out)
  begin
    -- simplified data source for video subsystem
    -- only cpu or ram are sources of interest
    if (hcnt(1) = '0') then
      sync_bus_db <= cpu_data_out;
    else
      sync_bus_db <= rams_data_out;
    end if;
  end process;

  p_cpu_data_in_mux_comb : process(program_rom_cs_l, cpu_iorq_l, cpu_m1_l, cpu_vec_reg,
                                   sync_bus_wreq_l, sync_bus_reg,
                                   program_rom_data_dec, rams_data_out,
                                   iodec_in0_l, iodec_in1_l, iodec_dipsw1_l, iodec_dipsw2_l,
                                   in0_reg, in1_reg, dipsw1_reg, dipsw2_reg)
  begin
    -- simplifed again
    if (cpu_iorq_l = '0') and (cpu_m1_l = '0') then
      cpu_data_in <= cpu_vec_reg;
    elsif (sync_bus_wreq_l = '0') then
      cpu_data_in <= sync_bus_reg;
    else
      if (program_rom_cs_l = '0') then
        cpu_data_in <= program_rom_data_dec;
      else
        cpu_data_in <= rams_data_out;
        if (iodec_in0_l = '0')    then cpu_data_in <= in0_reg; end if;
        if (iodec_in1_l = '0')    then cpu_data_in <= in1_reg; end if;
        if (iodec_dipsw1_l = '0') then cpu_data_in <= dipsw1_reg; end if;
        if (iodec_dipsw2_l = '0') then cpu_data_in <= dipsw2_reg; end if;
      end if;
    end if;
  end process;

  u_rams : entity work.Pacman_RAMs
    port map (
      i_cfg_hw_pengo => cfg.hw_pengo,
      -- note, we get a one clock delay from our rams
      i_addr         => ab,
      i_data         => cpu_data_out, -- cpu only source of ram data
      o_data         => rams_data_out,
      i_r_w_l        => sync_bus_r_w_l,
      i_vram_l       => vram_l,

      i_clk          => i_clk_sys,
      i_ena          => i_ena_sys
      );
  --
  -- Program ROMs in external DRAM
  -- it's important we don't fully use the bus before the RAM is loaded, or the LP port cannot access the memory
  -- valid is sampled the clock after ena

  --     __              __              __
  --  __/  \____________/  \____________/  \__                 ena_sys
  --
  --    <P3><P0><P1><P2><P3><P0><P1><P2><P3>                   cph_sys
  --
  -- GENERIC FAST = TRUE on DDR controller must be used (default)
  --
  --     ---<A0>---- << address and valid sampled here
  --
  --                    <R0>  << result here.
  -- The CPU is clocked every other cycle, so we will register the response from the memory
  -- we also have four clocks to do any descrambling required on the ROM read.

  o_rom_read <= (not hcnt(0)) and (not program_rom_cs_l); -- any access
  o_rom_addr <= program_rom_addr;

  u_descram : entity work.Pacman_ROM_Descrambler
  port map (
    i_clk                 => i_clk_sys,
    i_ena                 => i_ena_sys,
    --
    i_hw_pengo            => cfg.hw_pengo,
    i_hw_type_is_mrtnt    => cfg.hw_type_is_mrtnt,
    --
    i_cpu_m1_l            => cpu_m1_l,
    i_addr                => program_rom_addr,
    --
    i_rom_data            => i_rom_data,
    o_rom_data            => program_rom_data_dec
  );

  --
  -- video subsystem
  --
  u_video : entity work.Pacman_Video
    port map (
      i_clk_sys       => i_clk_sys,
      i_ena_sys       => i_ena_sys,
      --
      i_hw_type_is_mrtnt => cfg.hw_type_is_mrtnt,
      --
      i_hcnt          => hcnt,
      i_vcnt          => vcnt,
      --
      i_ab            => ab,
      i_db            => sync_bus_db,
      --
      i_hblank        => hblank,
      i_vblank        => vblank,
      i_flip          => control_reg(3),
      i_ps            => ps_reg,
      i_wr2_l         => wr2_l,
      --
      o_red           => video_r,
      o_green         => video_g,
      o_blue          => video_b,
      o_blank         => blank,
      --
      i_clk           => i_clk_sys,
      i_ena           => i_ena_sys
      );

  o_video_rgb(23 downto 16) <= video_r & video_r & video_r(2 downto 1);
  o_video_rgb(15 downto  8) <= video_g & video_g & video_g(2 downto 1);
  o_video_rgb( 7 downto  0) <= video_b & video_b & video_b & video_b;

  o_hsync_l <= not hsync;
  o_vsync_l <= not vsync;
  o_csync_l <= comp_sync_l;
  o_blank   <= blank;
  --
  -- audio subsystem
  --
  u_audio : entity work.Pacman_Audio
    port map (
      i_clk_sys        => i_clk_sys,
      i_ena_sys        => i_ena_sys,
      --
      i_hcnt           => hcnt,
      --
      i_ab             => ab,
      i_db             => sync_bus_db,
      --
      i_wr1_l          => wr1_l,
      i_wr0_l          => wr0_l,
      i_sound_on       => control_reg(1),
      --
      o_audio          => audio,
      --
      i_clk            => i_clk_sys,
      i_ena            => i_ena_sys
      );

  o_audio_l <= audio & x"00";
  o_audio_r <= audio & x"00";

end RTL;
