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


module UART(clk_in, rx_data, data, data_rdy, reset, send, tx_data, send_data, send_rdy);

input clk_in, rx_data, reset, send;
input [7:0] send_data;

output data_rdy, send_rdy, tx_data;

output wire [7:0] data;

wire clk_div;
wire [7:0] data_link;
wire ready_link;

clk_divider div1(.clk_in(clk_in), .clk_out(clk_div));

receiver rec1(.clk_in(clk_div), .data_rdy(data_rdy), .rx_data(rx_data), .data(data), .reset(reset));

transmitter tran1(.clk_in(clk_div), .send(send), .reset(reset), .send_data(send_data), .send_rdy(send_rdy), .tx_data(tx_data));

endmodule
