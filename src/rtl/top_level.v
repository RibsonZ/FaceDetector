`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH UST
// Engineer: Wojciech Zebrowski
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
// 
//////////////////////////////////////////////////////////////////////////////////


module top_level(
    input wire clk100,
    
    input wire rst,
    
    input wire btnl,
    input wire btnc,
    input wire btnr,
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
    wire [0:0] wren;
    wire resend;
    wire nblank;
    wire vsync;
    wire nsync;
    
    wire [18:0] wraddress;
    wire [11:0] wrdata;
    
    wire [18:0] rdaddress;
    wire [11:0] rddata, rddata_rgb, wrdata_bw;
    wire [3:0] rddata_bw;
    wire active_area;
    
    wire rez_160x120;
    wire rez_320x240;
    wire [1:0] size_select;
    reg [16:0] rd_addr, wr_addr;
    wire color_sel;
    
    assign color_sel = sw[0];
    
    assign rez_160x120 = btnl;
    assign rez_320x240 = btnr;
    
    assign vga_vsync = vsync;
    
    assign size_select = {btnl, btnr};
    
    clocking u1_clocking(
        .CLK_100(clk100),
        .CLK_50(clk_camera),
        .CLK_25(clk_vga)        
    );
    
    VGA u1_VGA(
        .CLK25(clk_vga),
        .rez_160x120(rez_160x120),
        .rez_320x240(rez_320x240),
        .clkout(), //open
        .hsync(vga_hsync),
        .vsync(vsync),
        .nblank(nblank),
        .nsync(nsync),
        .activeArea(active_area)
    );
    
    debounce u1_debounce(
        .clk(clk_vga),
        .i(btnc),
        .o(resend)
    );
    
    ov7670_controller u1_ov7670_controller (
        .clk(clk_camera),
        .resend(resend),
        .config_finished(config_finished),
        .sioc(ov7670_sioc),
        .siod(ov7670_siod),
        .reset(ov7670_reset),
        .pwdn(ov7670_pwdn),
        .xclk(ov7670_xclk)
    );
    
    always @* begin
        case(size_select)
            2'b00: begin
                rd_addr = rdaddress[18:2];
                wr_addr = wraddress [18:2];
            end
            default: begin
                rd_addr = rdaddress[16:0];
                wr_addr = wraddress[16:0];
            end
        endcase
    end
    
    frame_buffer u1_frame_buffer(
        .addrb(rd_addr),
        .clkb(clk_vga),
        .doutb(rddata_rgb),
        .clka(ov7670_pclk),
        .addra(wr_addr),
        .dina(wrdata),
        .wea(wren)
    );
    
    ov7670_capture u1_ov7670_capture(
        .pclk(ov7670_pclk),
        .rez_160x120(rez_160x120),
        .rez_320x240(rez_320x240),
        .vsync(ov7670_vsync),
        .href(ov7670_href),
        .d(ov7670_data),
        .addr(wraddress),
        .dout(wrdata),
        .we(wren[0])
    );
    
    assign rddata = color_sel ? rddata_rgb : {rddata_bw, rddata_bw, rddata_bw};
    
    RGB u1_RGB(
        .din(rddata),
        .nblank(active_area),
        .r(vga_r),
        .g(vga_g),
        .b(vga_b)
    );
    
    RGB2BW u1_RGB2BW(
        .rgb(rddata_rgb),
        .bw(rddata_bw)
    );
    
    address_generator u1_address_generator(
        .CLK25(clk_vga),
        .rez_160x120(rez_160x120),
        .rez_320x240(rez_320x240),
        .enable(active_area),
        .vsync(vsync),
        .address(rdaddress)
    );
    
endmodule
