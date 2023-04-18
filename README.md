# SPI RAM loader example for Subservient

## Instructions

    # Install FuseSoC
    pip install --user fusesoc

    # Create and enter a workspace
    mkdir workspace && cd workspace

    # Add required FuseSoC libraries
    fusesoc library add fusesoc-cores https://github.com/fusesoc/fusesoc-cores
    fusesoc library add serv https://github.com/olofk/serv
    fusesoc library add subservient https://github.com/olofk/subservient
    fusesoc library add spi_ram_loader https://github.com/olofk/spi_ram_loader

    # Run SoC cocotb simulation
    MODULE=test_soc fusesoc run --target=socsim spi_ram_loader

