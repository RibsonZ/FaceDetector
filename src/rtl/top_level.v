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
    input wire btnl, // INCREMENT THRESHOLD
    input wire btnc, // CAPTURE FRAME
    input wire btnr, // DECREMENT THRESHOLD
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
    inout ps2c,
    inout ps2d
    );
    
    wire clk_camera;
    wire clk_vga;
    wire xclk;
    wire clk_25;
    wire wren;
    wire resend;
    wire nblank;
    wire vsync;
    wire hsync;
    wire nsync;
    wire [14:0] rd_addr, wr_addr; //integral image addresses
    wire rst_vga, rst_camera, rst;
    wire locked;
    reg write_en;
    wire [19:0] ii_wrdata, ii_rddata, ii_rddata_a;
    wire [11:0] rgb_display_data;
    wire continue, decrement_threshold, increment_threshold;
    wire detect_en;
    wire cap_done; // out from ii_cap
    wire detect_done; // out from detect
    wire [14:0] address_a; // into buff
    wire wea; //into buff
    wire [19:0] classifier_rd_addr;
    wire detected_flag;
    wire [11:0] vcnt, hcnt;
    wire [11:0] rgb_display_out;
    wire nblank_out;
    wire left, middle, right;
    wire mouse_left, mouse_right;
    
    assign led = detected_flag;
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
    
    MouseCtl #(.SYSCLK_FREQUENCY(25000000),.DATA_WIDTH(64))
    u1_MouseCtl (
        .clk(ov7670_pclk),
        .rst(rst),
        .xpos(),
        .ypos(),
        .zpos(),
        .left(left),
        .middle(middle),
        .right(right),
        .new_event(),
        .value(0),
        .setx(0),
        .sety(0),
        .setmax_x(0),
        .setmax_y(0),
        .ps2_clk(ps2c),
        .ps2_data(ps2d)
    );
    
    control_module u1_control_module(
        .clk(ov7670_pclk),
        .rst(rst),
        .mouse_left(mouse_left), //debounced
        .mouse_right(mouse_right), //debounced
        .continue(continue)
    );
    
    integral_image_display u1_integral_image_display(
        .rst(rst),
        .clk_vga(clk_vga),
        .vga_hsync(hsync),
        .vsync_out(vsync),
        .nblank(nblank),
        .nsync(nsync),
        .rgb(rgb_display_data),
        .rd_addr(rd_addr),
        .ii_rddata(ii_rddata),
        .hcnt_out(hcnt),
        .vcnt_out(vcnt)
    );
    
    draw_rectangle ul_draw_rectangle(
        .rst(rst),
        .pclk(clk_vga),
        .hcount_in(hcnt),
        .vcount_in(vcnt),
        .hsync_in(hsync),
        .vsync_in(vsync),
        .hblnk_in(!nblank),
        .vblnk_in(!nblank),
        .rgb_in(rgb_display_data),
        .hsync_out(vga_hsync),
        .vsync_out(vga_vsync),
        .rgb_out(rgb_display_out),
        .nblank_out(nblank_out),
        .detected_flag(detected_flag),
        .continuous(continue),
        .hblnk_out(),
        .vblnk_out(),
        .vcount_out(),
        .hcount_out()
    );
    
    debounce u2_debounce_increment(
        .rst(rst),
        .clk(ov7670_pclk),
        .i(btnl),
        .o(increment_threshold)
    );
    
    debounce u3_debounce_decrement(
        .rst(rst),
        .clk(ov7670_pclk),
        .i(btnr),
        .o(decrement_threshold)
    );
    
    debounce u4_debounce(
        .rst(rst),
        .clk(ov7670_pclk),
        .i(left),
        .o(mouse_left)
    );
        
    debounce u5_debounce(
        .rst(rst),
        .clk(ov7670_pclk),
        .i(right),
        .o(mouse_right)
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
        .addra(address_a), //14:0, write address
        .clka(ov7670_pclk),
        .dina(ii_wrdata), //19:0, input data
        .douta(ii_rddata_a),
        .wea(wea), //write enable
        /* BRAM_PORTB */
        .addrb(rd_addr), //14:0, read address
        .clkb(clk_vga),
        .dinb(0),
        .doutb(ii_rddata), //19:0, output data
        .web(0)
    );

    integral_image_capture u1_integral_image_capture(
        .ov7670_pclk(ov7670_pclk),
        .rst(rst),
        .ov7670_vsync(ov7670_vsync),
        .ov7670_href(ov7670_href),
        .ov7670_data(ov7670_data),
        .we(wren),
        .ii_address(wr_addr),
        .cap_done(cap_done),
        .ii_wrdata(ii_wrdata)
    );
    
    RGB u1_RGB(
        .din(rgb_display_out),
        .nblank(nblank_out),
        .r(vga_r),
        .g(vga_g),
        .b(vga_b)
    );
    
    
    detection_sm u1_detection_sm(
        .clk(ov7670_pclk),
        .rst(rst),
        .cap_done(cap_done),
        .detect_done(detect_done),
        .continue(continue),
        .write_en_in(wren),
        .wr_addr(wr_addr),
        .classifier_rd_addr(classifier_rd_addr),
        .detect_en(detect_en),
        .address_a_out(address_a), // goes to ii_buffer
        .write_en_out(wea)
    );
    
    cascade dut_cascade(
        .clk(ov7670_pclk),
        .rst(rst),
        .detect_en(detect_en),
        .detect_done(detect_done), //out
        .data_in( {1'b0, ii_rddata_a} ), //conversion to signed //in //ii_rddata_a
        .rd_addr(classifier_rd_addr), //out
        .detected_flag(detected_flag), //out
        .increment_threshold(increment_threshold),
        .decrement_threshold(decrement_threshold)
    );
    
endmodule
