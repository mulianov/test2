import os

from cocotb_test.simulator import run

tests_dir = os.path.abspath(os.path.dirname(__file__))
rtl_dir = os.path.abspath(os.path.join(tests_dir, '..', 'rtl'))

def test_top():
    dut = "top"
    module = os.path.splitext(os.path.basename(__file__))[0]
    toplevel = dut

    verilog_sources = [
        os.path.join(rtl_dir, f"{dut}.sv"),
    ]

    # parameters = {}
    # parameters['ADDR_WIDTH'] = 32
    # extra_env = {f'PARAM_{k}': str(v) for k, v in parameters.items()}

    run(
        python_search=[tests_dir],
        simulator="icarus",
        verilog_sources=verilog_sources, # sources
        toplevel=toplevel,            # top level HDL
        module=module,        # name of cocotb test module
        waves=True,
        # parameters=parameters,
        # extra_env=extra_env,
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
