VERILATOR_OUTPUT_DIR = $(CUR_DIR)/build/verilator
VERILATOR_LOG_DIR = $(VERILATOR_OUTPUT_DIR)/logs
VERILATOR_BUILD_DIR = $(VERILATOR_OUTPUT_DIR)/obj_dir
VERILATOR_SRC_DIR = $(CUR_DIR)/sim/verilator

ifeq ($(VERILATOR_ROOT),)
VERILATOR = verilator
VERILATOR_COVERAGE = verilator_coverage
else
export VERILATOR_ROOT
VERILATOR = $(VERILATOR_ROOT)/bin/verilator
VERILATOR_COVERAGE = $(VERILATOR_ROOT)/bin/verilator_coverage
endif

GENHTML = genhtml

VERILATOR_FLAGS = -cc --exe \
	       --x-assign 0 \
	       -Wall -Wpedantic \
	       -sv +1800-2017ext+sv \
	       --trace-fst \
               --assert \
               --coverage \
               --build -j \
	       --Mdir build/verilator/obj_dir \
	       --top top \
	       --no-trace-top \
	       +libext+.v+.sv+.vh+.svh -y $(RTL_SRC_DIR)

#VERILATOR_FLAGS += --timing

VERILATOR_INPUT = $(RTL_SRC_DIR)/top.sv $(VERILATOR_SRC_DIR)/sim_main.cpp
# ######################################################################

VERILATOR_COV_FLAGS += --annotate logs/annotated
VERILATOR_COV_FLAGS += --write-info logs/coverage.info
VERILATOR_COV_FLAGS += logs/coverage.dat

######################################################################

verilator.tb:
	@echo "\n-- VERILATE ----------------\n"
	@mkdir -p $(VERILATOR_OUTPUT_DIR)
	$(VERILATOR) $(VERILATOR_FLAGS) $(VERILATOR_INPUT)
	@echo "\n-- RUN ---------------------\n"
	@rm -rf $(VERILATOR_LOG_DIR)
	@mkdir -p $(VERILATOR_LOG_DIR)
	@cd $(VERILATOR_OUTPUT_DIR); $(VERILATOR_BUILD_DIR)/Vtop
	@echo "\n-- COVERAGE ----------------\n"
	@rm -rf $(VERILATOR_LOG_DIR)/annotated
	@cd $(VERILATOR_OUTPUT_DIR); $(VERILATOR_COVERAGE) $(VERILATOR_COV_FLAGS)
	@echo "\n-- DONE --------------------\n"

verilator.cov_html: verilator.tb
	@rm -rf $(VERILATOR_LOG_DIR)/annotated
	$(GENHTML) $(VERILATOR_LOG_DIR)/coverage.info -o $(VERILATOR_LOG_DIR)/html

verilator.wave: verilator.tb
	gtkwave -T $(SIM_COMMON_DIR)/gtkwave.tcl $(VERILATOR_OUTPUT_DIR)/wave_verilator.fst

verilator.clean:
	rm -rf $(VERILATOR_OUTPUT_DIR)
