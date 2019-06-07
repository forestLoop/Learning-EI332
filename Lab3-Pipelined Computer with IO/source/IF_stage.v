module IF_stage (
    input [1:0] pcsource,
    input [31:0] pc, bpc, da, jpc,
    input mem_clock,
    output [31:0] npc, pc4, ins
);
    wire [31:0] fetched_ins;
    lpm_rom_irom inst_rom(pc[7:2], mem_clock, fetched_ins);
    assign ins = pcsource[0]? 32'h0 : fetched_ins;
    assign pc4 = pc + 32'h4;
    mux4x32 next_pc(pc4, bpc, da, jpc, pcsource, npc);
endmodule
