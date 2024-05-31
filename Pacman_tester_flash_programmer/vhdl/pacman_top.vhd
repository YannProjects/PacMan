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
    i_clk_pacman_core     : in  bit1;
    i_clk_6M_star         : in  bit1;
    i_clk_6M_star_n       : in  bit1;
    i_core_reset          : in  bit1; -- actif niveau haut

    -- Video
    o_video_rgb           : out word(23 downto 0); -- 23..16 RED 15..8 GREEN 7..0 BLUE
    o_hsync_l             : out bit1;
    o_vsync_l             : out bit1;
    o_csync_l             : out bit1;
    o_blank               : out bit1;

    -- Audio
    o_audio_vol_out       : out word(3 downto 0);  -- left  sample
    o_audio_wav_out       : out word(3 downto 0);  -- right sample
    
    -- Z80    
    i_cpu_a               : in word(15 downto 0);  -- Z80 adresse bus
    o_cpu_di              : out word(7 downto 0);  -- Z80 data input
    i_cpu_do              : in word(7 downto 0);  -- Z80 data output
    
    o_cpu_rst             : out bit1; -- Z80 reset
    o_cpu_clk             : out bit1; -- Z80 clk
    o_cpu_wait_l          : out bit1; -- Z80 wait
    o_cpu_int_l           : out bit1; -- Z80 INT
    i_cpu_m1_l            : in bit1; -- Z80 M1
    i_cpu_mreq_l          : in bit1; -- Z80 MREQ
    i_cpu_iorq_l          : in bit1; -- Z80 IORQ
    i_cpu_rd_l            : in bit1; -- Z80 RD
    i_cpu_rfsh_l          : in bit1; -- Z80 RFRSH
    i_halt                : in bit1;
    
    -- Registres de configuration (IN0, IN1, DIP SW)
    i_config_reg          : in word(7 downto 0);
    
    -- Z80 code ROM
    o_rom_cs_l           : out bit1; -- ROM CS
    o_rd_regs_l          : out bit1; -- CPU read interrupt reg or hold register
    
    -- IN0, IN1, DPI switches
    o_in0_cs_l           : out bit1;
    o_in1_cs_l           : out bit1;
    o_dip_sw_cs_l        : out bit1;
    
    -- CPU freeze
    i_freeze             : in bit1
    );
end;

architecture RTL of Pacman_Top is
  -- The original uses a 6.144 MHz clock
  -- base clock 24.576 (x4)
  -- ref clock  98.304

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
  signal cpu_wait_l             : bit1;
  signal cpu_int_l              : bit1;

  signal program_rom_cs_l       : bit1;
  signal sync_bus_cs_l          : bit1;

  signal control_reg            : word( 7 downto 0);
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

  signal blank                  : bit1;
  signal video_r                : word( 2 downto 0);
  signal video_g                : word( 2 downto 0);
  signal video_b                : word( 1 downto 0);

  signal audio                  : word(15 downto 0);
  
  signal sync_bus_stb_U0        : bit1;
  signal sync_bus_r_w_U0_l      : bit1; 
  signal sync_bus_stb_U2        : bit1; 
  signal sync_bus_rp_U4_1    : bit1; 
  signal sync_bus_wp_U4_1    : bit1;
  signal sync_bus_rp_l          : bit1;
  signal sync_bus_wp_l          : bit1;

