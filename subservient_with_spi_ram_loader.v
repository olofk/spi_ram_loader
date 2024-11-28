`default_nettype none
module subservient_with_spi_ram_loader
  #(parameter aw = 9)
  (
   input wire		i_clk,

   //SRAM interface
   output wire [aw-1:0]	o_sram_waddr,
   output wire [7:0]	o_sram_wdata,
   output wire		o_sram_wen,
   output wire [aw-1:0]	o_sram_raddr,
   input wire [7:0]	i_sram_rdata,
   output wire		o_sram_ren,

   //Debug interface
   input wire		i_sclk,
   input wire		i_cs_n,
   input wire		i_mosi,

   //External I/O
   output wire		o_gpio);

   wire [aw-1:0]	core_sram_waddr;
   wire [7:0]		core_sram_wdata;
   wire			core_sram_wen;
   wire [aw-1:0]	dbg_sram_waddr;
   wire [7:0]		dbg_sram_wdata;
   wire			dbg_sram_wen;

   assign o_sram_waddr = i_cs_n ? core_sram_waddr : dbg_sram_waddr;
   assign o_sram_wdata = i_cs_n ? core_sram_wdata : dbg_sram_wdata;
   assign o_sram_wen   = i_cs_n ? core_sram_wen   : dbg_sram_wen;
   
   subservient
     #(.memsize  (2**aw),
       .WITH_CSR (0))
   dut
     (// Clock & reset
      .i_clk (i_clk),
      .i_rst (!i_cs_n),

      //SRAM interface
      .o_sram_waddr (core_sram_waddr),
      .o_sram_wdata (core_sram_wdata),
      .o_sram_wen   (core_sram_wen),
      .o_sram_raddr (o_sram_raddr),
      .i_sram_rdata (i_sram_rdata),
      .o_sram_ren   (o_sram_ren),

      // External I/O
      .o_gpio (o_gpio));

   spi_ram_loader #(.AW (aw)) spi_ram_loader
     (
      .i_clk  (i_clk ),
      .i_sclk (i_sclk),
      .i_cs_n (i_cs_n),
      .i_mosi (i_mosi),
      .o_sram_waddr (dbg_sram_waddr),
      .o_sram_wdata (dbg_sram_wdata),
      .o_sram_wen   (dbg_sram_wen  ));
      
endmodule
`default_nettype wire
