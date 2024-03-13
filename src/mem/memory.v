// 32 bytes memory block

`define REG_P     0 //RW
`define REG_I     1 //RW
`define REG_D     2 //RW
`define REG_SP    3 //RW
`define REG_PID_O 14 //R
`define REG_PWM_O 15 //R

module memory(
    input clk_in,
    input reset,
    input write_enable,
    input [7:0] w_addr,
    input [7:0] r_addr,
    input [15:0] w_data,
    output reg[15:0] r_data_o,
    output wire [15:0] p,
    output wire [15:0] i,
    output wire [15:0] d,
    output wire [15:0] sp,
    input wire [15:0] pid_o_i,
    input wire [15:0] pwm_o_i);

    reg[15:0] mem [15:0];
  
    //WRITE
    always @(posedge clk_in) begin
        mem[`REG_PID_O] <= pid_o_i;
        mem[`REG_PWM_O] <= pwm_o_i;
        if (write_enable)
            mem[w_addr] <= w_data;
            //case (w_addr)
             //   mem[w_addr] <= w_data;
                /*
                `REG_P  : mem[w_addr] <= w_data;
                `REG_I  : mem[w_addr] <= w_data;
                `REG_D  : mem[w_addr] <= w_data;
                `REG_SP : mem[w_addr] <= w_data;*/
           // endcase
    end

    //READ
    always @(posedge clk_in) begin
        r_data_o <= mem[r_addr[4:0]];
    end
    
    assign p = mem[`REG_P];
    assign i = mem[`REG_I];
    assign d = mem[`REG_D];
    assign sp = mem[`REG_SP];
endmodule
