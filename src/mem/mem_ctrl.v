// Memory controller - to be directly addressed by our UART

module mem_ctrl(
    input clk_in,
    input reset,
    input data_rdy,
    input [7:0] data_in,
    output reg write_enable,
    output reg [15:0] data_out,
    output reg [7:0] addr = 0);

    wire rdy_pulse;
    reg [2:0] state = 3'b000;
    reg [2:0] next_state = 3'b000;
    reg [1:0] rec_cnt = 0;
    
    parameter idle = 0, read = 2, first_byte = 3, second_byte = 4, rec_addr = 5, write = 6;
    
    edge_detector detector(.clk_in(clk_in), .signal_in(data_rdy), .sig_pulse(rdy_pulse));
    
    always @(state) begin
        case(state)
            idle: begin
                write_enable <= 1'b0;
            end
            rec_addr: begin
                write_enable <= 1'b0;
            end
            read: begin
                write_enable <= 1'b0;
            end
            write: begin
                write_enable <= 1'b1;
            end
        endcase
    end
    
    // TODO: turn this into a state machine
    // Word format:
        // write: WWWWaddr -> WWWW -> 0110 write word, addr -> address to write
        // read: RRRRaddr  -> RRRR -> 0111 read word, addr -> read address
        
    always @(posedge clk_in) begin
        if (rdy_pulse)   // data from UART is ready
            // triggered by rdy_pulse
            case(data_in[7:4])
                4'b0110: begin              // write detected
                    if (state == idle) begin    // proceed to store address if in idle state
                        addr <= data_in[3:0];
                        next_state <= rec_addr;
                    end else if (state == rec_addr) begin   // address stored, store the first (high) byte
                        data_out[15:8] <= data_in;
                        next_state <= first_byte;
                    end else if (state == first_byte) begin // first byte stored, proceed to store the second one
                        data_out[7:0] <= data_in;
                        next_state <= write;            
                    end else next_state <= idle;
                end
                default: begin
                    if (state == idle) begin    // default setting, if in idle stay in idle
                        next_state <= idle;
                    end else if (state == rec_addr) begin   // address stored, store the first (high) byte
                        data_out[15:8] <= data_in;
                        next_state <= first_byte;
                    end else if (state == first_byte) begin // first byte stored, proceed to store the second one
                        data_out[7:0] <= data_in;                  
                        next_state <= write;
                    end else next_state <= idle;              
                end
            endcase
        if (state == write) next_state <= idle; // always keep write_enable high for only one clock cycle
        state <= next_state;
    end

endmodule