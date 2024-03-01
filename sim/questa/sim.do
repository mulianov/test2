coverage save -onexit report.ucdb;
add wave -position insertpoint sim:/top_tb/*
vcd file wave_vsim.vcd
vcd add -r top_tb/*
run -all
vcover report -details -html report.ucdb
