
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;

  use work.Replay_Pack.all;

-- Custom IC 5 S VRAM addresser
-- Converti les coordonnées horizontales / verticales en adresses RAM

entity Pacman_VRAM_Addr is
  port (
    i_h       : in    word ( 8 downto 0); -- H256_L H128 H64 H32 H16 H8 H4 H2 H1
    i_v       : in    word ( 7 downto 0); --        V128 V64 v32 V16 V8 V4 V2 V1
    i_flip    : in    bit1;
    o_ab      : out   word (11 downto 0)
    );
end;

architecture RTL of Pacman_VRAM_Addr is

  signal f    : word(7 downto 3);
  signal vp   : word(7 downto 3);
  signal hp   : word(7 downto 3);
  signal sel  : std_logic;
  signal y157 : std_logic_vector (11 downto 0);

begin

  f  <= (others => i_flip);
  vp <= i_v(7 downto 3) xor f;
  hp <= i_h(7 downto 3) xor f;

  p_sel : process(i_h)
  begin
    sel <= not ( (i_h(5) xor i_h(4)) or (i_h(5) xor i_h(6)) );
  end process;

  p_y157 : process(sel, i_h, hp, vp)
  begin
    if (sel = '1') then
      y157 <= '0' & i_h(2) & hp(6) & hp(6) & hp(6) & hp(6) & hp(3) & vp(7 downto 3);
    else
      y157 <= "11111111" & i_h(6 downto 4) & i_h(2);
    end if;
  end process;

  p_ab : process(i_h, vp, hp, y157)
  begin
    if (i_h(8) = '1') then -- H256_l
      o_ab <= '0' & i_h(2) & vp(7 downto 3) & hp(7 downto 3);
    else
      o_ab <= y157;
    end if;
  end process;

end RTL;
