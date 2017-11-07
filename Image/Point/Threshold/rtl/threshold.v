module threshold #(
	parameter work_mode   = 0,
	parameter color_width = 8
) (
	input                    clk      ,
	input                    rst_n    ,
	input                    th_mode  ,
	input  [color_width-1:0] th1      ,
	input  [color_width-1:0] th2      ,
	input                    in_enable,
	input  [color_width-1:0] in_data  ,
	output                   out_ready,
	output                   out_data
);

	reg reg_out_ready;
	reg reg_out_data ;

	generate
		always @(posedge clk or negedge rst_n or negedge in_enable) begin
			if(~rst_n || ~in_enable) begin
				reg_out_ready <= 0;
			end else begin
				reg_out_ready <= 1;
			end
		end

		if(work_mode == 0) begin
			always @(posedge clk) begin
				case (th_mode)
					0 : reg_out_data <= (in_data > th1) ? 1 : 0;
					1 : reg_out_data <= ((in_data > th1) && (in_data <= th2)) ? 1 : 0;
				endcase
			end
		end else begin
			always @(posedge in_enable) begin
				case (th_mode)
					0 : reg_out_data <= (in_data > th1) ? 1 : 0;
					1 : reg_out_data <= ((in_data > th1) && (in_data <= th2)) ? 1 : 0;
				endcase
			end
		end

		assign out_ready = reg_out_ready;
		assign out_data = out_ready == 0 ? 0 : reg_out_data;
	endgenerate

endmodule