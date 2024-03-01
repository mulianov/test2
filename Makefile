CUR_DIR=$(shell pwd)
RTL_SRC_DIR = $(CUR_DIR)/rtl
SIM_SRC_DIR = $(CUR_DIR)/sim/src
SIM_COMMON_DIR = $(CUR_DIR)/sim/common

module_top = top

include sim/icarus/icarus.mk
include sim/verilator/verilator.mk
include sim/questa/questa.mk
include sim/cocotb/cocotb.mk
include impl/yosys/yosys.mk
include impl/vivado/vivado.mk

verible_filelist:
	find . -name "*.sv" -o -name "*.svh" -o -name "*.v" | sort > verible.filelist

clean:
	rm -rf build
