--
-- A simulation model of Pacman hardware
-- Copyright (c) MikeJ - January 2006
--
-- All rights reserved
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
-- The latest version of this file can be found at: www.fpgaarcade.com
--
-- Email pacman@fpgaarcade.com
--
-- Revision list
--
-- version 003 Jan 2006 release, general tidy up
-- version 001 initial release
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.Replay_Pack.all;

library UNISIM;
use UNISIM.Vcomponents.all;

entity Pacman_Video is
  port (
    i_clk                       : in  bit1;
    --
    i_hcnt                      : in  word(8 downto 0);
    i_vcnt                      : in  word(8 downto 0);
    --
    i_ab                        : in  word(11 downto 0);
    i_db                        : in  word( 7 downto 0);
    --
    i_hblank                    : in  bit1;
    i_vblank                    : in  bit1;
    i_flip                      : in  bit1;
    i_wr2_l                     : in  bit1;
    --
    o_red                       : out word( 2 downto 0);
    o_green                     : out word( 2 downto 0);
    o_blue                      : out word( 1 downto 0);
    o_blank                     : out bit1
    );
end;

architecture RTL of PACMAN_VIDEO is

  signal sprite_xy_ram_wen  : bit1;
  signal sprite_xy_ram_do   : word( 7 downto 0);
  signal dr                 : word( 7 downto 0);

  signal char_sum_reg       : word( 3 downto 0);
  signal char_match_reg     : bit1;
  signal char_hblank_reg    : bit1;
  signal db_reg             : word( 7 downto 0);

  signal xflip              : bit1;
  signal yflip              : bit1;
  signal obj_on             : bit1;

  signal ca                 : word(11 downto 0);
  signal char_rom_5e_0_dout : word( 7 downto 0);
  signal char_rom_5f_0_dout : word( 7 downto 0);
  signal cd                 : word( 7 downto 0);

  signal shift_regl         : word( 3 downto 0);
  signal shift_regu         : word( 3 downto 0);
  signal shift_op           : word( 1 downto 0);
  signal shift_sel          : word( 1 downto 0);

  signal vout_obj_on        : bit1;
  signal vout_yflip         : bit1;
  signal vout_hblank        : bit1;
  signal vout_db            : word( 4 downto 0);

  signal cntr_ld            : bit1;
  signal ra                 : word( 7 downto 0);
  signal sprite_ram_ip      : word( 3 downto 0);
  signal sprite_ram_op      : word( 3 downto 0);
  signal sprite_ram_addr    : word(11 downto 0);
  signal sprite_ram_addr_t1 : word(11 downto 0);
  signal vout_obj_on_t1     : bit1;
  signal col_rom_addr       : word(10 downto 0);

  signal lut_4a             : word( 7 downto 0);
  signal lut_4a_t1          : word( 7 downto 0);
  signal vout_hblank_t1     : bit1;
  signal sprite_ram_reg     : word( 3 downto 0);

  signal video_out          : word( 7 downto 0);
  signal video_op_sel       : bit1;
  signal final_col          : word( 4 downto 0);
  signal lut_7f             : word( 7 downto 0);
  
  component RAM16X1D
		port(
			DPO		: out std_ulogic;
			SPO		: out std_ulogic;
			A0		: in std_ulogic;
			A1		: in std_ulogic;
			A2		: in std_ulogic;
			A3		: in std_ulogic;        
			D		: in std_ulogic;
			DPRA0	: in std_ulogic;
			DPRA1	: in std_ulogic;
			DPRA2	: in std_ulogic;
			DPRA3	: in std_ulogic;
			WCLK	: in std_ulogic;        
			WE		: in std_ulogic);
  end component;

  component RAMB16_S4_S4
  port (
      DOA    : out word(3 downto 0);
      DIA    : in word(3 downto 0);
      ADDRA  : in word(11 downto 0);
      WEA    : in std_logic;
      ENA    : in std_logic;
      SSRA   : in std_logic;
      CLKA   : in std_logic;
      -- read side
      DOB    : out word(3 downto 0);
      DIB    : in word(3 downto 0);
      ADDRB  : in word(11 downto 0);
      WEB    : in std_logic;
      ENB    : in std_logic;
      SSRB   : in std_logic;
      CLKB   : in std_logic
  );
  end component;   

