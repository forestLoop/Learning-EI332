module CU(op, func, rs, rt, mrn, mm2reg, mwreg, ern, em2reg, ewreg, rsrtequ,   // input
            pcsource, wpcir, dwreg, dm2reg, dwmem, djal, daluc, daluimm, // output
            dshift, regrt, sext, fwdb, fwda);  // output
    input [5:0] op, func;
    input [4:0] rs, rt, mrn, ern;
    input mm2reg, mwreg, em2reg, ewreg, rsrtequ;

    output [3:0] daluc;
    output [1:0] pcsource, fwda, fwdb;
    output wpcir, dwreg, dm2reg, dwmem, djal, daluimm, dshift, regrt, sext; 

    wire [3:0] daluc_temp;
    wire dwmem_temp, dwreg_temp, dm2reg_temp, dshift_temp, daluimm_temp, djal_temp;
    CU_part cu_part(op, func, rsrtequ, dwmem_temp, dwreg_temp, regrt, dm2reg_temp,
        daluc_temp, dshift_temp, daluimm_temp, pcsource, djal_temp, sext );

    // if wpcir == 0, then all these xxx_temp will be discarded
    // if wpcir == 1, then all these xxx_temp will be adopted
    assign  wpcir = ~(em2reg & ((ern == rs)|(ern == rt)) & ~dwmem_temp);
    assign  dwreg = wpcir?dwreg_temp:1'b0;
    assign  dm2reg = wpcir?dm2reg_temp:1'b0;
    assign  dwmem = wpcir?dwmem_temp:1'b0;
    assign  daluimm = wpcir?daluimm_temp:1'b0;
    assign  dshift = wpcir?dshift_temp:1'b0;
    assign  djal = wpcir?djal_temp:1'b0;
    assign  daluc = wpcir?daluc_temp:4'b0;
    // forwarding signals
    assign fwda[0] = (ewreg & ~em2reg & ern == rs & ern != 0) | (mm2reg & mrn == rs & mrn != 0);
    assign fwda[1] = (mwreg & ~mm2reg & mrn == rs & ern != rs & mrn != 0) | (mm2reg & mrn == rs & mrn != 0); 
    assign fwdb[0] = (ewreg & ~em2reg & ern == rt & ern != 0) | ( mm2reg & mrn == rt & mrn != 0);
    assign fwdb[1] = (mwreg & ~mm2reg & mrn == rt & ern != rt & mrn != 0) | (mm2reg & mrn == rt & mrn != 0); 

endmodule



// this CU_part is copied from single cycle cpmputer
module CU_part (op, func, z, wmem, wreg, regrt, m2reg, aluc, shift,
              aluimm, pcsource, jal, sext);
    input  [5:0] op,func;
    input        z;
    output       wreg,regrt,jal,m2reg,shift,aluimm,sext,wmem;
    output [3:0] aluc;
    output [1:0] pcsource;
    wire r_type = ~|op;
    wire i_add = r_type & func[5] & ~func[4] & ~func[3] &
            ~func[2] & ~func[1] & ~func[0];          //100000
    wire i_sub = r_type & func[5] & ~func[4] & ~func[3] &
            ~func[2] &  func[1] & ~func[0];          //100010

    wire i_and =  r_type & func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & ~func[0];  // 100100
    wire i_or  =  r_type & func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & func[0]; // 100101

    wire i_xor = r_type & func[5] & ~func[4] & ~func[3] & func[2] & func[1] & ~func[0]; // 100110
    wire i_sll = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0]; // 000000
    wire i_srl = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & ~func[0]; // 000010
    wire i_sra = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & func[0]; // 000011
    wire i_jr  = r_type & ~func[5] & ~func[4] & func[3] & ~func[2] & ~func[1] & ~func[0]; // 001000
        
    wire i_addi = ~op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0]; //001000
    wire i_andi = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] & ~op[0]; //001100

    wire i_ori  = ~op[5] & ~op[4] &  op[3] & op[2] & ~op[1] & op[0]; //001101
    wire i_xori = ~op[5] & ~op[4] & op[3] & op[2] & op[1] & ~op[0];  // 001110
    wire i_lw   = op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];  // 100011
    wire i_sw   = op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0]; //101011
    wire i_beq  = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & ~op[0];  // 000100
    wire i_bne  = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & op[0]; // 000101
    wire i_lui  = ~op[5] & ~op[4] & op[3] & op[2] & op[1] & op[0]; // 001111
    wire i_j    = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & ~op[0];  // 000010
    wire i_jal  = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0]; // 000011


    assign pcsource[1] = i_jr | i_j | i_jal;
    assign pcsource[0] = ( i_beq & z ) | (i_bne & ~z) | i_j | i_jal ;

    assign wreg = i_add | i_sub | i_and | i_or   | i_xor  |
             i_sll | i_srl | i_sra | i_addi | i_andi |
             i_ori | i_xori | i_lw | i_lui  | i_jal;

    assign aluc[3] = i_sra;
    assign aluc[2] = i_sub | i_or | i_srl | i_sra | i_ori | i_beq | i_bne | i_lui;
    assign aluc[1] = i_xor | i_sra | i_srl | i_sll | i_xori | i_lui;
    assign aluc[0] = i_and | i_andi | i_or | i_ori | i_sll | i_srl | i_sra;
    assign shift   = i_sll | i_srl | i_sra ;

    assign aluimm  = i_addi | i_andi | i_ori | i_xori | i_lw | i_sw | i_lui;
    assign sext    = i_addi | i_lw | i_sw | i_beq | i_bne;
    assign wmem    = i_sw;
    assign m2reg   = i_lw;
    assign regrt   = i_addi | i_andi | i_ori | i_xori | i_lw | i_lui;
    assign jal     = i_jal;

endmodule
