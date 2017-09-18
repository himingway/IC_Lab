module async_cmp #(
	parameter ADDRSIZE = 4,
	parameter N = ADDRSIZE-1
) (
	output aempty_n, afull_n,
	input [N:0] wptr, rptr,
	input wrst_n
);

	reg direction;

	wire dirset_n = ~((wptr[N] ^ rptr[N-1]) & ~(wptr[N-1] ^ rptr[N]));
	wire dirclr_n = ~((~(wptr[N] ^ rptr[N-1]) & (wptr[N-1] ^ rptr [N])) | ~wrst_n);

	wire high = 1'b1;

	always @(posedge high or negedge dirset_n or negedge dirclr_n) begin 
		if (!dirclr_n) 
			direction <= 1'b0;
		else if (!dirset_n)
			direction <= 1'b1;
		else
			direction <= high; //RS flip_flor
	end

	assign aempty_n = ~((wptr == rptr) && !direction);
	assign afull_n  = ~((wptr == rptr) && direction);

endmodule