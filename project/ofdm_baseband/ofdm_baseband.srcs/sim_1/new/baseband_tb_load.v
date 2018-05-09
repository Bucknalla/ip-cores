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

module baseband_tb_load_file();

reg clk;
reg [15:0] counter;
reg rst, rst_axi; 
wire [31:0] signal_out;
reg [31:0] captured_data;
reg ready_in;
reg valid_in;
wire ready_out;
wire valid_out;
wire error;

integer               data_stream    ; // file handler
integer               scan_stream    ; // file handler
`define NULL 0    

initial begin
  data_stream = $fopen("/home/alex/GitHub/ip-cores/project/ofdm_baseband/ofdm_baseband.srcs/sim_1/new/data.bin", "r"); // You will need to change this to your local dir
  if (data_stream == `NULL) begin
    $display("data_stream handle was NULL");
    $finish;
  end
end

parameter CLK_PERIOD = 10;    

design_1 design_1_i
    (.CLK(clk),
    .DATA_IN_AXIS_tdata(captured_data),
    .DATA_IN_AXIS_tready(ready_out),
    .DATA_IN_AXIS_tvalid(valid_in),
    .DATA_OUT_AXIS_tdata(signal_out),
    .DATA_OUT_AXIS_tvalid(valid_out),
    .DATA_OUT_AXIS_tready(ready_in),
    
    .ERROR(error),
    .RST(rst),
    .RST_AXI(rst_axi)
    );


// Clock Setup
initial clk = 0;
always #(CLK_PERIOD/2) clk = ~clk;

// SIGNAL_IN INCREMENTER
always @(posedge clk) begin
    if((rst) & ready_out) begin
        scan_stream = $fscanf(data_stream, "%b\n", captured_data);
        $display(captured_data); 
    end
    if ($feof(data_stream)) begin
        $fclose(data_stream);
        $fclose(scan_stream);
        $finish;
    end
end

// S_AXIS_DATA (INPUT)
initial
begin
    rst = 0;
    rst_axi = 1;
    counter = 0;
    captured_data = 0;
    scan_stream = 0;
    valid_in = 1;
    ready_in = 1; 
    #20;  
    rst = 1;
    rst_axi = 0;
end
        

endmodule
