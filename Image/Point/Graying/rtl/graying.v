module graying #(
	parameter work_mode   = 0,
	parameter color_width = 8,
	parameter mul_delay   = 0
) (
	input                      clk      ,
	input                      rst_n    ,
	input                      in_enable,
	input  [3*color_width-1:0] in_data  ,
	output                     out_ready,
	output [  color_width-1:0] out_data
);

	reg [color_width - 1 : 0] r, g, b;
	reg [             10 : 0] mul_r       ;
	reg [             11 : 0] mul_g       ;
	reg [              8 : 0] mul_b       ;
	reg [             11 : 0] mul_g_buffer;
	reg [color_width - 1 : 0] sum_temp    ;
	reg [color_width - 1 : 0] reg_out_data;
	reg [              1 : 0] con_enable  ;

	generate
		if (work_mode == 0) begin
			always @(*) begin
				r = in_data [3 * color_width - 1 : 2 * color_width];
				g = in_data [2 * color_width - 1 : 1 * color_width];
				b = in_data [1 * color_width - 1 : 0 * color_width];
			end
		end else begin
			always @(posedge in_enable) begin
				r = in_data [3 * color_width - 1 : 2 * color_width];
				g = in_data [2 * color_width - 1 : 1 * color_width];
				b = in_data [1 * color_width - 1 : 0 * color_width];
			end
		end

		always @(*) begin
			mul_r = 313524 * {{(12 - color_width){1'b0}},r} >> 20;
			mul_g = 615514 * {{(12 - color_width){1'b0}},g} >> 20;
			mul_b = 119537 * {{(12 - color_width){1'b0}},b} >> 20;
		end

		always @(posedge clk) begin
			mul_g_buffer <= mul_g;
			sum_temp     <= mul_r + mul_b;
		end

		always @(posedge clk or negedge rst_n or negedge in_enable) begin
			if (~rst_n || ~in_enable) begin
				reg_out_data <= 0;
			end else begin
				reg_out_data <= sum_temp + mul_g_buffer;
			end
		end

		always @(posedge clk or negedge rst_n or negedge in_enable) begin
			if (~rst_n || ~in_enable)
				con_enable <= 0;
			else if (con_enable == mul_delay + 1)
				con_enable <= con_enable;
			else
				con_enable <= con_enable + 1'b1;
		end

		assign out_ready = (con_enable == mul_delay + 1) ? 1'd1 : 1'd0;
		assign out_data = out_ready ? reg_out_data : 'd0;
	endgenerate

endmodule