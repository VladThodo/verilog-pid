
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2023 01:30:04 PM
// Design Name: 
// Module Name: clk_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module clk_divider(clk_in, clk_out);

input clk_in;
output reg clk_out;

reg[16:0] cnt = 16'd0;
parameter DIV = 16'd651;

always @(posedge clk_in)
begin
    cnt <= cnt + 16'd1;
    
    if(cnt >= (DIV - 1))
        cnt <= 16'd0;
    
    clk_out <= (cnt < DIV / 2) ? 1'b1 : 1'b0;
 
end

endmodule
