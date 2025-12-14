# test_my_design.py (simple)

import cocotb
from cocotb.triggers import Timer, RisingEdge

import random

async def generate_clock(dut):
    """Generate clock pulses."""

    for _ in range(10**32):
        dut.clk.value = 0
        await Timer(1, unit="ns")
        dut.clk.value = 1
        await Timer(1, unit="ns")

async def send_spi(dut, data_to_send):
    dut.data_in_master_valid.value = 1
    dut.data_in_master.value = data_to_send

    for _ in range(10**32):
        await RisingEdge(dut.clk)
        if dut.data_in_master_ack.value == 1:
            break
    assert dut.data_in_master_ack.value == 1

    await RisingEdge(dut.clk)
    dut.data_in_master_valid.value = 0
    dut.data_in_master.value = 0

    for _ in range(10**31):
        await RisingEdge(dut.clk)
        if dut.data_out_slave_valid.value == 1:
            break
    assert dut.data_out_slave_valid.value == 1

    await RisingEdge(dut.clk)
    dut.data_out_master_ack.value = 1
    dut.data_out_slave_ack.value = 1
    await RisingEdge(dut.clk)
    dut.data_out_master_ack.value = 0
    dut.data_out_slave_ack.value = 0
    return dut.data_out_slave.value.to_unsigned()

@cocotb.test()
async def spi_test(dut):
    dut.rst_n.value = 0
    dut.data_in_master_valid.value = 0
    dut.data_out_slave_ack.value = 0
    cocotb.start_soon(generate_clock(dut))  # run the clock "in the background
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1

    for _ in range(10):
        data_to_send = random.randint(0,255)
        data_recieved = await send_spi(dut, data_to_send)

        assert data_to_send == data_recieved

