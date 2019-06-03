module sevenseg ( data, ledsegments);
  input [3:0] data;
  output [6:0] ledsegments;
  reg [6:0] ledsegments;
  always @ (data)
    case(data)
      // gfe_dcba // 7 段 LED 数码管的位段编号
      // 654_3210 // DE1-SOC 板上的信号位编号
      0: ledsegments = 7'b100_0000; // DE1-SOC 板上的数码管为共阳极接法。
      1: ledsegments = 7'b111_1001;
      2: ledsegments = 7'b010_0100;
      3: ledsegments = 7'b011_0000;
      4: ledsegments = 7'b001_1001;
      5: ledsegments = 7'b001_0010;
      6: ledsegments = 7'b000_0010;
      7: ledsegments = 7'b111_1000;
      8: ledsegments = 7'b000_0000;
      9: ledsegments = 7'b001_0000;
      default: ledsegments = 7'b111_1111; // 其它值时全灭。
    endcase
endmodule

module out_port_translator (value, out);
    input [31:0] value;
    output [13:0] out;
    wire [3:0] data1,data2;
	  wire [6:0] out1,out2;
    sevenseg value_display_high(data1, out1);
    sevenseg value_display_low(data2, out2);
	  assign out = { out1,out2 };
    assign data1 = value / 10;
    assign data2 = value % 10;
    // always @ (value) begin
    //     data1 = value / 10;
    //     data2 = value % 10;
    // end

endmodule