begin
  --
  -- video timing
  --
  p_hvcnt : process
    variable hcarry,vcarry : boolean;
  begin
      wait until rising_edge(i_clk_pacman_core);
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
  end process;

  p_sync_comb : process(hcnt, vcnt)
  begin
    vsync <= not vcnt(8);
    do_hsync <= (hcnt = "010101111"); -- 0AF
  end process;

  p_sync : process
  begin
      wait until rising_edge(i_clk_pacman_core);
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
  end process;

  p_comp_sync : process(hsync, vsync)
  begin
    comp_sync_l <= (not vsync) and (not hsync);
  end process;
  
  --
  -- cpu
  --
  p_cpu_wait_comb : process(sync_bus_wreq_l)
  begin
    cpu_wait_l  <= '1';
    if (sync_bus_wreq_l = '0') then
      cpu_wait_l  <= '0';
    end if;
  end process;

  p_irq_req_watchdog : process
    variable rising_vblank : boolean;
  begin
      wait until rising_edge(i_clk_pacman_core);
      rising_vblank := do_hsync and (vcnt = "111101111"); -- 1EF
      -- interrupt 8c
    
      if (control_reg(0) = '0') then
        cpu_int_l <= '1';
      elsif rising_vblank then -- 1EF
        cpu_int_l <= '0';
      end if;
    
      -- watchdog 8c
      -- note sync reset
      if (i_core_reset = '1') or (i_freeze = '0') then
        watchdog_cnt <= "1111";
      elsif (iodec_wdr_l = '0') then
        watchdog_cnt <= "0000";
      elsif rising_vblank then
        watchdog_cnt <= watchdog_cnt + "1";
      end if;
    
      watchdog_reset_l <= '1';
      if (watchdog_cnt = "1111") then
        watchdog_reset_l <= '0';
      end if;
    
      -- simulation
      -- watchdog_reset_l <= not i_core_reset; -- watchdog disable
      
  end process;

  -- other cpu signals
  h1_inv      <= not hcnt(0);
  
  -- Z80 externe
  o_cpu_clk <= not hcnt(0);

  
  o_cpu_rst <= watchdog_reset_l;
  o_cpu_wait_l <= cpu_wait_l and i_freeze;
  o_cpu_int_l <= cpu_int_l;
  o_in0_cs_l <= iodec_in0_l;
  o_in1_cs_l <= iodec_in1_l;
  o_dip_sw_cs_l <= iodec_dipsw1_l;
  o_rom_cs_l <= program_rom_cs_l;
  
  --
  -- primary addr decode
  --
  p_mem_decode_comb : process(i_cpu_rfsh_l, i_cpu_mreq_l, i_cpu_a)
  begin
    --Normally the Pac-Man ROMs reside at address 0x0000-0x3fff and are mirrored at 0x8000-0xbfff (Z-80 A15 is not used in Pac-Man).
    --The aux board logic modifies the address map and enables the aux board ROMs for addresses 0x3000-0x3fff and 0x8000-0x97ff.

    -- 7M
    -- 7N
    sync_bus_cs_l <= '1';
    --
    if (i_cpu_mreq_l = '0') and (i_cpu_rfsh_l = '1') then
      -- Pacman
      -- syncbus 0x4000 - 0x7FFF (RAM + vidéo +  I/Os)
      if (i_cpu_a(14) = '1') then
        sync_bus_cs_l <= '0';
      end if;
    end if;

    program_rom_cs_l  <= '1';
    --
    -- Pacman
    -- ROM     0x0000 - 0x3FFF
    if (i_cpu_a(14) = '0') and (i_cpu_rd_l = '0') then
      program_rom_cs_l <= '0';
    end if;
  end process;
  
  ---------------------------------------------------------------
  ---------------------------------------------------------------
  -- BEGIN
  -- sync bus custom ic (6D)
  -- BEGIN
  ---------------------------------------------------------------
  ---------------------------------------------------------------
  -- 74LS374 U6 & U7
  p_sync_bus_reg : process
  begin
      wait until rising_edge(i_clk_6M_star);
      ------------------------------------------------------------
      -- Modification pour éviter des problème de timing entre le délai des adresse du Z80 (positionné à 57 ns dans les contraintes d'input delay.
      -- Ce délai est trop important (pessimiste) je pense.
      -- et le front montant de l'horloge i_clk_6M_star qui est à ~54 ns et arrive trop tôt par rapport au délai des adresses
      -- => Ca corrige ce problème, mais à vérifier si ça ne casse rien d'autre...
      -- wait until rising_edge(i_clk_pacman_core);
      ------------------------------------------------------------
      -- register on sync bus module that is used to store interrupt vector
      -- Implementation du circuit U7 du SYNC BUS. Utilise pour memoriser le vecteur
      -- d'interruption dans un registre (U7)
      if (i_cpu_iorq_l = '0') and (i_cpu_m1_l = '1') then
        cpu_vec_reg <= i_cpu_do;
      end if;
    
      -- read holding reg
      -- Circuit U6 du SYNC BUS. 
      if (hcnt(1 downto 0) = "01") then
        -- 74LS244 U5 du SYNC BUS
        if sync_bus_r_w_l = '0' then
            sync_bus_reg <= i_cpu_do;
        else
            sync_bus_reg <= sync_bus_db;
        end if;
      end if;
  end process;
  
  -- 74LS139 (U0) SYNC BUS controller
  -- A => hcnt(1)
  -- B => RDn
  p_sync_bus_comb : process(i_cpu_rd_l, sync_bus_cs_l, hcnt)
  begin
    -- sync_bus_stb is now an active low clock enable signal (= 5D pin 12 "CLK")
    sync_bus_stb_U0 <= '1';
    sync_bus_r_w_U0_l <= '1';
    sync_bus_wreq_l <= '1';

    -- Le CPU à l'accès au bus "ab" si hcnt(1) = '0'
    if (sync_bus_cs_l = '0') then
      if (i_cpu_rd_l = '0') and (hcnt(1) = '0') then
        sync_bus_stb_U0 <= '0'; -- Pin 12 74LS139
      elsif (i_cpu_rd_l = '0') and (hcnt(1) = '1') then
        -- Wait request
        sync_bus_wreq_l <= '0'; -- Pin 11 74LS139
      elsif (i_cpu_rd_l = '1') and (hcnt(1) = '0') then
        -- sync_bus_r_w_l = 1 => Read ; sync_bus_r_w_l = 0 => Write
        sync_bus_r_w_U0_l <= '0'; -- Pin 10
      end if;
    end if;
  end process;
  
  -- 74LS74 U2 pin 5
  p_sync_bus_stb_U2 : process
  begin
    wait until rising_edge(i_clk_6M_star);
    if hcnt(0) = '0' then
        sync_bus_stb_U2 <= sync_bus_stb_U0;
    end if;
  end process;  
  
  -- 74LS74 U2 pin 9
  p_sync_bus_rw_U2 : process
  begin
    wait until rising_edge(i_clk_6M_star);
    if hcnt(0) = '0' then
        sync_bus_r_w_l <= sync_bus_r_w_U0_l;
    end if;
  end process;
  
  -- 74LS74 U4 pin 6
  p_sync_bus_U4_1 : process
  begin
    wait until rising_edge(i_clk_6M_star);
    -- R/W IN0, IN1, RAM,...
    sync_bus_rp_U4_1 <= not hcnt(0);
  end process;
 
  -- 74LS74 U4 pin 8
  p_sync_bus_U4_2 : process
  begin
    wait until falling_edge(i_clk_pacman_core);
    sync_bus_wp_U4_1 <= not hcnt(0);
  end process;
  
  sync_bus_rp_l <= not (sync_bus_rp_U4_1 or hcnt(0));
  sync_bus_wp_l <= not (sync_bus_wp_U4_1 or hcnt(0));
  
  -- Chip select IN0, IN1, RAM,...
  sync_bus_stb <= not(not(sync_bus_stb_U2 or sync_bus_rp_l) or not(sync_bus_r_w_l or sync_bus_wp_l));
  
  p_db_mux_comb : process(hcnt, rams_data_out, i_config_reg)
  begin
    -- simplified data source for video subsystem
    -- only cpu or ram are sources of interest
    if (sync_bus_r_w_l = '0') then
        sync_bus_db <= i_cpu_do;
    else
        sync_bus_db <= rams_data_out;
        if (iodec_in0_l = '0') or (iodec_in1_l = '0') then
            -- Rack adv force à 1 pour le moment car il manque une pull-up.
            sync_bus_db <= (i_config_reg(7), i_config_reg(6), i_config_reg(5), '1', i_config_reg(0), i_config_reg(1), i_config_reg(2), i_config_reg(3));
        elsif (iodec_in1_l = '0') then
            sync_bus_db <= (i_config_reg(7), i_config_reg(6), i_config_reg(5), i_config_reg(4), i_config_reg(0), i_config_reg(1), i_config_reg(2), i_config_reg(3));
        elsif (iodec_dipsw1_l = '0') then
            -- '11' pour le moment sur les bits 0 et 1 car il manque des pull-up sur les straps.
            sync_bus_db <= ('1', '1', i_config_reg(1), i_config_reg(0), i_config_reg(4), i_config_reg(5), i_config_reg(6), i_config_reg(7));
        end if;
    end if;
  end process;

  p_cpu_data_in_mux_comb : process(program_rom_cs_l, i_cpu_iorq_l, i_cpu_m1_l, cpu_vec_reg,
                                   sync_bus_wreq_l, sync_bus_reg,
                                   rams_data_out,
                                   iodec_in0_l, iodec_in1_l, iodec_dipsw1_l, iodec_dipsw2_l)
  begin
    -- simplified again
    if (i_cpu_iorq_l = '0') and (i_cpu_m1_l = '0') then
      o_cpu_di <= cpu_vec_reg;
    elsif (sync_bus_wreq_l = '0') then
      -- Cas de la lecture du registre de sync_bus_req.
      o_cpu_di <= sync_bus_reg;
    end if;
  end process;

  ---------------------------------------------------------------
  ---------------------------------------------------------------
  -- END
  -- sync bus custom ic (6D)
  -- END
  ---------------------------------------------------------------
  ---------------------------------------------------------------

  -- Lecture registre synchro bus ou
  -- vect_reg ou
  -- IN0, IN1, DIP switch
  o_rd_regs_l <= '0' when (sync_bus_wreq_l = '0') or (i_cpu_iorq_l = '0' and i_cpu_m1_l = '0') else '1';
  
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

  p_ab_mux_comb : process(hcnt, i_cpu_a, vram_addr_ab)
  begin
    -- When 2H is low, the CPU controls the bus.
    -- Le bus (ab) utilise pour adresser la RAM est partage entre le CPU.
    -- Le signal vram_addr_ab est l'adresse generee par le custom IC VRAM adresser (5S)
    -- Cycle utilise par le CPU pour acceder à la RAM
    if (hcnt(1) = '0') then
      ab <= i_cpu_a(11 downto 0);
    -- Cycle utilise par la partie VRAM adresser pour la generation de la video
    else
      ab <= vram_addr_ab;
    end if;
  end process;

  -- 7H / 7L (sync_bus_stb = ping 12 5D
  p_vram_comb : process(hcnt, i_cpu_a, sync_bus_stb)
  begin
    -- RAM = 0x4000 - 0x4FEF => A12 = 0. vram_l = 0 si cpu_addr(12) = 0 et sync_bus_stb = 0
    vram_l <= ( (i_cpu_a(12) or sync_bus_stb) and not (hcnt(1) and hcnt(0)) );
  end process;

  p_io_decode_comb : process(sync_bus_r_w_l, sync_bus_stb, ab, i_cpu_a)
  begin
    -- PACMAN

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

    if (i_cpu_a(12) = '1') and ( sync_bus_stb = '0') then
      if (sync_bus_r_w_l ='0') then -- writes
        -- Pacman
        if (ab(7 downto 4) = "0100") then wr0_l          <= '0'; end if; -- Audio
        if (ab(7 downto 4) = "0101") then wr1_l          <= '0'; end if; -- Audio
        if (ab(7 downto 4) = "0110") then wr2_l          <= '0'; end if; -- Sprite RAM
        if (ab(7 downto 6) = "00"  ) then iodec_out_l    <= '0'; end if;
        if (ab(7 downto 6) = "11"  ) then iodec_wdr_l    <= '0'; end if;
      else -- reads
        -- Pacman
        if (ab(7 downto 6) = "00"  ) then iodec_in0_l    <= '0'; end if;
        if (ab(7 downto 6) = "01"  ) then iodec_in1_l    <= '0'; end if;
        if (ab(7 downto 6) = "10"  ) then iodec_dipsw1_l <= '0'; end if;
      end if;
    end if;
  end process;

  p_control_reg : process
    variable ena : std_logic_vector(7 downto 0);
  begin
    -- 8 bit addressable latch 7K
    -- (made into register)

    --   PACMAN
    --
    -- 0 interrupt ena                  interrupt ena
    -- 1 sound ena                      sound ena
    -- 2 not used                       ps(1)
    -- 3 flip                           flip
    -- 4 1 player start lamp            coin 1 meter
    -- 5 2 player start lamp            coin 2 meter
    -- 6 coin lockout                   ps(2)
    -- 7 coin counter                   ps(3)

      wait until rising_edge(i_clk_pacman_core);
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
            control_reg(i) <= i_cpu_do(0);
          end if;
        end loop;
      end if;
  end process;

  u_rams : entity work.Pacman_RAMs
    port map (
      -- note, we get a one clock delay from our rams
      i_addr         => ab,
      i_data         => i_cpu_do, -- cpu only source of ram data
      o_data         => rams_data_out,
      i_r_w_l        => sync_bus_r_w_l,
      i_vram_l       => vram_l,
      i_clk          => i_clk_pacman_core
      );

  --
  -- video subsystem
  --
  u_video : entity work.Pacman_Video
    port map (
      i_clk           => i_clk_pacman_core,
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
      i_wr2_l         => wr2_l,
      --
      o_red           => video_r,
      o_green         => video_g,
      o_blue          => video_b,
      o_blank         => blank
      );

  o_video_rgb(23 downto 16) <= video_r & "00000";
  o_video_rgb(15 downto  8) <= video_g & "00000";
  o_video_rgb( 7 downto  0) <= video_b & "000000";

  o_hsync_l <= not hsync;
  o_vsync_l <= not vsync;
  o_csync_l <= comp_sync_l;
  o_blank   <= blank;
  --
  -- audio subsystem
  --
  u_audio : entity work.Pacman_Audio
    port map (
      i_hcnt           => hcnt,
      --
      i_ab             => ab,
      i_db             => sync_bus_db,
      --
      i_wr1_l          => wr1_l,
      i_wr0_l          => wr0_l,
      i_sound_on       => control_reg(1),
      --
      o_audio_vol_out  => o_audio_vol_out,
      o_audio_wav_out  => o_audio_wav_out,
      --
      i_clk            => i_clk_6M_star_n
      );
      
end RTL;
