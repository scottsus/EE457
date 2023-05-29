
# ee457_fifo.do

vlib work
vlog +acc  "ee457_fifo.v"
vlog +acc  "ee457_fifo_tb.v"
# vsim  work.ee457_fifo_tb
vsim -novopt -t 1ps -lib work fifo_tb
# do {ee457_fifo_wave.do}
view wave
view structure
view signals
log -r *
run 300ns
add wave sim:/fifo_tb/*
WaveRestoreZoom {0 ps} {500 ns}
