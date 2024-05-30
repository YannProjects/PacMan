----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.12.2022 20:48:16
-- Design Name: 
-- Module Name: ROM - Behavioral
-- Project Name: PacMan
-- Target Devices: Artyx 7
-- Tool Versions: 
-- Description: 
-- Simulation flash ROM externe au FPGA
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;

use work.Replay_Pack.all;

entity rom is
port(
    A: in std_logic_vector(13 downto 0);
    D: out std_logic_vector (7 downto 0);
    OEn: in std_logic;
    CSn: in std_logic
);
end rom;
 
architecture Behavioral of rom is
    
    signal rom_data_0             : word(7 downto 0);
    signal rom_data_1             : word(7 downto 0);
    signal rom_data_2             : word(7 downto 0);
    signal rom_data_3             : word(7 downto 0);
    signal o_data                 : word(7 downto 0);

    begin
    
      u_rom_6E : entity work.pacman_rom_6e
      port map (
        a => A(11 downto 0),
        spo => rom_data_0
      );    
    
      u_rom_6F : entity work.pacman_rom_6f
      port map (
        a => A(11 downto 0),
        spo => rom_data_1
      );    
    
      u_rom_6H : entity work.pacman_rom_6h
      port map (
        a => A(11 downto 0),
        spo => rom_data_2
      );    
    
      u_rom_6J : entity work.pacman_rom_6j
      port map (
        a => A(11 downto 0),
        spo => rom_data_3
      );
      
      p_rom_data : process(A, rom_data_0, rom_data_1, rom_data_2, rom_data_3)
      begin
        o_data <= rom_data_0;
        case A(13 downto 12) is
          when "00" => o_data <= rom_data_0;
          when "01" => o_data <= rom_data_1;
          when "10" => o_data <= rom_data_2;
          when "11" => o_data <= rom_data_3;
          when others => null;
        end case;
      end process;
    
      D <= o_data;
    
end Behavioral;
