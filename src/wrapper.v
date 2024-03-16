// Put the pieces together in this (hopefully) nice wrapper

module wrapper(
    input clk_in,
    input reset,
    input rx_data,
    output tx_data,
    output [15:0] p);

    wire serial_clk;
    (*mark_debug = "true" *) wire data_rdy;
    (*mark_debug = "true" *) wire [7:0] data_link;
    (*mark_debug = "true" *) wire write_enable;
    (*mark_debug = "true" *) wire [15:0] data_out;
    wire [7:0] addr;
    wire [7:0] r_addr;
    wire [15:0] r_data_o;
    wire ser_busy;
    wire ser_send;
    wire [7:0] ser_data_send;
    
    assign clk = clk_in;

    clock_wizard wizard1(
        .clk_in(clk_in), 
        .serial_clk(serial_clk));

    UART uart1(
        .clk_in(clk_in),
        .clk_en(serial_clk), 
        .reset(reset), 
        .rx_data(rx_data), 
        .tx_data(tx_data), 
        .data(data_link),
        .send(ser_send),
        .send_data(ser_data_send),
        .busy_o(ser_busy),
        .data_rdy(data_rdy));
        
    mem_ctrl memctrl1(
        .clk_in(clk_in), 
        .reset(reset), 
        .data_rdy(data_rdy),
        .data_in(data_link),
        .write_enable(write_enable),
        .data_out(data_out),
        .addr(addr),
        .r_data_i(r_data_o),
        .ser_busy_i(ser_busy),
        .ser_data_o(ser_data_send),
        .ser_enable_o(ser_send),
        .r_addr_o(r_addr)
    );
    
    memory mem1(
        .clk_in(clk_in),
        .reset(reset),
        .write_enable(write_enable),
        .w_addr(addr),
        .r_addr(r_addr),
        .w_data(data_out),
        .r_data_o(r_data_o),
        .p(p));
endmodule