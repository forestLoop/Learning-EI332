module MEM_stage (
    input [31:0] malu, mb,
    input mwmem, clock, mem_clock, resetn,
    output [31:0] mmo,
    input [31:0] in_port0, in_port1, in_port2,
    output [31:0] out_port0, out_port1, out_port2
);
    wire write_datamem_enable, write_io_output_reg_enable, dmem_clk, write_enable;
    wire [31:0] mem_dataout, io_read_data;
    wire [31:0] datain, addr;
    assign dmem_clk = mem_clock;
    assign write_enable = mwmem;
    assign addr = malu;
    assign datain = mb;
    assign write_datamem_enable = write_enable & ~addr[7];
    assign write_io_output_reg_enable = write_enable & addr[7];
    mux2x32 mem_io_dataout_mux(mem_dataout,io_read_data,addr[7],mmo);
    lpm_ram_dq_dram dram(addr[6:2],dmem_clk,datain,write_datamem_enable,mem_dataout );
    io_output_reg io_output_regx3 (addr,datain,write_io_output_reg_enable,dmem_clk,resetn,
        out_port0,out_port1,out_port2);
    io_input_reg io_input_regx3(addr,dmem_clk,io_read_data,in_port0,in_port1,in_port2);
endmodule
