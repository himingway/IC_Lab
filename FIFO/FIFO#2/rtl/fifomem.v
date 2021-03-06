//`define VENDORRAM
module fifomem #(
	parameter DATASIZE = 8, // Memory data word width
	parameter ADDRSIZE = 4  // Number of mem address bits
) (
	input  [DATASIZE-1:0] wdata ,
	input  [ADDRSIZE-1:0] waddr, raddr,
	input                 wclken, wclk,
	output [DATASIZE-1:0] rdata
);

	`ifdef VENDORRAM
		vendor_rar mem (
			.dout(rdata),
			.din(wdata),
			.waddr(waddr),
			.raddr(raddr),
			.wclken(wclken),
			.clk(wclk)
		);
	`else 
	// RTL Verilog memory model
		localparam DEPTH = 1 << ADDRSIZE;

		reg [DATASIZE-1:0] mem[0:DEPTH-1];

		assign rdata = mem [raddr];

		always @(posedge wclk) begin
			if (wclken)
				mem[waddr] <= wdata;
		end
		
	`endif

endmodule