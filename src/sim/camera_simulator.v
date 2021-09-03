`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH UST
// Engineer: Miko³aj Karelus
// 
// Create Date: 01.09.2021 15:14:01
// Design Name: 
// Module Name: camera_simulator
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


module camera_simulator(

    output reg sim_pclk,
    output wire sim_vsync_out,
    output wire sim_href_out,
    output wire [7:0] sim_data
    
    );
    
    reg [7:0] sim_data_nxt;
    reg [15:0] counter = 0;
    reg [15:0] vctr_nxt;
    reg [15:0] counter_nxt;
    reg [15:0] vctr = 0;
    reg sim_vsync_nxt, sim_href_nxt ;
    reg sim_vsync = 0;
    reg sim_href = 0;
    
    localparam HEIGHT = 120;
    localparam WIDTH = 160;
    
    assign sim_data = 8'b10101010;
    assign sim_vsync_out = sim_vsync;
    assign sim_href_out = sim_href;
    
    always begin
        #5 sim_pclk = 0;
        #5 sim_pclk = 1;
    end
    
    always @(posedge sim_pclk) begin
        counter <= counter_nxt;
        sim_vsync <= sim_vsync_nxt;
        vctr <= vctr_nxt;
        sim_href <= sim_href_nxt;
    end
    
    always @(*) begin
        counter_nxt = counter + 1 ;
        
        if (counter == WIDTH * 2) begin
        
            sim_href_nxt = 0;
            vctr_nxt = vctr + 1;
            counter_nxt = 0;
            
                if (vctr == HEIGHT) begin
                    sim_vsync_nxt = 1;
                    vctr_nxt = 0;
                end
                else begin
                    sim_vsync_nxt = 0;
                end
        end
        else begin
            sim_href_nxt = 1;
            sim_vsync_nxt = sim_vsync;
            vctr_nxt = vctr;
        end
    end

endmodule
