// Use this to generate clock enable signals for all of our components
// Replaces clock dividers

// Input clock running at 100Mhz

module clock_wizard(
    input clk_in,
    output reg serial_clk,
    output reg pwm_clk,
    output reg pid_clk);

    parameter serial_div = 651;
    parameter pwm_div = 4000;
    parameter pid_div = 0;

    reg [15:0] serial_cnt = 0;
    reg [15:0] pwm_cnt = 0;
    reg [15:0] pid_cnt = 0;

    // Generates clock pulses at ~153600 Hz

    always @(posedge clk_in) begin
        if (serial_cnt == serial_div) begin
            serial_cnt <= 0;
            serial_clk <= 1'b1;
        end else begin
            serial_cnt <= serial_cnt + 1;
            serial_clk <= 1'b0;
        end
    end

    // Generates clock pulses at ~25000Hz, used for fan control

    always @(posedge clk_in) begin
        if (pwm_cnt == pwm_div) begin
            pwm_cnt <= 0;
            pwm_clk <= 1'b1;
        end else begin
            pwm_cnt <= pwm_cnt + 1;
            pwm_clk <= 1'b0;
        end
    end

    // Generates clock pulses at ~15Hz, used for sensor sampling

    always @(posedge clk_in) begin
        if(pid_cnt == pid_div) begin
            pid_cnt <= 0;
            pid_clk <= 1'b1;
        end else begin
            pid_cnt <= pid_cnt + 1;
            pid_clk <= 1'b0;
        end
    end


endmodule