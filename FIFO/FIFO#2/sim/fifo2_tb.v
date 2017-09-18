// Copyright (C) 2017  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions
// and other software and tools, and its AMPP partner logic
// functions, and any output files from any of the foregoing
// (including device programming or simulation files), and any
// associated documentation or information are expressly subject
// to the terms and conditions of the Intel Program License
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel MegaCore Function License Agreement, or other
// applicable license agreement, including, without limitation,
// that your use is for the sole purpose of programming logic
// devices manufactured by Intel and sold by Intel or its
// authorized distributors.  Please refer to the applicable
// agreement for further details.

// *****************************************************************************
// This file contains a Verilog test bench template that is freely editable to
// suit user's needs .Comments are provided in each section to help the user
// fill out necessary details.
// *****************************************************************************
// Generated on "09/18/2017 11:01:40"

// Verilog Test Bench template for design : fifo2
//
// Simulation tool : QuestaSim (Verilog)
//

`timescale 1 ps/ 1 ps
module fifo2_vlg_tst();
// constants
// general purpose registers
// test vector input registers
	reg       rclk  ;
	reg       rinc  ;
	reg       rrst_n;
	reg       wclk  ;
	reg [7:0] wdata ;
	reg       winc  ;
	reg       wrst_n;
// wires
	wire [7:0] rdata ;
	wire       rempty;
	wire       wfull ;

// assign statements (if any)
	fifo2 i1 (
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
	reg       normal_wr, normal_rd;
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

