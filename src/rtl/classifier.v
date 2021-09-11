`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH UST
// Engineer: Miko³aj Karelus
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

module classifier(
    input clk,
    input rst,
    input increment_threshold,
    input decrement_threshold,
    input detect_en, // from detection_sm, says when to leave idle
    output reg detect_done, // to detection_sm, says when detection is over, active for one clk cycle
    input wire signed [20:0] data_in, // data_in from buffer, 3 clock cycles delayed relativer to address
    output reg [14:0] rd_addr, // address passed to buffer by detection_sm when detect_en
    output reg detected_flag // result, set in compute_score state
    );
    
    /* TWO VERTICAL
    *
    *   -------------------------
    *   |       *-------*       |
    *   |       |       |       |
    *   |       *-------*       |
    *   |       |///////|       |
    *   |       *-------*       |
    *   -------------------------
    */
    
    
    localparam
    DATA_POINTS_NO = 6, // TWO VERTICAL : six datapoints necessary
    DELAY = 16,
    IDLE = 3'b001,
    COLLECT_DATA = 3'b010,
    COMPUTE_SCORE = 3'b100,
    THRESHOLD = 500,
    MAX_THRESHOLD = 160 * 120 * 21'h0F,
    II_WIDTH = 160,
    II_HEIGHT = 120;
    
    reg [7:0] counter, counter_nxt;
    reg detect_done_nxt;
    reg [2:0] state, state_nxt;
    reg [14:0] addresses [DATA_POINTS_NO-1:0];
    reg [14:0] rd_addr_nxt;
    reg signed [20:0] data [DATA_POINTS_NO-1:0];
    reg signed [20:0] data_nxt [DATA_POINTS_NO-1:0];
    reg signed [20:0] score;
    reg signed [20:0] threshold, threshold_nxt;
    reg detected_flag_nxt;
    reg detect_en_z, detect_en_z_nxt;
    integer i;
        
    always @(posedge clk) begin
        if (rst) begin
            for (i=0; i < DATA_POINTS_NO; i=i+1 )begin
                data[i] <= 0;
            end
            state <= IDLE;
            /* Numeration of pixels is left to right, top to bottom */
            addresses[0] <= II_WIDTH * 60 + II_WIDTH - 1; // positive bottom right / negative top right
            addresses[1] <= II_WIDTH * 60; // positive bottom left / negative top left
            addresses[2] <= II_WIDTH - 1; // positive top right
            addresses[3] <= 0; // positive top left
            addresses[4] <= II_WIDTH * (II_HEIGHT - 1) + II_WIDTH - 1;// negative bottom right
            addresses[5] <= II_WIDTH * (II_HEIGHT - 1);// negative bottom left
            counter <= 0;
            detect_done <= 0;
            rd_addr <= 0;
            detected_flag <= 0;
            detect_en_z <= 0;
            threshold <= THRESHOLD;
            end
        else begin
            for (i=0; i < DATA_POINTS_NO; i=i+1 )begin
                data[i] <= data_nxt[i];
            end
            state <= state_nxt;
            counter <= counter_nxt;
            detect_done<= detect_done_nxt;
            rd_addr <= rd_addr_nxt;
            detected_flag <= detected_flag_nxt;
            detect_en_z <= detect_en_z_nxt;
            threshold <= threshold_nxt;
        end
    end
    
    always @* begin
        for (i=0; i < DATA_POINTS_NO; i=i+1 )begin
            data_nxt[i] = data[i];
        end
        
        // difference between two discrete definite integrals of a flattened 2D function {address := grayscale value} (image)
        score = ( data[0] - data[1] - data[2] + data[3] ) - ( data[4] - data[5] - data[0] + data[1] );
        
        rd_addr_nxt = rd_addr;
        detected_flag_nxt = detected_flag;
        counter_nxt = counter;
        detect_done_nxt = detect_done;
        detect_en_z_nxt = detect_en;
        threshold_nxt = threshold;
        
        case (state)
            IDLE: 
                begin
                    if (increment_threshold) begin
                        threshold_nxt = (threshold + 100 < MAX_THRESHOLD) ? threshold + 100 : threshold;
                    end
                    
                    if (decrement_threshold) begin
                        threshold_nxt = (threshold - 100 > 0) ? threshold - 100 : threshold;
                    end
                    
                    if (detect_en && !detect_en_z) begin
                        state_nxt = COLLECT_DATA;
                    end
                    else begin
                        state_nxt = state;
                        detect_done_nxt = 0;
                    end
                end
            COLLECT_DATA:
                begin
                    rd_addr_nxt = (counter < DATA_POINTS_NO) ? addresses[counter] : 0;
                    for (i=0; i < DATA_POINTS_NO; i=i+1 )begin
                        if (i == counter - 3 ) begin
                            data_nxt[i] = data_in;
                        end
                        else begin
                            data_nxt[i]=data[i];
                        end
                    end
                    
                    if (counter == DATA_POINTS_NO - 1 + 3) begin
                        state_nxt = COMPUTE_SCORE;
                        counter_nxt = 0;
                    end
                    else begin
                        state_nxt = state;
                        counter_nxt = counter + 1;
                    end
                end
            COMPUTE_SCORE:
                begin
                    detected_flag_nxt = score > threshold;
                    detect_done_nxt = 1;
                    state_nxt = IDLE;
                end
    endcase
    end   
endmodule
