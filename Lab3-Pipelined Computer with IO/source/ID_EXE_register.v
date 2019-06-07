module ID_EXE_register (dwreg,dm2reg,dwmem,daluc,daluimm,da,db,dimm,drn,
        dshift,dsa,djal,dpc4,clock,resetn,ewreg,em2reg,ewmem,ealuc,ealuimm,
        ea,eb,eimm,ern0,eshift,esa,ejal,epc4);
    // too much arguments!
    // so I have to write them in this outdated style.
    input dwreg, dm2reg, dwmem, daluimm, dshift, djal, clock, resetn;
    input [3:0] daluc;
    input [4:0] drn;
    input [31:0] da, db, dimm, dpc4, dsa;

    output reg ewreg, em2reg, ewmem, ealuimm, eshift, ejal;
    output reg [3:0] ealuc;
    output reg [4:0] ern0;
    output reg [31:0] ea, eb, eimm, epc4, esa;

    always @(posedge clock) begin
        if(~resetn) begin
            ewreg <= 0;
            em2reg <= 0;
            ewmem <= 0;
            ealuimm <= 0;
            eshift <= 0;
            ejal <= 0;
            ealuc <= 4'h0;
            ern0 <= 5'h0;
            ea <= 32'h0;
            eb <= 32'h0;
            eimm <= 32'h0;
            epc4 <= 32'h0;
            esa <= 32'h0;
        end else begin
            ewreg <= dwreg;
            em2reg <= dm2reg;
            ewmem <= dwmem;
            ealuimm <= daluimm;
            eshift <= dshift;
            ejal <= djal;
            ealuc <= daluc;
            ern0 <= drn;
            ea <= da;
            eb <= db;
            eimm <= dimm;
            epc4 <= dpc4;
            esa <= dsa;
        end
    end
endmodule
