module bit_reverse #(parameter DW = 32)(
	input [DW-1:0] in, // data input
	output [DW-1:0] out // data output
);

	reg [DW-1:0] out;
	integer i;

	always @(*) begin
		for(i = 0; i < DW; i = i + 1)
			out[i] = in[DW-1-i];
	end
endmodule