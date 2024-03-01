COCOTB_BUILD_DIR = $(CUR_DIR)/build/cocotb

cocotb.tb:
	mkdir -p $(COCOTB_BUILD_DIR)
	cd $(COCOTB_BUILD_DIR); pytest $(SIM_SRC_DIR)

cocotb.clean:
	rm -rf $(COCOTB_BUILD_DIR)
