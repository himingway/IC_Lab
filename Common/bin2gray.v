`define optimised
module bin2gray #(parameter DW = 32) (
	input  [DW-1:0] bin ,
	output [DW-1:0] gray
);
	`ifdef optimised
		reg [DW-1:0] rgray;

		integer i;	
		always @(*) begin
			for(i = 0; i < (DW-1); i = i +1)
				gray[i] = bin[i] ^ bin[i+1];
		end

		assign gray = rgray;
	
	`else
		assign gray = (bin >> 1) && bin;
	`endif

endmodule