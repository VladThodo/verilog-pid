/*
    Computes P, I, D values, multiplies them with given coefficients and sums everything up
    Output is passed to a PWM module which scales it and turns it into a duty cycle 
*/

module pid_controller(
    input clk_in_i,
    input clk_en_i,
    input reset_i,
    input man_control_i,
    input [15:0] p_coef_i,
    input [15:0] i_coef_i,
    input [15:0] d_coef_i,
    input [15:0] sp_i,
    input [15:0] sens_data_i,
    input [15:0] offset_i,
    input [15:0] int_up_i,
    input [15:0] int_low_i,
    output reg [15:0] pid_o
);

    reg [15:0] p = 0, d = 0, prev_err = 0;
    reg [9:0] i = 0;
    reg [15:0] discrete_sum [6:0];
    reg [2:0] sum_addr = 0;
    reg [10:0] zero_pass = 0;
    
    
    reg [31:0] pid;
    reg [15:0] prev_sens_data = 0; // detect sensor data change
    wire [15:0] err_pos;
    wire [15:0] err_neg;
    
    assign err_pos = sp_i - sens_data_i;
    assign err_neg = sens_data_i - sp_i;
    
    always @(posedge clk_in_i or posedge reset_i) begin
        if(reset_i == 1) begin
            // reset integral component
            sum_addr <= 0;
            i <= 0;
            for (i=0; i<7; i=i+1) discrete_sum[i] <= 0;
        end
        else begin
            if (man_control_i) begin
            end else begin
                if (sp_i > sens_data_i) begin
                    if (i < int_up_i)
                        i <= i + err_pos;   //integral clipping
                    else 
                    i <= int_up_i;
                    pid_o <= err_pos * p_coef_i + i * i_coef_i + offset_i;
                end else begin  // we're overshooting
                    if (i > int_low_i) 
                        i <= i - err_neg;
                    else 
                        i <= int_low_i;     // reset integral to 0 setpoint
                    pid_o <= p_coef_i + i * i_coef_i + offset_i;
                end
            end
          end
     end

endmodule