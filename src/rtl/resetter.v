`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH UST
// Engineer: Wojciech Zebrowski
// 
// Create Date: 03/31/2021 11:59:22 PM
// Design Name: vga_example
// Module Name: resetter
// Project Name: FaceDetector
// Target Devices: Basys 3
// Tool Versions: ??
// Description: makes asynchronous resets synchronous
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module resetter(
    input pclk,
    input locked,
    output reg rst_out
    );
  
  `define RST_DURATION 10
  
  reg rst_nxt;
  reg [3:0] counter, counter_nxt;
  
  always @(posedge pclk)
  begin
    rst_out <= rst_nxt;
    counter <= counter_nxt;
  end
  
  always @*
  begin
    if (locked == 0)
    begin
      rst_nxt = 1;
      counter_nxt = `RST_DURATION;
    end
    else if (counter == 0)
    begin
      rst_nxt = 0;
      counter_nxt = 0;
    end
    else
    begin
      rst_nxt = rst_out;
      counter_nxt = counter - 1;
    end
  end
  
endmodule
