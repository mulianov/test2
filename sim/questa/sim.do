quit -sim
vlib work
vlog -work work -O0 -cover bcs +acc rtl/top.sv sim/top_tb.sv
vsim -voptargs=+acc -debugDB -coverage -fsmdebug -onfinish stop top_tb
coverage save -onexit report.ucdb;
add wave -position insertpoint sim:/top_tb/*
vcd file wave_vsim.vcd
vcd add -r top_tb/*
run -all
vcover report -details -html report.ucdb