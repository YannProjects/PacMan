----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.06.2023 23:17:43
-- Design Name: 
-- Module Name: flash_programmer_sim - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

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

entity PacMan_Tester_sim is
--  Port ( );
end PacMan_Tester_sim;

architecture Behavioral of PacMan_Tester_sim is

constant clk_period : time := 10 ns;
constant bit_duration : time := 104 us;

signal main_clk, rst_sys, flash_csn : std_logic;
signal z80_rst, z80_clk : std_logic;
signal z80_m1_l, z80_mreq_l, z80_iorq_l, z80_rd_l : std_logic;
signal z80_wr_l, z80_rfrsh_l, z80_waitn, z80_intn : std_logic;
signal z80_a : std_logic_vector(15 downto 0);
signal enable_cpu_core_data_l, in0_cs, in1_cs, dip_sw_cs : std_logic;
signal D_bidir, z80_do, pacman_core_data_output, D_rom : std_logic_vector(7 downto 0);
signal cfg_dip_sw, in0_reg, in1_reg, config_reg, core_data_output : std_logic_vector(7 downto 0);

signal joy_a, joy_b : word(3 downto 0);
signal coins, buttons : word(1 downto 0);
signal credit, table, test : bit1;

begin

    joy_a <= b"1111";
    joy_b <= b"1111";
    coins <= b"11";
    buttons <= b"11";
    credit <= '1';
    table <= '1';
    test <= '1';

    clk_process :process
    begin
         main_clk <= '0';
         wait for clk_period / 2;
         main_clk <= '1';
         wait for clk_period / 2;
    end process;
       
    u_z80 : entity work.T80a
    port map (
		RESET_n	=> z80_rst,
		R800_mode => '0',
		CLK_n => z80_clk,
		WAIT_n => z80_waitn,
		INT_n => z80_intn,
		NMI_n => '1',
		BUSRQ_n => '1',
		M1_n => z80_m1_l,
		MREQ_n => z80_mreq_l,
		RD_n => z80_rd_l,
		WR_n => z80_wr_l,
		IORQ_n => z80_iorq_l,
		RFSH_n => z80_rfrsh_l,
		A => z80_a,
		D => D_bidir
	);    
        
    D_bidir <= D_rom;
    D_bidir <= core_data_output;
    z80_do <= D_bidir;
    
    -- Simulation 74HC244 U1 sur le schema
    core_data_output <= pacman_core_data_output when enable_cpu_core_data_l = '0' else (others => 'Z');
  
   ---------------------
   -- PacMan core top --
   ---------------------
   core_top_0 : entity work.Core_Top
   port map (
        -- Paramètres de gestion du core:
        -- garder ena_sys, rst_sys_n, halt, sys_clk => A configurer dans la partie simulation
        i_clk_main          =>    main_clk,
        i_rst_sys_n         =>    rst_sys,
        -- i_cfg         =>    sim_config,
        -- Keyboard, Mouse and Joystick
        -- Conserver les entrées joy_a et joy_b:
        -- BOT 5-Fire2, 4-Fire1, 3-Right 2-Left, 1-Back, 0-Forward (active low)
        -- i_kb_ms_joy   =>    sim_joystick,
        
        -- Boutons start1 / start2 / credit (active low)
        -- i_kbut        =>    sim_start_credit_buttons
    
        -- Audio/Video
        -- o_av                  : out   r_AV_fm_core
        
        -- z80    
        i_cpu_a_core        => z80_a,
        o_cpu_di_core       => pacman_core_data_output,
        i_cpu_do_core       => z80_do,
    
        o_cpu_rst_core      => z80_rst,
        o_cpu_clk_core      => z80_clk,
        o_cpu_wait_l_core   => z80_waitn,
        o_cpu_int_l_core    => z80_intn,
        i_cpu_m1_l_core     => z80_m1_l,
        i_cpu_mreq_l_core   => z80_mreq_l,
        i_cpu_iorq_l_core   => z80_iorq_l,
        i_cpu_rd_l_core     => z80_rd_l,
        i_cpu_wr_l_core     => z80_wr_l,
        i_cpu_rfrsh_l_core  => z80_rfrsh_l,
        
        -- Registres de configuration (IN0, IN1, DIP SW)
        i_config_reg        => config_reg,
    
        -- DIPs
        o_in0_l_cs          => in0_cs,
        o_in1_l_cs          => in1_cs,
        o_dip_l_cs          => dip_sw_cs,
        
        o_rom_cs            => flash_csn,
        o_rd_bus_ctrl_regs  => enable_cpu_core_data_l,

        
        -- CPU freeze
        i_freeze => '1'
    );  

  flash_memory : entity work.s29al008j
  generic map (
      UserPreload => TRUE,
      mem_file_name => "s29al008j.mem"
  )
  port map(
      A18 => '0',
      A17 => '0',
      A16 => '0',
      A15 => '0',
      A14 => '0',
      A13 => z80_a(14),
      A12 => z80_a(13),
      A11 => z80_a(12),
      A10 => z80_a(11),
      A9 => z80_a(10),
      A8 => z80_a(9),
      A7 => z80_a(8),
      A6 => z80_a(7),
      A5 => z80_a(6),
      A4 => z80_a(5),
      A3 => z80_a(4),
      A2 => z80_a(3),
      A1 => z80_a(2),
      DQ15 => z80_a(0),
      A0 => z80_a(1),

      DQ7 => D_rom(7),
      DQ6 => D_rom(6),
      DQ5 => D_rom(5),
      DQ4 => D_rom(4),
      DQ3 => D_rom(3),
      DQ2 => D_rom(2),
      DQ1 => D_rom(1),
      DQ0 => D_rom(0),

      CENeg => flash_csn,
      OENeg => z80_rd_l,
      WENeg => z80_wr_l,
      RESETNeg => rst_sys,
      BYTENeg => '0',
      WPNeg => '1'
   );
   
    
    config_reg <= in0_reg when in0_cs = '0' else (others => 'Z');
    config_reg <= in1_reg when in1_cs = '0' else (others => 'Z');
    config_reg <= cfg_dip_sw when dip_sw_cs = '0' else (others => 'Z');
    
    --
    -- DIP switch 1 (ON = 0, OFF = 1) (https://www.arcade-museum.com/manuals-videogames/S/SuperABC.pdf)
    --                         SW1   SW2   SW3   SW4   SW5   SW6   SW7   SW8
    -- Free Play               ON    ON
    -- 1 Coin 1 Credit *       OFF   ON
    -- 1 Coin 2 Credits        ON    OFF
    -- 2 Coins 1 Credit        OFF   OFF
    ------------------------------------------------------------------------
    -- 1 Pacman Per Game                   ON    ON
    -- 2 Pacman Per Game                   OFF   ON
    -- 3 Pacman Per Game *                 ON    OFF
    -- 5 Pacman Per Game                   OFF   OFF
    ------------------------------------------------------------------------
    -- Bonus Player @ 10000 Pts *                      ON    ON
    -- Bonus Player @ 15000 Pts                        OFF   ON
    -- Bonus Player @ 20000 Pts                        ON    OFF
    -- No Bonus Players                                OFF   OFF
    ------------------------------------------------------------------------
    -- Free Game in ULTRA PAC / Buy-in ON *                  ON
    -- Free Life in ULTRA PAC / Buy-in OFF                   OFF
    ------------------------------------------------------------------------
    -- Auto. Rack Advance (Skip)                                   ON (pas lu par la lecture des DIP SW, connecté directement au core)
    -- Normal- Must be off for game play *                         OFF
    ------------------------------------------------------------------------
    -- Freeze Video (Pause)                                              ON (pas lu par la lecture des DIP SW, connecté directement au core)
    -- Normal- Must be off for game play *                               OFF
    ------------------------------------------------------------------------
    -- cfg_dynamic(11): Mode "service", seulement utilise dans le cas de Pengo
    -- cfg_dynamic(10) : Utilise pour lire un switch (le 7) qui doit être lu à 1 (OFF)
    -- cfg_dynamic(9) : Mode cocktail (0 = ON)
    -- cfg_dynamic(8) : Mode test (0 = ON)
  
    -- cfg_dip_sw <= std_logic_vector(c_1_coin_1_credit) or 
    --               std_logic_vector(c_1_pacman) or std_logic_vector(c_bonus_10000) or
    --               std_logic_vector(c_free_game) or std_logic_vector(c_auto_rack_advance) or
    --               std_logic_vector(c_freeze_video);
    cfg_dip_sw <= std_logic_vector(c_sw1_off or c_sw3_off or c_sw5_off);

    in0_reg(7) <= credit;      -- credit
    in0_reg(6) <= coins(1);    -- coin2
    in0_reg(5) <= coins(0);    -- coin1
    in0_reg(4) <= cfg_dip_sw(6); -- test_l dipswitch (rack advance)
    in0_reg(3) <= joy_a(1);    -- p1 down
    in0_reg(2) <= joy_a(3);    -- p1 right
    in0_reg(1) <= joy_a(2);    -- p1 left
    in0_reg(0) <= joy_a(0);    -- p1 up

    in1_reg(7) <= table;
    in1_reg(6) <= buttons(1);  -- start 2
    in1_reg(5) <= buttons(0);  -- start 1
    in1_reg(4) <= test;       -- test
    in1_reg(3) <= joy_b(1);   -- p2 down
    in1_reg(2) <= joy_b(3);   -- p2 right
    in1_reg(1) <= joy_b(2);   -- p2 left
    in1_reg(0) <= joy_b(0);   -- p2 up   
    
    rst_sys <= '0', '1' after 100 us;

end Behavioral;
