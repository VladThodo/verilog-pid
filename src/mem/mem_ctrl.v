// Memory controller - to be directly addressed by our UART

module mem_ctrl(
    input clk_in,
    input reset,
    input data_rdy,
    input [7:0] data_in,
    output write_enable,
    output reg [7:0] data_out,
    output reg [7:0] addr = 0);

    wire rdy_pulse;
    reg [2:0] state = 3'b000;
    reg [2:0] next_state = 3'b000;
    reg [1:0] rec_cnt = 0;
    
    parameter rec_addr = 0, rec_data = 1;
    
    edge_detector detector(.clk_in(clk_in), .signal_in(data_rdy), .sig_pulse(rdy_pulse));

    always @(posedge rdy_pulse) begin
        if(data_in == 255) 
            rec_cnt <= 0;
        else begin   
            if(rec_cnt == 1) begin
                rec_cnt <= 0;
                data_out <= data_in;
                state <= 1;
            end else begin
                rec_cnt <= rec_cnt + 1;
                addr <= data_in[4:0];
                state <= 0;
            end
        end
    end

    assign write_enable = (rdy_pulse)&&(state);

endmodule