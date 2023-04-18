`default_nettype none
module spi_ram_loader
  #(parameter AW = 0)
   (
    input wire		 i_clk,
    input wire		 i_sclk,
    input wire		 i_cs_n,
    input wire		 i_mosi,
    output wire [AW-1:0] o_sram_waddr,
    output wire [7:0]	 o_sram_wdata,
    output wire		 o_sram_wen);

   reg			sclk_r;

   reg [AW+2:0]		bit_cnt;
   reg [6:0]		data;

   wire bit_en = i_sclk & !sclk_r;

   assign o_sram_waddr = bit_cnt[AW+2:3];
   assign o_sram_wdata = {data[6:0], i_mosi};
   assign o_sram_wen = bit_en & (&bit_cnt[2:0]);

   always @(posedge i_clk) begin
      sclk_r <= i_sclk;

      if (bit_en)
	data <= {data[5:0],i_mosi};

      if (bit_en)
	bit_cnt <= bit_cnt + 'd1;

      if (i_cs_n) begin
	 bit_cnt <= 'd0;
      end
   end

endmodule
`default_nettype wire
