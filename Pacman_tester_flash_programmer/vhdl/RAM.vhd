----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.12.2022 20:48:16
-- Design Name: 
-- Module Name: RAM - Behavioral
-- Project Name: PacMan v2
-- Target Devices: Artyx 7
-- Tool Versions: 
-- Description: RAM simulation
-- 
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
 
entity RAM is
generic(
    address_length: natural := 12;
    data_length: natural := 8
);
port(
    A: in std_logic_vector((address_length - 1) downto 0);
    D: inout std_logic_vector ((data_length - 1) downto 0);
    CS_n: in STD_LOGIC;
    W_n: in STD_LOGIC
);
end RAM;
 
architecture Behavioral of RAM is
    type ram_type is array (0 to (2**(address_length) -1)) of std_logic_vector((data_length - 1) downto 0);
    
    signal mem: ram_type;
    signal dina, douta : std_logic_vector(7 downto 0);
    
begin

    mem(conv_integer(unsigned(A))) <= dina when W_n = '0';
    dina <= D;
    D <= mem(conv_integer(unsigned(A))) when CS_n = '0' and W_n = '1' else (others => 'Z');
 
end Behavioral;