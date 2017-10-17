`define OPTIMISED

module bin2onehot #(parameter DW = 32) (
	input  [NB-1:0] bin , // unsigned binary input
	output [DW-1:0] onehot // one hot output vector
);

	parameter NB = $clog2(DW);

	`ifdef OPTIMISED
		integer i;
		reg [DW-1:0] ronehot;
		always @(*) begin
			for(i = 0; i < DW; i = i + 1)
				ronehot[i] = (bin[NB-1:0] == i); 
		end
		assign onehot = ronehot;
	`else 
		assign onehot = (1<< (bin+1));
	`endif
endmodule