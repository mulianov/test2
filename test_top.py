from cocotb_test.simulator import run

def test_top():
    run(
        simulator="icarus",
        verilog_sources=["top.sv"], # sources
        toplevel="top",            # top level HDL
        module="top_cocotb",        # name of cocotb test module
        waves=True,
        # gui=True,
        # python_search
        # includes
        # defines
        # compile_args
        # sim_args = ["-fst"]
        # plus_args
        # seed
        # extra_env
    )
