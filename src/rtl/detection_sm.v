`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AGH UST
// Engineer: Mikolaj Karelus
// 
// Create Date: 09/09/2021 10:55:08 AM
// Design Name: 
// Module Name: detection_sm
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


module detection_sm(
    input clk,
    input rst,
    input cap_done,
    input detect_done,
    input continue,
    input write_en_in,
    input [14:0] wr_addr, // write address from capture module, data goes straight to the memory block
    input [14:0] classifier_rd_addr, // read address from detect module
//    input [19:0] data_in, data will go straight to detection module
    output reg detect_en,
    output [14:0] address_a_out,
    output write_en_out//,
//    output reg led_out
    );
    
    localparam
    IDLE = 2'b00,
    CAPTURE = 2'b01,
    DETECT = 2'b10,
    
    WR_ADDR = 1,
    CLASSIFIER_RD_ADDR = 0;
    
    reg continue_latched, continue_latched_nxt;
    
    reg [1:0] state, state_nxt;
    
    reg addr_sel, addr_sel_nxt;
//    reg write_en_out_nxt;
//    reg led_out_nxt;
    reg detect_en_nxt;
    reg cap_done_z, cap_done_z_nxt;
    
    assign write_en_out = (state == CAPTURE) ? write_en_in : 0;
    assign address_a_out = addr_sel ? wr_addr : classifier_rd_addr;
    
    always@(posedge clk) begin
        if(rst) begin
            detect_en <= 0;
//            write_en_out <= 0;
            addr_sel <= 0;
            state <= IDLE;
            continue_latched <= 0;
            cap_done_z <= 0;
        end
        else begin
            state <= state_nxt;
//            write_en_out <= write_en_out_nxt;
            detect_en <= detect_en_nxt;
            addr_sel <= addr_sel_nxt;
            continue_latched <= continue_latched_nxt;
            cap_done_z <= cap_done_z_nxt;
        end
    end
    
    //Mealy - outputs result from this: states and inputs
    always @* begin
        continue_latched_nxt = continue_latched;
        cap_done_z_nxt = cap_done;
        detect_en_nxt = detect_en;
        state_nxt = state;
        addr_sel_nxt = addr_sel;
        case(state)
            IDLE: begin
                addr_sel_nxt = CLASSIFIER_RD_ADDR;
//                write_en_out_nxt = 0;
                detect_en_nxt = 0;
                
                if(continue) begin
                    continue_latched_nxt = 1;                    
                end
                
                if(continue_latched && cap_done) begin
                    state_nxt = CAPTURE;
                    continue_latched_nxt = 0;
                end
                else begin
                    state_nxt = state;
                end
            end
            CAPTURE: begin
                addr_sel_nxt = WR_ADDR;
//                write_en_out_nxt = write_en_in;
                detect_en_nxt = 0;
                
                if(cap_done && !cap_done_z) begin //rising edge
                    state_nxt = DETECT;
                end
                else begin
                    state_nxt = state;
                end
            end
            DETECT: begin
                addr_sel_nxt = CLASSIFIER_RD_ADDR;
//                write_en_out_nxt = 0;
                detect_en_nxt = 1;
                
                if(detect_done) begin
                    state_nxt = IDLE;
                end
                else begin
                    state_nxt = state;
                end
            end
            default: begin
            end
        endcase
    end
    
    
endmodule
