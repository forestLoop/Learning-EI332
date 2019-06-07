module EXE_stage (
    input [31:0] ea, eb, eimm, epc4, esa,
    input [4:0] ern0,
    input [3:0] ealuc,
    input ealuimm, eshift, ejal,
    output [31:0] ealu,
    output [4:0] ern
);
    wire [31:0] alua, alub, alu_result, epc8;
    wire zero;  // useless but to fit ALU's definition
    assign epc8 = epc4 + 32'h4;
    mux2x32 alu_a (ea,esa,eshift,alua);     // determine whether to use shift amount
    mux2x32 alu_b (eb,eimm,ealuimm,alub);  // determine whether to use immediate number
    ALU alu(alua, alub, ealuc, alu_result, zero);
    mux2x32 is_jal(alu_result, epc8, ejal, ealu);
    assign ern = ejal ? 5'b11111 : ern0;    // if jal, then write $ra, namely $31.

endmodule
