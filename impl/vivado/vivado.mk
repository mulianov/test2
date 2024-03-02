VIVADO = vivado -nojournal -nolog
VIVADO_TCL = $(VIVADO) -mode tcl -source

VIVADO_BUILD_DIR = $(CUR_DIR)/build/vivado
VIVADO_SRC_DIR = $(CUR_DIR)/impl/vivado

vivado.elab:
	$(VIVADO_TCL) $(VIVADO_SRC_DIR)/vivado_elab.tcl

vivado.full:
	$(VIVADO_TCL) $(VIVADO_SRC_DIR)/vivado_full.tcl
