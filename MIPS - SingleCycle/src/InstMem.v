`timescale 1ns/1ns

module inst_mem (input [31:0] adr, output [31:0] inst);
    
	reg [7:0] mem [0:4095];

    	initial begin
        	$readmemb("inst8b.mem", mem);
    	end
    
    	assign inst = { mem[adr[11:0]], mem[adr[11:0]+1], mem[adr[11:0]+2], mem[adr[11:0]+3] };
    
endmodule

