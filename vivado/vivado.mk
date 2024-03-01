VIVADO = vivado -nojournal -nolog
VIVADO_TCL = $(VIVADO) -mode tcl -source

vivado.elab:
	$(VIVADO_TCL) ./vivado_elab.tcl

vivado.full:
	$(VIVADO_TCL) ./vivado_full.tcl
