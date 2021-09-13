`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2021 07:03:52 PM
// Design Name: 
// Module Name: cascade_test
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2021 01:23:47 PM
// Design Name: 
// Module Name: detection_system_test
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


module cascade_test();
    
    wire [14:0] wr_addr;
    reg rst;
    wire wren;
    wire [7:0] ov7670_data;
    wire ov7670_vsync, ov7670_href;
    wire ov7670_pclk;
    wire wea;
    integer i;
    wire [14:0] address_a;
    wire [19:0] ii_wrdata;
    wire [19:0] ii_rddata_a;
    wire cap_done;
    wire detect_en;
    wire detect_done;
    wire [14:0] classifier_rd_addr;
    wire detected_flag;
    reg btnl=0;
    reg increment_threshold = 0;
    reg decrement_threshold = 0;
    
    integral_image_buffer dut_integral_image_buffer(
        /* BRAM_PORTA */
        .addra(address_a), //14:0, write address
        .clka(ov7670_pclk),
        .dina(ii_wrdata), //19:0, input data
        .douta(ii_rddata_a),
        .wea(wea), //write enable
        /* BRAM_PORTB */
        .addrb(0), //14:0, read address
        .clkb(0),
        .doutb(), //19:0, output data
        .web(0)
    );

    integral_image_capture dut_integral_image_capture(
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
    
    reg en_pattern = 0;
    
    camera_simulator u1_camera_simulator(
        .en_pattern(en_pattern),
        .en(1),
        .sim_pclk(ov7670_pclk),
        .sim_vsync(ov7670_vsync),
        .sim_href(ov7670_href),
        .sim_data(ov7670_data)
    );
    
    reg [19:0] test_data_in;
    
    reg [14:0] classifier_rd_addr_z, classifier_rd_addr_z_z;
    
    always@(posedge ov7670_pclk) begin
        classifier_rd_addr_z <= classifier_rd_addr;
        classifier_rd_addr_z_z <= classifier_rd_addr_z;
    end
    
    always@(posedge ov7670_pclk) begin
        case(classifier_rd_addr_z)
            1: test_data_in <= 5;
            9599: test_data_in <= 5000;
            9600: test_data_in <= 4900;
            19199: test_data_in <= 6000;
            default: test_data_in <= 0;
        endcase
            
    end
    
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
    
//    classifier dut_classifier(
//        .clk(ov7670_pclk),
//        .rst(rst),
//        .detect_en(detect_en), //in
//        .detect_done(detect_done), //out
//        .data_in( {1'b0, ii_rddata_a} ), //conversion to signed //in //ii_rddata_a
//        .rd_addr(classifier_rd_addr), //out
//        .detected_flag(detected_flag), //out
//        .increment_threshold(increment_threshold),
//        .decrement_threshold(decrement_threshold)
//    );
    
    detection_sm dut_detection_sm(
        .clk(ov7670_pclk),
        .rst(rst),
        .cap_done(cap_done),
        .detect_done(detect_done),
        .continue(btnl),
        .write_en_in(wren),
        .wr_addr(wr_addr),
        .classifier_rd_addr(classifier_rd_addr),
        .detect_en(detect_en),
        .address_a_out(address_a),
        .write_en_out(wea)
    );
    
    initial begin
        #5
        rst = 1;
        @(posedge ov7670_pclk)
        rst = 0;
    end
    
    always begin
        #100
        @(posedge ov7670_pclk)
        btnl = 1;
        @(posedge ov7670_pclk)
        btnl = 0;
        @(cap_done) ;
        @(posedge ov7670_pclk) ;
        @(posedge ov7670_pclk) ;
        $display("Idle left?");
        $stop;
//        // threshold control test
//        #100
//        @(posedge ov7670_pclk) ;
//        increment_threshold = 1;
//        @(posedge ov7670_pclk) ;
//        increment_threshold = 0;
//        @(posedge ov7670_pclk) ;
//        @(posedge ov7670_pclk) ;
//        $display("Check if threshold of classifier was incremented.");
//        $stop;
        
//        #100
//        @(posedge ov7670_pclk) ;
//        decrement_threshold = 1;
//        @(posedge ov7670_pclk) ;
//        decrement_threshold = 0;
//        @(posedge ov7670_pclk) ;
//        @(posedge ov7670_pclk) ;
//        $display("Check if threshold of classifier was decremented.");
//        $stop;
        
        @(posedge cap_done)
        $display("cap_done set.");
        @(posedge ov7670_pclk);
        @(posedge ov7670_pclk);
        $display("State should be detect");
        $stop;
        @(posedge detect_done)
        $display("detect_done set.");
        @(posedge ov7670_pclk);
        @(posedge ov7670_pclk);
        $display("State should be idle again. Check detection_flag (result of detection) as well as score.");
        en_pattern = ! en_pattern;
        $display("Next run is with the pattern toggled.");
        $stop;
    end
    
endmodule

