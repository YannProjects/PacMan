----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.07.2020 11:50:50
-- Design Name: 
-- Module Name: Clocks_gen - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
library unisim;
use IEEE.STD_LOGIC_1164.ALL;
use unisim.vcomponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Clocks_gen is
    Port ( i_clk_main : in STD_LOGIC;
           o_clk_52m : out STD_LOGIC;
           o_clk_vga : out STD_LOGIC;
           o_clk_sys : out STD_LOGIC;
           i_rst : in std_logic;
           o_pll_locked : out std_logic);
end Clocks_gen;

architecture Based_on_IP of Clocks_gen is
     
signal i_clk_6_5m, i_sys_clk, i_clk_52m : std_logic;

begin

    -- Composant utilisé pour générer les horloges du ZX81 et du controlleur VGA:
    -- VGA_CLK: 25,1 MHz pour le controlleur VGA
    -- 6,5 MHz: ULA
    -- 3,25 MHz: Z80    
     
    clk_gen : entity work.clk_wiz_0
    port map (
        reset => i_rst,
        locked => o_pll_locked,
        clk_main => i_clk_main,
        clk_52m => o_clk_52m,
        clk_vga => o_clk_vga,
        clk_sys => o_clk_sys
    );

end Based_on_IP;

