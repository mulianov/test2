YOSYS_BUILD_DIR = $(CUR_DIR)/build/yosys

# hierarchy_opts = -top $(module_top)
#-p "proc; opt; memory; opt; fsm; opt" \

yosys.elaborate:
	mkdir -p $(YOSYS_BUILD_DIR)
	cd $(YOSYS_BUILD_DIR); yosys -p "plugin -i systemverilog" \
		-p "read_systemverilog -formal $(RTL_SRC_DIR)/top.sv" \
		-p "show -colors 42 -stretch -format svg -prefix $(module_top)_elab show top"

yosys.synth:
	mkdir -p $(YOSYS_BUILD_DIR)
	cd $(YOSYS_BUILD_DIR); yosys -p "plugin -i systemverilog" \
		-p "read_systemverilog -formal $(RTL_SRC_DIR)/top.sv" \
		-p "synth_xilinx -family xc7 -top $(module_top) -flatten" \
		-p "write_json $(module_top)_synth.json"; \
		netlistsvg -o $(module_top)_synth.svg $(module_top)_synth.json

yosys.clean:
	rm -rf $(YOSYS_BUILD_DIR)
