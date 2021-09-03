`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH UST
// Engineer: Wojciech Zebrowski
// 
// Create Date: 08/31/2021 12:32:08 AM
// Design Name: 
// Module Name: haar_like_feature
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Operates on integral image; at img_rdy it starts calculating the score and compares it to the threshold to yield the vote.
// 
//
// ADD PORT C TO BLOCK MEMORY FOR ACCESS FROM FEATURES, block memory must have 20bits assuming 160x120
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module haar_like_feature(
    input [3:0] type,
    input [15:0] position,
    input [15:0] width,
    input [15:0] height,
    input [19:0] threshold,
    input polarity,
    output [19:0] score,
    output vote
    );
endmodule
