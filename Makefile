.PHONY: run_test

######################################################################
# Set up variables

GENHTML = genhtml

# If $VERILATOR_ROOT isn't in the environment, we assume it is part of a
# package install, and verilator is in your path. Otherwise find the
# binary relative to $VERILATOR_ROOT (such as when inside the git sources).
ifeq ($(VERILATOR_ROOT),)
VERILATOR = verilator
VERILATOR_COVERAGE = verilator_coverage
else
export VERILATOR_ROOT
VERILATOR = $(VERILATOR_ROOT)/bin/verilator
VERILATOR_COVERAGE = $(VERILATOR_ROOT)/bin/verilator_coverage
endif

VERILATOR_FLAGS =
# Generate C++ in executable form
VERILATOR_FLAGS += -cc --exe
# Generate makefile dependencies (not shown as complicates the Makefile)
#VERILATOR_FLAGS += -MMD
# Optimize
VERILATOR_FLAGS += --x-assign 0
# Warn abount lint issues; may not want this on less solid designs
VERILATOR_FLAGS += -Wall
# Make waveforms
VERILATOR_FLAGS += --trace-fst
# Check SystemVerilog assertions
VERILATOR_FLAGS += --assert
# Generate coverage analysis
VERILATOR_FLAGS += --coverage
# Run make to compile model, with as many CPUs as are free
VERILATOR_FLAGS += --build -j
# VERILATOR_FLAGS += --timing
# Run Verilator in debug mode
#VERILATOR_FLAGS += --debug
# Add this trace to get a backtrace in gdb
#VERILATOR_FLAGS += --gdbbt

# Input files for Verilator
# VERILATOR_INPUT = -f input.vc top.sv sim_main.cpp top_tb.sv
VERILATOR_INPUT = -f input.vc top.sv sim_main.cpp

######################################################################

# Create annotated source
VERILATOR_COV_FLAGS += --annotate logs/annotated
# A single coverage hit is considered good enough
# VERILATOR_COV_FLAGS += --annotate-min 1
# Create LCOV info
VERILATOR_COV_FLAGS += --write-info logs/coverage.info
# Input file from Verilator
VERILATOR_COV_FLAGS += logs/coverage.dat

######################################################################
default: run_test

verilate:
	@echo
	@echo "-- VERILATE ----------------"
	$(VERILATOR) --version
	$(VERILATOR) $(VERILATOR_FLAGS) $(VERILATOR_INPUT)

	@echo
	@echo "-- RUN ---------------------"
	@rm -rf logs
	@mkdir -p logs
	obj_dir/Vtop

	@echo
	@echo "-- COVERAGE ----------------"
	@rm -rf logs/annotated
	$(VERILATOR_COVERAGE) $(VERILATOR_COV_FLAGS)

	@echo
	@echo "-- DONE --------------------"

cov_html: verilate
	@rm -rf logs/annotated
	$(GENHTML) logs/coverage.info -o logs/html

file_main = top
module_top = top
# hierarchy_opts = -top $(module_top)
#-p "proc; opt; memory; opt; fsm; opt" \

all: test run_test

test:
	iverilog -o top -g2012 top.sv top_tb.sv

run_test: test
	vvp top -fst

yosys_elaborate:
	yosys -p "plugin -i systemverilog" \
		-p "read_systemverilog -formal $(file_main).sv" \
		-p "show -colors 42 -stretch -format svg -prefix mygraph show top"

yosys_synth:
	yosys -p "plugin -i systemverilog" \
		-p "read_systemverilog -formal $(file_main).sv" \
		-p "synth_xilinx -family xc7 -top $(module_top) -flatten" \
		-p "write_json $(file_main).json"

synth_svg: yosys_synth
	netlistsvg -o $(file_main).svg $(file_main).json

wave: run_test
	gtkwave -T gtkwave.tcl wave_iverilog.fst

vivado:
	vivado -mode tcl -source ./test1.tcl

verible_filelist:
	find . -name "*.sv" -o -name "*.svh" -o -name "*.v" | sort > verible.filelist

clean:
	rm -rf top *.fst *.json *.svg _output slpp_all logs obj_dir verible.filelist *.vcd
