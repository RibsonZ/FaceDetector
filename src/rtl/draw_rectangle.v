`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Karelus Mikolaj
// 
// Create Date: 16.03.2021 13:46:10
// Design Name: 
// Module Name: draw_rectangle
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


module draw_rectangle(
    input wire rst,
    input wire pclk,
    input wire [11:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [11:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] rgb_in,
    input wire detected_flag,
    input wire continuous,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out,
    output reg nblank_out
    );
    
    reg [11:0] rgb_out_nxt;
    
    localparam RECTANGLE_X_POSITION = 100;
    localparam RECTANGLE_Y_POSITION = 100;
    localparam RECTANGLE_HEIGHT = 100;
    localparam RECTANGLE_WIDTH = 100;
    localparam RECTANGLE_COLOUR_NOT_CONTINUOUS = 12'hf_f_0;
    localparam RECTANGLE_COLOUR_CONTINUOUS = 12'h0_0_f;
    localparam CIRCLE_X_POSITION = 500;
    localparam CIRCLE_Y_POSITION = 150;
    localparam CIRCLE_RADIUS = 50;
    localparam CIRCLE_COLOUR_DETECTED = 12'h0_f_0;
    localparam CIRCLE_COLOUR_NOT_DETECTED = 12'hf_0_0;
    
    always @(posedge pclk) begin
        if (rst) begin
        hcount_out <= 0;
        hsync_out <= 0;
        hblnk_out <= 0;
        vcount_out <= 0;
        vsync_out <= 0;
        vblnk_out <= 0;
        rgb_out <= 0;
        nblank_out <= 0;
        end
        else begin
        hcount_out <= hcount_in;
        hsync_out <= hsync_in;
        hblnk_out <= hblnk_in;
        vcount_out <= vcount_in;
        vsync_out <= vsync_in;
        vblnk_out <= vblnk_in;
        rgb_out <= rgb_out_nxt;
        nblank_out <= !(hblnk_in || vblnk_in);
        end        
    end
    
    always @* begin
        /* STATUS RECT */
        if (hcount_in >= RECTANGLE_X_POSITION
            && hcount_in < (RECTANGLE_X_POSITION + RECTANGLE_WIDTH)
            && vcount_in >= RECTANGLE_Y_POSITION
            && vcount_in <= (RECTANGLE_Y_POSITION+RECTANGLE_HEIGHT)) begin 
        
            if (continuous) begin
                rgb_out_nxt = RECTANGLE_COLOUR_CONTINUOUS;         
            end
            else begin
                rgb_out_nxt = RECTANGLE_COLOUR_NOT_CONTINUOUS;
            end
        end
        /* DETECTION INDICATOR CIRCLE */
        else if ((hcount_in-CIRCLE_X_POSITION)*(hcount_in-CIRCLE_X_POSITION) + (vcount_in-CIRCLE_Y_POSITION)*(vcount_in-CIRCLE_Y_POSITION) <= CIRCLE_RADIUS) begin
            if (detected_flag) begin
                rgb_out_nxt = CIRCLE_COLOUR_DETECTED;
            end
            else begin
                rgb_out_nxt = CIRCLE_COLOUR_NOT_DETECTED;
            end
        end
        else begin
            rgb_out_nxt = rgb_in;  
        end
    end
endmodule
