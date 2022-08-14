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
    Port ( main_clk : in STD_LOGIC;
           clk_52m : out STD_LOGIC;
           vga_clk : out STD_LOGIC;
           clk_sys : out STD_LOGIC;
           rst : in std_logic;
           pll_locked : out std_logic);
end Clocks_gen;

architecture Based_on_IP of Clocks_gen is
     
signal i_clk_6_5m, i_sys_clk, i_clk_52m : std_logic;

begin

    -- Composant utilis� pour g�n�rer les horloges du ZX81 et du controlleur VGA:
    -- VGA_CLK: 25,1 MHz pour le controlleur VGA
    -- 6,5 MHz: ULA
    -- 3,25 MHz: Z80    
     
    clk_gen : entity work.clk_wiz_2
    port map (
        reset => rst,
        locked => pll_locked,
        clk_in1 => main_clk,
        clk_52m => i_clk_52m,
        clk_vga => vga_clk,
        clk_sys => i_sys_clk
    );

    clk_sys <= i_sys_clk;
    clk_52m <= i_clk_52m;

end Based_on_IP;

