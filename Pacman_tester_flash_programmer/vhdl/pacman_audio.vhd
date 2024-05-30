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
-- version 002 added volume multiplier
-- version 001 initial release
--
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;

  use work.Replay_Pack.all;

library UNISIM;
  use UNISIM.Vcomponents.all;

entity Pacman_Audio is
  port (
    i_hcnt                      : in  word( 8 downto 0);
    --
    i_ab                        : in  word(11 downto 0);
    i_db                        : in  word( 7 downto 0);
    --
    i_wr1_l                     : in  bit1;
    i_wr0_l                     : in  bit1;
    i_sound_on                  : in  bit1;
    --
    o_audio_vol_out             : out word(3 downto 0);
    o_audio_wav_out             : out word(3 downto 0);
    --
    i_clk                       : in  bit1
    );
end;

architecture RTL of Pacman_Audio is

  signal addr          : word( 3 downto 0);
  signal data          : word( 3 downto 0);
  signal vol_ram_wen   : bit1;
  signal frq_ram_wen   : bit1;
  signal vol_ram_dout  : word( 3 downto 0);
  signal frq_ram_dout  : word( 3 downto 0);

  signal sum           : word( 5 downto 0);
  signal accum_reg     : word( 5 downto 0);
  
  signal rom3m_addr    : word( 6 downto 0);
  signal rom3m_data    : word( 3 downto 0);										   
  signal rom3m         : word( 3 downto 0);

  signal rom1m_addr    : word( 7 downto 0);
  signal rom1m_data    : word( 3 downto 0);

  signal audio_vol_out : word( 3 downto 0);
  signal audio_wav_out : word( 3 downto 0);
  signal audio_dac_out : word( 15 downto 0);

  signal filter_out    : word( 15 downto 0);
  
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
  
  component rom_pacman_1m
		port(
            a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            spo : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
  end component;

  component rom_pacman_3m
		port(
            a : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            spo : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
  end component;


begin

  -- 74LS74 3L
  p_sel_com : process(i_hcnt, i_ab, i_db, accum_reg)
  begin
    if (i_hcnt(1) = '0') then -- 2h,
      addr <= i_ab(3 downto 0);
      -- La memoire 74LS89 inverse les donnees en sortie. 
      -- Mais, le circuit 3K 74LS158) inverse aussi les donnees, du
      -- coup il n'y a rien a faire. On peut prendre i_db tel quel.
      data <= i_db(3 downto 0); -- removed invert
    else
      addr <= i_hcnt(5 downto 2);
      data <= accum_reg(4 downto 1);
    end if;
  end process;
  
  -- 2L
  vol_ram : for i in 0 to 3 generate
  begin
    inst: RAM16X1D
      port map (
        a0    => addr(0),
        a1    => addr(1),
        a2    => addr(2),
        a3    => addr(3),
        dpra0 => addr(0),
        dpra1 => addr(1),
        dpra2 => addr(2),
        dpra3 => addr(3),
        wclk  => i_clk,
        we    => vol_ram_wen,
        d     => data(i),
        dpo   => vol_ram_dout(i)
        );
  end generate;

  -- 2K
  frq_ram : for i in 0 to 3 generate
  begin
    inst: RAM16X1D
      port map (
        a0    => addr(0),
        a1    => addr(1),
        a2    => addr(2),
        a3    => addr(3),
        dpra0 => addr(0),
        dpra1 => addr(1),
        dpra2 => addr(2),
        dpra3 => addr(3),
        wclk  => i_clk,
        we    => frq_ram_wen,
        d     => data(i),
        dpo   => frq_ram_dout(i)
        );
  end generate;

  frq_ram_wen <= not rom3m(1);
  vol_ram_wen <= not I_WR1_L;
    
  -- ROM 3M
  -- larger than we need, only 256 x 8 needed
  u_rom_3M : rom_pacman_3m
  port map (
    a => rom3m_addr(6 downto 0),
    spo => rom3m_data
  );

  -- rom3m_addr( 6 ) <= i_wr0_l;
  -- rom3m_addr( 5 downto 0) <= i_hcnt(5 downto 0) when i_wr0_l = '1' else i_hcnt(5 downto 0) + 1;
  -- rom3m <= rom3m_data;
  -- rom3m <= rom3m_data when i_clk = '0' else (others => '1');
  rom3m_addr( 6 downto 0) <= i_wr0_l & i_hcnt(5 downto 0);
  rom3m <= rom3m_data when i_clk = '0' else (others => '1');

  -- 74LS283 1K
  p_adder : process(vol_ram_dout, frq_ram_dout, accum_reg)
  begin
    -- 1K 4 bit adder
    sum <= ('0' & vol_ram_dout & '1') + ('0' & frq_ram_dout & accum_reg(5));
  end process;

  -- 72LS174 1L
  p_accum_reg : process(i_clk, rom3m)
  begin
    -- 1L
    if (rom3m(3) = '0') then -- clear
        accum_reg <= "000000";
    elsif rising_edge(i_clk) then
        if (rom3m(0) = '0') then -- rising edge clk
            accum_reg <= sum(5 downto 1) & accum_reg(4);
        end if;
    end if;
  end process;

  p_rom_1m_addr_comb : process(accum_reg, frq_ram_dout)
  begin
    rom1m_addr( 7 downto 5) <= frq_ram_dout(2 downto 0);
    rom1m_addr( 4 downto 0) <= accum_reg(4 downto 0);
  end process;

  -- ROM 1M
  -- larger than we need, only 256 x 8 needed
  u_rom_1M : rom_pacman_1m
  port map (
    a => rom1m_addr(7 downto 0),
    spo => rom1m_data
  );
  
  -- 72LS273 2M
  p_original_output_reg : process(i_clk, i_sound_on)
  begin
    -- 2m used to use async clear
								  
    if (i_sound_on = '0') then
      audio_vol_out <= "0000";
      audio_wav_out <= "0000";
    elsif rising_edge(i_clk) then
      if (rom3m(2) = '0') then
        audio_vol_out <= vol_ram_dout(3 downto 0);
        audio_wav_out <= rom1m_data(3 downto 0);
      end if;
    end if;
  end process;
  
  o_audio_vol_out <= audio_vol_out;
  o_audio_wav_out <= audio_wav_out;

end architecture RTL;