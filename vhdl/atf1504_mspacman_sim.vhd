----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.07.2025 12:23:32
-- Design Name: 
-- Module Name: atf1504_mspacman_sim - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  Simulation VHDL pour l'implémentation de la carte auxiliaire PacMan sur un CPLD ATF1504
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.replay_pack.all;
use work.replay_lib_wrap_pack.all;
use work.Core_Pack.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity atf1504_mspacman_sim is
  port (
    i_resetn         : in  std_logic;
    -- System clock
    i_gclk1          : in  std_logic;
    -- Addresses CPU
    i_a              : in  std_logic_vector(12 downto 0);
    -- Adresses A3..A10 de U5/U5/U7 (soit les même que le CPU pour U6/U7, soit générée par le CPLD pour les adresses de U5
    
    o_A3p, o_A4p, o_A5p, o_A8p, o_A9p, o_A10p   : out std_logic;
    
    -- Inutile car la memoire flash contient aussi une entree OENeg en plus du CENeg
    -- i_mreqn          : in  std_logic; 
    i_rfrshn         : in  std_logic;
    o_jrfrshn        : out std_logic;
    o_csen           : out std_logic;
    -- Selection U5/U6/U7 en fonction de back_seul qui est relié à A12/A13 de la mémoire flash
    -- o_bank_sel = '00' => U5 (2K)
    -- o_bank_sel = '01' => U6 (4K)
    -- o_bank_sel = '10' => U7 (4K)
    o_bank_sel       : out std_logic_vector(1 downto 0)
  );
end atf1504_mspacman_sim;

architecture Behavioral of atf1504_mspacman_sim is

signal overlay_on, overlay_off, J, K, Q, patch_match : std_logic;
signal u5_bank_sel, u6_bank_sel, u6_bank_sel_1, u6_bank_sel_2, u7_bank_sel, overlay, mspacman_flash_csn : std_logic;
signal cpu_addr, rom_patched, final_addr : std_logic_vector(15 downto 0);

begin
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
    p_overlay : process
        variable tmp: std_logic := '0';
    begin
        wait until rising_edge(i_gclk1);
        if (J = '0' and K = '0')then
            tmp := tmp;
        elsif(J = '1' and K = '1')then
            tmp := 'Z';
        elsif(J = '0' and K = '1')then
            tmp := '0';
        else
            tmp:='1';
        end if;
        Q <= tmp;
    end process;

    J <= overlay_on;  
    K <= (not i_resetn) or overlay_off;
    overlay <= Q;

    cpu_addr <= i_a & b"000";

    -- Overlay OFF si 0x0038, 0x03B0, 0x1600, 0x2120, 0x3FF0, 0x8000, 0x97F0 
    overlay_off <= '1' when (cpu_addr = x"0038" or cpu_addr = x"03B0" or cpu_addr = x"1600" or cpu_addr = x"2120" or
                   cpu_addr = x"3FF0" or cpu_addr = x"8000" or cpu_addr = x"97F0") else '0';
    overlay_on <= '1' when cpu_addr = x"3FF8" else '0';

    rom_patched <= x"8008" when cpu_addr = x"0410" else -- 0410
                   x"81D8" when cpu_addr = x"08E0" else -- 08E0
                   x"8118" when cpu_addr = x"0A30" else -- 0A30
                   x"80D8" when cpu_addr = x"0BD0" else -- 0BD0
                   x"8120" when cpu_addr = x"0C20" else -- 0C20
                   x"8168" when cpu_addr = x"0E58" else -- 0E58
                   x"8198" when cpu_addr = x"0EA8" else -- 0EA8
                                                     
                   x"8020" when cpu_addr = x"1000" else -- 1000
                   x"8010" when cpu_addr = x"1008" else -- 1008
                   x"8098" when cpu_addr = x"1288" else -- 1288
                   x"8048" when cpu_addr = x"1348" else -- 1348
                   x"8088" when cpu_addr = x"1688" else -- 1688
                   x"8188" when cpu_addr = x"16B0" else -- 16B0
                   x"80C8" when cpu_addr = x"16D8" else -- 16D8
                   x"81C8" when cpu_addr = x"16F8" else -- 16F8
                   x"80A8" when cpu_addr = x"19A8" else -- 19A8
                   x"81A8" when cpu_addr = x"19B8" else -- 19B8
                                                     
                   x"8148" when cpu_addr = x"2060" else -- 2060
                   x"8018" when cpu_addr = x"2108" else -- 2108
                   x"81A0" when cpu_addr = x"21A0" else -- 21A0
                   x"80A0" when cpu_addr = x"2298" else -- 2298
                   x"80E8" when cpu_addr = x"23E0" else -- 23E0
                   x"8000" when cpu_addr = x"2418" else -- 2418
                   x"8058" when cpu_addr = x"2448" else -- 2448
                   x"8140" when cpu_addr = x"2470" else -- 2470
                   x"8080" when cpu_addr = x"2488" else -- 2488
                   x"8180" when cpu_addr = x"24B0" else -- 24B0
                   x"80C0" when cpu_addr = x"24D8" else -- 24D8
                   x"81C0" when cpu_addr = x"24F8" else -- 24F8
                   x"8050" when cpu_addr = x"2748" else -- 2748
                   x"8090" when cpu_addr = x"2780" else -- 2780
                   x"8190" when cpu_addr = x"27B8" else -- 27B8
                   x"8028" when cpu_addr = x"2800" else -- 2800
                   x"8100" when cpu_addr = x"2B20" else -- 2B20
                   x"8110" when cpu_addr = x"2B30" else -- 2B30
                   x"81D0" when cpu_addr = x"2BF0" else -- 2BF0
                   x"80D0" when cpu_addr = x"2CC0" else -- 2CC0
                   x"80E0" when cpu_addr = x"2CD8" else -- 2CD8
                   x"81E0" when cpu_addr = x"2CF0" else -- 2CF0
                   x"8160" when cpu_addr = x"2D60" else -- 2D60
                   x"0000";
            
    final_addr <= cpu_addr when patch_match = '0' else rom_patched;
    patch_match <= '1' when rom_patched /= x"0000" else '0';

    -- addr = 0x8000-0x87FF, no xlate (physical ROM hi 0000-07FF), decrypt u5
    u5_bank_sel <= patch_match or (cpu_addr(15) and (not cpu_addr(14)) and (not cpu_addr(13)) and (not cpu_addr(12)) and (not cpu_addr(11)));

    -- addr = 0x8800-0x8FFF, xlate to 0x9800-0x9FFF (physical ROM hi 1800-1FFF), decrypt half of u6
    u6_bank_sel_1 <= cpu_addr(15) and (not cpu_addr(14)) and (not cpu_addr(13)) and (not cpu_addr(12)) and cpu_addr(11);
    -- addr = 0x9000-0x97FF, no xlate (physical ROM hi 1000-17FF), decrypt half of u6
    u6_bank_sel_2 <= cpu_addr(15) and (not cpu_addr(14)) and (not cpu_addr(13)) and cpu_addr(12) and (not cpu_addr(11));
    u6_bank_sel <=  u6_bank_sel_1 or u6_bank_sel_2;
    
    -- addr = 0x3000-0x37FF, xlate to 0xB000-0xB7FF (physical ROM hi 2000-27FF), decrypt half of u7
    -- addr = 0x3800-0x3FFF, xlate to 0xB800-0xBFFF (physical ROM hi 2800-2FFF), decrypt half of u7
    u7_bank_sel <= (not cpu_addr(15)) and (not cpu_addr(14)) and cpu_addr(13) and cpu_addr(12);

    o_bank_sel <= "01" when u6_bank_sel = '1' else 
                  "10" when u7_bank_sel = '1' else "00";
    mspacman_flash_csn <= not ((u5_bank_sel or u6_bank_sel or u7_bank_sel) and overlay);
    o_csen <= mspacman_flash_csn;
   -- Sur le controleur de bus PacMan le signal RFRSH=1 est utilise comme chip select des ROMs et du bus controller custom 285.
   -- S'il est a 1 les ROMs et le CS du bus controller sont inactifs.
   -- Je pense qu'il doit donc etre a 0 si on accede aux ROM auxiliaires MsPacMan pour desactiver l'acces 
   -- au controleur de bus dans ce cas, sinon on recopie i_rfrfshn
   -- A faire seulement en cas d'overlay actif */
    o_jrfrshn <= (overlay and mspacman_flash_csn) or (not overlay and i_rfrshn);

    o_A3p <= (final_addr(3) and not u5_bank_sel) or (final_addr(8) and u5_bank_sel);
    o_A4p <= final_addr(4);
    o_A5p <= (final_addr(5) and not u5_bank_sel) or (final_addr(3) and u5_bank_sel);
    o_A8p <= (final_addr(8) and not u5_bank_sel) or (final_addr(10) and u5_bank_sel);
    o_A9p <= (final_addr(9) and not u5_bank_sel) or (final_addr(5) and u5_bank_sel);
    o_A10p <= (final_addr(10) and not u5_bank_sel) or (final_addr(9) and u5_bank_sel);

end Behavioral;