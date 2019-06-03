module in_port_translator (switches, result);
    input [4:0] switches;
    output [31:0] result;
    assign result = {27'b0,switches};
endmodule
