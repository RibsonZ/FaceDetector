`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH UST
// Engineer: Miko³aj Karelus
// 
// Create Date: 01.09.2021 18:08:49
// Design Name: 
// Module Name: testbench
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


module testbench(
    );
    wire sim_pclk;
    wire sim_vsync;
    wire sim_href;
    wire [7:0] sim_data;
    reg reset;
    reg clk100;
    
    top_level u1_top_level(
        .ov7670_pclk(sim_pclk),
        .ov7670_vsync(sim_vsync),
        .ov7670_href(sim_href),
        .ov7670_data(sim_data),
        .reset_in(reset),
        .clk100(clk100)
    );
    
    camera_simulator u1_camera_simulator(
        .sim_pclk(sim_pclk),
        .sim_vsync_out(sim_vsync),
        .sim_href_out(sim_href),
        .sim_data(sim_data)
    );
    
    always begin
        #5 clk100 = 0;
        #5 clk100 = 1;
    end
    
    initial begin
    #5 reset = 5;
    #1 reset =0;
    end
endmodule
