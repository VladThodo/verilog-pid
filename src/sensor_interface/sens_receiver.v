/*
    The sensor transmits data via an inverted serial line at 9600 baud
    Data format:
        R (ASCII) distance_first_byte (ASCII) distance_second_byte (ASCII)
*/

`define SENSOR_DATA_ADDR 13 // memory address of sensor data

module sens_receiver(
    input sens_in_i;    // sensor serial input -> inverted
    input clk_in_i;       // main clock
    input clk_en_i;       // clock enable signal running at 16 * serial speed
    input reset_i;
    output reg [7:0] sens_data_o; // sensor data parallel out
    output sens_write_data_o;   // mem write control
);

    wire data_rdy;  // indicates that serial data has been received
    wire sens_ser_line = ~sens_in_i; // inverted serial line
    reg [7:0] sens_data;
    reg [3:0] state = 0; // default state = idle
    reg [3:0] nex_state = 0;

    // possible states of our sensor data receiver 
    parameter idle = 0,
              start = 1,
              first_byte = 2,
              second_byte = 3;

    // receiver module from UART

    receiver rec1(.clk_in(clk_in_i), 
                  .clk_en(clk_en_i), 
                  .data_rdy(data_rdy), 
                  .rx_data(sens_ser_line), 
                  .data(sens_data), 
                  .reset(reset_i));          
    
    always @(posedge clk_in) begin
        if(data_rdy) begin       // valid serial data
            if (sens_data == 82 & state == idle) begin  // we received an R -> begin sensor data read
                next_state <= start;
            end else if (state == start) begin
                next_state <= first_byte;
            end
        end
    end
endmodule