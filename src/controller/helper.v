/*
    Computes P, I, D values, multiplies them with given coefficients and sums everything up
    Output is passed to a PWM module which scales it and turns it into a duty cycle 
*/

module pid_controller(
    input clk_in_i,
    input clk_en_i,
    input reset_i,
    input [15:0] p_coef_i,
    input [15:0] i_coef_i,
    input [15:0] d_coef_i,
    input [15:0] sp_i,
    input [15:0] sens_data_i,
    output reg signed [15:0] pid_o
);

    
    reg [31:0] pid;

    wire signed [16:0] err;
    
    assign err = sp_i - sens_data_i;
    always @(posedge clk_in_i or posedge reset_i) begin
        if(reset_i == 1) begin
            // reset integral component
            pid_o <= 0;
        end
        else begin
            if (clk_en_i) begin             // compute PID values at a slower clock speed
                i = i + err;
                if (i > x)
                    i = c1;
                else if (i<y)
                    i = c2l
                else 
                    i = i;
                pid_o <= err * p_coef_i + i * i_coef_i;
            end
        end
    end

endmodule