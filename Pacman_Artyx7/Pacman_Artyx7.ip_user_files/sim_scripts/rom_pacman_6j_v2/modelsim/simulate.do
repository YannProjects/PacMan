onbreak {quit -f}
onerror {quit -f}

<<<<<<< HEAD
vsim -voptargs="+acc" -L dist_mem_gen_v8_0_13 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.rom_pacman_6j_v2 xil_defaultlib.glbl
=======
vsim -voptargs="+acc" -L xpm -L dist_mem_gen_v8_0_13 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.rom_pacman_6j_v2 xil_defaultlib.glbl
>>>>>>> 8d8951fe53392006346f0a5ba26bbcbabd6294a8

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {rom_pacman_6j_v2.udo}

run -all

quit -force