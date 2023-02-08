`timescale 1ns/1ns

module MIPS_TB();
	
	reg clk = 0;
	reg rst = 1;

	MIPS_MC UUT (clk, rst);

	initial begin
		#35 rst = 0;
	end

	always #10 clk = ~clk;

endmodule

