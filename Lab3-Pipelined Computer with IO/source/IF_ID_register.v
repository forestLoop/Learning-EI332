module IF_ID_register (
    input [31:0] pc4, ins,
    input wpcir, clock, reset,
    output reg [31:0] dpc4, inst  
);
    always @(posedge clock) begin
        if(~reset) begin
            dpc4 <= 0;
            inst <= 0;
        end else begin
            if(wpcir) begin
                dpc4 <= pc4;
                inst <= ins;
            end
        end
    end
endmodule
