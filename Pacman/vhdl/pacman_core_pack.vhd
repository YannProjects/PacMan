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
-- Email support@fpgaarcade.com

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;

  use work.Replay_Pack.all;

Package Core_Pack is  
  -- DB0/DB1 (SW1 et SW2)
  constant c_free_play            : word(7 downto 0) := b"00000000";
  constant c_1_coin_1_credit      : word(7 downto 0) := b"00000010";
  constant c_1_coin_2_credits     : word(7 downto 0) := b"00000001";
  constant c_2_coins_1_credit     : word(7 downto 0) := b"00000011";
  -- DB1/DB2 (SW3 et SW4)
  constant c_1_pacman             : word(7 downto 0) := b"00000000";
  constant c_2_pacman             : word(7 downto 0) := b"00001000";
  constant c_3_pacman             : word(7 downto 0) := b"00000100";
  constant c_5_pacman             : word(7 downto 0) := b"00001100";  
  -- DB4/DB5 (SW5 et SW6)
  constant c_bonus_10000          : word(7 downto 0) := b"00000000";
  constant c_bonus_15000          : word(7 downto 0) := b"00100000";
  constant c_bonus_20000          : word(7 downto 0) := b"00010000";
  constant c_no_bonus             : word(7 downto 0) := b"00110000";
  -- DB6 (SW7)
  constant c_free_game            : word(7 downto 0) := b"00000000";
  -- DB7 (SW8)
  constant c_free_life            : word(7 downto 0) := b"00100000";
  
  -- Deux dernier DIP switches non lus par DIPSWn (freeze + Rack advance) 
  constant c_auto_rack_advance    : word(7 downto 0) := b"00000000";
  constant c_normal_rack          : word(7 downto 0) := b"01000000";
  
  constant c_freeze_video         : word(7 downto 0) := b"00000000";
  constant c_normal_video         : word(7 downto 0) := b"10000000";
  
  -- La lecture des switch est m�lang�e car les bits du registre D_Reg ne sont
  -- pas c�bl�s en direct (ex. SW1 est connect� � D7). Les valeurs sont remplies
  -- pour v�rifier que les bit sont bien remis dans l'ordre par le FPGA lots de la lecture
  -- du registre des SIP switches.
  constant c_sw1_off              : word(7 downto 0) := b"10000000";
  constant c_sw2_off              : word(7 downto 0) := b"01000000";
  constant c_sw3_off              : word(7 downto 0) := b"00100000";
  constant c_sw4_off              : word(7 downto 0) := b"00010000";
  constant c_sw5_off              : word(7 downto 0) := b"00000001";
  constant c_sw6_off              : word(7 downto 0) := b"00000010";
  constant c_p1_strap_off         : word(7 downto 0) := b"00000100";
  constant c_p2_strap_off         : word(7 downto 0) := b"00001000";

end;

package body Core_Pack is

end;

