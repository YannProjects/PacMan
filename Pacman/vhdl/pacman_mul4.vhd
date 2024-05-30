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
-- version 002 initial release
--
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;

  use work.Replay_Pack.all;

entity Pacman_Mul_Partial is
  port (
    i_a   : in   word(1 downto 0);
    i_b   : in   word(1 downto 0);
    o_r   : out  word(3 downto 0)
    );
end;

architecture RTL of Pacman_Mul_Partial is

begin
  p_lut_comb : process(i_a, i_b)
    variable ip : word(3 downto 0);
  begin
    ip := i_a & i_b;
    case ip is
      when "0000" => o_r <= x"0";
      when "0001" => o_r <= x"0";
      when "0010" => o_r <= x"0";
      when "0011" => o_r <= x"0";
      when "0100" => o_r <= x"0";
      when "0101" => o_r <= x"1";
      when "0110" => o_r <= x"2";
      when "0111" => o_r <= x"3";
      when "1000" => o_r <= x"0";
      when "1001" => o_r <= x"2";
      when "1010" => o_r <= x"4";
      when "1011" => o_r <= x"6";
      when "1100" => o_r <= x"0";
      when "1101" => o_r <= x"3";
      when "1110" => o_r <= x"6";
      when "1111" => o_r <= x"9";
      when others => null;
    end case;
  end process;
end architecture RTL;

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;

  use work.Replay_Pack.all;

entity Pacman_Mul4 is
  port (
    i_a   : in  word(3 downto 0);
    i_b   : in  word(3 downto 0);
    o_r   : out word(7 downto 0)
    );
end;

architecture RTL of Pacman_Mul4 is

  signal r1    : word(3 downto 0);
  signal r2    : word(3 downto 0);
  signal r3    : word(3 downto 0);
  signal r4    : word(3 downto 0);

  signal add12 : word(7 downto 0);
  signal add34 : word(7 downto 0);

begin
  -- simple combinatorial multiplier

  partial_1 : entity work.Pacman_Mul_Partial
    port map ( i_a => i_a(1 downto 0), i_b => i_b(1 downto 0), o_r => r1);

  partial_2 : entity work.Pacman_Mul_Partial
    port map ( i_a => i_a(1 downto 0), i_b => i_b(3 downto 2), o_r => r2);

  partial_3 : entity work.Pacman_Mul_Partial
    port map ( i_a => i_a(3 downto 2), i_b => i_b(1 downto 0), o_r => r3);

  partial_4 : entity work.Pacman_Mul_Partial
    port map ( i_a => i_a(3 downto 2), i_b => i_b(3 downto 2), o_r => r4);

  -- balanced adder tree
  add12 <= ("0000" & r1       ) + ("00" & r2 & "00");
  add34 <= ("00"   & r3 & "00") + (       r4 & "0000");
  o_r   <= add12 + add34;

end architecture RTL;
