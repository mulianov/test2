add_file -type cst $env(GOWIN_SRC_DIR)/top.cst
add_file -type sdc $env(GOWIN_SRC_DIR)/top.sdc

add_file -type verilog $env(RTL_SRC_DIR)/top.sv

set tmpdir $::env(GOWIN_BUILD_DIR)

set_device GW2A-LV18PG256C8/I7 -device_version C
set_option -synthesis_tool gowinsynthesis
set_option -output_base_name top
set_option -top_module top
set_option -verilog_std sysv2017
set_option -gen_sdf 1
set_option -gen_posp 1
set_option -gen_verilog_sim_netlist 1
set_option -oreg_in_iob 0
set_option -bit_compress 1
set_option -gen_text_timing_rpt 1
set_option -print_all_synthesis_warning 1
set_option -rpt_auto_place_io_info 1
set_option -use_sspi_as_gpio 1

run all
