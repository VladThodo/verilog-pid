// 16 x 16 bytes memory block

`define REG_P             0 //RW
`define REG_I             1 //RW
`define REG_D             2 //RW
`define REG_SP            3 //RW
`define REG_OFF           4 // RW
`define REG_I_UP          5 // RW, upper integral limit
`define REG_I_LOW         6 // RW, lower integral limit
`define REG_FLAGS         7 // RW, flags register
`define REG_PID_O_VAL     8 // RW, hard coded PID output value for testing and startup

`define REG_ERR_VAL       10 // R - error value
`define REG_I_VAL         11 // R - integral value
`define REG_D_VAL         12 // R - derivative value
`define REG_S_I           13 //R
`define REG_PID_O         14 //R
`define REG_PWM_O         15 //R

module memory(
    input clk_in,
    input reset,
    input write_enable,
    input sens_data_rdy_i,
    input [7:0] w_addr,
    input [7:0] r_addr,
    input [15:0] w_data,
    input [15:0] sens_data_i,
    output reg[15:0] r_data_o,
    output wire [15:0] p,
    output wire [15:0] i,
    output wire [15:0] d,
    output wire [15:0] s,
    output wire [15:0] sp,
    output wire [15:0] offset_o,
    output wire [15:0] int_up_o,
    output wire [15:0] int_low_o,
    input wire [15:0] pid_o_i,
    input wire [15:0] integral_i,
    input wire [15:0] err_i,
    input wire [15:0] deriv_i,
    input wire [15:0] pwm_o_i);

    reg[15:0] mem [15:0];
  
    //WRITE
    always @(posedge clk_in) begin
        mem[`REG_PID_O] <= pid_o_i;
        mem[`REG_PWM_O] <= pwm_o_i;
        mem[`REG_D_VAL] <= deriv_i;
        mem[`REG_I_VAL] <= integral_i;
        mem[`REG_ERR_VAL] <= err_i;
        if (sens_data_rdy_i) begin
            mem[`REG_S_I] <= sens_data_i;
        end
        if (write_enable) // write restrictions 
            case (w_addr)        
                default: mem[w_addr] <= w_data;
                `REG_PID_O: ;     // do nothing, this is our PID out 
                `REG_PWM_O: ;     // do nothing, this is our PWM generator output
                `REG_S_I:   ;     // do nothing, this is our sensor data
            endcase
    end

    //READ
    always @(posedge clk_in) begin
        r_data_o <= mem[r_addr];
    end
    
    assign p = mem[`REG_P]; // P coefficient
    assign i = mem[`REG_I]; // I coefficient
    assign d = mem[`REG_D]; // D coefficient
    assign s = mem[`REG_S_I]; // measured distance from sensor
    assign sp = mem[`REG_SP]; // PID set point
    assign offset_o = mem[`REG_OFF]; // PID controller offset
    assign int_up_o = mem[`REG_I_UP]; // Integral upper limit
    assign int_low_o = mem[`REG_I_LOW]; // Integral lower limit
    
endmodule
