# run_bft_kintex7_batch.tcl
# bft sample design
# A Vivado script that demonstrates a very simple RTL-to-bitstream non-project batch flow
#
# NOTE:  typical usage would be "vivado -mode tcl -source run_bft_kintex7_batch.tcl"
#
# STEP#0: define output directory area.
#
set outputDir ./_output
file mkdir $outputDir
#
# STEP#1: setup design sources and constraints
#
# read_vhdl -library bftLib [ glob ./Sources/hdl/bftLib/*.vhdl ]
# read_vhdl ./Sources/hdl/bft.vhdl
# read_verilog  [ glob ./Sources/hdl/*.v ]
read_verilog -sv -verbose top.sv
read_xdc top.xdc
#
# STEP#2: run synthesis, report utilization and timing estimates, write checkpoint design
#
synth_design -top top -part xczu28dr-ffvg1517-2-e -rtl
exit
