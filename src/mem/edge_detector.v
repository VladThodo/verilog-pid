// Use this to detect the positive edge of data_rdy (from UART)
// Clock should be running at max speed since we want to sample this as fast as possible

module edge_detector(
    input clk_in,
    input signal_in,
    output wire sig_pulse);

    reg signal_delay;

    always @(posedge clk_in) begin
        signal_delay <= signal_in;    
    end

    assign sig_pulse = signal_in && ~signal_delay;

endmodule