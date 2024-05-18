/*
    The sensor transmits data via an inverted serial line at 9600 baud
    Data format:
        R (ASCII) distance_first_byte (ASCII) distance_second_byte (ASCII) \r (end of line)
*/

`define SENSOR_DATA_ADDR 13 // memory address of sensor data

module sens_receiver(
    input sens_in_i,    // sensor serial input -> inverted
    input clk_in_i,       // main clock
    input clk_en_i,       // clock enable signal running at 16 * serial speed
    input reset_i,
    output reg [15:0] sens_data_o, // sensor data parallel out
    output reg sens_write_data_o = 0   // mem write control
);

    wire data_rdy;  // indicates that serial data has been received
    wire sens_ser_line = ~sens_in_i; // inverted serial line
    wire [7:0] sens_data;
    wire rdy_pulse;
    reg [3:0] state = 0; // default state = idle
    reg [3:0] next_state = 0;
    
    // possible states of our sensor data receiver 
    parameter idle = 0,
              start = 1,
              first_byte = 2,
              second_byte = 3,
              third_byte = 4;
    
    
    // receiver module from UART
    
    receiver rec1(.clk_in(clk_in_i), 
                  .clk_en(clk_en_i), 
                  .data_rdy(data_rdy), 
                  .rx_data(sens_ser_line), 
                  .data(sens_data), 
                  .reset(reset_i));
                            
    // edge detector for data ready
    edge_detector detector(.clk_in(clk_in_i), 
                           .signal_in(data_rdy), 
                           .sig_pulse(rdy_pulse));
    
    always @(state) begin
        case (state)
            idle: sens_write_data_o <= 0;
            third_byte: begin
                sens_write_data_o = 1;
            end
            second_byte: sens_write_data_o <= 0;
            first_byte: sens_write_data_o <= 0;
            default: ;
        endcase
    end
    
    always @(posedge clk_in_i) begin
        if (reset_i == 1) state <= idle;
        else begin
            if(rdy_pulse) begin       // valid serial data
                if (sens_data == 82 & state == idle) begin  // we received an R -> begin sensor data read
                    next_state <= start;
                end else if (state == start) begin
                    next_state <= first_byte;
                end else if (state == first_byte) begin
                    sens_data_o[15:0] <= (sens_data - 48) * 10;    // substract ASCII value for 0
                    next_state <= second_byte;
                end else if (state == second_byte) begin
                    sens_data_o <= sens_data_o + (sens_data - 48);   // substract ASCII value for 0
                    next_state <= third_byte;
                end else if (state == third_byte) begin
                    if (sens_data == 13) next_state <= idle;                
                end
            end
        end
        state <= next_state;
    end
endmodule