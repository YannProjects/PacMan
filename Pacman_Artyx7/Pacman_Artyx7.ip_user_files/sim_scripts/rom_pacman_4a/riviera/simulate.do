onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+rom_pacman_4a -L xpm -L dist_mem_gen_v8_0_13 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.rom_pacman_4a xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure

do {rom_pacman_4a.udo}

run -all

endsim

quit -force
