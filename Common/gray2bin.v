`define OPTIMISED

module gray2bin #(parameter DW = 32)(
	input [DW-1:0] gray,
	output [DW-1:0] bin
);

	`ifdef OPTIMISED
		reg [DW-1:0] rbin;
		int i,j;
		always @(*) begin
			begin 
				rbin = gray;
				for(i=0; i<DW-1; i=i+1) begin 
					rbin[i] = 1'b0;
					for(j=i; j<DW; j=j+1)
						rbin[i] = rbin[i] ^ gray[j];
				end
			end
		end
		assign bin = rbin;
	`else 
		// reg [DW-1:0] rbin;
		int i;
		always @(*) begin
			for(i=0; i < DW; i=i+1) begin 
				rbin[i] = ^ (gray >> 1);
			end
		end
		assign bin = rbin;
	`endif
endmodule