module ContrastTransform #(
	parameter work_mode      = 0,
	parameter color_channels = 3,
	parameter color_width    = 8,
	parameter mul_delay      = 0
) (
	input                                    clk      , // Clock
	input                                    rst_n    , // Asynchronous reset active low
	input  [                           23:0] ct_scale ,
	input                                    in_enable,
	input  [color_channels*color_width-1:0] in_data  ,
	output                                   out_ready,
	output [color_channels*color_width-1:0] out_data
);

	reg [2:0] con_enable;

	genvar i;
	generate
		`define h (i + 1) * color_width - 1
		`define l i * color_width

		always @(posedge clk or negedge rst_n or negedge in_enable) begin
			if(~rst_n || ~in_enable)
				con_enable <= 0;
			else if(con_enable == mul_delay+1)
				con_enable <= con_enable;
			else
				con_enable <= con_enable +1;
		end
		assign out_ready = con_enable == mul_delay + 1 ? 1 : 0;

		for (i = 0; i < color_channels; i = i + 1) begin
			wire [11:0] mul_a;
			wire [23:0] mul_b;
			wire [23:0] mul_p;
			if(work_mode == 0) begin
				assign mul_a = in_data[`h : `l];
				assign mul_b = ct_scale;
			end else begin
				reg[11 : 0] reg_mul_a;
				reg[23 : 0] reg_mul_b;
				always @(posedge in_enable) begin
					reg_mul_a = in_data [`h : `l];
					reg_mul_b = ct_scale;
				end
				assign mul_a = reg_mul_a;
				assign mul_b = reg_mul_b;
			end

			assign mul_p = ((mul_a * mul_b) >> 12);

			reg [color_width-1:0] out_buffer;
			always @(posedge clk) begin
				out_buffer <= (mul_p[23:color_width] != 0) ?
					{color_width{1'b1}} : mul_p[color_width - 1:0];
			end
			assign out_data[`h : `l] = out_ready ? out_buffer : 0;
		end
		`undef h
		`undef l
	endgenerate

endmodule