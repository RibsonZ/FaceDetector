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
    input wire reset_in, // BTNU
//    input wire btnl, // INCREMENT THRESHOLD
//    input wire btnc, // CAPTURE FRAME
//    input wire btnr, // DECREMENT THRESHOLD
//    input wire [3:0] sw,// sw[0] switches on continuous mode
    output wire led,
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
    output ov7670_reset,
    inout mou_ps2c,
    inout mou_ps2d
    );
    
    wire clk_camera;
    wire clk_vga;
    wire xclk;
    wire clk_25;
//    wire wren;
//    wire resend;
//    wire nblank;
//    wire vsync;
//    wire hsync;
//    wire nsync;
//    wire [14:0] rd_addr, wr_addr; //integral image addresses
    wire rst_vga, rst_camera, rst;
    wire locked;
//    reg write_en;
//    wire [19:0] ii_wrdata, ii_rddata, ii_rddata_a;
//    wire [11:0] rgb_display_data;
//    wire continue;//, decrement_threshold, increment_threshold;
//    wire detect_en;
//    wire cap_done; // out from ii_cap
//    wire detect_done; // out from detect
//    wire [14:0] address_a; // into buff
//    wire wea; //into buff
//    wire [19:0] classifier_rd_addr;
//    wire detected_flag;
//    wire [11:0] vcnt, hcnt;
//    wire [11:0] rgb_display_out;
//    wire nblank_out;
//    wire left, middle, right;
//    wire mouse_left, mouse_right;

    wire m2d_left, m2d_right;
    wire d2ctl_left, d2_ctl_right;
    wire ctl2det_continue;
    wire [19:0] iic2buf_wrdata;
    
    wire [14:0] iic2det_addr;
    wire iic2det_wren, iic2det_cap_done;
    
    wire [14:0] casc2det_addr;
    wire casc2det_detect_done;
    
    wire casc2draw_detected_flag;
    
    wire [14:0] det2buf_addr;
    wire det2buf_we;
    
    wire det2casc_detect_en;
    
    wire [19:0] buf2casc_data;
    
    wire [19:0] buf2disp_data;
    
    wire [14:0] disp2buf_addr;
    
    wire [11:0] disp2draw_hcnt;
    wire disp2draw_nblank;
    wire [11:0] disp2draw_rgb;
    wire [11:0] disp2draw_vcnt;
    wire disp2draw_hsync;
    wire disp2draw_vsync;
    
    wire [11:0] draw2rgb_data;
    wire draw2RGB_nblank;
    
    assign led = casc2draw_detected_flag;
    assign clk_vga = clk_25;
    assign xclk = clk_25;
    
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
    
    assign rst = rst_vga | rst_camera;
    
    MouseCtl u1_MouseCtl (
        .clk(ov7670_pclk),
        .rst(rst),
        .xpos(),
        .ypos(),
        .zpos(),
        .left(m2d_left),
        .middle(),
        .right(m2d_right),
        .new_event(),
        .value(0),
        .setx(0),
        .sety(0),
        .setmax_x(0),
        .setmax_y(0),
        .ps2_clk(mou_ps2c),
        .ps2_data(mou_ps2d)
    );
    
    debounce u4_debounce(
        .rst(rst),
        .clk(ov7670_pclk),
        .i(m2d_left),
        .o(d2ctl_left)
    );
        
    debounce u5_debounce(
        .rst(rst),
        .clk(ov7670_pclk),
        .i(m2d_right),
        .o(d2_ctl_right)
    );
    
    control_module u1_control_module(
        .clk(ov7670_pclk),
        .rst(rst),
        .mouse_left(d2ctl_left), //debounced
        .mouse_right(d2_ctl_right), //debounced
        .continue(ctl2det_continue)
    );
    
    integral_image_display u1_integral_image_display(
        .rst(rst),
        .clk_vga(clk_vga),
        .vga_hsync(disp2draw_hsync),
        .vsync_out(disp2draw_vsync),
        .nblank(disp2draw_nblank),
        .nsync(),
        .rgb(disp2draw_rgb),
        .rd_addr(disp2buf_addr),
        .ii_rddata(buf2disp_data),
        .hcnt_out(disp2draw_hcnt),
        .vcnt_out(disp2draw_vcnt)
    );
    
    draw ul_draw(
        .rst(rst),
        .pclk(clk_vga),
        .hcount_in(disp2draw_hcnt),
        .vcount_in(disp2draw_vcnt),
        .hsync_in(disp2draw_hsync),
        .vsync_in(disp2draw_vsync),
        .hblnk_in(!disp2draw_nblank),
        .vblnk_in(!disp2draw_nblank),
        .rgb_in(disp2draw_rgb),
        .hsync_out(vga_hsync),
        .vsync_out(vga_vsync),
        .rgb_out(draw2rgb_data),
        .nblank_out(draw2RGB_nblank),
        .detected_flag(casc2draw_detected_flag),
        .continuous(ctl2det_continue),
        .hblnk_out(),
        .vblnk_out(),
        .vcount_out(),
        .hcount_out()
    );

    ov7670_controller u1_ov7670_controller (
        .clk(clk_camera),
        .rst(rst),
        .xclk_in(xclk),
        .resend(0), // RESEND TIED LOW
        .config_finished(),
        .sioc(ov7670_sioc),
        .siod(ov7670_siod),
        .reset(ov7670_reset),
        .pwdn(ov7670_pwdn),
        .xclk_out(ov7670_xclk)
    );
    
    integral_image_buffer u1_integral_image_buffer(
        /* BRAM_PORTA */
        .addra(det2buf_addr), //14:0, write address
        .clka(ov7670_pclk),
        .dina(iic2buf_wrdata), //19:0, input data
        .douta(buf2casc_data),
        .wea(det2buf_we), //write enable
        /* BRAM_PORTB */
        .addrb(disp2buf_addr), //14:0, read address
        .clkb(clk_vga),
        .dinb(0),
        .doutb(buf2disp_data), //19:0, output data
        .web(0)
    );

    integral_image_capture u1_integral_image_capture(
        .ov7670_pclk(ov7670_pclk),
        .rst(rst),
        .ov7670_vsync(ov7670_vsync),
        .ov7670_href(ov7670_href),
        .ov7670_data(ov7670_data),
        .we(iic2det_wren),
        .ii_address(iic2det_addr),
        .cap_done(iic2det_cap_done),
        .ii_wrdata(iic2buf_wrdata)
    );
    
    RGB u1_RGB(
        .din(draw2rgb_data),
        .nblank(draw2RGB_nblank),
        .r(vga_r),
        .g(vga_g),
        .b(vga_b)
    );
    
    detection_sm u1_detection_sm(
        .clk(ov7670_pclk),
        .rst(rst),
        .cap_done(iic2det_cap_done),
        .detect_done(casc2det_detect_done),
        .continue(ctl2det_continue),
        .write_en_in(iic2det_wren),
        .wr_addr(iic2det_addr),
        .classifier_rd_addr(casc2det_addr),
        .detect_en(det2casc_detect_en),
        .address_a_out(det2buf_addr),
        .write_en_out(det2buf_we)
    );
    
    cascade u1_cascade(
        .clk(ov7670_pclk),
        .rst(rst),
        .detect_en(det2casc_detect_en),
        .detect_done(casc2det_detect_done), //out
        .data_in( {1'b0, buf2casc_data} ), //conversion to signed //in
        .rd_addr(casc2det_addr), //out
        .detected_flag(casc2draw_detected_flag), //out
        .increment_threshold(0),
        .decrement_threshold(0)
    );
    
endmodule
