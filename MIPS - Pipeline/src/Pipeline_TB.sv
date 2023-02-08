`timescale 1ns/1ns

module Pipeline_Testbench ();

	reg clk = 1'b0;
	reg rst = 1'b1;

	mips_pipeline UUT (clk, rst);

	initial begin 
		#37 rst = 1'b0;
	end

	always #10 clk = ~clk;

endmodule