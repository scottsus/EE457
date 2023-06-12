onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ee457_pipe_cpu_tb/uut/clk
add wave -noupdate /ee457_pipe_cpu_tb/uut/rst
add wave -noupdate -radix decimal /ee457_pipe_cpu_tb/cc
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/uut/pc
add wave -noupdate -expand -group HighLevel -radix ascii /ee457_pipe_cpu_tb/if_opname
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/uut/if_id_instruc
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/uut/reg_ra
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/uut/reg_rb
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/uut/reg_radata
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/uut/reg_rbdata
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/uut/ina
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/uut/inb
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/uut/alu_res
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/uut/branch_taken
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/uut/ex_mem_next_pc_d
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/uut/ex_mem_alu_result
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/uut/dmem_rdata
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/dmem_wdata
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/dmemwrite
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/uut/regfile/wa
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/uut/regfile/wdata
add wave -noupdate -expand -group HighLevel /ee457_pipe_cpu_tb/uut/regfile/wen
add wave -noupdate -expand -group {IF Stage} /ee457_pipe_cpu_tb/uut/pc
add wave -noupdate -expand -group {IF Stage} /ee457_pipe_cpu_tb/uut/pcwrite
add wave -noupdate -expand -group {IF Stage} /ee457_pipe_cpu_tb/uut/imem_rdata
add wave -noupdate -expand -group {IF Stage} -radix ascii /ee457_pipe_cpu_tb/if_opname
add wave -noupdate -expand -group {ID Stage} /ee457_pipe_cpu_tb/uut/if_id_instruc
add wave -noupdate -expand -group {ID Stage} /ee457_pipe_cpu_tb/uut/reg_ra
add wave -noupdate -expand -group {ID Stage} /ee457_pipe_cpu_tb/uut/reg_rb
add wave -noupdate -expand -group {ID Stage} /ee457_pipe_cpu_tb/uut/reg_radata
add wave -noupdate -expand -group {ID Stage} /ee457_pipe_cpu_tb/uut/reg_rbdata
add wave -noupdate /ee457_pipe_cpu_tb/uut/hdu_stall
add wave -noupdate /ee457_pipe_cpu_tb/uut/stall
add wave -noupdate /ee457_pipe_cpu_tb/uut/irwrite
add wave -noupdate /ee457_pipe_cpu_tb/uut/insert_bubble
add wave -noupdate -expand -group {EX stage} /ee457_pipe_cpu_tb/uut/id_ex_reg_radata
add wave -noupdate -expand -group {EX stage} /ee457_pipe_cpu_tb/uut/id_ex_reg_rbdata
add wave -noupdate -expand -group {EX stage} /ee457_pipe_cpu_tb/uut/id_ex_regdst
add wave -noupdate -expand -group {EX stage} /ee457_pipe_cpu_tb/uut/id_ex_alusrc
add wave -noupdate -expand -group {EX stage} /ee457_pipe_cpu_tb/uut/id_ex_aluop
add wave -noupdate -expand -group {EX stage} /ee457_pipe_cpu_tb/uut/id_ex_branch
add wave -noupdate -expand -group {EX stage} /ee457_pipe_cpu_tb/uut/id_ex_jump
add wave -noupdate -expand -group {EX stage} /ee457_pipe_cpu_tb/uut/id_ex_memread
add wave -noupdate -expand -group {EX stage} /ee457_pipe_cpu_tb/uut/id_ex_memwrite
add wave -noupdate -expand -group {EX stage} /ee457_pipe_cpu_tb/uut/id_ex_regwrite
add wave -noupdate -expand -group {EX stage} /ee457_pipe_cpu_tb/uut/id_ex_memtoreg
add wave -noupdate -expand -group {EX stage} /ee457_pipe_cpu_tb/uut/ina
add wave -noupdate -expand -group {EX stage} /ee457_pipe_cpu_tb/uut/inb
add wave -noupdate -expand -group {EX stage} /ee457_pipe_cpu_tb/uut/alu_func
add wave -noupdate -expand -group {EX stage} /ee457_pipe_cpu_tb/uut/alu_res
add wave -noupdate -expand -group {EX stage} /ee457_pipe_cpu_tb/uut/zero
add wave -noupdate -expand -group {MEM Stage} /ee457_pipe_cpu_tb/uut/ex_mem_alu_result
add wave -noupdate -expand -group {MEM Stage} /ee457_pipe_cpu_tb/uut/ex_mem_branch
add wave -noupdate -expand -group {MEM Stage} /ee457_pipe_cpu_tb/uut/branch_taken
add wave -noupdate -expand -group {MEM Stage} /ee457_pipe_cpu_tb/uut/ex_mem_memread
add wave -noupdate -expand -group {MEM Stage} /ee457_pipe_cpu_tb/uut/ex_mem_memwrite
add wave -noupdate -expand -group {MEM Stage} /ee457_pipe_cpu_tb/uut/ex_mem_regwrite
add wave -noupdate -expand -group {MEM Stage} /ee457_pipe_cpu_tb/uut/ex_mem_memtoreg
add wave -noupdate -expand -group {MEM Stage} /ee457_pipe_cpu_tb/uut/ex_mem_jump
add wave -noupdate -expand -group {MEM Stage} /ee457_pipe_cpu_tb/uut/ex_mem_next_pc_d
add wave -noupdate -expand -group {MEM Stage} /ee457_pipe_cpu_tb/uut/dmem_addr
add wave -noupdate -expand -group {MEM Stage} /ee457_pipe_cpu_tb/uut/dmem_rdata
add wave -noupdate -expand -group {MEM Stage} /ee457_pipe_cpu_tb/uut/dmem_wdata
add wave -noupdate -expand -group {MEM Stage} /ee457_pipe_cpu_tb/uut/dmemread
add wave -noupdate -expand -group {MEM Stage} /ee457_pipe_cpu_tb/uut/dmemwrite
add wave -noupdate -expand -group WBStage /ee457_pipe_cpu_tb/uut/regfile/wa
add wave -noupdate -expand -group WBStage /ee457_pipe_cpu_tb/uut/regfile/wdata
add wave -noupdate -expand -group WBStage /ee457_pipe_cpu_tb/uut/regfile/wen
add wave -noupdate /ee457_pipe_cpu_tb/uut/regfile/regarray
add wave -noupdate -expand /ee457_pipe_cpu_tb/dmem/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {327007 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 302
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {41318 ps}
