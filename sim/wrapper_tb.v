
module wrapper_tb;

  // Parameters

  //Ports
  reg  clk_in;
  reg  reset;
  reg  rx_data;
  wire  tx_data;
  wire [15:0] p;

  wrapper  wrapper_inst (
    .clk_in(clk_in),
    .reset(reset),
    .rx_data(rx_data),
    .tx_data(tx_data),
    .p(p)
  );

//always #5  clk = ! clk ;

endmodule