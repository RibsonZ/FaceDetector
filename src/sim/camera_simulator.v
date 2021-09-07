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
    input wire en,
    output reg sim_pclk,
    output reg sim_vsync,
    output reg sim_href,
    output wire [7:0] sim_data
    
    );
    
    initial begin
        sim_vsync = 0;
    end
    
    reg [7:0] sim_data_nxt;
    integer counter=0, vctr=0, vctr_nxt , counter_nxt;
    reg sim_vsync_nxt, sim_href_nxt;
    
    localparam HEIGHT = 480,
    WIDTH = 640;
    
    assign sim_data = 8'hFF;
    
    initial begin sim_pclk = 0; end
    
    //output clk
    always begin
        #5 sim_pclk = en? !sim_pclk : 0;
    end
    
    //internal clock
    reg int_pclk = 0;
    
    always@(posedge sim_pclk) begin
        int_pclk = !int_pclk;
    end
    
    always @(posedge int_pclk) begin
        counter <= counter_nxt;
        sim_vsync <= sim_vsync_nxt;
//        vctr <= vctr_nxt;
//        sim_href <= sim_href_nxt;
    end
    
    always@(negedge int_pclk) begin
        vctr <= vctr_nxt;
        sim_href <= sim_href_nxt;
    end
    
    always @(*) begin
        counter_nxt = counter + 1 ;
        
        if (counter == WIDTH) begin
        
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
            vctr_nxt = vctr;
            sim_vsync_nxt = sim_vsync;
        end
            
    end

endmodule
