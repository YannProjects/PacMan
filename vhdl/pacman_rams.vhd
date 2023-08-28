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
  use work.all;

library UNISIM;
  use UNISIM.Vcomponents.all;

entity Pacman_RAMs is
  port (
    i_cfg_hw_pengo    : in    bit1;
    --
    i_addr            : in    word(11 downto 0);
    i_data            : in    word( 7 downto 0);
    o_data            : out   word( 7 downto 0);
    i_r_w_l           : in    bit1;
    i_vram_l          : in    bit1;
    --
    i_clk             : in    bit1
    );
end;

architecture RTL of Pacman_RAMs is

  signal ram_addr           : word(11 downto 0);
  signal ram_we             : bit1;
  signal ram_data           : word(7 downto 0);
  
  component RAMB16_S4
  port (
      DO    : out word(3 downto 0);
      ADDR  : in word(11 downto 0);
      CLK   : in std_logic;
      DI    : in word(3 downto 0);
      EN    : in std_logic;
      SSR   : in std_logic;
      WE    : in std_logic
  );
  end component;     

begin
  ram_addr <= i_addr(11 downto 0);

  --  vram  0x000-0x3FF
  --  cram  0x400-0x7FF
  --  ram   0x800-0xBFF << PENGO ONLY
  --  ram   0xC00-0xFFF

  p_decode : process(i_addr, i_r_w_l, i_vram_l)
  begin
    ram_we   <= '0';
    if (i_r_w_l = '0') and (i_vram_l = '0') then
      ram_we <= '1';
    end if;
  end process;

 u_rams : entity work.pacman_ram
 port map (
    a => ram_addr(11 downto 0),
    d => i_data,
    clk => i_clk,
    we => ram_we,
    spo => ram_data
 );

  p_output : process(i_cfg_hw_pengo, ram_addr, ram_data)
  begin
    o_data <= ram_data;
    if (i_cfg_hw_pengo = '0') then
      if (ram_addr(11 downto 10) = "10") then -- no memory here for Pacman
        o_data <= (others => '0');
      end if;
    end if;
  end process;

end architecture RTL;
