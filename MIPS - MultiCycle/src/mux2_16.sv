
module mux2_16 (input [15:0] a, b, input s, output [15:0] y);

    assign y = (s == 1'b0) ? a : b;
    
endmodule
