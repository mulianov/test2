ICARUS_BUILD_DIR = $(CUR_DIR)/build/icarus
ICARUS_SRC_DIR = $(CUR_DIR)/sim/icarus

icarus.tb:
	mkdir -p $(ICARUS_BUILD_DIR)
	iverilog -o $(ICARUS_BUILD_DIR)/top.vvp -g2012 \
		$(RTL_SRC_DIR)/top.sv $(SIM_SRC_DIR)/top_tb.sv
	cd $(ICARUS_BUILD_DIR); vvp top.vvp -fst

icarus.wave: icarus.tb
	gtkwave -T $(SIM_COMMON_DIR)/gtkwave.tcl $(ICARUS_BUILD_DIR)/wave.fst

icarus.vpi: icarus.tb
	cd $(ICARUS_BUILD_DIR) ;\
	iverilog-vpi $(ICARUS_SRC_DIR)/test_vpi.c ;\
	vvp -M . -m test_vpi top.vvp

icarus.clean:
	rm -rf $(ICARUS_BUILD_DIR)
