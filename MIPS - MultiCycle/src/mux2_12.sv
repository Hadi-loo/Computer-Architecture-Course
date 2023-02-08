
module mux2_12 (input [11:0] a, b, input s, output [11:0] y);

    assign y = (s == 1'b0) ? a : b;
    
endmodule