begin

  p_sprite_ram_comb : process(i_hblank, i_hcnt, i_wr2_l, sprite_xy_ram_do)
  begin
    -- ram enable is low when HBLANK_L is 0 (for sprite access) or
    -- 2H is low (for cpu writes)
    -- we can simplify this

    sprite_xy_ram_wen <= '0';
    if (i_wr2_l = '0') then
      sprite_xy_ram_wen <= '1';
    end if;

    if (i_hblank = '1') then
      dr <= not sprite_xy_ram_do;
    else
      dr <= "11111111"; -- pull ups on board
    end if;
  end process;

  sprite_xy_ram : for i in 0 to 7 generate
  -- should be a latch, but we are using a clock
  -- ops are disabled when ME_L is high or WE_L is low
  -- YHE => Chips 3F, 3H 
  begin
    inst: RAM16X1D
      port map (
        a0    => i_ab(0),
        a1    => i_ab(1),
        a2    => i_ab(2),
        a3    => i_ab(3),
        dpra0 => i_ab(0),
        dpra1 => i_ab(1),
        dpra2 => i_ab(2),
        dpra3 => i_ab(3),
        wclk  => i_clk,
        we    => sprite_xy_ram_wen,
        d     => i_db(i),
        dpo   => sprite_xy_ram_do(i)
        );
  end generate;

  
  p_char_regs : process
    variable inc : std_logic;
    variable sum : std_logic_vector(8 downto 0);
    variable match : std_logic;
  begin
      wait until rising_edge(i_clk);
      -- Tous les 8 pixels il faut changer de tile
      -- Composants 1H 74LS174, 1F et 2F (74LS283), la somme est latch�e
      -- sur le front montant 4H 
      if (i_hcnt(2 downto 0) = "011") then -- rising 4h
        -- Quand hblank = 0 => inc = 1 et dr = "11111111" => on a toujours dr & inc = 111111111
        -- donc:
        -- (i_vcnt(7 downto 0) & '1') + (dr & inc):
        --  xxxxxxxx1
        -- +
        --  111111111
        --  ---------
        --  xxxxxxxx => i_vcnt(7 downto 0) & '0'
        -- Quand hblank passe � 1 on a i_vcnt = 0x1F0. Si dr=0 (valeur par d�faut), char_match_reg=1 mais pendant le VBLANK => rien n'est affiche.
        inc := (not i_hblank);
        -- 1f, 2f
        -- Dans ce cas (i_hcnt(2 downto 0) = "011"), la valeur positionn�e sur le bus AB
        -- correspond aux adresses paires des registres de sprites (X-location)
        -- mais l'image est orient�e horizontalement et coordonn�e X = n� de ligne sur l'ecran ?
        -- char_match_reg est a priori valide pour 16 lignes pour afficher les 16 lignes du sprite
        sum := (i_vcnt(7 downto 0) & '1') + (dr & inc);
        -- 3e
        match := '0';
        if (sum(8 downto 5) = "1111") then
          match := '1';
        end if;
        -- 1h
        char_sum_reg     <= sum(4 downto 1);
        char_match_reg   <= match;
        char_hblank_reg  <= i_hblank;
        -- 4d 74LS373
        -- Contient 8 bits avec 2 couleurs par bits => 2 pixels
        -- Le registre est mis � jours tous les 4 pixels (i_hcnt(2 downto 0) = "011")
        db_reg <= i_db; -- character reg
      end if;
  end process;

  p_flip_comb : process(char_hblank_reg, i_flip, db_reg)
  begin
    if (char_hblank_reg = '0') then
      xflip <= i_flip;
      yflip <= i_flip;
    else
      -- Pour les sprites (hblank = 1 => On lit les registres de sprites
      -- bits 7-2 : n� sprite
      -- bits 1 : flip X
      -- bits 0 : flip Y
      xflip <= db_reg(1);
      yflip <= db_reg(0);
    end if;
  end process;

  p_char_addr_comb : process(db_reg, i_hcnt,
                             char_match_reg, char_sum_reg, char_hblank_reg,
                             xflip, yflip)
  begin
    -- 2h, 4e
    -- Sert a controler le d�but et la fin de l'affichage des caracteres
    -- (affichage = toute la ligne - les 4 caracteres en bordure de ligne (ex.: 0x3C8, 0x3E8, 0x008, 0x028) 
    obj_on <= char_match_reg or i_hcnt(8); -- 256h not 256h_l

    ca(11 downto 6) <= db_reg(7 downto 2);

    if (char_hblank_reg = '0') then
      ca(5)     <= db_reg(1);
      ca(4)     <= db_reg(0);
    else
      ca(5)     <= char_sum_reg(3) xor xflip;
      ca(4)     <= i_hcnt(3);
    end if;

    ca(3) <= i_hcnt(2)       xor yflip;
    ca(2) <= char_sum_reg(2) xor xflip;
    ca(1) <= char_sum_reg(1) xor xflip;
    ca(0) <= char_sum_reg(0) xor xflip;

  end process;
  
  -- Tile (= char) roms
  u_rom_5E : entity work.rom_pacman_5e
  port map (
    a => ca,
    spo => char_rom_5e_0_dout
  );

  -- Sprite ROM
  u_rom_5F : entity work.rom_pacman_5f
  port map (
    a => ca,
    spo => char_rom_5f_0_dout
  );

  p_char_data_mux : process(char_hblank_reg, char_rom_5e_0_dout, char_rom_5f_0_dout)
  begin
    -- 5l
    -- 5e 1
    -- 5f 3

    -- pacman.5e Tile ROM (256 8x8 pixel tile image)
    -- pacman.5f Sprite ROM (64 16x16 sprite images)
    if (char_hblank_reg = '0') then
      cd <= char_rom_5e_0_dout;
    else
      -- hblank = 1 => On lit la ROM des sprites
      cd <= char_rom_5f_0_dout;
    end if;
  end process;

  -- 5B/5C 74LS194
  p_char_shift : process
  begin
    -- 4 bit shift req
    wait until rising_edge(i_clk);
      case shift_sel is
        when "00" => null;

        when "01" => shift_regu <= '0' & shift_regu(3 downto 1);
                     shift_regl <= '0' & shift_regl(3 downto 1);

        when "10" => shift_regu <= shift_regu(2 downto 0) & '0';
                     shift_regl <= shift_regl(2 downto 0) & '0';

        when "11" => shift_regu <= cd(7 downto 4); -- load
                     shift_regl <= cd(3 downto 0);
        when others => null;
      end case;
  end process;

  -- 5A
  p_char_shift_comb : process(i_hcnt, vout_yflip, shift_regu, shift_regl)
    variable ip : std_logic;
  begin
    ip := i_hcnt(0) and i_hcnt(1);
    if (vout_yflip = '0') then

      shift_sel(0) <= ip;
      shift_sel(1) <= '1';
      shift_op(0) <= shift_regl(3);
      shift_op(1) <= shift_regu(3);
    else

      shift_sel(0) <= '1';
      shift_sel(1) <= ip;
      shift_op(0) <= shift_regl(0);
      shift_op(1) <= shift_regu(0);
    end if;
  end process;

  p_video_out_reg : process
  begin
    wait until rising_edge (i_clk);
      if (i_hcnt(2 downto 0) = "111") then
        vout_obj_on   <= obj_on;
        vout_yflip    <= yflip;
        vout_hblank   <= i_hblank;
        vout_db(4 downto 0) <= i_db(4 downto 0); -- colour reg
      end if;
  end process;

  -- LUT de conversion permettant de retrouver l'index de couleurs 
  p_lut_4a_comb : process(vout_db, shift_op)
  begin
    col_rom_addr(10 downto 8) <= (others => '0'); --
    col_rom_addr(          7) <= '0';  -- Pengo PCB option
    col_rom_addr( 6 downto 0) <= vout_db(4 downto 0) & shift_op(1 downto 0);
  end process;
  
  -- 0x80 Pacman, 0x400 Pengo
  u_rom_4a : entity work.rom_pacman_4a
  port map (
    -- Juste besoin de 256 octets
    a => col_rom_addr(7 downto 0),
    spo => lut_4a
  );

  p_cntr_ld : process(i_hcnt, vout_obj_on, vout_hblank)
    variable ena : std_ulogic;
  begin
    ena := '0';
    -- 8H
    -- Pendant le hblank, la valeur sur i_ab correspond aux adresses impaires
    -- des registres de sprites: c'est l'adresse en horizontal.
    -- Cette valeur est charg�e dans le registre ra pendant le hblank et la RAM de sprite est remplie
    -- avec le contenu du sprite.
    -- Chaque registre de sprite est lu un par un (0x3, 0x5, 0x7, 0x9, 0xB, 0xD) et on rempli la RAM en rechargeant
    -- le registre ra. Si plusieurs sprites on la m�me adresses, c'est le dernier qui apparaitra en premier.
    -- Le plus prioritaire (celui qui est affich� en dernier) est a priori le sprite 6.
    -- Je ne vois pas que les sprite 0 et 7 sont adress�s. 
    -- La m�moire des sprites contient une ligne compl�te d'affichage � partie du pixel 16 jusqu'au 272
    -- Les 16 premiers et 16 derniers pixel ne peuvent pas afficher de sprite. 
    if (i_hcnt(3 downto 0) = "0111") then
      ena := '1';
    end if;
    cntr_ld <= ena and (vout_hblank or not vout_obj_on);
  end process;

  p_ra_cnt : process
  begin
    wait until rising_edge(i_clk);
      if (cntr_ld = '1') then
        ra <= dr;
      else
        ra <= ra + "1";
      end if;
  end process;

  sprite_ram_addr <= "0000" & ra;

  u_sprite_ram : RAMB16_S4_S4
    port map (
      -- write side, 1 clk later than original
      DOA   => open,
      DIA   => sprite_ram_ip,
      ADDRA => sprite_ram_addr_t1,
      WEA   => vout_obj_on_t1,
      ENA   => '1',
      SSRA  => '0',
      CLKA  => i_clk,
      -- read side
      DOB   => sprite_ram_op,
      DIB   => "0000",
      ADDRB => sprite_ram_addr,
      WEB   => '0',
      ENB   => '1',
      SSRB  => '0',
      CLKB  => i_clk
      );

  p_sprite_ram_op_comb : process(sprite_ram_op, vout_obj_on_t1)
  begin
    if vout_obj_on_t1 = '1' then
      sprite_ram_reg <= sprite_ram_op;
    else
      sprite_ram_reg <= "0000";
    end if;
  end process;

  p_video_op_sel_comb : process(sprite_ram_reg)
  begin
    video_op_sel <= '0'; -- no sprite
    if not (sprite_ram_reg = "0000") then
      video_op_sel <= '1';
    end if;
  end process;

  p_sprite_ram_ip_reg : process
  begin
    wait until rising_edge(i_clk);
      sprite_ram_addr_t1 <= sprite_ram_addr;
      vout_obj_on_t1 <= vout_obj_on;
      vout_hblank_t1 <= vout_hblank;
      lut_4a_t1 <= lut_4a;
  end process;

  p_sprite_ram_ip_comb : process(vout_hblank_t1, video_op_sel, sprite_ram_reg, lut_4a_t1)
  begin
  -- 3a
    if (vout_hblank_t1 = '0') then
      sprite_ram_ip <= (others => '0');
    else
      -- Cette partie permet soit de lire la donn�e contenue dans le latch sprite (sprite_ram_ip <= sprite_ram_reg) pour l'affichage du sprite
      -- soit d'�crire la valeur de la couleur dans la RAM des sprites (sprite_ram_ip <= lut_4a_t1(3 downto 0))
      -- Mais, je ne comprends pas � quel moment les donn�es de sprites sont �crites dans la RAM sprite (par le CPU ???)
      -- A priori, les donn�es sont �crite durant top line avec hsync = 1, elles sont effac�es juste apr�s la lecture
      -- gr�ce au d�calage d'un cyle entre la lecture (en premier) et l'ecriture (en second via vout_hblank_t1). A confirmer quand m�me.
      if (video_op_sel = '1') then
        sprite_ram_ip <= sprite_ram_reg;
      else
        sprite_ram_ip <= lut_4a_t1(3 downto 0);
      end if;
    end if;
  end process;

  -- Multiplexeur s�lectionnant soit les donn�es de la ROM couleur, soit du latch de sprite (3C)
  -- qui contient les valeurs de couleurs du sprite
  p_video_op_comb : process(vout_hblank, i_vblank, video_op_sel, sprite_ram_reg, lut_4a)
  begin
      -- 3b
    final_col(4) <= '0';
    if (vout_hblank = '1') or (i_vblank = '1') then
      final_col(3 downto 0) <= (others => '0');
    else
      if (video_op_sel = '1') then
        final_col(3 downto 0) <= sprite_ram_reg; -- sprite
      else
        final_col(3 downto 0) <= lut_4a(3 downto 0); -- tile
      end if;
    end if;
  end process;

  u_rom_7f : entity work.rom_pacman_7f
  port map (
    a => final_col,
    spo => lut_7f
  );
  
  p_final_reg : process
  begin
    wait until rising_edge(i_clk);
    -- not really registered
    video_out <= lut_7f;
    o_blank   <= vout_hblank or i_vblank;
  end process;

  --  assign outputs
  o_blue (1 downto 0) <= video_out(7 downto 6);
  o_green(2 downto 0) <= video_out(5 downto 3);
  o_red  (2 downto 0) <= video_out(2 downto 0);

end architecture RTL;
