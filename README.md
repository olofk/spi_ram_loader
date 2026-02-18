# SPI RAM loader example for Subservient

## Instructions

    # Install FuseSoC (needs at least version 2.4)
    pip install fusesoc

    # Create and enter a workspace
    mkdir workspace && cd workspace

    # Add required FuseSoC libraries
    fusesoc library add --sync-type url https://cores.fusesoc.net/fusesoc_pd
    fusesoc library add https://github.com/olofk/spi_ram_loader

    # Run stand-alone cocotb simulation
    fusesoc run --target=sim spi_ram_loader

    # Run SoC cocotb simulation
    fusesoc run --target=socsim spi_ram_loader

## Example

subservient_with_spi_ram_loader_and_ram contains a basic example on how to use spi_ram_loader together with a SoC to preload an application into a memory before running it. When cs_n is pulled low, the system enters debug mode where the SoC is held in reset. Each byte written over SPI will be written sequentially to the SRAM. When cs_n is released, the system will leave reset and start executing the code from memory.

![example](subservient_with_spi_ram_loader.png)
