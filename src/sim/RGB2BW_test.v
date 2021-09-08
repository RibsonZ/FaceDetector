`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2021 01:22:04 PM
// Design Name: 
// Module Name: RGB2BW_test
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


module RGB2BW_test();
    
    reg [11:0] rgb;
    wire [3:0] bw;
    
    RGB2BW dut_RGB2BW(
        .rgb(rgb),
        .bw(bw)
    );

    initial begin
        $monitor("rgb: %h, bw: %h", rgb, bw);
        rgb = 12'hAAA;
        #5
        rgb = 12'h555;
        #5
        rgb = 12'h123;
        #5
        $stop;
    end
    
    
endmodule
