module ID_stage (
    mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst,
    wrn,wdi,ealu,malu,mmo,wwreg,clock,resetn,
    bpc,jpc,pcsource,wpcir,dwreg,dm2reg,dwmem,daluc,
    daluimm,da,db,dimm,drn,dshift,djal,dsa
);
    input [31:0] dpc4, inst, wdi, ealu, malu, mmo;
    input [4:0] mrn, ern, wrn;
    input mwreg, ewreg, em2reg, mm2reg, wwreg, clock, resetn;
    
    output [31:0] bpc, jpc, da, db, dimm, dsa;
    output [4:0] drn;
    output [3:0] daluc;
    output [1:0] pcsource;
    output wpcir, dwreg, dm2reg, dwmem, daluimm, dshift, djal;

    wire [5:0] op = inst[31:26];
    wire [4:0] rs = inst[25:21];
    wire [4:0] rt = inst[20:16];
    wire [4:0] rd = inst[15:11];
    wire [4:0] sa = inst[10:6];
    wire [5:0] func =inst[5:0];
    wire [15:0] imm = inst[15:0];

    wire sext, regrt;
    wire rsrtequ = (da == db ? 1 : 0);  // whether the values in rs and rt are equal
    wire [1:0] fwda, fwdb;
    wire [31:0] q1, q2, offset;

    // control unit
    CU cu(op, func, rs, rt, mrn, mm2reg, mwreg, ern, em2reg, ewreg, rsrtequ,   // input
            pcsource, wpcir, dwreg, dm2reg, dwmem, djal, daluc, daluimm, // output
            dshift, regrt, sext, fwdb, fwda);  // output
    // register files
    regfile rf(rs, rt, wdi, wrn, wwreg, clock, resetn, q1, q2);
    // two forwarding units
    mux4x32 forwarding_da(q1,ealu,malu,mmo,fwda,da);
    mux4x32 forwarding_db(q2,ealu,malu,mmo,fwdb,db);
    
    assign dsa = {27'b0, sa};   // shift amount
    assign dimm = {{16{sext & inst[15]}},imm};  // sign extended imm
    assign jpc = {dpc4[31:28],inst[25:0],2'b0};    // pc for jump
    assign drn = regrt?rt:rd;
    assign offset = {imm[13:0], inst[15:0], 2'b0};
    assign bpc = dpc4 + offset;     // pc for branch
endmodule
