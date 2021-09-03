`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH UST
// Engineer: Wojciech Zebrowski
// 
// Create Date: 09/01/2021 05:36:30 PM
// Design Name: 
// Module Name: integral_image_display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      Responsible for unpacking the Integral Image memory and displaying the frame
//      over VGA. 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module integral_image_display(
        input rst,
        input clk_vga,
        output vga_hsync,
        output vsync,
        output nblank,
        output nsync,
        output active_area,
        output [11:0] rgb
    );
    
    VGA u1_VGA(
        .rst(rst),
        .CLK25(clk_vga),
        .rez_160x120(1),
        .rez_320x240(0),
        .clkout(), //open
        .hsync(vga_hsync),
        .vsync(vsync),
        .nblank(nblank),
        .nsync(nsync),
        .activeArea(active_area)
    );
    
    localparam
    II_WIDTH = 160,
    II_HEIGHT = 120;
    
    reg [14:0] ii_address = 0; // future address output
    reg [19:0] ii_rddata; // future data input
    reg [19:0] ii_z_buff [II_WIDTH - 1 : 0]; // allows access to up to II_WIDTH elements back without direct block ram access
    integer i;
    reg [19:0] row_buff;
    reg [7:0] row_ctr;
    reg [7:0] col_ctr;
    reg [19:0] bw_reg;
    
    assign rgb = {bw_reg[3:0], bw_reg[3:0], bw_reg[3:0]};
    
    always @(posedge clk_vga) begin
        if (rst) begin
            for (i = 0 ; i < 4 ; i = i + 1) begin
                ii_z_buff[i] <= 0;
            end
            row_buff <= 0;
            row_ctr <= 0;
            col_ctr <= 0;
            ii_address <= 0;
        end
        else begin
            if (vsync == 0) begin // vertical sync
                for (i = 0 ; i < 4 ; i = i + 1) begin
                    ii_z_buff[i] <= 0;
                end
                row_buff <= 0;
                row_ctr <= 0;
                col_ctr <= 0;
                ii_address <= 0;
            end
            else if(active_area) begin
                if (col_ctr == II_WIDTH) begin
                    row_ctr <= row_ctr + 1;
                    row_buff <= 0;
                    col_ctr <= 0;
                        if (row_ctr == II_HEIGHT) begin // here to prevent overflow, this is also reset by vsync above
                            ii_address <= 0;
                        end
                end
                bw_reg <= ii_rddata - ii_z_buff[II_WIDTH - 1] - row_buff;
                ii_address <= ii_address + 1;
                row_buff <= row_buff + bw_reg;
                // shifting z buffer
                for (i = 160; i > 0 ; i = i - 1) begin
                    ii_z_buff[i] <= ii_z_buff[i - 1];
                end
                ii_z_buff[0] <= ii_rddata;
                col_ctr <= col_ctr + 1;
            end
        end
        
    end
    
    
endmodule
