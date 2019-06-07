module PC (
    input [31:0] npc,
    input wpcir, clock, resetn,
    output reg [31:0] pc 
);
    always @(posedge clock) begin : proc_pc
        if(~resetn) begin
            pc <= 0;
        end else begin
            if(wpcir) begin
                pc <= npc;
            end
        end
    end
endmodule
