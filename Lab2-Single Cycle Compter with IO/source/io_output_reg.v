module io_output_reg (addr,datain,write_io_enable,io_clk,clrn,out_port0,out_port1,out_port2 );
    input [31:0] addr,datain;
    input write_io_enable,io_clk;
    input clrn;
    //reset signal. if necessary,can use this signal to reset the output to 0.
    output [31:0] out_port0,out_port1, out_port2;
    reg [31:0] out_port0; // output port0
    reg [31:0] out_port1; // output port1
    reg [31:0] out_port2; // output port2
    always @(posedge io_clk or negedge clrn)
        begin
            if (clrn == 0)
                begin // reset
                    out_port0 <= 0;
                    out_port1 <= 0; // reset all the output port to 0.
                    out_port2 <= 0;
                end
            else
                begin
                    if (write_io_enable == 1)
                        case (addr[7:2])
                            6'b100000: out_port0 <= datain; // 80h
                            6'b100001: out_port1 <= datain; // 84h
                            6'b100010: out_port2 <= datain;
                            // more ports，可根据需要设计更多的输出端口。
                        endcase
                end
        end
endmodule
