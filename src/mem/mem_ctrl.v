/*
    This memory controller is directly addressed by the UART.
    Each write cycle requires three bytes:
        - 0x6X, where 0x6 indicates a write command followed by a 4 bit address, i.e. 0x60 for address 0
        - first data byte (high byte, leftmost)
        - second data byte (low byte, rightmost)
    Read commands only require one command:
        - 0x7X, where 0x7 indicates a read request and X the addres, i.e. 0x70 for addr 0
    Note that the controller responds on serial with the leftmost byte first
    
    Known bugs:
        - for some reason 3 serial bytes are sent instead of two, can't reproduce in simulation
                [16/03/2024]
                -- analyzed serial out with logic analyzer, happens only when read is sent after writing
                    TODO: debug further
*/

`define WRITE_WORD    4'b0110           // 6 0x6X -> write word
`define READ_WORD     4'b0111           // 7 0x7X -> read word

module mem_ctrl(
    input clk_in,
    input reset,
    input data_rdy,
    input [7:0] data_in,
    input [15:0] r_data_i,
    input ser_busy_i,
    output reg ser_enable_o = 0,
    output reg [7:0] ser_data_o,
    output reg write_enable,
    output reg [15:0] data_out,
    output reg [7:0] addr = 0,
    output reg [7:0] r_addr_o = 0);

    wire rdy_pulse;
    reg [4:0] state = 4'b0000;
    reg [4:0] next_state = 4'b0000;
    reg [1:0] rec_cnt = 0;
    
    parameter idle = 0, read_wait = 2, first_byte = 3, second_byte = 4, rec_addr = 5, write = 6, r_first_byte_on = 7, r_first_byte_off = 8, r_second_byte_off = 9, r_second_byte_on = 10;
    
    edge_detector detector(.clk_in(clk_in), .signal_in(data_rdy), .sig_pulse(rdy_pulse));
    
    always @(state) begin
        case(state)
            idle: begin
                write_enable <= 1'b0;
                ser_enable_o <= 1'b0;
            end
            rec_addr: begin
                write_enable <= 1'b0;
                ser_enable_o <= 1'b0;
            end
            read_wait: begin
                write_enable <= 1'b0;
                ser_enable_o <= 1'b1;
            end
            r_first_byte_on: begin
                write_enable <= 1'b0;
                ser_enable_o <= 1'b1;
            end
            r_first_byte_off: begin
                write_enable <= 1'b0;
                ser_enable_o <= 1'b0;
            end
            r_second_byte_off: begin
                write_enable <= 1'b0;
                ser_enable_o <= 1'b0;
            end
            r_second_byte_on: begin
                write_enable <= 1'b0;
                ser_enable_o <= 1'b1;
            end
            write: begin
                write_enable <= 1'b1;
                ser_enable_o <= 1'b0;
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
                `WRITE_WORD: begin              // write detected
                    if (state == idle) begin    // proceed to store address if in idle state
                        addr <= data_in[3:0];
                        next_state <= rec_addr;
                    end else if (state == rec_addr) begin   // address stored, store the first (high) byte
                        data_out[15:8] <= data_in[7:0];
                        next_state <= first_byte;
                    end else if (state == first_byte) begin // first byte stored, proceed to store the second one
                        data_out[7:0] <= data_in[7:0];                  
                        next_state = write;
                    end
                end
                `READ_WORD: begin                   // Read detected
                    if (state == idle) begin
                        r_addr_o <= data_in[3:0];
                        next_state <= r_first_byte_off;
                    end else if (state == rec_addr) begin   // address stored, store the first (high) byte
                        data_out[15:8] <= data_in[7:0];
                        next_state <= first_byte;
                    end else if (state == first_byte) begin // first byte stored, proceed to store the second one
                        data_out[7:0] <= data_in[7:0];                  
                        next_state = write;
                    end
                end
                default: begin
                    if (state == idle) begin    // default setting, if in idle stay in idle
                        next_state <= idle;
                    end else if (state == rec_addr) begin   // address stored, store the first (high) byte
                        data_out[15:8] <= data_in[7:0];
                        next_state <= first_byte;
                    end else if (state == first_byte) begin // first byte stored, proceed to store the second one
                        data_out[7:0] <= data_in[7:0];                  
                        next_state = write;
                    end             
                end
            endcase
        
        if (state == write | state == r_second_byte_on) begin
            next_state <= idle; // always keep write_enable or read high for only one clock cycle
        end else if (state == r_first_byte_off) begin
            ser_data_o <= r_data_i[15:8];
            next_state <= r_first_byte_on;
        end else if (state == r_first_byte_on) begin
            next_state <= r_second_byte_off;
        end else if (state == r_second_byte_off & ser_busy_i == 0) begin        // wait for UART transmitter to be ready
            ser_data_o <= r_data_i[7:0];
            next_state <= r_second_byte_on;
        end
        state = next_state;
    end

endmodule