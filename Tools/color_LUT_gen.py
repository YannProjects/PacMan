color_lut_base = 2048

for blue in range(4):
    for green in range(8):
        for red in range(8):
            color_index = color_lut_base + 4*((red << 5) + (green << 2) + blue)
            pacman_color = (blue << 6) + (green << 3) + red
            rgb = (red << (24-3)) + (green << (16-3)) + (blue << (8-2))
            # (CLUT_REG_ADDR_1,x"00E0E0E0", '0')
            print("(X\"00000" + format(color_index, '03X') + "\", x\"" + format(rgb, '08X') + "\"" + ", '0'), pacman color = " + format(pacman_color, '08X'))
