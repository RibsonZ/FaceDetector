`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2021 07:10:56 PM
// Design Name: 
// Module Name: cascade
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


module cascade(
        input clk, // to classifiers
        input rst, // to classifiers
        input increment_threshold, // to classifiers
        input decrement_threshold, // to classifiers
        input detect_en, // from detection_sm, says when to leave idle
        output reg detect_done, // to detection_sm, says when detection is over, active for one clk cycle
        input wire signed [20:0] data_in, // data_in to classifiers
        output reg [14:0] rd_addr, // combinatorial output
        output reg detected_flag // result, set in RETURN state
    );
    
    localparam
    IDLE = 4'h0,
    DETECT_1 = 4'h1,
    DETECT_2 = 4'h2,
    DETECT_3 = 4'h3,
    RETURN = 4'hF;
    
    reg signed [4:0] result, result_nxt; // -16 : 15
    
    reg [3:0] state, state_nxt;
    
    reg detected_flag_nxt;
    reg detect_done_nxt;
    reg detect_en_z, detect_en_z_nxt;
    
    /* CLASSIFIER 1 VARS */
    reg detect_en_1, detect_en_1_nxt;
    wire detect_done_1;
//    wire signed [20:0] data_in_1;
    wire [14:0] rd_addr_1;
    wire detected_flag_1;
    /*********************/
    
    /* CLASSIFIER 2 VARS */
    reg detect_en_2, detect_en_2_nxt;
    wire detect_done_2;
//    wire signed [20:0] data_in_2;
    wire [14:0] rd_addr_2;
    wire detected_flag_2;
    /*********************/
    
    /* CLASSIFIER 3 VARS */
    reg detect_en_3, detect_en_3_nxt;
    wire detect_done_3;
//    wire signed [20:0] data_in_3;
    wire [14:0] rd_addr_3;
    wire detected_flag_3;
    /*********************/
    
    classifier u1_classifier(
        .clk(clk),
        .rst(rst),
        .detect_en(detect_en_1), //in
        .detect_done(detect_done_1), //out
        .data_in(data_in), //conversion to signed //in //ii_rddata_a
        .rd_addr(rd_addr_1), //out
        .detected_flag(detected_flag_1), //out
        .increment_threshold(increment_threshold),
        .decrement_threshold(decrement_threshold)
    );
    
    classifier u2_classifier(
        .clk(clk),
        .rst(rst),
        .detect_en(detect_en_2), //in
        .detect_done(detect_done_2), //out
        .data_in(data_in), //conversion to signed //in //ii_rddata_a
        .rd_addr(rd_addr_2), //out
        .detected_flag(detected_flag_2), //out
        .increment_threshold(increment_threshold),
        .decrement_threshold(decrement_threshold)
    );
        
    classifier u3_classifier(
        .clk(clk),
        .rst(rst),
        .detect_en(detect_en_3), //in
        .detect_done(detect_done_3), //out
        .data_in(data_in), //conversion to signed //in //ii_rddata_a
        .rd_addr(rd_addr_3), //out
        .detected_flag(detected_flag_3), //out
        .increment_threshold(increment_threshold),
        .decrement_threshold(decrement_threshold)
    );

    always @(posedge clk) begin
        if (rst) begin
            result <= 0;
            state <= IDLE;
            detected_flag <= 0;
            detect_done <= 0;
            detect_en_z <= 0;
            /* C1 */
            detect_en_1 <= 0;
            /******/
            /* C2 */
            detect_en_2 <= 0;
            /******/
            /* C3 */
            detect_en_3 <= 0;
            /******/
        end
        else begin
            result <= result_nxt;
            state <= state_nxt;
            detected_flag <= detected_flag_nxt;
            detect_done <= detect_done_nxt;
            detect_en_z <= detect_en_z_nxt;
            /* C1 */
            detect_en_1 <= detect_en_1_nxt;
            /******/
            /* C2 */
            detect_en_2 <= detect_en_2_nxt;
            /******/
            /* C3 */
            detect_en_3 <= detect_en_3_nxt;
            /******/
        end
    end
    
    always @* begin
        
        detect_en_z_nxt = detect_en;
        detect_en_1_nxt = detect_en_1;
        result_nxt = result;
        detect_done_nxt = detect_done;
        detected_flag_nxt = detected_flag;
        detect_en_1_nxt = 0;
        detect_en_2_nxt = 0;
        detect_en_3_nxt = 0;
        
        case(state)
            IDLE:
                begin
                    rd_addr = 0; // combi
                    
                    if (detect_en && !detect_en_z) begin
                        state_nxt = DETECT_1;
                    end
                    else begin
                        state_nxt = state;
                        detect_done_nxt = 0;
                    end
                end
            DETECT_1:
                begin
                    rd_addr = rd_addr_1; // combi
                    detect_en_1_nxt = 1;
                    
                    if (detect_done_1) begin
                        detect_en_1_nxt = 0;
                        state_nxt = DETECT_2;
                        if (detected_flag_1) begin
                            result_nxt = result + 1;
                        end
                        else begin
                            result_nxt = result - 1;
                        end
                    end
                    else begin
                        state_nxt = state;
                    end
                end
            DETECT_2:
                begin
                    rd_addr = rd_addr_2; // combi
                    detect_en_2_nxt = 1;
                    
                    if (detect_done_2) begin
                        detect_en_2_nxt = 0;
                        state_nxt = DETECT_3;
                        if (detected_flag_2) begin
                            result_nxt = result + 1;
                        end
                        else begin
                            result_nxt = result - 1;
                        end
                    end
                    else begin
                        state_nxt = state;
                    end
                end
            DETECT_3:
                begin
                    rd_addr = rd_addr_3; // combi
                    detect_en_3_nxt = 1;
                    
                    if (detect_done_3) begin
                        detect_en_3_nxt = 0;
                        state_nxt = RETURN;
                        if (detected_flag_3) begin
                            result_nxt = result + 1;
                        end
                        else begin
                            result_nxt = result - 1;
                        end
                    end
                    else begin
                        state_nxt = state;
                    end
                end
            RETURN:
                begin
                    rd_addr = 0; // combi
                    
                    detected_flag_nxt = result >= 0; // set if more positive results than negative
                    detect_done_nxt = 1;
                    state_nxt = IDLE;
                    result_nxt = 0;
                end
        endcase
    end
    
    
endmodule
