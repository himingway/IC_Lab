module rptr_empty #(parameter ADDRSIZE = 4) (
	output reg                rempty  ,
	output reg [ADDRSIZE-1:0] rptr    ,
	input                     aempty_n,
	input                     rinc, rclk, rrst_n
);

	reg [ADDRSIZE-1:0] rbin;
	reg rempty, rempty2;

	wire [ADDRSIZE-1:0] rgnext, rbnext;

	//-------------------
	// GRAYSTYLE2 pointer
	//-------------------
	always @(posedge clk or negedge rrst_n) begin 
		if (!rrst_n) begin 
			rbin <= 0;
			rptr <= 0;
		end
		else begin 
			rbin <= rbnext;
			rptr <= rgnext;
		end
	end

	//----------------------------------------
	// increment the binary count if not empty
	//----------------------------------------
	assign rbnext = !rempty? rbin + rinc : rbin;
	assign rgnext = (rbnext >> 1) ^ rbnext; // binary-to-gray conversion

	always @(posedge clk or negedge aempty_n) begin 
		if (!aempty_n)
			{rempty, rempty2} <= 2'b11;
		else
			{rempty, rempty2} <= {rempty2, ~rempty_n};
	end

endmodulea