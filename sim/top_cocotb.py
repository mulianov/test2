# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

import os
import random
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.types import LogicArray

@cocotb.test()
async def top_simple_test(dut):
    dut.button.value = 0
    dut.reset.value = 1

    clock = Clock(dut.clk, 5, units="ns")  # Create a 10us period clock on port clk
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False))

    for i in range(3):
        await RisingEdge(dut.clk)
    dut.reset.value = 0  # Assign the random value val to the input port d

    # Synchronize with the clock. This will regisiter the initial `d` value
    await RisingEdge(dut.clk)

    dut.button.value = 1
    await RisingEdge(dut.clk)
    dut.button.value = 0

    for i in range(10):
        await RisingEdge(dut.clk)
