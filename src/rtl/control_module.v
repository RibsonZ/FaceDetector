`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2021 09:03:15 PM
// Design Name: 
// Module Name: control_module
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


module control_module(
    input clk,
    input rst,
    input mouse_left, // frame capture
    input mouse_right, // continuous toggle
    output reg continue
    );
    
    localparam
    CONTINUOUS = 0,
    SINGLE = 1;
    
    reg continue_nxt;
    reg state, state_nxt;
    
    always @(posedge clk) begin
        if (rst) begin
            continue <= 0;
            state <= CONTINUOUS;
        end
        else begin
            continue <= continue_nxt;
            state <= state_nxt;
        end
    end
    
    always @* begin
        continue_nxt = continue;
        state_nxt = state;
        
        case(state)
            CONTINUOUS:
                begin
                    continue_nxt = 1;
                    if (mouse_right) begin
                        state_nxt = SINGLE;
                    end
                    else begin
                        state_nxt = state;
                    end
                end
            SINGLE:
                begin
                    if (mouse_left) begin
                        continue_nxt = 1;
                    end
                    else begin
                        continue_nxt = 0;
                    end
                    
                    if (mouse_right) begin
                        state_nxt = CONTINUOUS;
                    end
                    else begin
                        state_nxt = state;
                    end
                end
        endcase
    end
    
endmodule
