import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge, RisingEdge, Timer

CYCLE_TIME_NS = 10 #100MHz clock

async def init_dut(dut):
    cocotb.start_soon(Clock(dut.i_clk, CYCLE_TIME_NS, units="ns").start())

    dut._log.info("Initialize and reset model")

    # Initial values
    dut.i_sclk.value = 0
    dut.i_cs_n.value = 1
    dut.i_mosi.value = 0

async def spi_xfer(dut, data):
    for i in range(8):
        dut.i_mosi.value = (data >> (7-i)) & 0x1
        await Timer(25, units="ns")
        dut.i_sclk.value = 1
        await Timer(25, units="ns")
        dut.i_sclk.value = 0

async def transmit(dut, vec):
    dut.i_cs_n.value = 0
    for i in range(len(vec)):
        await spi_xfer(dut, vec[i])
        await Timer(36, units="ns")
    dut.i_cs_n.value = 1

async def uart_rx(dut):
    await(Timer(50, units="us"))
    while True:
        c = 0
        await FallingEdge(dut.o_gpio)
        await Timer(4410+8820, units="ns")
        for i in range(8):
            c |= dut.o_gpio.value.integer << i
            await Timer(8820, units="ns")
        print(chr(c), end='')

@cocotb.test()
async def basic(dut):
    await init_dut(dut)

    await Timer(2, units="us")

    f = open("hello.bin", "rb")
    vec = f.read()
    f.close()
    cocotb.start_soon(uart_rx(dut))
    await transmit(dut, vec)
    await Timer(10000, units="us")

