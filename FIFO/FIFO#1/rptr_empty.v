module rptr_empty #(parameter ADDRSIZE = 4 // Number of mem address bits
) (
	input      [  ADDRSIZE:0] rq2_wptr,
	input                     rinc, rclk, rrst_n,
	output reg                rempty  ,
	output     [ADDRSIZE-1:0] raddr   ,
	output reg [  ADDRSIZE:0] rptr
);

	reg [ADDRSIZE:0] rbin;
	wire [ADDRSIZE:0] rgraynext, rbinnext;

	//-------------------
	// GRAYSTYLE2 pointer
	//-------------------
	always @(posedge rclk or negedge rrst_n) begin 
		if (!rrst_n)
			{rbin, rptr} <= 0;
		else
			{rbin, rptr} <= {rbinnext, rgraynext};
	end
		assign raddr = rbin[ADDRSIZE-1:0];
		assign rbinnext = rbin + (rinc & ~ rempty)
		assign rgraynext = (rbinnext >> 1) ^ rbinnext;

		assign rempty_var = (rgraynext = rq2_wptr);

		always @(posedge rclk or negedge rrst_n) begin 
			if (!rrst_n)
				rempty <= 1'b1;
			else
				rempty <= rempty <= rempty_var;
		end

endmodule