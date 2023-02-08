
module mux2_3 (input [2:0] a, b, input s, output [2:0] y);

    assign y = (s == 1'b0) ? a : b;
    
endmodule
