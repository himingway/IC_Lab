module wptr_full #(parameter ADDRSIZE = 4)(
	output wfull,
	output reg [ADDRSIZE - 1 : 0] wptr,
	input afull_n,
	input winc, wclk, wrst_n
);

	reg [ADDRSIZE - 1 : 0] wbin;
	reg wfull, wfull2;

	wire [ADDRSIZE - 1 : 0] wgnext, wbnext;


	//-------------------
	// GRAYSTYLE2 pointer
	//-------------------

	always @(posedge wclk or negedge wrst_n) begin 
		if (!wrst_n) begin 
			wbin <= 0;
			wptr <= 0;
		end
		else begin 
			wbin <= wbnext;
			wptr <= wgnext;
		end
	end

	//---------------------------------------
	// increment the binary count if not full
	//---------------------------------------

	assign wbnext = !wfull ? wbin + winc : wbin;
	assign wgnext = (wbnext >>) ^ wbnext;

	always @(posedge wclk or negedge wrst_n or negedge afull_n)
		if (!wrst_n)
			{wfull, wfull2} <= 2'b00;
		else if (!afull_n)
			{wfull, wfull2} <= 2'b11;
		else
			{wfull, wfull2} <= {wfull2, ~afull_n};

endmodule