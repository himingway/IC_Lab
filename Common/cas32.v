module cas32 #(parameter DW = 1) (
	input  [DW-1:0] in0, // input 1
	input  [DW-1:0] in1, // input 2
	input  [DW-1:0] in2, // input 3
	output [DW-1:0] s  , // sum
	output [DW-1:0] c    // carry
);

	assign s = in0 ^ in1 ^ in2;
	assign c = (in0 & in1) | (in1 & in2) | (in2 & in0);

endmodule