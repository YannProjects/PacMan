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
    -- ARM interface
    i_memio_to_core             : in  r_Memio_to_core := z_Memio_to_core;
    --
    i_memio_fm_core             : in  r_Memio_fm_core := z_Memio_fm_core; -- cascade input. Must be z_Memio_fm_core on first memory
    o_memio_fm_core             : out r_Memio_fm_core; -- output back to LIB, or cascade into i_memio_fm_core on next memory
    --
    i_clk_sys                   : in  bit1 := '0';
    i_ena_sys                   : in  bit1 := '0';
    --
    i_hcnt                      : in  word( 8 downto 0);
    --
    i_ab                        : in  word(11 downto 0);
    i_db                        : in  word( 7 downto 0);
    --
    i_wr1_l                     : in  bit1;
    i_wr0_l                     : in  bit1;
    i_sound_on                  : in  bit1;
    --
    o_audio                     : out word(15 downto 0);
    --
    i_clk                       : in  bit1;
    i_ena                       : in  bit1
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
  signal rom3m_n       : word(15 downto 0);
  signal rom3m_w       : word( 3 downto 0);
  signal rom3m         : word( 3 downto 0);

  signal rom1m_addr    : word(10 downto 0);
  signal rom1m_data    : word( 7 downto 0);

  signal audio_vol_out : word( 3 downto 0);
  signal audio_wav_out : word( 3 downto 0);
  signal audio_dac_out : word(15 downto 0);

  signal filter_in_s   : signed(15 downto 0);
  signal filter_out_s  : signed(15 downto 0);
  signal filter_out    : word(15 downto 0);
  -- using Chris Brenner volume LUT
  --
  type ROM_ARRAY is array(0 to 255) of std_logic_vector(15 downto 0);
  constant ROM : ROM_ARRAY := (
    x"25ED",x"1F81",x"19F3",x"15E9",x"11B4",x"0F02",x"0C7B",x"0A82", -- 0x0000
    x"07B7",x"064F",x"04EE",x"03D1",x"0288",x"01A4",x"00BE",x"0000", -- 0x0008
    x"25ED",x"201C",x"1B15",x"176D",x"139E",x"112D",x"0EE3",x"0D1A", -- 0x0010
    x"0A93",x"094D",x"080E",x"070B",x"05E2",x"0513",x"0443",x"0397", -- 0x0018
    x"25ED",x"20CD",x"1C5F",x"1926",x"15CA",x"13A4",x"119F",x"100D", -- 0x0020
    x"0DD2",x"0CB3",x"0B9A",x"0AB6",x"09B0",x"08F9",x"0842",x"07AA", -- 0x0028
    x"25ED",x"2169",x"1D81",x"1AAA",x"17B4",x"15CF",x"1408",x"12A5", -- 0x0030
    x"10AE",x"0FB1",x"0EB9",x"0DF0",x"0D09",x"0C68",x"0BC7",x"0B41", -- 0x0038
    x"25ED",x"225C",x"1F47",x"1D08",x"1AB2",x"1933",x"17CB",x"16B3", -- 0x0040
    x"1526",x"145E",x"139A",x"12FC",x"1245",x"11C6",x"1147",x"10DD", -- 0x0048
    x"25ED",x"22F8",x"2069",x"1E8C",x"1C9C",x"1B5E",x"1A34",x"194B", -- 0x0050
    x"1802",x"175C",x"16B9",x"1636",x"159F",x"1535",x"14CB",x"1474", -- 0x0058
    x"25ED",x"23A8",x"21B2",x"2045",x"1EC8",x"1DD5",x"1CF0",x"1C3E", -- 0x0060
    x"1B41",x"1AC2",x"1A46",x"19E1",x"196D",x"191C",x"18CB",x"1888", -- 0x0068
    x"25ED",x"2444",x"22D4",x"21C9",x"20B2",x"2000",x"1F58",x"1ED6", -- 0x0070
    x"1E1D",x"1DC0",x"1D65",x"1D1B",x"1CC6",x"1C8B",x"1C4F",x"1C1E", -- 0x0078
    x"25ED",x"2594",x"2548",x"2510",x"24D6",x"24B1",x"248E",x"2473", -- 0x0080
    x"244C",x"2439",x"2426",x"2416",x"2405",x"23F8",x"23EC",x"23E2", -- 0x0088
    x"25ED",x"2630",x"266A",x"2694",x"26C0",x"26DC",x"26F6",x"270B", -- 0x0090
    x"2728",x"2737",x"2745",x"2751",x"275E",x"2767",x"2771",x"2778", -- 0x0098
    x"25ED",x"26E1",x"27B3",x"284D",x"28EC",x"2953",x"29B3",x"29FD", -- 0x00A0
    x"2A67",x"2A9D",x"2AD1",x"2AFB",x"2B2C",x"2B4E",x"2B70",x"2B8C", -- 0x00A8
    x"25ED",x"277C",x"28D6",x"29D1",x"2AD6",x"2B7E",x"2C1B",x"2C95", -- 0x00B0
    x"2D43",x"2D9A",x"2DF0",x"2E36",x"2E85",x"2EBD",x"2EF5",x"2F23", -- 0x00B8
    x"25ED",x"2870",x"2A9B",x"2C2F",x"2DD4",x"2EE2",x"2FDF",x"30A4", -- 0x00C0
    x"31BB",x"3248",x"32D2",x"3341",x"33C2",x"341B",x"3475",x"34BF", -- 0x00C8
    x"25ED",x"290B",x"2BBD",x"2DB3",x"2FBE",x"310D",x"3247",x"333C", -- 0x00D0
    x"3497",x"3545",x"35F1",x"367C",x"371B",x"378A",x"37F9",x"3856", -- 0x00D8
    x"25ED",x"29BC",x"2D07",x"2F6C",x"31EB",x"3383",x"3503",x"362E", -- 0x00E0
    x"37D6",x"38AC",x"397D",x"3A26",x"3AE9",x"3B71",x"3BF9",x"3C69", -- 0x00E8
    x"25ED",x"2A57",x"2E29",x"30F0",x"33D4",x"35AE",x"376C",x"38C7", -- 0x00F0
    x"3AB2",x"3BA9",x"3C9C",x"3D61",x"3E42",x"3EDF",x"3F7D",x"4000"  -- 0x00F8
  );
  
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

