`timescale 1ns/1ns

module mux2_32 (input [31:0] a, b, input s, output [31:0] y);

    assign y = (s == 1'b0) ? a : b;
    
endmodule