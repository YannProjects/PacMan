import os
import sys

black="\u001b[30m"
red="\u001b[31m"
green="\u001b[32m"
yellow="\u001b[33m"
blue="\u001b[34m"
magenta="\u001b[35m"
cyan="\u001b[36m"
white="\u001b[37m"

bg_black="\u001b[40m"
bg_red="\u001b[41m"
bg_green="\u001b[42m"
bg_yellow="\u001b[43m"
bg_blue="\u001b[44m"
bg_magenta="\u001b[45m"
bg_cyan="\u001b[46m"
bg_white="\u001b[47m"

reset="\u001b[0m"

tile_file = "/cygdrive/d/Documents/Projets_HW/PacMan_v2/roms/pacman_5e.coe"
sprites_file = "/cygdrive/d/Documents/Projets_HW/PacMan_v2/roms/pacman_5f.coe"

tile_nb=0
tile_size = 8
tile_bitmap=[0 for i in range(2*tile_size)]
display_sprites = 0
display_tiles = 0

if len(sys.argv) != 3:
    print("Usage:")
    print(" Affichage_pacman_tiles_sprites.py sprites ou tiles items ID ou 256 pour afficher tout")
    print("Ex.: Affichage_pacman_tiles_sprites.py sprites 256")
    print("Affichage_pacman_tiles_sprites.py tiles 25")
    exit()

tile_or_sprite = sys.argv[1]
tile_or_sprite_id = sys.argv[2]

if tile_or_sprite == "sprites" or tile_or_sprite == "all":
    display_sprites = 1

if tile_or_sprite == "tiles" or tile_or_sprite == "all":
    display_tiles = 1

if tile_or_sprite_id == "all":
    item_id = 256
else:
    item_id = int(tile_or_sprite_id)
    
print ("Affichage tile ou sprite: ", tile_or_sprite)
print ("Tile ou sprite ID=", str(item_id))

input_file_name = tile_file

file_stats = os.stat(input_file_name)
file_size = file_stats.st_size
print("File size = ", file_size)

tile_rom_file = open(input_file_name, "rb")


if (display_tiles == 1):
    for i in range(int(file_size/len(tile_bitmap))):
        tile_bitmap = tile_rom_file.read(len(tile_bitmap))
        if (tile_nb == item_id) or (item_id == 256):
            print("\n------------ TILE ", tile_nb, " -------------------")

            for j in range(tile_size):
                first_pixel_group = tile_bitmap[2*tile_size-1-j]
                second_pixel_group = tile_bitmap[tile_size-1-j]
                #print("\nFirst pixel group=", hex(first_pixel_group))
                #print("Second pixel group=", hex(second_pixel_group))

                pixel_group_list=[second_pixel_group, first_pixel_group]
                for pixel_group in pixel_group_list:
                    for k in range(4):
                        pixel_color = ((pixel_group >> k) & 0x1) + ((pixel_group >> (k+4)) & 0x1) * 2
                        if pixel_color == 0:
                            print(bg_black + " " + reset, end="")
                        elif pixel_color == 1:
                            print(bg_white + " " + reset, end="")
                        elif pixel_color == 2:
                            print(bg_blue + " " + reset, end="")
                        elif pixel_color == 3:
                            print(bg_red + " " + reset, end="")

                print("")
        tile_nb += 1

tile_rom_file.close()


print("\n----------------------------------------------")
print("\n----------------------------------------------")
print("\n----------------------------------------------")

input_file_name = sprites_file

file_stats = os.stat(input_file_name)
file_size = file_stats.st_size
print("File size = ", file_size)

sprites_rom_file = open(input_file_name, "rb")

sprite_nb=0
strip_size = 4
nb_strips_per_sprite = 16
sprites_bitmap=[0 for i in range(strip_size*nb_strips_per_sprite)]

xflip=0
yflip=0

if (display_sprites == 1):
    for i in range(int(file_size/len(sprites_bitmap))):
        sprites_bitmap = sprites_rom_file.read(strip_size*nb_strips_per_sprite)

        if (sprite_nb == item_id) or (item_id == 256):
            print("\n------------ SPRITE ", sprite_nb, " -------------------")
            print("XFLIP = ", xflip, ", YFLIP = ", yflip)
            
            for j in range(nb_strips_per_sprite):
            
                if xflip == 0:
                    line_offset = ((j & 8)*4 + (j & 7))
                else:
                    line_offset = ((j & 8)*4 + (j & 7)) ^ 0x27
                    
                if yflip == 0:
                    first_pixel_group = sprites_bitmap[line_offset]
                    second_pixel_group = sprites_bitmap[line_offset + 0x18]
                    third_pixel_group = sprites_bitmap[line_offset + 0x10]
                    fourth_pixel_group = sprites_bitmap[line_offset + 0x8]    
                else:
                    first_pixel_group = sprites_bitmap[line_offset + 0x8]
                    second_pixel_group = sprites_bitmap[line_offset + 0x10]
                    third_pixel_group = sprites_bitmap[line_offset + 0x18]
                    fourth_pixel_group = sprites_bitmap[line_offset]          

                #print("\n1st pixel group=", hex(first_pixel_group))
                #print("2nd pixel group=", hex(second_pixel_group))
                #print("3rd pixel group=", hex(third_pixel_group))
                #print("4th pixel group=", hex(fourth_pixel_group))

                pixel_group_list=[first_pixel_group, second_pixel_group, third_pixel_group, fourth_pixel_group ]
                for pixel_group in pixel_group_list:
                    for k in range(4):
                        if yflip == 0:
                            pixel_color = ((pixel_group >> k) & 0x1) + ((pixel_group >> (k+4)) & 0x1) * 2
                        else:
                            pixel_color = ((pixel_group >> (7-k)) & 0x1) * 2 + ((pixel_group >> (3-k)) & 0x1)
                        if pixel_color == 0:
                            print(bg_black + " " + reset, end="")
                        elif pixel_color == 1:
                            print(bg_white + " " + reset, end="")
                        elif pixel_color == 2:
                            print(bg_blue + " " + reset, end="")
                        elif pixel_color == 3:
                            print(bg_red + " " + reset, end="")

                print("")
                
        sprite_nb += 1


sprites_rom_file.close()
