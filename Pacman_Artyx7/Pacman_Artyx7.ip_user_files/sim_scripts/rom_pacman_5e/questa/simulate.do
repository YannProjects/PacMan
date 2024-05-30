onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib rom_pacman_5e_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {rom_pacman_5e.udo}

run -all

quit -force
