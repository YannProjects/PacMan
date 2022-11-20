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

-- Note, this is not used any more - DRAM is used as Pengo has 32K of ROM.
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;

  use work.Replay_Pack.all;

entity Pacman_Program_ROM is
  port (
    -- Core interface
    i_addr                      : in  word(13 downto 0);
    o_data                      : out word( 7 downto 0);
    --
    i_ena                       : in  bit1
    );
end;

architecture RTL of Pacman_Program_ROM is

  signal memio_ram_0            : r_Memio_fm_core;
  signal memio_ram_1            : r_Memio_fm_core;
  signal memio_ram_2            : r_Memio_fm_core;
  signal memio_ram_3            : r_Memio_fm_core;
  --
  signal rom_data_0             : word(7 downto 0);
  signal rom_data_1             : word(7 downto 0);
  signal rom_data_2             : word(7 downto 0);
  signal rom_data_3             : word(7 downto 0);
  signal rom_data               : word(7 downto 0);


begin
  -- note, the config space address does not need to match the core address space

  u_rom_6E : entity work.rom_pacman_6e
  port map (
    a => i_addr(11 downto 0),
    spo => rom_data_0
  );    

  u_rom_6F : entity work.rom_pacman_6f
  port map (
    a => i_addr(11 downto 0),
    spo => rom_data_1
  );    

  u_rom_6H : entity work.rom_pacman_6h
  port map (
    a => i_addr(11 downto 0),
    spo => rom_data_2
  );    

  u_rom_6J : entity work.rom_pacman_6j
  port map (
    a => i_addr(11 downto 0),
    spo => rom_data_3
  );
  
  p_rom_data : process(i_addr, rom_data_0, rom_data_1, rom_data_2, rom_data_3)
  begin
    o_data <= rom_data_0;
    case i_addr(13 downto 12) is
      when "00" => o_data <= rom_data_0;
      when "01" => o_data <= rom_data_1;
      when "10" => o_data <= rom_data_2;
      when "11" => o_data <= rom_data_3;
      when others => null;
    end case;
  end process;

end RTL;

