`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH UST
// Engineer: Mike Field, Wojciech Zebrowski
// 
// Create Date: 08/25/2021 03:14:06 PM
// Design Name: 
// Module Name: top_level
// Project Name: FaceDetector
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//      Based on the design provided under:
//          https://www.fpga4student.com/2018/08/basys-3-fpga-ov7670-camera.html
//////////////////////////////////////////////////////////////////////////////////


module top_level(
    input wire clk100,
    input wire reset_in, //BTNU
    input wire btnl, // 
    input wire btnc, // hold for resend (camera re-init)
    input wire btnr, //
    input wire [3:0] sw,
    output wire config_finished,
    output vga_hsync,
    output vga_vsync,
    output [3:0] vga_r, vga_g, vga_b,
    input ov7670_pclk,
    output ov7670_xclk,
    input ov7670_vsync,
    input ov7670_href,
    input [7:0] ov7670_data,
    output ov7670_sioc,
    inout ov7670_siod,
    output ov7670_pwdn,
    output ov7670_reset
    );
    
    wire clk_camera;
    wire clk_vga;
    wire xclk;
    wire clk_25;
    wire [0:0] wren;
    wire resend;
    wire nblank;
    wire vsync;
    wire nsync;
    wire [14:0] rd_addr, wr_addr; //integral image addresses
    wire rst_vga, rst_camera, rst;
    wire locked;
    reg write_en;
    wire [19:0] ii_wrdata, ii_rddata;
    wire [11:0] rgb_display_data;
    
    assign vga_vsync = vsync;
    assign clk_vga = clk_25;
    assign xclk = clk_25;
    assign rst = rst_vga | rst_camera;
    
    clock_generator u1_clock_generator(
        .reset(reset_in),
        .clk_in_100(clk100),
        .clk_out_50(clk_camera),
        .clk_out_25(clk_25),
        .locked(locked)
    );
    
    resetter u1_resetter(
        .pclk(clk_vga),
        .locked(locked),
        .rst_out(rst_vga)
    );
    
    resetter u2_resetter(
        .pclk(clk_camera),
        .locked(locked),
        .rst_out(rst_camera)
    );
    
    integral_image_display(
        .rst(rst),
        .clk_vga(clk_vga),
        .vga_hsync(vga_hsync),
        .vsync_out(vsync),
        .nblank(nblank),
        .nsync(nsync),
        .rgb(rgb_display_data),
        .rd_addr(rd_addr),
        .ii_rddata(ii_rddata)
    );
    
    debounce u1_debounce(
        .rst(rst),
        .clk(clk_vga),
        .i(btnc),
        .o(resend)
    );
    
    ov7670_controller u1_ov7670_controller (
        .clk(clk_camera),
        .rst(rst),
        .xclk_in(xclk),
        .resend(resend),
        .config_finished(config_finished),
        .sioc(ov7670_sioc),
        .siod(ov7670_siod),
        .reset(ov7670_reset),
        .pwdn(ov7670_pwdn),
        .xclk_out(ov7670_xclk)
    );
    
    integral_image_buffer u1_integral_image_buffer(
        /* BRAM_PORTA */
        .addra(wr_addr), //14:0, write address
        .clka(ov7670_pclk),
        .dina(ii_wrdata), //19:0, input data
        .wea(wren[0]), //write enable
        .ena(1),
        /* BRAM_PORTB */
        .addrb(rd_addr), //14:0, read address
        .clkb(clk_vga),
        .doutb(ii_rddata) //19:0, output data
        
    );

    integral_image_capture u1_integral_image_capture(
            .ov7670_pclk(ov7670_pclk),
            .rst(rst),
            .ov7670_vsync(ov7670_vsync),
            .ov7670_href(ov7670_href),
            .ov7670_data(ov7670_data),
//            .wraddress(wr_addr),
//            .wrdata(wrdata),
            .we(wren[0]),
            .ii_address(wr_addr),
            .ii_wrdata(ii_wrdata)
    );
    
    RGB u1_RGB(
        .din(rgb_display_data),
        .nblank(nblank),
        .r(vga_r),
        .g(vga_g),
        .b(vga_b)
    );
    
endmodule
