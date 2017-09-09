module clk_div_3 (
	input clk,
	input rst_n,
	output clk_div_3
);

	reg [1:0] cnt;

	reg tff1_en;
	reg tff2_en;

	always @(posedge clk or negedge rst_n) begin 
		if (!rst_n) begin 
			cnt <= 2'd0;
		end
		else if (cnt == 2'd2) begin
			cnt <= 2'd0;
		end
		else
			cnt <= cnt + 1'b1;
	end

	always @(cnt) begin 
		if (cnt == 2'd0)
			tff1_en = 1'b1;
		else
			tff1_en = 1'b0;
	end
	
	always @(cnt) begin 
		if (cnt == 2'd2)
			tff2_en = 1'b1;
		else
			tff2_en = 1'b0;
	end


	reg tff1;
	reg tff2;

	always @(posedge clk or negedge rst_n) begin 
		if (!rst_n)
			tff1 <= 1'b0;
		else if (tff1_en)
			tff1 <= ~tff1;
		else
			tff1 <= tff1;
	end

	always @(negedge clk or negedge rst_n) begin 
		if (!rst_n)
			tff2 <= 1'b0;
		else if (tff2_en)
			tff2 <= ~tff2;
		else
			tff2 <= tff2;
	end

	assign clk_div_3 = tff1 ^ tff2;
	
endmodule // clk_div_3