`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2021 02:25:57 AM
// Design Name: 
// Module Name: draw_rect_test
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


module draw_rect_test();
    
    reg rst = 0, clk_vga = 0;
    reg [7:0] hcnt, vcnt;
    reg hsync, vsync;
    reg nblank;
    reg rgb_display_data = 0;
    wire vga_hsync;
    wire vga_vsync;
    wire rgb_display_out;
    wire nblank_out;
    
    always
        #5 clk_vga = !clk_vga;
    
    initial begin
        rst = 1;
        #20
        rst = 0;
        
        vcnt = 200;
        while(i < 160) begin
            i = i + 1;
            $stop;
        end
    end
    
    
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
        .detected_flag(),
        .continuous(),
        .hblnk_out(),
        .vblnk_out(),
        .vcount_out(),
        .hcount_out()
    );
    
    
    
endmodule
