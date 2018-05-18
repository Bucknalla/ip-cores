`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Alex Bucknall
//
// Create Date: 04/05/2018
// Design Name: baseband_tb.v
// Module Name: baseband_tb
// Project Name: baseband_tb
// Target Devices: Zynq 7000
// Tool Versions: 2016.4
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module baseband_tb();

reg clk;
reg [15:0] counter;
reg rst; 
reg [31:0] signal_in; 
wire [31:0] signal_out;
reg ready_in;
reg valid_in;
wire ready_out;
wire valid_out;
wire error;
//wire [3:0] status;
//reg tlast_in;
//reg tstrb_in;
//wire tlast_out;
//wire tstrb_out; 
    
parameter CLK_PERIOD = 10;    

design_1 design_1_i
    (.CLK(clk),

    .DATA_IN_AXIS_tdata(signal_in),
//    .DATA_IN_AXIS_tlast(tlast_in),
    .DATA_IN_AXIS_tready(ready_out),
//    .DATA_IN_AXIS_tstrb(tstrb_in),
    .DATA_IN_AXIS_tvalid(valid_in),
    
//    .QAM_IN_AXIS_tdata(signal_in),
////    .DATA_IN_AXIS_tlast(tlast_in),
//     .QAM_IN_AXIS_tready(ready_out),
//    //    .DATA_IN_AXIS_tstrb(tstrb_in),
//     .QAM_IN_AXIS_tvalid(valid_in),

    .DATA_OUT_AXIS_tdata(signal_out),
//    .DATA_OUT_AXIS_tlast(tlast_out),
//    .DATA_OUT_AXIS_tready(ready_in),
////    .DATA_OUT_tstrb(tstrb_out),
    .DATA_OUT_AXIS_tvalid(valid_out),

    .ERROR(error),
    .RST(rst)
//    .STATUS(status)
    );

initial clk = 0;

always #5 clk = ~clk;

// SIGNAL_IN INCREMENTER
always
begin
    #5
    if(ready_out & (clk))
    begin
        signal_in = signal_in +1;
    end
end

// S_AXIS_DATA (INPUT)
initial
begin
    rst = 1;
    counter = 0;
    signal_in = 0;
//    tstrb_in = 0;
//    tlast_in = 0;
    ready_in = 1;
    valid_in = 1; 
    #20;  
    rst = 0;
//    repeat(1000)
//    begin
//        #20 signal_in = signal_in + 1;
//        counter = counter + 1'b1;
//    end      
    #200000 $finish;
end
        

endmodule
