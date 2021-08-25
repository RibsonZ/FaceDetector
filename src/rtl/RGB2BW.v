`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH UST
// Engineer: Wojciech Zebrowski
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
        input [11:0] rgb,
        output [3:0] bw
    );
    
    reg [5:0] sum;
    
    always @*
    begin
        sum = rgb[11:8] + rgb[7:4] + rgb[3:0];
    end
    
    assign bw = sum[5:2];
    
endmodule
