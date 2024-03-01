coverage save -onexit report.ucdb;
add wave -position insertpoint sim:/top_tb/top_instance/*
vcd file wave_vsim.vcd
vcd add -r top_tb/top_instance/*
run -all
vcover report -details -html report.ucdb
