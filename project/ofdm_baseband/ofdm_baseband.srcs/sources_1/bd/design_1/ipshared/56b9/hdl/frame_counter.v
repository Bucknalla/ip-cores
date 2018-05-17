`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Alex Bucknall
//
// Create Date: 04/05/2018
// Design Name: frame_counter.v
// Module Name: frame_counter
// Project Name: frame_counter
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


module frame_counter 
    (
    input clk,
    input rst,
    input valid,
    input ready,
    input pilot_flag,
    input event_frame_started,
    input [12:0] frame_length,
    output reg end_frame = 0,
    output reg start_frame = 0
    );
        
    reg [12:0] counter = 0;
    
    always @ (posedge clk) begin
        if(!rst) begin
            end_frame <= 0;
            start_frame <= 0;
            counter <= 0;
        end
        else if (valid & ready) begin
            end_frame <= 0;
            start_frame <= 0;
            if(counter == 0) begin
                start_frame <= 1;
                counter <= counter + 1;
            end
            else if(counter == (frame_length - 2)) begin
                end_frame <= 1;
                counter <= counter + 1;
            end
            else if(counter == (frame_length - 1)) begin
                counter <= 0;
            end
            else begin
                counter <= counter + 1;
            end
        end
    end
endmodule
