module subservient_with_spi_ram_loader_and_ram
  #(parameter AW = 0,
    parameter memsize = 2**AW)
  (
   input wire		i_clk,

   //Debug interface
   input wire		i_sclk,
   input wire		i_cs_n,
   input wire		i_mosi,

   //External I/O
   output wire		o_gpio);

   wire [AW-1:0]	sram_waddr;
   wire [7:0]		sram_wdata;
   wire			sram_wen;
   wire [AW-1:0]	sram_raddr;
   wire [7:0]		sram_rdata;
   wire			sram_ren;

   reg			rst = 1'b1;
   initial #10 rst = 1'b0;
   
   subservient_generic_ram
     #(.depth (memsize))
   memory
     (.i_clk   (i_clk),
      .i_rst   (rst),
      .i_waddr (sram_waddr),
      .i_wdata (sram_wdata),
      .i_wen   (sram_wen),
      .i_raddr (sram_raddr),
      .o_rdata (sram_rdata),
      .i_ren   (sram_ren));

   subservient_with_spi_ram_loader
     #(.aw  (AW))
   dut
     (// Clock & reset
      .i_clk (i_clk),

      //SRAM interface
      .o_sram_waddr (sram_waddr),
      .o_sram_wdata (sram_wdata),
      .o_sram_wen   (sram_wen),
      .o_sram_raddr (sram_raddr),
      .i_sram_rdata (sram_rdata),
      .o_sram_ren   (sram_ren),

      //Debug interface
      .i_sclk (i_sclk),
      .i_cs_n (i_cs_n),
      .i_mosi (i_mosi),

      // External I/O
      .o_gpio (o_gpio));

endmodule
