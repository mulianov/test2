CUR_DIR=$(shell pwd)
RTL_SRC_DIR = $(CUR_DIR)/rtl
SIM_SRC_DIR = $(CUR_DIR)/sim

module_top = top

include sim/icarus.mk
include sim/verilator.mk
include sim/questa.mk
include rtl/yosys.mk
include vivado/vivado.mk

verible_filelist:
	find . -name "*.sv" -o -name "*.svh" -o -name "*.v" | sort > verible.filelist

clean:
	verible.filelist *.vcd  \
	*.ucdb transcript vsim.dbg vsim.wlf \
	work sim_build __pycache__ cscope* \
	vivado*.jou vivado*.log \
	.nvim .pytest_cache .Xil
