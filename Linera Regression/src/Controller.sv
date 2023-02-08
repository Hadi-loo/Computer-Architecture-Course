`timescale 1ns/1ns
module controller(clk,rst,Co,cnt,clr_counter,
			clr_psumx,clr_psumy,clr_meanx,clr_meany,clr_sumxx,clr_sumxy,clr_B0,clr_B1,
			ld_psumx,ld_psumy,ld_sumxy,ld_sumxx,ld_meanx,ld_meany,ld_B0,ld_B1);

	parameter [2:0] start=0, init=1, calc1=2, calc2=3, calc3=4, error=5, finish=6;

	input clk,rst,Co;

	output reg clr_psumx,clr_psumy,clr_meanx,clr_meany,clr_sumxx,clr_sumxy,clr_B0,clr_B1;
	output reg ld_psumx,ld_psumy,ld_sumxy,ld_sumxx,ld_meanx,ld_meany,ld_B0,ld_B1;
	output reg clr_counter,cnt;

	reg [2:0] ps = 0,ns = 1;
	
	always @(ps,Co) begin
		ns = start;
		clr_counter = 0; cnt = 0;
		clr_psumx = 0; clr_psumy = 0;
		clr_meanx = 0; clr_meany = 0;
		clr_sumxx = 0; clr_sumxy = 0;
		clr_B0 = 0; clr_B1 = 0;
		ld_psumx=0; ld_psumy=0;
		ld_sumxy=0; ld_sumxx=0;
		ld_meanx=0; ld_meany=0;
		ld_B0=0; ld_B1=0;
		case (ps)
			start: begin ns = init; end
			init: begin ns = calc1; clr_counter=1; clr_psumx=1; clr_psumy=1; clr_meanx=1; clr_meany=1; clr_sumxx=1; clr_sumxy=1; clr_B0=1; clr_B1=1; end
			calc1: begin ns = Co ? calc2:calc1; cnt=1; ld_psumx=1; ld_psumy=1; ld_sumxy=1; ld_sumxx=1; end
			calc2: begin ns = calc3; ld_meanx=1; ld_meany=1; end
			calc3: begin ns = error; ld_B0=1; ld_B1=1; clr_counter=1; end
			error: begin ns = Co ? finish:error; cnt=1; end
			finish: begin ns = finish; end			
		endcase
	end

	always @(posedge clk, posedge rst) begin
		if (rst) ps <= start;
		else ps <= ns;
	end
	
endmodule 	
