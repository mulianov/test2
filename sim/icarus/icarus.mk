ICARUS_BUILD_DIR = $(CUR_DIR)/build/icarus
ICARUS_SRC_DIR = $(CUR_DIR)/sim/icarus

icarus.compile:
	mkdir -p $(ICARUS_BUILD_DIR)
	iverilog -o $(ICARUS_BUILD_DIR)/top.vvp -g2012 \
                -DCLK_PERIOD=$(CLK_PERIOD) \
		$(RTL_SRC_DIR)/top.sv $(SIM_SRC_DIR)/top_tb.sv

icarus.run: icarus.compile
	cd $(ICARUS_BUILD_DIR); vvp top.vvp -fst

icarus.wave: icarus.run
	gtkwave -T $(SIM_COMMON_DIR)/gtkwave.tcl $(ICARUS_BUILD_DIR)/wave.fst

icarus.vpi: icarus.compile
	cd $(ICARUS_BUILD_DIR) ;\
	iverilog-vpi $(ICARUS_SRC_DIR)/test_vpi.c ;\
	vvp -M. -mtest_vpi top.vvp

icarus.clean:
	rm -rf $(ICARUS_BUILD_DIR)
