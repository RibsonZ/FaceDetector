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
    output reg sim_vsync,
    output reg sim_href,
    output wire [7:0] sim_data
    
    );
    
    reg [7:0] sim_data_nxt;
    reg counter, vctr, vctr_nxt , counter_nxt, sim_vsync_nxt, sim_href_nxt;
    
    localparam HEIGHT = 120;
    
    assign sim_data = 8'b10101010;
    
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
        
        if (counter_nxt == 320) begin
        
            sim_href_nxt = 0;
            vctr_nxt = vctr + 1;
            counter_nxt = 0;
            
                if (vctr == HEIGHT) begin
                    sim_vsync_nxt = 1;
                    vctr_nxt = 0;
                end
                else 
                    sim_vsync_nxt = 0;
          end
            else sim_href_nxt = 1;
    end

endmodule
