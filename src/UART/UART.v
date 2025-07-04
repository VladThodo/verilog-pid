`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2023 03:55:45 PM
// Design Name: 
// Module Name: PID_data
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


module UART(
    input clk_in,
    input clk_en, 
    input rx_data,
    input reset,
    input send,
    input [7:0] send_data,
    output data_rdy,
    output busy_o,
    output tx_data,
    output wire [7:0] data);


//wire clk_s;

//clk_divider div1(.clk_in(clk_in), .clk_out(clk_div));

receiver rec1(.clk_in(clk_in), .clk_en(clk_en), .data_rdy(data_rdy), .rx_data(rx_data), .data(data), .reset(reset));

transmitter tran1(.clk_in(clk_in), .clk_en(clk_en), .send(send), .reset(reset), .send_data(send_data), .busy_o(busy_o), .tx_data(tx_data));

endmodule
