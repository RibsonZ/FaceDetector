`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2021 10:32:56 PM
// Design Name: 
// Module Name: RGB2BW
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


module RGB2BW(
    input [7:0] R,
    input [7:0] G,
    input [7:0] B,
    output [7:0] R_BW,
    output [7:0] G_BW,
    output [7:0] B_BW
    );
    
    reg [9:0] sum;
    
    always @*
    begin
        sum = R + G + B;
    end
    
    assign R_BW = sum[9:2];
    assign G_BW = sum[9:2];
    assign B_BW = sum[9:2];
    
endmodule
