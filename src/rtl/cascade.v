`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH UST
// Engineer: Wojciech Zebrowski
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
//  adjust VARS, STATES, INSTANCES, STATE LOGIC
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
    DETECT_4 = 4'h4,
    DETECT_5 = 4'h5,
    DETECT_6 = 4'h6,
    DETECT_7 = 4'h7,
    DETECT_8 = 4'h8,
    DETECT_9 = 4'h9,
    RETURN = 4'hF,
    II_WIDTH = 160,
    II_HEIGHT = 120;
    
    reg signed [4:0] result, result_nxt; // -16 : 15
    
    reg [3:0] state, state_nxt;
    
    reg detected_flag_nxt;
    reg detect_done_nxt;
    reg detect_en_z, detect_en_z_nxt;
    
    /* CLASSIFIER 1 VARS */
    reg detect_en_1, detect_en_1_nxt;
    wire detect_done_1;
    wire [14:0] rd_addr_1;
    wire detected_flag_1;
    /*********************/
    
    /* CLASSIFIER 2 VARS */
    reg detect_en_2, detect_en_2_nxt;
    wire detect_done_2;
    wire [14:0] rd_addr_2;
    wire detected_flag_2;
    /*********************/
    
    /* CLASSIFIER 3 VARS */
    reg detect_en_3, detect_en_3_nxt;
    wire detect_done_3;
    wire [14:0] rd_addr_3;
    wire detected_flag_3;
    /*********************/
    
    /* CLASSIFIER 4 VARS */
    reg detect_en_4, detect_en_4_nxt;
    wire detect_done_4;
    wire [14:0] rd_addr_4;
    wire detected_flag_4;
    /*********************/
    
    /* CLASSIFIER 5 VARS */
    reg detect_en_5, detect_en_5_nxt;
    wire detect_done_5;
    wire [14:0] rd_addr_5;
    wire detected_flag_5;
    /*********************/
    
    /* CLASSIFIER 6 VARS */
    reg detect_en_6, detect_en_6_nxt;
    wire detect_done_6;
    wire [14:0] rd_addr_6;
    wire detected_flag_6;
    /*********************/
    
    /* CLASSIFIER 7 VARS */
    reg detect_en_7, detect_en_7_nxt;
    wire detect_done_7;
    wire [14:0] rd_addr_7;
    wire detected_flag_7;
    /*********************/
    
    /* CLASSIFIER 8 VARS */
    reg detect_en_8, detect_en_8_nxt;
    wire detect_done_8;
    wire [14:0] rd_addr_8;
    wire detected_flag_8;
    /*********************/
    
    /* CLASSIFIER 9 VARS */
    reg detect_en_9, detect_en_9_nxt;
    wire detect_done_9;
    wire [14:0] rd_addr_9;
    wire detected_flag_9;
    /*********************/
    
    
    classifier_2x2 u1_classifier(
        .address_0( 41 + 20 + 36 * II_WIDTH),
        .address_1( 41 + 20 + 24 * II_WIDTH),
        .address_2(  4 + 20 + 36 * II_WIDTH),
        .address_3(  4 + 20 + 24 * II_WIDTH),
        .address_4( 78 + 20 + 36 * II_WIDTH),
        .address_5( 78 + 20 + 24 * II_WIDTH),
        .address_6(  4 + 20 + 48 * II_WIDTH),
        .address_7( 41 + 20 + 48 * II_WIDTH),
        .address_8( 78 + 20 + 48 * II_WIDTH),
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
    
    classifier_1x2 u2_classifier(
        .address_0(120 + 20 + 50 * II_WIDTH),
        .address_1(55 + 20 + 50 * II_WIDTH),
        .address_2(120 + 20 + 28 * II_WIDTH),
        .address_3(55 + 20 + 28 * II_WIDTH),
        .address_4(120 + 20 + 72 * II_WIDTH),
        .address_5(55 + 20 + 72 * II_WIDTH),
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
        
    classifier_3x1 u3_classifier(
        .address_0( 41 + 20 + 35 * II_WIDTH),
        .address_1( 41 + 20 +  10 * II_WIDTH),
        .address_2( 3 + 20 + 35 * II_WIDTH),
        .address_3( 3 + 20 +  10 * II_WIDTH),
        .address_4( 79 + 20 + 35 * II_WIDTH),
        .address_5( 79 + 20 +  10 * II_WIDTH),
        .address_6(117 + 20 + 35 * II_WIDTH),
        .address_7(117 + 20 +  10 * II_WIDTH),
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
    
    classifier_2x2 u4_classifier(
        .address_0( 51 + 20 + 57 * II_WIDTH),
        .address_1( 51 + 20 +  35 * II_WIDTH),
        .address_2( 39 + 20 + 57 * II_WIDTH),
        .address_3( 39 + 20 +  35 * II_WIDTH),
        .address_4( 63 + 20 + 57 * II_WIDTH),
        .address_5( 63 + 20 +  35 * II_WIDTH),
        .address_6(39 + 20 + 79 * II_WIDTH),
        .address_7(51 + 20 +  79 * II_WIDTH),
        .address_8(63 + 20 +  79 * II_WIDTH),
        .clk(clk),
        .rst(rst),
        .detect_en(detect_en_4), //in
        .detect_done(detect_done_4), //out
        .data_in(data_in), //conversion to signed //in //ii_rddata_a
        .rd_addr(rd_addr_4), //out
        .detected_flag(detected_flag_4), //out
        .increment_threshold(increment_threshold),
        .decrement_threshold(decrement_threshold)
    );
    
    classifier_2x1 u5_classifier(
        .address_0( 60 + 20 + 65 * II_WIDTH),
        .address_1( 60 + 20 +  30 * II_WIDTH),
        .address_2( 43 + 20 + 65 * II_WIDTH),
        .address_3( 43 + 20 +  30 * II_WIDTH),
        .address_4( 77 + 20 + 65 * II_WIDTH),
        .address_5( 77 + 20 +  30 * II_WIDTH),
        .clk(clk),
        .rst(rst),
        .detect_en(detect_en_5), //in
        .detect_done(detect_done_5), //out
        .data_in(data_in), //conversion to signed //in //ii_rddata_a
        .rd_addr(rd_addr_5), //out
        .detected_flag(detected_flag_5), //out
        .increment_threshold(increment_threshold),
        .decrement_threshold(decrement_threshold)
    );
    
    classifier_3x1 u6_classifier(
        .address_0( 37 + 20 + 98 * II_WIDTH),
        .address_1( 37 + 20 +  73 * II_WIDTH),
        .address_2( 4 + 20 + 98 * II_WIDTH),
        .address_3( 4 + 20 +  73 * II_WIDTH),
        .address_4( 69 + 20 + 73 * II_WIDTH),
        .address_5( 69 + 20 +  73 * II_WIDTH),
        .address_6(103 + 20 + 98 * II_WIDTH),
        .address_7(103 + 20 +  73 * II_WIDTH),
        .clk(clk),
        .rst(rst),
        .detect_en(detect_en_6), //in
        .detect_done(detect_done_6), //out
        .data_in(data_in), //conversion to signed //in //ii_rddata_a
        .rd_addr(rd_addr_6), //out
        .detected_flag(detected_flag_6), //out
        .increment_threshold(increment_threshold),
        .decrement_threshold(decrement_threshold)
    );
    
    classifier_2x2 u7_classifier(
        .address_0( 42 + 20 + 36 * II_WIDTH),
        .address_1( 42 + 20 +  24 * II_WIDTH),
        .address_2( 30 + 20 + 36 * II_WIDTH),
        .address_3( 30 + 20 +  24 * II_WIDTH),
        .address_4( 54 + 20 + 36 * II_WIDTH),
        .address_5( 54 + 20 +  24 * II_WIDTH),
        .address_6(30 + 20 + 48 * II_WIDTH),
        .address_7(42 + 20 +  48 * II_WIDTH),
        .address_8(54 + 20 +  48 * II_WIDTH),
        .clk(clk),
        .rst(rst),
        .detect_en(detect_en_7), //in
        .detect_done(detect_done_7), //out
        .data_in(data_in), //conversion to signed //in //ii_rddata_a
        .rd_addr(rd_addr_7), //out
        .detected_flag(detected_flag_7), //out
        .increment_threshold(increment_threshold),
        .decrement_threshold(decrement_threshold)
    );
    
    classifier_2x2 u8_classifier(
        .address_0( 22 + 20 + 36 * II_WIDTH),
        .address_1( 22 + 20 +  19 * II_WIDTH),
        .address_2( 0 + 20 + 36 * II_WIDTH),
        .address_3( 0 + 20 +  19 * II_WIDTH),
        .address_4( 44 + 20 + 36 * II_WIDTH),
        .address_5( 44 + 20 +  19 * II_WIDTH),
        .address_6(0 + 20 + 53 * II_WIDTH),
        .address_7(22 + 20 +  53 * II_WIDTH),
        .address_8(44 + 20 +  53 * II_WIDTH),
        .clk(clk),
        .rst(rst),
        .detect_en(detect_en_8), //in
        .detect_done(detect_done_8), //out
        .data_in(data_in), //conversion to signed //in //ii_rddata_a
        .rd_addr(rd_addr_8), //out
        .detected_flag(detected_flag_8), //out
        .increment_threshold(increment_threshold),
        .decrement_threshold(decrement_threshold)
    );
    
    classifier_1x2 u9_classifier(
        .address_0( 88 + 20 + 51 * II_WIDTH),
        .address_1( 64 + 20 +  51 * II_WIDTH),
        .address_2( 88 + 20 + 29 * II_WIDTH),
        .address_3( 64 + 20 +  29 * II_WIDTH),
        .address_4( 88 + 20 + 73 * II_WIDTH),
        .address_5( 64 + 20 +  73 * II_WIDTH),
        .clk(clk),
        .rst(rst),
        .detect_en(detect_en_9), //in
        .detect_done(detect_done_9), //out
        .data_in(data_in), //conversion to signed //in //ii_rddata_a
        .rd_addr(rd_addr_9), //out
        .detected_flag(detected_flag_9), //out
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
            /* C4 */
            detect_en_4 <= 0;
            /******/
            /* C5 */
            detect_en_5 <= 0;
            /******/
            /* C6 */
            detect_en_6 <= 0;
            /******/
            /* C7 */
            detect_en_7 <= 0;
            /******/
            /* C8 */
            detect_en_8 <= 0;
            /******/
            /* C9 */
            detect_en_9 <= 0;
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
            /* C4 */
            detect_en_4 <= detect_en_4_nxt;
            /******/
            /* C5 */
            detect_en_5 <= detect_en_5_nxt;
            /******/
            /* C6 */
            detect_en_6 <= detect_en_6_nxt;
            /******/
            /* C7 */
            detect_en_7 <= detect_en_7_nxt;
            /******/
            /* C8 */
            detect_en_8 <= detect_en_8_nxt;
            /******/
            /* C9 */
            detect_en_9 <= detect_en_9_nxt;
            /******/
        end
    end
    
    always @* begin
        
        detect_en_z_nxt = detect_en;
        result_nxt = result;
        detect_done_nxt = detect_done;
        detected_flag_nxt = detected_flag;
        detect_en_1_nxt = 0;
        detect_en_2_nxt = 0;
        detect_en_3_nxt = 0;
        detect_en_4_nxt = 0;
        detect_en_5_nxt = 0;
        detect_en_6_nxt = 0;
        detect_en_7_nxt = 0;
        detect_en_8_nxt = 0;
        detect_en_9_nxt = 0;
        state_nxt = state;
        rd_addr = 0;
        
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
                        state_nxt = DETECT_4;
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
            DETECT_4:
                begin
                    rd_addr = rd_addr_4; // combi
                    detect_en_4_nxt = 1;
                    
                    if (detect_done_4) begin
                        detect_en_4_nxt = 0;
                        state_nxt = DETECT_5;
                        if (detected_flag_4) begin
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
            DETECT_5:
                begin
                    rd_addr = rd_addr_5; // combi
                    detect_en_5_nxt = 1;
                    
                    if (detect_done_5) begin
                        detect_en_5_nxt = 0;
                        state_nxt = DETECT_6;
                        if (detected_flag_5) begin
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
            DETECT_6:
                begin
                    rd_addr = rd_addr_6; // combi
                    detect_en_6_nxt = 1;
                    
                    if (detect_done_6) begin
                        detect_en_6_nxt = 0;
                        state_nxt = DETECT_7;
                        if (detected_flag_6) begin
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
            DETECT_7:
                begin
                    rd_addr = rd_addr_7; // combi
                    detect_en_7_nxt = 1;
                    
                    if (detect_done_7) begin
                        detect_en_7_nxt = 0;
                        state_nxt = DETECT_8;
                        if (detected_flag_7) begin
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
            DETECT_8:
                begin
                    rd_addr = rd_addr_8; // combi
                    detect_en_8_nxt = 1;
                    
                    if (detect_done_8) begin
                        detect_en_8_nxt = 0;
                        state_nxt = DETECT_9;
                        if (detected_flag_8) begin
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
            DETECT_9:
                begin
                    rd_addr = rd_addr_9; // combi
                    detect_en_9_nxt = 1;
                    
                    if (detect_done_9) begin
                        detect_en_9_nxt = 0;
                        state_nxt = RETURN;
                        if (detected_flag_9) begin
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
