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
        output vsync_out,
        output nblank,
        output nsync,
//        output active_area,
        output [11:0] rgb,
        output [14:0] rd_addr,
        input  [19:0] ii_rddata
    );
    
    localparam
    II_WIDTH = 160,
    II_HEIGHT = 120;
    
    reg [14:0] ii_address = 0; // future address output
//    reg [19:0] ii_rddata; // future data input
    reg [19:0] ii_z_buff [II_WIDTH - 1 : 0]; // allows access to up to II_WIDTH elements back without direct block ram access
    integer i;
    reg [19:0] row_buff;
    reg [7:0] row_ctr;
    reg [7:0] col_ctr;
    reg [19:0] bw_reg;
    wire active_area;
    wire vsync;
    reg vsync_z, vsync_z_z, vsync_z_z_z, active_area_z, active_area_z_z, active_area_z_z_z;
    
    assign rd_addr = ii_address;
    assign rgb = {bw_reg[3:0], bw_reg[3:0], bw_reg[3:0]};
    assign vsync_out = vsync_z_z;
    
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
    
    // up to date with the VGA module, dictates the address and introduces delay
    always @(posedge clk_vga) begin
        if (rst) begin
            ii_address <= 0;
        end
        else begin
            if (vsync == 0) begin
                ii_address <= 0;
            end
            else if(active_area) begin
                ii_address <= ii_address + 1;
            end
            
            vsync_z <= vsync;
            vsync_z_z <= vsync_z;
            vsync_z_z_z <= vsync_z_z;
            active_area_z <= active_area;
            active_area_z_z <= active_area_z;
            active_area_z_z_z <= active_area_z_z;
            
        end
    end
    
    // this gets all signals from the VGA module delayed by N clocks, and these are the output signals
    always @(posedge clk_vga) begin
        if (rst) begin
            for (i = 0 ; i < II_WIDTH ; i = i + 1) begin
                ii_z_buff[i] <= 0;
            end
            row_buff <= 0;
            row_ctr <= 0;
            col_ctr <= 0;
//            ii_address <= 0;
        end
        else begin
            if (vsync_z_z_z == 0) begin // vertical sync
                for (i = 0 ; i < II_WIDTH ; i = i + 1) begin
                    ii_z_buff[i] <= 0;
                end
                row_buff <= 0;
                row_ctr <= 0;
                col_ctr <= 0;
//                ii_address <= 0;
            end
            else if(active_area_z_z_z) begin
                if (col_ctr == II_WIDTH - 1) begin
                    row_ctr <= row_ctr + 1;
                    row_buff <= /*0;*/ii_rddata - ii_z_buff[II_WIDTH - 1];// <= 0 + bw_reg;
//                    if (row_ctr == II_HEIGHT) begin // here to prevent overflow, this is also reset by vsync above
//                        ii_address <= 0;
//                    end
                    bw_reg <= ii_rddata - ii_z_buff[II_WIDTH - 1] - row_buff; //????????
//                    ii_address <= ii_address + 1;
                    for (i = II_WIDTH - 1; i > 0 ; i = i - 1) begin
                        ii_z_buff[i] <= ii_z_buff[i - 1];
                    end
                    ii_z_buff[0] <= ii_rddata;
                    col_ctr <= 0;
                end
                else begin
                    bw_reg <= ii_rddata - ii_z_buff[II_WIDTH - 1] - row_buff; // row buff contains the previous current row, so up to the current element exclusively ??????
//                    ii_address <= ii_address + 1;
                    row_buff <= ii_rddata - ii_z_buff[II_WIDTH - 1]; // equation for current row up to current element inclusively ??????
                    // shifting z buffer
                    for (i = II_WIDTH - 1; i > 0 ; i = i - 1) begin
                        ii_z_buff[i] <= ii_z_buff[i - 1];
                    end
                    ii_z_buff[0] <= ii_rddata;
                    col_ctr <= col_ctr + 1;
                end
            end
            else begin
                bw_reg <= 0;
            end
        end
        
    end
    
    
endmodule
