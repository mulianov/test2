GWSH = gw_sh

GOWIN_BUILD_DIR = $(CUR_DIR)/build/gowin
GOWIN_SRC_DIR = $(CUR_DIR)/impl/gowin

gowin:
	mkdir -p $(GOWIN_BUILD_DIR)
	cd $(GOWIN_BUILD_DIR); $(GWSH) $(GOWIN_SRC_DIR)/top.tcl
