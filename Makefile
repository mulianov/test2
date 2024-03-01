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
	rm -rf build
