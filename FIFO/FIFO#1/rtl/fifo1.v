module fifo1 #(
	parameter DSIZE = 8,
	parameter ASIZE = 4
) (
	input  [DSIZE-1:0] wdata ,
	input              winc, wclk, wrst_n,
	input              rinc, rclk, rrst_n,
	output [DSIZE-1:0] rdata ,
	output             wfull ,
	output             rempty
);

	wire [ASIZE-1:0] waddr, raddr;
	wire [  ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

	sync_r2w #(ASIZE) sync_r2w (
		.rptr    (rptr    ),
		.wclk    (wclk    ),
		.wrst_n  (wrst_n  ),
		.wq2_rptr(wq2_rptr)
	);

	sync_w2r #(ASIZE) sync_w2r (
		.wptr    (wptr    ),
		.rq2_wptr(rq2_wptr),
		.rclk    (rclk    ),
		.rrst_n  (rrst_n  )
	);

	fifomem #(DSIZE,ASIZE) fifomem (
		.raddr (raddr),
		.wdata (wdata),
		.waddr (waddr),
		.wclken(winc ),
		.wfull (wfull),
		.wclk  (wclk ),
		.rdata (rdata)
	);

	rptr_empty #(ASIZE) rptr_empty (
		.rq2_wptr(rq2_wptr),
		.rinc    (rinc    ),
		.rclk    (rclk    ),
		.rrst_n  (rrst_n  ),
		.rempty  (rempty  ),
		.raddr   (raddr   ),
		.rptr    (rptr    )
	);

	wptr_full #(ASIZE) wptr_full (
		.winc    (winc    ),
		.wclk    (wclk    ),
		.wrst_n  (wrst_n  ),
		.wfull   (wfull   ),
		.waddr   (waddr   ),
		.wptr    (wptr    ),
		.wq2_rptr(wq2_rptr)
	);

endmodule