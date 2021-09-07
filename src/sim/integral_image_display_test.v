`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2021 02:50:03 PM
// Design Name: 
// Module Name: integral_image_display_test
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


module integral_image_display_test();
    
    wire [14:0] wr_addr;
    reg rst;
    wire [0:0] wren;
    wire [31:0] ii_wrdata;
    wire [7:0] ov7670_data;
    wire ov7670_vsync, ov7670_href;
    
    wire ov7670_pclk;
    
    initial begin
        $monitor("ii_cap.col_ctr: %d, wr_addr: %d, ii_wrdata: %d, ii_wrdata/11: %d", dut_integral_image_capture.col_ctr, wr_addr, ii_wrdata, ii_wrdata/11);
        rst = 1;
        @(posedge ov7670_pclk)
        rst = 0;
    end
    
    reg [31:0] log_ii_wrdata = 0;
    reg [31:0] log_ii_wrdata_z = 0;
//    reg [31:0] log_row_ctr = 0;
//    reg [31:0] log_row_ctr_z = 0;
        
    
    // detects lack of monotonicity of iiwrdata except for when its caused by a row change
    
    always@ii_wrdata begin
        log_ii_wrdata_z = log_ii_wrdata;
        log_ii_wrdata = ii_wrdata;
        
//        log_row_ctr_z = log_row_ctr;
//        log_row_ctr = dut_integral_image_capture.row_ctr;
        
        
        if ((dut_integral_image_capture.col_ctr < 154 && dut_integral_image_capture.col_ctr > 3 /*row didnt change*/)
            && log_ii_wrdata < log_ii_wrdata_z /*monotonicity lost*/)begin
            $display("monotonicity lost!");
            $stop;
        end
    end
    
    reg save_done = 0; // save_done flag
    reg rw_sel = 1;
    
    always @(posedge ov7670_vsync) begin
        save_done = 1;
        rw_sel = 0;
        $display("SAVE DONE!");
        $stop;
    end
    
    camera_simulator u1_camera_simulator(
        .en(!save_done),
        .sim_pclk(ov7670_pclk),
        .sim_vsync(ov7670_vsync),
        .sim_href(ov7670_href),
        .sim_data(ov7670_data)
    );
    
    integral_image_capture dut_integral_image_capture(
        .ov7670_pclk(ov7670_pclk),
        .rst(rst),
        .ov7670_vsync(ov7670_vsync),
        .ov7670_href(ov7670_href),
        .ov7670_data(ov7670_data),
        .we(wren[0]),
        .ii_address(wr_addr),
        .ii_wrdata(ii_wrdata)
    );
    

    
    reg clk_vga = 0;
    
    always begin // clock if save_done
        #5 clk_vga = save_done ? !clk_vga : clk_vga;
    end
    
    wire [14:0] rd_addr;
    wire [19:0] ii_rddata; 
    wire [11:0] rgb;
    wire vga_vsync, vga_hsync;
    
    reg rst_vga; // initialize vga module
    
    initial begin
        @(save_done)
        rst_vga = 1;
        #10
        rst_vga = 0;
    end
    
    initial begin
        $monitor("rd_addr: %d, rgb[3:0]: %d", rd_addr, rgb[3:0]);
    end
    
    integral_image_display dut_integral_image_display(
        .rst(rst_vga),
        .clk_vga(clk_vga),
        .vga_hsync(vga_hsync),
        .vsync(vga_vsync),
        .nblank(),
        .nsync(),
        .rgb(rgb),
        .rd_addr(rd_addr),
        .ii_rddata(ii_rddata)
    );
    
    always @(vga_hsync) begin
        $stop;
    end
    
    integral_image_buffer dut_integral_image_buffer(
        /* BRAM_PORTA */
        .addra(wr_addr), //14:0, write address
        .clka(ov7670_pclk),
        .dina(ii_wrdata), //19:0, input data
        .wea(wren[0]), //write enable
        .ena(rw_sel),
        /* BRAM_PORTB */
        .addrb(rd_addr), //14:0, read address
        .clkb(clk_vga),
        .doutb(ii_rddata) //19:0, output data
    );

endmodule
