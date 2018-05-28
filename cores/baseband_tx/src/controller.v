`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2018 12:49:51
// Design Name: 
// Module Name: controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module controller(
    input clk,
    input rst,
    
    input [31:0] slv_reg0, // NFFT
    input [31:0] slv_reg1, // CP_LEN
    input [31:0] slv_reg2, // FWD/INV
    input [31:0] slv_reg3, // SCALE_SCH
    output reg valid_out,
    output reg [40:0] data_out,
    input ready_in
    
    );
    
always @ (posedge clk) begin
    if (!rst) begin
        valid_out <= 0;
        data_out <= 0;    
    end
    else if(ready_in) begin
        valid_out <= 1;
        data_out <= {5'b0,slv_reg3[9:0],slv_reg2[0:0],6'b0,slv_reg1[9:0],3'b0,slv_reg0[4:0]}; // 
    end

end    
    
    
endmodule
