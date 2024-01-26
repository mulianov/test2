# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

import os
import random
from pathlib import Path

import cocotb
from cocotb.clock import Clock
# from cocotb.runner import get_runner
from cocotb.triggers import RisingEdge
from cocotb.types import LogicArray

from vcd.gtkw import GTKWSave

@cocotb.test()
async def top_simple_test(dut):
    # Assert initial output is unknown
    # assert LogicArray(dut.q.value) == LogicArray("X")
    # Set initial input value to prevent it from floating
    dut.i_data.value = 0
    dut.rst.value = 1

    clock = Clock(dut.clk, 5, units="ns")  # Create a 10us period clock on port clk
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    for i in range(3):
        await RisingEdge(dut.clk)
    dut.rst.value = 0  # Assign the random value val to the input port d

    # Synchronize with the clock. This will regisiter the initial `d` value
    await RisingEdge(dut.clk)

    # expected_val = 0  # Matches initial input value
    for i in range(10):
        # val = random.randint(0, 1)
        # dut.i_data.value = val  # Assign the random value val to the input port d
        dut.i_data.value = i  # Assign the random value val to the input port d
        await RisingEdge(dut.clk)
        # assert dut.q.value == expected_val, f"output q was incorrect on the {i}th cycle"
        # expected_val = val  # Save random value for next RisingEdge

    # Check the final input on the next clock
    await RisingEdge(dut.clk)
    # assert dut.q.value == expected_val, "output q was incorrect on the last cycle"


# def test_simple_top_runner():
#     sim = os.getenv("SIM", "icarus")
#
#     proj_path = Path(__file__).resolve().parent
#
#     verilog_sources = [proj_path / "top.sv"]
#
#     runner = get_runner(sim)
#     runner.build(
#         verilog_sources=verilog_sources,
#         vhdl_sources=[],
#         hdl_toplevel="top",
#         always=True,
#         waves=True
#     )
#
#     runner.test(
#         hdl_toplevel="top",
#         test_module="test_top,",
#         waves=True
#     )
#
#     '''
#     f = open("sim_build/myproject.gtkw", "w", encoding="utf-8")
#     gtkw = GTKWSave(f)
#     # gtkw = GTKWSave(io.StringIO())
#     # with gtkw.group('mygroup'):
#     gtkw.trace("top.clk")
#     gtkw.trace("top.i_data")
#     gtkw.trace("top.o_data")
#     gtkw.trace("top.valid")
#     '''
#
# if __name__ == "__main__":
#     test_simple_top_runner()
