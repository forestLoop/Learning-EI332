module EXE_MEM_register (
    input [31:0] ealu, eb,
    input [4:0] ern,
    input ewreg, em2reg, ewmem, clock, resetn,
    output reg [31:0] malu, mb,
    output reg [4:0] mrn,
    output reg mwreg, mm2reg, mwmem
);
    always @(posedge clock) begin
        if(~resetn) begin
            malu <= 32'h0;
            mb <= 32'h0;
            mrn <= 5'h0;
            mwreg <= 0;
            mm2reg <= 0;
            mwmem <= 0;
        end else begin
            malu <= ealu;
            mb <= eb;
            mrn <= ern;
            mwreg <= ewreg;
            mm2reg <= em2reg;
            mwmem <= ewmem;
        end
    end
endmodule
