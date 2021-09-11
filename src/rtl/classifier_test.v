`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2021 12:38:43 PM
// Design Name: 
// Module Name: classifier
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


/* PLACEHOLDER MODULE FOR TESTS */

module classifier_test(
    input clk,
    input rst,
    input detect_en, // from detection_sm, says when to leave idle
    output reg detect_done, // to detection_sm, says when detection is over
    input [19:0] data_in, // data_in from buffer, 3 clock cycles delayed relativer to address
    output reg [14:0] rd_addr, // address passed to buffer by detection_sm when detect_en
    output reg detected_flag // flag to let detection_sm know, that detection is over
    );
    
    localparam
    DELAY = 16;
    
    reg [7:0] counter;
    reg result;
    reg detect_en_z;
    
    always @(posedge clk) begin
        if (rst) begin
            detected_flag <= 0;
            rd_addr <= 0;
            detect_en_z <= 0;
            result <= 0;
            detect_done <= 0;
            counter <= 0;
        end
        else begin
            if(detect_en) begin
                if(!detect_en_z) begin// rising edge
                    counter <= 0;
                    result <= !result; // positive every other run
                end
                else if(counter == DELAY) begin
                    detected_flag <= result;
                    detect_done <= 1;
                end
                else begin
                    counter <= counter + 1;
                end
            end
            else begin
                detect_done <= 0;
            end
            rd_addr <= counter;
            detect_en_z <= detect_en;
        end
    end
    
endmodule
