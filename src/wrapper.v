// Put the pieces together in this (hopefully) nice wrapper

module wrapper(
    input clk_in,
    input reset,
    input rx_data,
    output tx_data,
    output [15:0] p);

    wire serial_clk;
    wire data_rdy;
    wire [7:0] data_link;
    wire write_enable;
    wire [7:0] data_out;
    wire [7:0] addr;

    clock_wizard wizard1(
        .clk_in(clk_in), 
        .serial_clk(serial_clk));

    UART uart1(
        .clk_in(serial_clk), 
        .reset(reset), 
        .rx_data(rx_data), 
        .tx_data(tx_data), 
        .data(data_link), 
        .data_rdy(data_rdy));

    mem_ctrl memctrl1(
        .clk_in(clk_in), 
        .reset(reset), 
        .data_rdy(data_rdy),
        .data_in(data_link),
        .write_enable(write_enable),
        .data_out(data_out),
        .addr(addr)
    );

    memory mem1(
        .clk_in(clk_in),
        .reset(reset),
        .write_enable(write_enable),
        .addr(addr),
        .data(data_out),
        .p(p)
    );
endmodule