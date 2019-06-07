module MEM_WB_register (
    input [31:0] malu, mmo,
    input [4:0] mrn,
    input mwreg, mm2reg, clock, resetn,
    output reg [31:0] walu, wmo,
    output reg [4:0] wrn,
    output reg wwreg, wm2reg
);
    always @(posedge clock) begin
        if(~resetn) begin
             walu <= 32'h0;
             wmo <= 32'h0;
             wrn <= 5'h0;
             wwreg <= 0;
             wm2reg <= 0;
        end else begin
             walu <= malu;
             wmo <= mmo;
             wrn <= mrn;
             wwreg <= mwreg;
             wm2reg <= mm2reg;
        end
    end
endmodule
