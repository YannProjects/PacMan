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
-- based on code from d18c7db (gmail) - May 2013
--
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;

  use work.Replay_Pack.all;

library UNISIM;
  use UNISIM.Vcomponents.all;

entity Pacman_ROM_Descrambler is
  port (
    i_clk                 : in  bit1;
    i_ena                 : in  bit1;
    --
    i_hw_pengo            : in  bit1;
    i_hw_type_is_mrtnt    : in  bit1;
    --
    i_cpu_m1_l            : in  bit1;
    i_addr                : in  word(15 downto 0);
    --
    i_rom_data            : in  word( 7 downto 0);
    o_rom_data            : out word( 7 downto 0)
  );
end;

architecture RTL of Pacman_ROM_Descrambler is
    --signal overlay_on   : bit1 := '0';
    --signal rom_patched  : word(15 downto 0);
    --signal rom_addr     : word(15 downto 0);
    --signal rom_lo       : word( 7 downto 0);
    --signal rom_hi       : word( 7 downto 0);
    --signal rom_data_in  : word( 7 downto 0);
    --signal rom_data_out : word( 7 downto 0);
    --signal sega_dec     : word( 7 downto 0);
  signal sega_dec : word(7 downto 0);


begin

    -- Sega ROM descrambler adapted from MAME segacrpt.c source code
    --u_sega_decode : entity work.sega_decode
    --port map (
        --I_CK     => clk,
        --I_DEC    => sega_dec_ena, -- passthrough when low
        --I_A(6)   => cpu_m1_l,
        --I_A(5)   => rom_addr(12),
        --I_A(4)   => rom_addr(8),
        --I_A(3)   => rom_addr(4),
        --I_A(2)   => rom_addr(0),
        --I_A(1)   => rom_data_in(5),
        --I_A(0)   => rom_data_in(3),
        --I_D      => rom_data_in,
        --O_D      => sega_dec
    --);

    --sega_dec_ena <= PENGO and (not rom_addr(15));

