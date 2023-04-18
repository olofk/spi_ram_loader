import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

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

async def receive(dut, length):
    print("Address  : data")
    print("===============")
    for _ in range(length):
        await RisingEdge(dut.o_sram_wen)
        #a = int(dut.o_sram_waddr.value)
        print(f"{dut.o_sram_waddr.value.integer:08x} : {dut.o_sram_wdata.value.integer:c}")

@cocotb.test()
async def basic(dut):
    await init_dut(dut)

    await Timer(2, units="us")
    s = "Some input data"
    vec = [ord(x) for x in s]
    cocotb.start_soon(transmit(dut, vec))
    await receive(dut, len(vec))
    await Timer(20, units="us")

    s = "Other input data"
    vec = [ord(x) for x in s]
    cocotb.start_soon(transmit(dut, vec))
    await receive(dut, len(vec))
    await Timer(20, units="us")
