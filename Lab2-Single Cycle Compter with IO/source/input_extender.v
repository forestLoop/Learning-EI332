module input_extender (in,out);
    input [1:0] in;
    output [31:0] out;
    assign out = {30'b0,in};
endmodule
