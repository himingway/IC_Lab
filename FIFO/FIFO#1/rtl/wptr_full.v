module wptr_full #(parameter ADDRSIZE = 4 // Number of mem address bits
) (
	input      [  ADDRSIZE:0] wq2_rptr,
	input                     winc, wclk, wrst_n,
	output reg                wfull   ,
	output     [ADDRSIZE-1:0] waddr   ,
	output reg [  ADDRSIZE:0] wptr
);

	reg [ADDRSIZE:0] wbin;

	wire [ADDRSIZE:0] wgraynext, wbinnext;
	wire              wfull_var;

	// GRAYSTYLE2 pointer
	always @(posedge wclk or negedge wrst_n) begin
		if (!wrst_n)
			{wbin, wptr} <= 0;
		else
			{wbin, wptr} <= {wbinnext, wgraynext};
	end

	//Memory write-address pointer
	assign waddr = wbin[ADDRSIZE-1:0];

	assign wbinnext  = wbin + (winc & ~wfull);
	assign wgraynext = (wbinnext >> 1) ^ wbinnext;

	assign wfull_var = (wgraynext == {~wq2_rptr[ADDRSIZE:ADDRSIZE-1], wq2_rptr[ADDRSIZE-2:0]});

	always @(posedge wclk or negedge wrst_n) begin
		if (!wrst_n)
			wfull <= 1'b0;
		else
			wfull <= wfull_var;
	end
endmodule