// 25 kHz PWM generator - connected to the output of our PID controller

module pwm_gen(
    input [15:0] pid_out_i,
    input reset_i,
    input clk_in_i,
    input clk_en_i,
    output reg pwm_o
);
    
    reg [15:0] pwm_counter = 0;
    reg [15:0] max_pwm = 10;
    reg [15:0] max_period = 4096;
    
    always @(posedge clk_in_i or posedge reset_i) begin
        if (reset_i == 1) begin
            pwm_o <= 0;
            pwm_counter <= 0;
        end else begin
            if (pwm_counter < max_period - pid_out_i) begin
                pwm_counter <= pwm_counter + 1;
                pwm_o <= 0;
            end else if (pwm_counter < max_period & pwm_counter >= (max_period - pid_out_i)) begin
                pwm_counter <= pwm_counter + 1;
                pwm_o <= 1;
            end else begin
                pwm_counter <= 0;
                pwm_o <= 0;
            end
        end
        
    end

endmodule
