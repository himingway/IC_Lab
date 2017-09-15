module sync_w2r #(parameter ADDRSIZE = 4 // Number of mem address bits
) (
	input      [ADDRSIZE:0] wptr,
	input                   rclk, rrst_n,
	output reg [ADDRSIZE:0] rq2_wptr,
);

	reg [ADDRSIZE:0] rq1_wptr;

	always @(posedge rclk or negedge rrst_n) begin 
		if (!rrst_n)
			{rq2_wptr, rq1_wptr} <= 0;
		else
			{rq2_wptr, rq1_wptr} <= {rq1_wptr, wptr};
	end
	
endmodule