`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2021 07:15:35 PM
// Design Name: 
// Module Name: integral_image_capture_test
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


module integral_image_capture_test();
    
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
    
    always @(posedge ov7670_vsync) begin
        $stop;
    end
    
    camera_simulator u1_camera_simulator(
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
    
    integral_image_buffer dut_integral_image_buffer(
        /* BRAM_PORTA */
        .addra(wr_addr), //14:0, write address
        .clka(ov7670_pclk),
        .dina(ii_wrdata), //19:0, input data
        .wea(wren[0]), //write enable
        /* BRAM_PORTB */
        .addrb(), //14:0, read address
        .clkb(),
        .doutb() //19:0, output data
    );

endmodule
