# run_bft_kintex7_batch.tcl
# bft sample design
# A Vivado script that demonstrates a very simple RTL-to-bitstream non-project batch flow
#
# NOTE:  typical usage would be "vivado -mode tcl -source run_bft_kintex7_batch.tcl"
#
# STEP#0: define output directory area.
#
set outputDir $env(VIVADO_BUILD_DIR)
file mkdir $outputDir
#
# STEP#1: setup design sources and constraints
#
# read_vhdl -library bftLib [ glob ./Sources/hdl/bftLib/*.vhdl ]
# read_vhdl ./Sources/hdl/bft.vhdl
# read_verilog  [ glob ./Sources/hdl/*.v ]
read_verilog -sv -verbose $env(RTL_SRC_DIR)/top.sv
read_xdc $env(VIVADO_SRC_DIR)/top.xdc
#
# STEP#2: run synthesis, report utilization and timing estimates, write checkpoint design
#
synth_design -top top -part xczu28dr-ffvg1517-2-e
write_checkpoint -force $outputDir/post_synth
report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
report_timing -file $outputDir/post_synth_timing.rpt
report_utilization -file $outputDir/post_synth_util.rpt
 report_power -file $outputDir/post_synth_power.rpt
#
# exit
#
# STEP#3: run placement and logic optimzation, report utilization and timing estimates, write checkpoint design
#
opt_design
place_design
phys_opt_design
write_checkpoint -force $outputDir/post_place
report_timing_summary -file $outputDir/post_place_timing_summary.rpt
#
# # STEP#4: run router, report actual utilization and timing, write checkpoint design, run drc, write verilog and xdc out
#
route_design
write_checkpoint -force $outputDir/post_route
report_timing_summary -file $outputDir/post_route_timing_summary.rpt
report_timing -sort_by group -max_paths 100 -path_type summary -file $outputDir/post_route_timing.rpt
report_clock_utilization -file $outputDir/clock_util.rpt
report_utilization -file $outputDir/post_route_util.rpt
report_power -file $outputDir/post_route_power.rpt
report_drc -file $outputDir/post_imp_drc.rpt
write_verilog -force $outputDir/top_impl_netlist.v
write_xdc -no_fixed_only -force $outputDir/top_impl.xdc
#
# STEP#5: generate a bitstream
#
# write_bitstream -force $outputDir/bft.bit
#
# STEP#6: gui start
#
start_gui
#
