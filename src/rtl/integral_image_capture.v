`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH UST
// Engineer: Wojciech Zebrowski
// 
// Create Date: 08/31/2021 08:56:42 PM
// Design Name: 
// Module Name: integral_image_capture
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
//      DEFINITIONS:
//          > II - Integral Image
//////////////////////////////////////////////////////////////////////////////////


module integral_image_capture(
        input ov7670_pclk,
        input rst,
        input ov7670_vsync,
        input ov7670_href,
        input [7:0] ov7670_data,
//        output [18:0] wraddress,
//        output [11:0] wrdata,
        output we,
        output reg [14:0] ii_address,
        output reg [31:0] ii_wrdata
    );
    
    wire [18:0] wraddress;
    wire [11:0] wrdata_rgb;
    wire [3:0] wrdata;
    
    ov7670_capture u1_ov7670_capture (
        .pclk(ov7670_pclk),
        .rst(rst),
        .rez_160x120(1),
        .rez_320x240(0),
        .vsync(ov7670_vsync),
        .href(ov7670_href),
        .d(ov7670_data),
        .addr(wraddress),
        .dout(wrdata_rgb),
        .we(we)
    );
    
    RGB2BW u1_RGB2BW (
        .rgb(wrdata_rgb),
        .bw(wrdata)
    );
    
    localparam
    II_WIDTH = 160,
    II_HEIGHT = 120;
    
//    reg [14:0] ii_address = 0; // future address output
//    reg [19:0] ii_wrdata; // future data output
    reg [19:0] ii_z_buff [II_WIDTH - 1 : 0]; // allows access to up to II_WIDTH elements back without direct block ram access
    integer i;
    reg [19:0] row_buff;
    reg [7:0] row_ctr;
    reg [7:0] col_ctr;
    
    always @(posedge ov7670_pclk) begin
        if (rst) begin
            for (i = 0 ; i < II_WIDTH ; i = i + 1) begin
                ii_z_buff[i] <= 0;
            end
            row_buff <= 0;
            row_ctr <= 0;
            col_ctr <= 0;
            ii_address <= 0;
            ii_wrdata <= 0;
        end
        else begin // no reset
            if (ov7670_vsync) begin
                for (i = 0 ; i < II_WIDTH ; i = i + 1) begin
                    ii_z_buff[i] <= 0;
                end
                row_buff <= 0;
                row_ctr <= 0;
                col_ctr <= 0;
                ii_address <= 0;
                ii_wrdata <= 0;
            end
            else if (we) begin// if there's a new pixel
                if (col_ctr == II_WIDTH - 1) begin // if we start a new row, reset row_buff
                    row_ctr <= row_ctr + 1;
                    row_buff <= 0 + wrdata;
                    ii_wrdata <= ii_z_buff[II_WIDTH - 1 - 1] + wrdata;//row_buff; //II_WIDTH -1 for size of line, -1 to get the valid value for the future, NEXT rising edge
                    ii_address <= ii_address + 1; // should be equivalent to row_ctr * II_WIDTH + col_ctr
                    // shifting z buffer
                    for (i = II_WIDTH - 1 ; i > 0 ; i = i - 1) begin
                        ii_z_buff[i] <= ii_z_buff[i - 1];
                    end
                    ii_z_buff[0] <= ii_wrdata;
                    col_ctr <= 0; // the next col number after new row
                end
                else begin /* business as usual */
                    // cumulative sum of row
                    row_buff <= row_buff + wrdata;
                    // computing ii element and address
                    ii_wrdata <= ii_z_buff[II_WIDTH - 1 - 1] + row_buff + wrdata;
                    ii_address <= ii_address + 1; // should be equivalent to row_ctr * II_WIDTH + col_ctr
                    // shifting z buffer
                    for (i = II_WIDTH - 1 ; i > 0 ; i = i - 1) begin
                        ii_z_buff[i] <= ii_z_buff[i - 1];
                    end
                    ii_z_buff[0] <= ii_wrdata;
                    col_ctr <= col_ctr + 1; // the next col number, will go to II_WIDTH - 1 on last row element
                end
            end
        end
    end
    
endmodule
