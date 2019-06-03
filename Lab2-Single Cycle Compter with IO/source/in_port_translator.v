module in_port_translator (switches, result);
    input [3:0] switches;
    output [31:0] result;
    assign result = {28'b0,switches};
endmodule
