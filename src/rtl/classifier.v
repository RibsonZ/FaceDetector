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

module classifier(
    input clk,
    input rst,
    input detect_en, // from detection_sm, says when to leave idle
    output reg detect_done, // to detection_sm, says when detection is over, active for one clk cycle
    input [20:0] data_in, // data_in from buffer, 3 clock cycles delayed relativer to address
    output reg [14:0] rd_addr, // address passed to buffer by detection_sm when detect_en
    output reg detected_flag // result, set in compute_score state
    );
    
    localparam
    DATA_POINTS_NO = 14'b0,
    DELAY = 16,
    IDLE = 3'b001,
    COLLECT_DATA = 3'b010,
    COMPUTE_SCORE = 3'b100,
    THRESHOLD = 500;
    
    reg [7:0] counter, counter_nxt;
    reg detect_en_nxt, detect_done_nxt;
    reg [2:0] state, state_nxt;
    reg [14:0] addresses [DATA_POINTS_NO-1:0];
    reg [14:0] rd_addr_nxt;
    reg [20:0] data [DATA_POINTS_NO-1:0];
    reg [20:0] data_nxt [DATA_POINTS_NO-1:0];
    reg [20:0] score, score_nxt;
    reg [20:0] data_in_nxt, detected_flag_nxt;
    integer i;
        
    always @(posedge clk) begin
        if (rst) begin
            for (i=0; i < DATA_POINTS_NO; i=i+1 )begin
                data[i] <= 0;
            end
            state <= IDLE;
            addresses[0] <= 0;
            addresses[1] <= 639;
            addresses[2] <= 480;
            addresses[3] <= 1119;
            counter <= 0;
            detect_done <= 0;
            rd_addr <= 0;
            score <= 0;
            end
        else begin
            for (i=0; i < DATA_POINTS_NO; i=i+1 )begin
                data[i] <= data_nxt[i];
            end
            counter <= counter_nxt;
            detect_done<= detect_done_nxt;
            rd_addr <= rd_addr_nxt;
            score <= score_nxt;
        end
    end
    
    always @* begin
        for (i=0; i < DATA_POINTS_NO; i=i+1 )begin
            data_nxt[i]=data[i];
        end
        
        case (state)
            IDLE: 
                begin
                    if (detect_en == 1) begin
                        state_nxt = COLLECT_DATA;
                    end
                    else begin
                        state_nxt = IDLE;
                        detect_done_nxt = 0;
                        detect_en_nxt = 0;
                    end
                end
            COLLECT_DATA:
                begin
                    if (counter == DATA_POINTS_NO - 1 + 3) begin
                        state_nxt = COMPUTE_SCORE;
                    end
                    else begin
                        rd_addr_nxt = (counter < DATA_POINTS_NO) ? addresses[counter] : 0;
                        for (i=0; i < DATA_POINTS_NO; i=i+1 )begin
                            if (i == counter - 3 ) begin
                                data_nxt[i] = data_in;
                            end
                            else begin
                                data_nxt[i]=data[i];
                            end
                        end
                        state_nxt = COLLECT_DATA;
                        end                    
                 end
            COMPUTE_SCORE:
                begin
                    score_nxt = (data[1]-data[0]) - (data[3]-data[2]);
                    detected_flag_nxt = score_nxt > THRESHOLD;
                    detect_done_nxt = 1;
                    state_nxt = IDLE;
                end                               
    endcase
    end   
endmodule
