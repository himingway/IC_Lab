`timescale 1 ns/ 1 ps
module fifo1_vlg_tst();
// constants
// general purpose registers
	reg       rclk     ;
	reg       rinc     ;
	reg       rrst_n   ;
	reg       wclk     ;
	reg [7:0] wdata    ;
	reg       winc     ;
	reg       wrst_n   ;
	reg       normal_wr;
	reg       normal_rd;
// wires
	wire [7:0] rdata ;
	wire       rempty;
	wire       wfull ;

// assign statements (if any)
	fifo1 i1 (
		// port map - connection between master ports and signals/registers
		.rclk  (rclk  ),
		.rdata (rdata ),
		.rempty(rempty),
		.rinc  (rinc  ),
		.rrst_n(rrst_n),
		.wclk  (wclk  ),
		.wdata (wdata ),
		.wfull (wfull ),
		.winc  (winc  ),
		.wrst_n(wrst_n)
	);

	parameter C_DATA_WIDTH = 8;

//******************************************************************
//  变量初始化
//******************************************************************
	initial
		begin
			wrst_n  = 1'b0;
			rrst_n  = 1'b0;
			normal_wr = 1'b0;
			normal_rd = 1'b0;
			#492;
			wrst_n  = 1'b1;
			rrst_n  = 1'b1;
			#100;
//只写FIFO
			normal_wr = 1'b1;
			repeat(20) @(posedge wclk);
			normal_wr = 1'b0;
//只读FIFO
			normal_rd = 1'b1;
			repeat(20) @(posedge rclk);
			normal_rd = 1'b0;
//同时读写FIFO
			normal_wr = 1'b1;
			normal_rd = 1'b1;
			repeat(100) @(posedge wclk);
			normal_wr = 1'b0;
			normal_rd = 1'b0;
			repeat(20) @(posedge rclk);
			$stop;
		end

	initial
		begin
			wclk = 0;
			forever #(100/2)
				wclk = ~wclk;
		end

	initial
		begin
			rclk = 0;
			forever #(70/2)
				rclk = ~rclk;
		end

//******************************************************************
//  写FIFO信号的产生
//******************************************************************
	always @(posedge wclk or negedge wrst_n)
		begin
			if(wrst_n == 1'b0)
				begin
					winc  <= 1'b0;
					wdata <= {(C_DATA_WIDTH){1'b0}};
				end
			else if(normal_wr == 1'b1)
				begin
					if(wfull == 1'b0)
						begin
							winc  <= 1'b1;
							wdata <= {$random%((1 << C_DATA_WIDTH)-1)};
						end
					else
						begin
							winc  <= 1'b0;
							wdata <= {(C_DATA_WIDTH){1'b0}};
						end
				end
			else
				begin
					winc  <= 1'b0;
					wdata <= {(C_DATA_WIDTH){1'b0}};
				end
		end

//******************************************************************
//  读FIFO信号的产生
//******************************************************************
	always @(posedge wclk or negedge wrst_n)
		begin
			if(wrst_n == 1'b0)
				rinc <= 1'b0;
			else if(normal_rd == 1'b1)
				begin
					if(rempty == 1'b0)
						rinc <= 1'b1;
					else
						rinc <= 1'b0;
				end
			else
				rinc <= 1'b0;
		end

endmodule

