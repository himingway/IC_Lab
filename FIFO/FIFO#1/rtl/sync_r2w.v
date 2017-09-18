module sync_r2w #(parameter ADDRSIZE = 4 // Number of mem address bits
) (
	input      [ADDRSIZE:0] rptr    ,
	input                   wclk, wrst_n,
	output reg [ADDRSIZE:0] wq2_rptr
);

	reg [ADDRSIZE:0] wq1_rptr;
	
	always @(posedge wclk or negedge wrst_n) begin 
		if (!wrst_n)
			{wq2_rptr, wq1_rptr} <= 0;
		else
			{wq2_rptr, wq1_rptr} <= {wq1_rptr, rptr};
	end

endmodule