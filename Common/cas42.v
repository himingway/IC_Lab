module cas42 #(parameter DW = 1) (
	input  [DW-1:0] in0 , // input 0
	input  [DW-1:0] in1 , // input 1
	input  [DW-1:0] in2 , // input 2
	input  [DW-1:0] in3 , // input 3
	input  [DW-1:0] cin , // carry in
	output [DW-1:0] s   , // sum
	output [DW-1:0] c   , // carry
	output [DW-1:0] cout  // carry out
);

	wire [DW-1:0] s_int;

	assign s     = in0 ^ in1 ^ in2 ^ in3 ^ cin;
	assign s_int = in0 ^ in1 ^ in2;
	assign c     = (in3 & s_int) | (in3 & cin) | (s_int & cin);
	assign cout  = (in0 & in1) | (in0 & in2) | (in1 & in2);

endmodule