begin

  p_sel_com : process(i_hcnt, i_ab, i_db, accum_reg)
  begin
    if (i_hcnt(1) = '0') then -- 2h,
      addr <= i_ab(3 downto 0);
      data <= i_db(3 downto 0); -- removed invert
    else
      addr <= i_hcnt(5 downto 2);
      data <= accum_reg(4 downto 1);
    end if;
  end process;

  p_ram_comb : process(i_wr1_l, rom3m, i_ena)
  begin
    vol_ram_wen <= '0';
    if (I_WR1_L = '0') and (i_ena = '1') then
      vol_ram_wen <= '1';
    end if;

    frq_ram_wen <= '0';
    if (rom3m(1) = '1') and (i_ena = '1') then
      frq_ram_wen <= '1';
    end if;
  end process;

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

  p_control_rom_comb : process(i_hcnt)
  begin
    rom3m_n <= x"0000"; rom3m_w <= x"0"; -- default assign
    case i_hcnt(3 downto 0) is
      when x"0" => rom3m_n <= x"0008"; rom3m_w <= x"0";
      when x"1" => rom3m_n <= x"0000"; rom3m_w <= x"2";
      when x"2" => rom3m_n <= x"1111"; rom3m_w <= x"0";
      when x"3" => rom3m_n <= x"2222"; rom3m_w <= x"0";
      when x"4" => rom3m_n <= x"0000"; rom3m_w <= x"0";
      when x"5" => rom3m_n <= x"0000"; rom3m_w <= x"2";
      when x"6" => rom3m_n <= x"1101"; rom3m_w <= x"0";
      when x"7" => rom3m_n <= x"2242"; rom3m_w <= x"0";
      when x"8" => rom3m_n <= x"0080"; rom3m_w <= x"0";
      when x"9" => rom3m_n <= x"0000"; rom3m_w <= x"2";
      when x"A" => rom3m_n <= x"1011"; rom3m_w <= x"0";
      when x"B" => rom3m_n <= x"2422"; rom3m_w <= x"0";
      when x"C" => rom3m_n <= x"0800"; rom3m_w <= x"0";
      when x"D" => rom3m_n <= x"0000"; rom3m_w <= x"2";
      when x"E" => rom3m_n <= x"0111"; rom3m_w <= x"0";
      when x"F" => rom3m_n <= x"4222"; rom3m_w <= x"0";
      when others => null;
    end case;
  end process;

  p_control_rom_op_comb : process(i_hcnt, i_wr0_l, rom3m_n, rom3m_w)
  begin
    rom3m <= rom3m_w;
    if (i_wr0_l = '1') then
      case i_hcnt(5 downto 4) is
        when "00" => rom3m <= rom3m_n( 3 downto 0);
        when "01" => rom3m <= rom3m_n( 7 downto 4);
        when "10" => rom3m <= rom3m_n(11 downto 8);
        when "11" => rom3m <= rom3m_n(15 downto 12);
        when others => null;
      end case;
    end if;
  end process;

  p_adder : process(vol_ram_dout, frq_ram_dout, accum_reg)
  begin
    -- 1K 4 bit adder
    sum <= ('0' & vol_ram_dout & '1') + ('0' & frq_ram_dout & accum_reg(5));
  end process;

  p_accum_reg : process
  begin
    -- 1L
    wait until rising_edge(i_clk);
    if (i_ena = '1') then
      if (rom3m(3) = '1') then -- clear
        accum_reg <= "000000";
      elsif (rom3m(0) = '1') then -- rising edge clk
        accum_reg <= sum(5 downto 1) & accum_reg(4);
      end if;
    end if;
  end process;

  p_rom_1m_addr_comb : process(accum_reg, frq_ram_dout)
  begin
    rom1m_addr(10 downto 8) <= (others => '0');
    rom1m_addr( 7 downto 5) <= frq_ram_dout(2 downto 0);
    rom1m_addr( 4 downto 0) <= accum_reg(4 downto 0);
  end process;

  -- larger than we need, only 256 x 8 needed
  u_rom_1M : entity work.rom_pacman_1m
  port map (
    a => rom1m_addr(7 downto 0),
    clk => i_clk,
    spo => rom1m_data
  );
    
  p_original_output_reg : process
  begin
    -- 2m used to use async clear
    wait until rising_edge(i_clk);
    if (i_ena = '1') then
      if (i_sound_on = '0') then
        audio_vol_out <= "0000";
        audio_wav_out <= "0000";
      elsif (rom3m(2) = '1') then
        audio_vol_out <= vol_ram_dout(3 downto 0);
        audio_wav_out <= rom1m_data(3 downto 0);
      end if;
    end if;
  end process;

  p_wave_volume_dac : process(audio_wav_out, audio_vol_out)
    variable addr : word(7 downto 0);
    -- models the external resistor array
  begin
    addr := (audio_wav_out & audio_vol_out);
    audio_dac_out <= ROM(to_integer(unsigned(ADDR)));
  end process;
  --

  filter_in_s <= signed(audio_dac_out); -- note works as top bit not set in audio_dac_out
    
  -- Anciennement géré par le composant rc_bypass spécifique à la carte FPGA Arcade ???
  filter_out_s <= filter_in_s;

  filter_out <= std_logic_vector(filter_out_s); -- keep signed here

  p_output_reg : process
  begin
    wait until rising_edge(i_clk);
    if (i_ena = '1') then
      o_audio(15 downto 0) <= filter_out;
    end if;
  end process;

end architecture RTL;
