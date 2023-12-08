`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2023 05:27:18 PM
// Design Name: 
// Module Name: receiver
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


// clk_in freq should be equal to 16 * desired baud rate


module receiver(
    input rx_data,
    input clk_in,
    input reset,
    output reg [7:0] data,
    output reg data_rdy);
    
    reg [1:0] state = 1'b0;
    reg [7:0] clk_cnt;
    reg [3:0] init_cnt;
    
    parameter idle = 0, start = 1, receiving = 2, ready = 3;
    
    always @(state) begin
        case (state)
            idle:
                data_rdy <= 0;
            start:
                data_rdy <= 0;
            receiving:
                data_rdy <= 0;
            ready:
                data_rdy <= 1'b1;
            default:
                data_rdy <= 0;
        endcase
    end
    
    always @(posedge clk_in or posedge reset) begin
        if (reset)
            state = idle;
        else
            case (state)
                idle: begin
                    clk_cnt <= 8'b0;
                    init_cnt <= 4'b0;
                  
                    if (rx_data == 1'b0)
                        state = start;
                end
                
                start: begin
                
                    init_cnt = init_cnt + 1'b1;
                    
                    if (init_cnt >= 8)
                        state = receiving;
                        
                    end
                
                receiving: begin
                    
                    clk_cnt = clk_cnt + 1'b1;
                    
                    if (clk_cnt >= 143)
                        state = ready;
                    else if (clk_cnt % 16 == 0)
                        data = (data >> 1) | (rx_data << 7);
                        
                    end
                    
                ready: begin
                
                    clk_cnt = clk_cnt + 1'b1;
                    
                    if (clk_cnt >= 160) 
                        state = idle;
                    
                    end
                    
            endcase
    end
    
endmodule
