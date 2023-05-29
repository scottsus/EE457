
# ee457_fifo_p2.do

vlib work
vlog +acc  "ee457_fifo_p2.v"
vlog +acc  "ee457_fifo_p2_tb.v"
# vsim  work.ee457_fifo_p2_tb
vsim -novopt -t 1ps -lib work fifo_tb
# do {ee457_fifo_p2_wave.do}
view wave
view structure
view signals
log -r *
run 300ns
add wave sim:/fifo_tb/*
WaveRestoreZoom {0 ps} {500 ns}
