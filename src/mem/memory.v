// 32 bytes memory block

module memory(
    input clk_in,
    input reset,
    input write_enable,
    input [7:0] addr,
    input [7:0] data,
    output wire [15:0] p,
    output wire [15:0] i,
    output wire [15:0] d,
    output wire [15:0] sp);

    reg[7:0] mem [4:0];

    always @(posedge write_enable) begin
        mem[addr[4:0]] <= data; 
    end

    assign p = {mem[0], mem[1]};
    assign i = {mem[2], mem[3]};
    assign d = {mem[4], mem[5]};
    assign sp = {mem[6], mem[7]};

endmodule
