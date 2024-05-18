// Put the pieces together in this (hopefully) nice wrapper

module wrapper(
    input clk_in,
    input reset,
    input rx_data,
    input sens_rx_data,
    output tx_data,
    output pwm_o,
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
    wire sens_write_data; 
    wire [15:0] sens_data_o;
    wire [15:0] i, d, s, sp;
    wire pwm_clk;
    wire [15:0] pid_out;
    wire [15:0] offset;
    wire [15:0] int_low;
    wire [15:0] int_high;
    
    assign clk = clk_in;

    clock_wizard wizard1(
        .clk_in(clk_in), 
        .serial_clk(serial_clk),
        .pwm_clk(pwm_clk)
    );

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
        .p(p),
        .i(i),
        .d(d),
        .s(s),
        .sp(sp),
        .int_low_o(int_low),
        .int_up_o(int_high),
        .pid_o_i(pid_out),
        .sens_data_i(sens_data_o),
        .offset_o(offset),
        .sens_data_rdy_i(sens_write_data));
        
   sens_receiver rec1(
        .clk_in_i(clk_in),
        .reset_i(reset),
        .clk_en_i(serial_clk),
        .sens_in_i(sens_rx_data),
        .sens_data_o(sens_data_o),
        .sens_write_data_o(sens_write_data)       
   );
   
   pid_controller pid(
        .clk_in_i(clk_in),
        .clk_en_i(serial_clk),
        .p_coef_i(p),
        .i_coef_i(i),
        .d_coef_i(d),
        .sp_i(sp),
        .sens_data_i(s),
        .pid_o(pid_out),
        .int_low_i(int_low),
        .int_up_i(int_high),
        .offset_i(offset)
   );
   
   pwm_gen pwm_gen(
        .clk_in_i(clk_in),
        .clk_en_i(pwm_clk),
        .pid_out_i(pid_out),
        .pwm_o(pwm_o)
   );
  
endmodule