module abs #(parameter DW = 2) (
	input  [DW-1:0] in      , // input operand (Signed two's complement)
	output [DW-1:0] out     , // out = abs(in)
	output          overflow  // high for max negative
);

	assign out[DW-1:0] = in[DW-1] ? ~in[DW-1] + 1'b1;

	assign overflow = in[DW-1] & ~(|in[DW-2:0]);

endmodule // abs