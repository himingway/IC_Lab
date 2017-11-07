`timescale 1ps/1ps
module CLOCK (
	output bit clk
	);
	
	always #(100ps) begin
		clk = ~clk;
	end

endmodule

interface TBInterface (input bit clk, input bit rst_n);
	parameter[3: 0] color_width = 8;
	bit th_mode;
	bit[color_width - 1 : 0] th1, th2;
	bit in_enable;
	bit[color_width - 1 : 0] in_data;
	bit out_ready;
	bit out_data;
endinterface

module Threshold_TB();

	integer fi,fo;
	string fname[$];
	string ftmp, imsize;
	int fsize;
	bit now_start;
	int fst;
	bit[7 : 0] imconf;

	bit clk, rst_n;
	TBInterface #(8) GrayPipeline(clk, rst_n);
	TBInterface #(8) GrayReqAck(clk, rst_n);
	CLOCK CLOCK1 (clk);
	threshold #(0, 8) 
		GYPipeline(GrayPipeline.clk, GrayPipeline.rst_n, GrayPipeline.th_mode, GrayPipeline.th1, GrayPipeline.th2, 
			GrayPipeline.in_enable, GrayPipeline.in_data, GrayPipeline.out_ready, GrayPipeline.out_data);
	threshold #(1, 8) 
		GYReqAck(GrayReqAck.clk, GrayReqAck.rst_n, GrayReqAck.th_mode, GrayReqAck.th1, GrayReqAck.th2, 
			GrayReqAck.in_enable, GrayReqAck.in_data, GrayReqAck.out_ready, GrayReqAck.out_data);

	task init_file();
		//Keep conf
		fst = $fscanf(fi, "%s", imsize);
		$fwrite(fo, "%s\n", imsize);
		fst = $fscanf(fi, "%s", imsize);
		$fwrite(fo, "%s\n", imsize);
		fst = $fscanf(fi, "%b", imconf);
		GrayPipeline.th_mode = imconf;
		GrayReqAck.th_mode = imconf;
		fst = $fscanf(fi, "%b", imconf);
		GrayPipeline.th1 = imconf;
		GrayReqAck.th1 = imconf;
		fst = $fscanf(fi, "%b", imconf);
		GrayPipeline.th2 = imconf;
		GrayReqAck.th2 = imconf;
	endtask : init_file

	task init_signal();
		rst_n = 0;
		now_start = 0;
		GrayPipeline.in_enable = 0;
		GrayReqAck.in_enable = 0;
		repeat(10) @(posedge clk);
		rst_n = 1;
	endtask : init_signal

	task work_pipeline();
		@(posedge clk);
		GrayPipeline.in_enable = 1;
		fst = $fscanf(fi, "%b", GrayPipeline.in_data);
		if(GrayPipeline.out_ready) begin
			if(~now_start)
				$display("%m: at time %0t ps , %s-pipeline working start !", $time, ftmp);
			now_start = 1;
			$fwrite(fo, "%0d\n", GrayPipeline.out_data);
		end
	endtask : work_pipeline

	task work_regack();
		@(posedge clk);
		GrayReqAck.in_enable = 1;
		fst = $fscanf(fi, "%b", GrayReqAck.in_data);
		while (~GrayReqAck.out_ready)
			@(posedge clk);
		if(~now_start)
			$display("%m: at time %0t ps , %s-reqack working start !", $time, ftmp);
		now_start = 1;
		$fwrite(fo, "%0d\n", GrayReqAck.out_data);
		GrayReqAck.in_enable = 0;
	endtask : work_regack

	initial begin
		fi = $fopen("imgindex.dat","r");
		while (!$feof(fi)) begin
			fst = $fscanf(fi, "%s", ftmp);
			fname.push_front(ftmp);
		end
		$fclose(fi);
		fsize = fname.size();
		repeat(1000) @(posedge clk);
		for (int i = 0; i < fsize; i++) begin;
			ftmp = fname.pop_back();
			$display("%s",ftmp);
			fi = $fopen({ftmp, ".dat"}, "r");
			fo = $fopen({ftmp, "-pipeline.res"}, "w");
			init_file();
			init_signal();
			while (!$feof(fi)) begin 
				work_pipeline();
			end
			$fclose(fi);
			$fclose(fo);
			fi = $fopen({ftmp, ".dat"}, "r");
			fo = $fopen({ftmp, "-reqack.res"}, "w");
			init_file();
			init_signal();
			while (!$feof(fi)) begin 
				work_regack();
			end
			$fclose(fi);
			$fclose(fo);
		end
		$finish;
	end

endmodule