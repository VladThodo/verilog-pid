// Memory controller - to be directly addressed by ou UART

module mem_ctrl(
    input clk_in,
    input reset,
    input data_rdy,
    input [7:0] data_in,
    output write_enable,
    output reg [7:0] data_out,
    output [7:0] addr);

    always @(posedge clk_in) begin
        data_out = data_out + 1;
    end

endmodule