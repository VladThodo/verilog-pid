`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2023 06:42:22 PM
// Design Name: 
// Module Name: transmitter
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

// clk_in should be 16 * baud_rate

module transmitter(
    input send,
    input clk_in,
    input reset,
    input [7:0] send_data,
    output reg send_rdy,
    output reg tx_data);
    
    parameter idle = 0, start = 1, sending = 2, done = 3;
    
    reg [1:0] state = 2'b0;
    reg [7:0] send_cnt;
    reg [7:0] data;
    
    always @(state) begin
        case (state)
            idle:
                send_rdy <= 1'b1;
            start:
                send_rdy <= 1'b0;
            sending:
                send_rdy <= 1'b0;
            done:
                send_rdy <= 1'b0;
            default:
                send_rdy <= 1'b0;    
        endcase
    end
    
    always @(posedge clk_in or posedge reset) begin
        if (reset)
            state = idle;
        else
            case (state)
                idle: begin
                
                    tx_data = 1;
                    send_cnt = 8'b0;
                    
                    if(send == 1) 
                        state = start;
                    
                    end
                    
                start: begin
                    
                    tx_data = 0;
                    send_cnt = send_cnt + 1'b1;
                    data = send_data;
                    
                    if(send_cnt >= 16)
                        state = sending;
                    
                    end
                
                sending: begin
                    
                    tx_data <= data[0];
                    send_cnt = send_cnt + 1'b1;
                                      
                    if(send_cnt >= 143) 
                        state = done;
                    else if(send_cnt % 16 == 0)            
                            data = data >> 1;
                            
                    end
                    
                done: begin
                    
                    tx_data = 1;
                    send_cnt = send_cnt + 1'b1;
                    
                    if(send_cnt >= 160) 
                        state = idle;
                        
                    end
            endcase
    end
    
endmodule
