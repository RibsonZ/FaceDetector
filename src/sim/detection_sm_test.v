`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2021 01:54:47 PM
// Design Name: 
// Module Name: detection_sm_test
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


module detection_sm_test();
    
    integer i;
    
    reg clk = 0;
    reg rst = 0;
    
    always begin
        #5 clk = !clk;
    end
    
    initial begin
        #5
        rst = 1;
        @(posedge clk)
        rst = 0;
    end
    
    wire detect_en;
    wire detect_done;
    wire [14:0] rd_addr; // tracks counter
    wire detected_flag; // success every other run
    reg cap_done=0; // set after frame captured
    reg btnl=0;
    
    classifier dut_classifier(
        .clk(clk),
        .rst(rst),
        .detect_en(detect_en), //in
        .detect_done(detect_done), //out
        .data_in(7), //in
        .rd_addr(rd_addr), //out
        .detected_flag(detected_flag) //out
    );
    
    detection_sm dut_detection_sm(
        .clk(clk),
        .rst(rst),
        .cap_done(cap_done),
        .detect_done(detect_done),
        .continue(btnl),
        .write_en_in(1),
        .wr_addr(14'h44),
        .classifier_rd_addr(rd_addr),
        .detect_en(detect_en),
        .address_a_out(),
        .write_en_out()
    );
    
    always begin
        #100
        // leave idle
        btnl = 1;
        @(posedge clk)
        btnl <= 0;
        #10
        @(posedge clk)
        cap_done <= 1;
        // idle left
        for (i = 0 ; i < 5 ; i = i +1)
            @(posedge clk);
        cap_done <= 0;
        $display("CHECK IF wr_addr == 44, if state is capture, despite prolonged cap_done presence.");
        $stop;
        #10
        @(posedge clk)
        cap_done <= 1;
        #20
        @(posedge clk)
        cap_done <= 0;
        @(posedge clk)
        $display("check if rising edge was correctly detected and state transitioned to detect");
        $stop;
        @(detect_done)
        @(posedge clk)
        $display("detect_done has changed. check if state is idle");
        $stop;
    end
    
//    initial begin
//        #50
//        //start detection
//        @(posedge clk)
//        detect_en <= 1;
//        #1000
//        $stop;
//    end
    
//    always @(posedge detect_done) begin
//        detect_en = 0;
//    end
    
endmodule
