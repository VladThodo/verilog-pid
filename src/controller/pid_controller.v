/*
    Computes P, I, D values, multiplies them with given coefficients and sums everything up
    Output is passed to a PWM module which scales it and turns it into a duty cycle 
*/

module pid_controller(
    input clk_in_i,
    input clk_en_i,
    input reset_i,
    input man_control_i,
    input sens_data_rdy,
    input [15:0] p_coef_i,
    input [15:0] i_coef_i,
    input [15:0] d_coef_i,
    input [15:0] sp_i,
    input [15:0] sens_data_i,
    input [15:0] offset_i,
    input [15:0] int_up_i,
    input [15:0] int_low_i,
    output reg [15:0] pid_o,
    output wire [15:0] int_o,
    output wire [15:0] deriv_o,
    output wire [15:0] err_o
    );

    reg [15:0] p = 0, d = 0, prev_err = 0;
    reg [9:0] i = 0;
    reg [15:0] discrete_sum [6:0];
    reg [2:0] sum_addr = 0;
    reg [10:0] zero_pass = 0;
    wire sens_rdy_pulse;
    
    reg [31:0] pid;
    reg [15:0] prev_sens_data = 0; // detect sensor data change
    wire [15:0] err_pos;
    wire [15:0] err_neg;
    wire [15:0] deriv;
    wire [15:0] err;
    reg state = 0;
    
    edge_detector detector(.clk_in(clk_in_i), 
                           .signal_in(sens_data_rdy), 
                           .sig_pulse(sens_rdy_pulse));
    
  
    assign err_pos = sp_i - sens_data_i;
    assign err_neg = sens_data_i - sp_i;
    
    assign err = sp_i > sens_data_i ? (sp_i - sens_data_i) : (sens_data_i - sp_i);
    
    assign deriv = prev_err > err ? (prev_err - err) : (err - prev_err);
    
    assign int_o = i;
    assign deriv_o = deriv;
    assign err_o = err; 
       
    always @(posedge clk_in_i or posedge reset_i) begin
        if(reset_i == 1) begin
            // reset integral component
            sum_addr <= 0;
            i <= 0;
            for (i=0; i<7; i=i+1) discrete_sum[i] <= 0;
        end
        else begin
            if (clk_en_i) prev_err <= err;
            if (sens_rdy_pulse) begin            
                if (sp_i > sens_data_i) begin
                    if (i < int_up_i)
                        i <= i + err;   // limitarea integralei
                    else 
                        i <= int_up_i;
                    pid_o <= err_pos * p_coef_i + i * i_coef_i + d_coef_i * deriv + offset_i;
                end else if(sp_i == sens_data_i) begin  // valoare de referin?? atins?
                    pid_o <= p_coef_i + d_coef_i * deriv + i * i_coef_i + offset_i;
                end else begin // valoare de referin?? dep??it?
                    if (i >= int_low_i) 
                        i <= i - err;
                    else 
                        i <= int_low_i;     // resetarea integralei la limita inferioara
                    pid_o <= i * i_coef_i + offset_i - p_coef_i * err - d_coef_i * deriv;
                end
            end
        end
    end
endmodule