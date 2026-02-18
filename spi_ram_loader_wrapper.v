`default_nettype none
module spi_ram_loader_wrapper
  #(parameter AW = 0)
   (
    input wire		 i_clk,
    input wire		 i_sclk,
    input wire		 i_cs_n,
    input wire		 i_mosi,
    output wire [AW-1:0] o_sram_waddr,
    output wire [7:0]	 o_sram_wdata,
    output wire		 o_sram_wen);

   vlog_tb_utils vtu();

   spi_ram_loader #(.AW (AW)) spi_ram_loader
     (
      .i_clk  (i_clk ),
      .i_sclk (i_sclk),
      .i_cs_n (i_cs_n),
      .i_mosi (i_mosi),
      .o_sram_waddr (o_sram_waddr),
      .o_sram_wdata (o_sram_wdata),
      .o_sram_wen   (o_sram_wen  ));

endmodule
`default_nettype wire
