color = "DB"
line_length = 288
num_of_lines = 224
file_name = "C:\\Users\\yannv\\Documents\\Projets_HW\\PacMan\\Tools\\video_ram_test_pattern.coe"

video_pattern_file = open(file_name, "w+")
video_pattern_file.write("memory_initialization_radix=16;\n")
video_pattern_file.write("memory_initialization_vector=\n")
for l in range(num_of_lines):
    if (l%32) == 0:
        for c in range(line_length):
            video_pattern_file.write(color + " ")
        video_pattern_file.write("\n")
    else:
        for c in range(line_length):
            if (c%32) == 0:
                video_pattern_file.write(color + " ")
            else:
                video_pattern_file.write("00 ")
        video_pattern_file.write("\n")

video_pattern_file.write(";")
video_pattern_file.close()
         