--{{{
--  The trap regions are 8 bytes in length starting on the following addresses:
--
--  latch clear, decode disable
--    0x0038
--    0x03b0
--    0x1600
--    0x2120
--    0x3ff0
--    0x8000
--    0x97f0
--
--  latch set, decode enable
--    0x3ff8
    --p_overlay : process
        --variable trap_addr : word(15 downto 0);
    --begin
        --wait until rising_edge(CLK);
        --trap_addr := addr(15 downto 3) & "000";
        --if      trap_addr = x"3ff8" then
            --overlay_on <= '1';
        --elsif
            --trap_addr = x"0038" or
            --trap_addr = x"03b0" or
            --trap_addr = x"1600" or
            --trap_addr = x"2120" or
            --trap_addr = x"3ff0" or
            --trap_addr = x"8000" or
            --trap_addr = x"97f0"
        --then
            --overlay_on <= '0';
        --end if;
    --end process;

    --p_decoder_comb : process(clk, rom_addr, addr, rom_data_in, rom_data_out, rom_patched, rom_hi, rom_lo, overlay_on)
        --variable patch_addr : word(15 downto 0);
    --begin
        --rom_addr    <= addr;
        --rom_patched <= addr;
        --data        <= rom_data_out;

        ---- default is unscrambled data
        --rom_data_out <= rom_data_in ;

        ---- mux ROMs to same data bus
        ---- ignore A15 so that Pacman ROMs 0000-3FFF mirror in high mem at 8000-BFFF
        --if rom_addr(14) = '0' then
            --rom_data_in <= rom_lo;
        --else
            --rom_data_in <= rom_hi;
        --end if;

        ----      Mr TNT program ROMs have data lines D3 and D5 swapped
        ----      Mr TNT  video  ROMs have data lines D4 and D6 and address lines A0 and A2 swapped
        --if MRTNT = '1' then
            --rom_data_out <= rom_data_in(7 downto 6) & rom_data_in(3) & rom_data_in(4) & rom_data_in(5) & rom_data_in(2 downto 0);
        --end if;

        --if PENGO = '1' then
            ---- ROM at 0000 - 7fff (Pengo)
            --if rom_addr(15) = '0' then
                --rom_data_out <= sega_dec;
            --end if;
        --end if;

        --if MSPACMAN = '1' and overlay_on = '1' then
            ----  forty 8-byte patches into Pac-Man code
            ---- If the CPU address presented falls in a patch range, substitute it with patched address
            ---- OH THE HUMANITY!!!
            --patch_addr := addr(15 downto 3) & "000";
            --case patch_addr is
                --when x"0410" => rom_patched <= x"800" & '1' & addr(2 downto 0); --      ROM[0x0410+i] = ROM[0x8008+i]
                --when x"08E0" => rom_patched <= x"81D" & '1' & addr(2 downto 0); --      ROM[0x08E0+i] = ROM[0x81D8+i]
                --when x"0A30" => rom_patched <= x"811" & '1' & addr(2 downto 0); --      ROM[0x0A30+i] = ROM[0x8118+i]
                --when x"0BD0" => rom_patched <= x"80D" & '1' & addr(2 downto 0); --      ROM[0x0BD0+i] = ROM[0x80D8+i]
                --when x"0C20" => rom_patched <= x"812" & '0' & addr(2 downto 0); --      ROM[0x0C20+i] = ROM[0x8120+i]
                --when x"0E58" => rom_patched <= x"816" & '1' & addr(2 downto 0); --      ROM[0x0E58+i] = ROM[0x8168+i]
                --when x"0EA8" => rom_patched <= x"819" & '1' & addr(2 downto 0); --      ROM[0x0EA8+i] = ROM[0x8198+i]

                --when x"1000" => rom_patched <= x"802" & '0' & addr(2 downto 0); --      ROM[0x1000+i] = ROM[0x8020+i]
                --when x"1008" => rom_patched <= x"801" & '0' & addr(2 downto 0); --      ROM[0x1008+i] = ROM[0x8010+i]
                --when x"1288" => rom_patched <= x"809" & '1' & addr(2 downto 0); --      ROM[0x1288+i] = ROM[0x8098+i]
                --when x"1348" => rom_patched <= x"804" & '1' & addr(2 downto 0); --      ROM[0x1348+i] = ROM[0x8048+i]
                --when x"1688" => rom_patched <= x"808" & '1' & addr(2 downto 0); --      ROM[0x1688+i] = ROM[0x8088+i]
                --when x"16B0" => rom_patched <= x"818" & '1' & addr(2 downto 0); --      ROM[0x16B0+i] = ROM[0x8188+i]
                --when x"16D8" => rom_patched <= x"80C" & '1' & addr(2 downto 0); --      ROM[0x16D8+i] = ROM[0x80C8+i]
                --when x"16F8" => rom_patched <= x"81C" & '1' & addr(2 downto 0); --      ROM[0x16F8+i] = ROM[0x81C8+i]
                --when x"19A8" => rom_patched <= x"80A" & '1' & addr(2 downto 0); --      ROM[0x19A8+i] = ROM[0x80A8+i]
                --when x"19B8" => rom_patched <= x"81A" & '1' & addr(2 downto 0); --      ROM[0x19B8+i] = ROM[0x81A8+i]

                --when x"2060" => rom_patched <= x"814" & '1' & addr(2 downto 0); --      ROM[0x2060+i] = ROM[0x8148+i]
                --when x"2108" => rom_patched <= x"801" & '1' & addr(2 downto 0); --      ROM[0x2108+i] = ROM[0x8018+i]
                --when x"21A0" => rom_patched <= x"81A" & '0' & addr(2 downto 0); --      ROM[0x21A0+i] = ROM[0x81A0+i]
                --when x"2298" => rom_patched <= x"80A" & '0' & addr(2 downto 0); --      ROM[0x2298+i] = ROM[0x80A0+i]
                --when x"23E0" => rom_patched <= x"80E" & '1' & addr(2 downto 0); --      ROM[0x23E0+i] = ROM[0x80E8+i]
                --when x"2418" => rom_patched <= x"800" & '0' & addr(2 downto 0); --      ROM[0x2418+i] = ROM[0x8000+i]
                --when x"2448" => rom_patched <= x"805" & '1' & addr(2 downto 0); --      ROM[0x2448+i] = ROM[0x8058+i]
                --when x"2470" => rom_patched <= x"814" & '0' & addr(2 downto 0); --      ROM[0x2470+i] = ROM[0x8140+i]
                --when x"2488" => rom_patched <= x"808" & '0' & addr(2 downto 0); --      ROM[0x2488+i] = ROM[0x8080+i]
                --when x"24B0" => rom_patched <= x"818" & '0' & addr(2 downto 0); --      ROM[0x24B0+i] = ROM[0x8180+i]
                --when x"24D8" => rom_patched <= x"80C" & '0' & addr(2 downto 0); --      ROM[0x24D8+i] = ROM[0x80C0+i]
                --when x"24F8" => rom_patched <= x"81C" & '0' & addr(2 downto 0); --      ROM[0x24F8+i] = ROM[0x81C0+i]
                --when x"2748" => rom_patched <= x"805" & '0' & addr(2 downto 0); --      ROM[0x2748+i] = ROM[0x8050+i]
                --when x"2780" => rom_patched <= x"809" & '0' & addr(2 downto 0); --      ROM[0x2780+i] = ROM[0x8090+i]
                --when x"27B8" => rom_patched <= x"819" & '0' & addr(2 downto 0); --      ROM[0x27B8+i] = ROM[0x8190+i]
                --when x"2800" => rom_patched <= x"802" & '1' & addr(2 downto 0); --      ROM[0x2800+i] = ROM[0x8028+i]
                --when x"2B20" => rom_patched <= x"810" & '0' & addr(2 downto 0); --      ROM[0x2B20+i] = ROM[0x8100+i]
                --when x"2B30" => rom_patched <= x"811" & '0' & addr(2 downto 0); --      ROM[0x2B30+i] = ROM[0x8110+i]
                --when x"2BF0" => rom_patched <= x"81D" & '0' & addr(2 downto 0); --      ROM[0x2BF0+i] = ROM[0x81D0+i]
                --when x"2CC0" => rom_patched <= x"80D" & '0' & addr(2 downto 0); --      ROM[0x2CC0+i] = ROM[0x80D0+i]
                --when x"2CD8" => rom_patched <= x"80E" & '0' & addr(2 downto 0); --      ROM[0x2CD8+i] = ROM[0x80E0+i]
                --when x"2CF0" => rom_patched <= x"81E" & '0' & addr(2 downto 0); --      ROM[0x2CF0+i] = ROM[0x81E0+i]
                --when x"2D60" => rom_patched <= x"816" & '0' & addr(2 downto 0); --      ROM[0x2D60+i] = ROM[0x8160+i]
                --when others => rom_patched <= addr;
            --end case;

-- Pacman ROMs
--              0x0000-0x0FFF = 0x0000-0x0FFF;  /* pacman.6e */
--              0x1000-0x1FFF = 0x1000-0x1FFF;  /* pacman.6f */
--              0x2000-0x2FFF = 0x2000-0x2FFF;  /* pacman.6h */
--              0x3000-0x3FFF = 0x3000-0x3FFF;  /* pacman.6j */

-- ROM mirror (easy just ignore A15)
--              0x8000-0x8FFF = 0x0000-0x0FFF;  /* mirror of pacman.6e */
--              0x9000-0x9FFF = 0x1000-0x1FFF;  /* mirror of pacman.6f */
--              0xA000-0xAFFF = 0x2000-0x2FFF;  /* mirror of pacman.6h */
--              0xB000-0xBFFF = 0x3000-0x3FFF;  /* mirror of pacman.6j */

-- Ms Pacman overlays

-- no xlate
--              0x8000-0x87FF = 0x8000-0x87FF (physical ROM hi 0000-07FF);      /* decrypt u5 */
--              0x9000-0x97FF = 0x9000-0x97FF (physical ROM hi 1000-17FF);      /* decrypt half of u6 */

-- xlate addr
--              0x3000-0x3FFF = 0xB000-0xBFFF (physical ROM hi 2000-2FFF);      /* decrypt u7 */

-- xlate addr
--              0x8800-0x8FFF = 0x9800-0x9FFF (physical ROM hi 1800-1FFF);      /* decrypt half of u6 */

-- ROM hi mem map
-- u5  2K 0000-07FF (0x8000-0x87FF)
-- u5  2K 0800-0FFF N/A
-- u6b 2K 1000-17FF (0x9000-0x97FF)
-- u6t 2K 1800-1FFF (0x8800-0x8FFF)
-- u7  4K 2000-2FFF (0x3000-0x3FFF)

            -- If the new patched address falls in certain Ms Pacman ranges, swap in ROM overlays and descramble address and data
            -- high address bits are not scrambled so we know for sure this only accesses ROM hi after address translation
            --case rom_patched(15 downto 11) is

                ---- addr = 0x3000-0x37FF, xlate to 0xB000-0xB7FF (physical ROM hi 2000-27FF), decrypt half of u7
                --when "00110" =>
                    --rom_addr     <= x"2" & rom_patched(11) & rom_patched(3) & rom_patched(7) & rom_patched(9) & rom_patched(10) & rom_patched(8) & rom_patched(6 downto 4) & rom_patched(2 downto 0);
                    --rom_data_out <= rom_hi(0) & rom_hi(4) & rom_hi(5) & rom_hi(7 downto 6) & rom_hi(3 downto 1);

                ---- addr = 0x3800-0x3FFF, xlate to 0xB800-0xBFFF (physical ROM hi 2800-2FFF), decrypt half of u7
                --when "00111" =>
                    --rom_addr     <= x"2" & rom_patched(11) & rom_patched(3) & rom_patched(7) & rom_patched(9) & rom_patched(10) & rom_patched(8) & rom_patched(6 downto 4) & rom_patched(2 downto 0);
                    --rom_data_out <= rom_hi(0) & rom_hi(4) & rom_hi(5) & rom_hi(7 downto 6) & rom_hi(3 downto 1);

                ---- addr = 0x8000-0x87FF, no xlate (physical ROM hi 0000-07FF), decrypt u5
                --when "10000" =>
                    --rom_addr     <= x"0" & rom_patched(11) & rom_patched(8)  & rom_patched(7) & rom_patched(5) & rom_patched(9) & rom_patched(10) & rom_patched(6) & rom_patched(3) & rom_patched(4) & rom_patched(2 downto 0);
                    --rom_data_out <= rom_hi(0) & rom_hi(4) & rom_hi(5) & rom_hi(7 downto 6) & rom_hi(3 downto 1);

                ---- addr = 0x8800-0x8FFF, xlate to 0x9800-0x9FFF (physical ROM hi 1800-1FFF), decrypt half of u6
                --when "10001" =>
                    --rom_addr     <= x"1" & rom_patched(11) & rom_patched(3) & rom_patched(7) & rom_patched(9) & rom_patched(10) & rom_patched(8) & rom_patched(6 downto 4) & rom_patched(2 downto 0);
                    --rom_data_out <= rom_hi(0) & rom_hi(4) & rom_hi(5) & rom_hi(7 downto 6) & rom_hi(3 downto 1);

                ---- addr = 0x9000-0x97FF, no xlate (physical ROM hi 1000-17FF), decrypt half of u6
                --when "10010" =>
                    --rom_addr     <= x"1" & rom_patched(11) & rom_patched(3) & rom_patched(7) & rom_patched(9) & rom_patched(10) & rom_patched(8) & rom_patched(6 downto 4) & rom_patched(2 downto 0);
                    --rom_data_out <= rom_hi(0) & rom_hi(4) & rom_hi(5) & rom_hi(7 downto 6) & rom_hi(3 downto 1);

                ---- catch all default action
                --when others => null;
                    --rom_addr     <= rom_patched;
                    --rom_data_out <= rom_data_in;
            --end case;
        --end if;
    --end process;
--}}}

  p_select : process(i_hw_pengo, i_hw_type_is_mrtnt, i_rom_data, sega_dec)
  begin
    o_rom_data <= i_rom_data;

    if    (i_hw_pengo = '1') then
      o_rom_data <= sega_dec;
    elsif (i_hw_type_is_mrtnt = '1') then
      -- swap D3 and D5
      o_rom_data <= i_rom_data(7 downto 6) & i_rom_data(3)  & i_rom_data(4)  & i_rom_data(5)  & i_rom_data(2 downto 0);
    end if;
  end process;

  p_sega_decoder : process
    variable sel : word(6 downto 0);
    variable val : word(2 downto 0);
  begin
    wait until rising_edge(i_clk);
    -- NOTE, no clock enable used, we need the result before the CPU enable

    -- default bypass
    sega_dec <= i_rom_data;

    if (i_addr(15) = '0') then -- de-scramble
      -- build address
      sel(6) := i_cpu_m1_l;
      sel(5) := i_addr(12);
      sel(4) := i_addr(8);
      sel(3) := i_addr(4);
      sel(2) := i_addr(0);
      sel(1) := i_rom_data(5) xor i_rom_data(7);
      sel(0) := i_rom_data(3) xor i_rom_data(7);

      -- figure out what to do
      case sel is
        when "0000000" => val := "110";
        when "0000001" => val := "100";
        when "0000010" => val := "111";
        when "0000011" => val := "101";
        when "0000100" => val := "011";
        when "0000101" => val := "111";
        when "0000110" => val := "001";
        when "0000111" => val := "101";
        when "0001000" => val := "110";
        when "0001001" => val := "100";
        when "0001010" => val := "010";
        when "0001011" => val := "000";
        when "0001100" => val := "001";
        when "0001101" => val := "011";
        when "0001110" => val := "101";
        when "0001111" => val := "111";
        when "0010000" => val := "001";
        when "0010001" => val := "000";
        when "0010010" => val := "101";
        when "0010011" => val := "100";
        when "0010100" => val := "110";
        when "0010101" => val := "100";
        when "0010110" => val := "010";
        when "0010111" => val := "000";
        when "0011000" => val := "110";
        when "0011001" => val := "100";
        when "0011010" => val := "010";
        when "0011011" => val := "000";
        when "0011100" => val := "110";
        when "0011101" => val := "100";
        when "0011110" => val := "010";
        when "0011111" => val := "000";
        when "0100000" => val := "101";
        when "0100001" => val := "100";
        when "0100010" => val := "001";
        when "0100011" => val := "000";
        when "0100100" => val := "101";
        when "0100101" => val := "100";
        when "0100110" => val := "001";
        when "0100111" => val := "000";
        when "0101000" => val := "001";
        when "0101001" => val := "011";
        when "0101010" => val := "101";
        when "0101011" => val := "111";
        when "0101100" => val := "110";
        when "0101101" => val := "100";
        when "0101110" => val := "111";
        when "0101111" => val := "101";
        when "0110000" => val := "001";
        when "0110001" => val := "000";
        when "0110010" => val := "101";
        when "0110011" => val := "100";
        when "0110100" => val := "000";
        when "0110101" => val := "001";
        when "0110110" => val := "010";
        when "0110111" => val := "011";
        when "0111000" => val := "001";
        when "0111001" => val := "011";
        when "0111010" => val := "101";
        when "0111011" => val := "111";
        when "0111100" => val := "001";
        when "0111101" => val := "000";
        when "0111110" => val := "101";
        when "0111111" => val := "100";
        when "1000000" => val := "011";
        when "1000001" => val := "111";
        when "1000010" => val := "001";
        when "1000011" => val := "101";
        when "1000100" => val := "110";
        when "1000101" => val := "100";
        when "1000110" => val := "111";
        when "1000111" => val := "101";
        when "1001000" => val := "110";
        when "1001001" => val := "100";
        when "1001010" => val := "010";
        when "1001011" => val := "000";
        when "1001100" => val := "110";
        when "1001101" => val := "100";
        when "1001110" => val := "111";
        when "1001111" => val := "101";
        when "1010000" => val := "011";
        when "1010001" => val := "111";
        when "1010010" => val := "001";
        when "1010011" => val := "101";
        when "1010100" => val := "001";
        when "1010101" => val := "000";
        when "1010110" => val := "101";
        when "1010111" => val := "100";
        when "1011000" => val := "110";
        when "1011001" => val := "100";
        when "1011010" => val := "010";
        when "1011011" => val := "000";
        when "1011100" => val := "000";
        when "1011101" => val := "001";
        when "1011110" => val := "010";
        when "1011111" => val := "011";
        when "1100000" => val := "110";
        when "1100001" => val := "100";
        when "1100010" => val := "010";
        when "1100011" => val := "000";
        when "1100100" => val := "000";
        when "1100101" => val := "001";
        when "1100110" => val := "010";
        when "1100111" => val := "011";
        when "1101000" => val := "001";
        when "1101001" => val := "011";
        when "1101010" => val := "101";
        when "1101011" => val := "111";
        when "1101100" => val := "110";
        when "1101101" => val := "100";
        when "1101110" => val := "010";
        when "1101111" => val := "000";
        when "1110000" => val := "101";
        when "1110001" => val := "100";
        when "1110010" => val := "001";
        when "1110011" => val := "000";
        when "1110100" => val := "101";
        when "1110101" => val := "100";
        when "1110110" => val := "001";
        when "1110111" => val := "000";
        when "1111000" => val := "001";
        when "1111001" => val := "011";
        when "1111010" => val := "101";
        when "1111011" => val := "111";
        when "1111100" => val := "110";
        when "1111101" => val := "100";
        when "1111110" => val := "010";
        when "1111111" => val := "000";
        when others => null;
      end case;

      -- apply the xor
      sega_dec(7) <= i_rom_data(7) xor val(2);
      sega_dec(6) <= i_rom_data(6);
      sega_dec(5) <= i_rom_data(7) xor val(1);
      sega_dec(4) <= i_rom_data(4);
      sega_dec(3) <= i_rom_data(7) xor val(0);
      sega_dec(2) <= i_rom_data(2);
      sega_dec(1) <= i_rom_data(1);
      sega_dec(0) <= i_rom_data(0);
    end if;
  end process;

end rtl;
