import sys
import os

input_file_name = sys.argv[1]
output_file_name_a = input_file_name + ".0a.coe"
output_file_name_b = input_file_name + ".0b.coe"
output_file_name_c = input_file_name + ".0c.coe"
output_file_name_d = input_file_name + ".0d.coe"
chunk_size = 4*4096

output_file_list = [output_file_name_a, output_file_name_b, output_file_name_c, output_file_name_d]

file_stats = os.stat(input_file_name)

num_files = int(file_stats.st_size / chunk_size)

bin_rom_file = open(input_file_name, "rb")
binary_data = bin_rom_file.read()

f = 0
for f in range (num_files):
    output_file_name = output_file_list[f]
    print("Creation fichier: " + output_file_name)

    coe_file = open(output_file_name, "w+")
    coe_file.write("memory_initialization_radix=16;\n")
    coe_file.write("memory_initialization_vector=")
    for i in range(chunk_size*f, chunk_size*(f+1)):
        coe_file.write(f"{binary_data[i]:02x}" + " ")

    coe_file.write(";")
    coe_file.close()

if file_stats.st_size % chunk_size !=0 :
    if f != 0:
        f = f + 1
    output_file_name = output_file_list[f]
    print("Creation fichier: " + output_file_name)

    coe_file = open(output_file_name, "w+")
    coe_file.write("memory_initialization_radix=16;\n")
    coe_file.write("memory_initialization_vector=")
    for i in range(chunk_size*(f), file_stats.st_size):
        coe_file.write(f"{binary_data[i]:02x}" + " ")

    coe_file.write(";")
    coe_file.close()

bin_rom_file.close()

         
