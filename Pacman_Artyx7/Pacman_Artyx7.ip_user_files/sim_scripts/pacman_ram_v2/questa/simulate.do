onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib pacman_ram_v2_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {pacman_ram_v2.udo}

run -all

quit -force
