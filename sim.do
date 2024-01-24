quit -sim
vlib work
vlog -work work -O0 -cover bcs +acc top.sv top_tb.sv
vsim -voptargs=+acc -debugDB -coverage top_tb
coverage save -onexit report.ucdb;
add wave -position insertpoint sim:/top_tb/*
vcd file wave_vsim.vcd
vcd add -r top_tb/*
run -all
vcover report -details -html report.ucdb
