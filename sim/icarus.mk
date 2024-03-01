ICARUS_BUILD_DIR = $(CUR_DIR)/build/icarus

icarus.tb:
	mkdir -p $(ICARUS_BUILD_DIR)
	iverilog -o $(ICARUS_BUILD_DIR)/top.vvp -g2012 rtl/top.sv sim/top_tb.sv
	cd $(ICARUS_BUILD_DIR); vvp top.vvp -fst

icarus.wave: icarus.tb
	gtkwave -T sim/gtkwave.tcl build/icarus/wave_icarus.fst

icarus.vpi: icarus.tb
	cd $(ICARUS_BUILD_DIR) ;\
	iverilog-vpi $(CUR_DIR)/sim/test_vpi.c ;\
	vvp -M . -m test_vpi top.vvp

icarus.clean:
	rm -rf $(ICARUS_BUILD_DIR)
