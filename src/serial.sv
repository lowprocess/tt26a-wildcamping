module serial #(parameter A = 4, parameter W = 24) (
    input sck,
    input sdi,
    output sdo,
    input select,
    input write,
    input reset,

    output reg [(A-1):0] addr_o,
    output reg [(W-1):0] data_o,
    input wire [(W-1):0] data_i,
    output reg write_strobe
);
    reg [(W-1):0] data_latch;

    typedef enum logic [1:0] {
        IDLE = 2'd0,
        ADDR = 2'd1,
        DATA = 2'd2,
        DONE = 2'd3
    } state_type;

    state_type current_state, next_state;
    reg [4:0] bit_count, next_count;

    always_ff @(posedge sck) begin
        if (select || reset) begin
            current_state <= IDLE;
            bit_count <= 0;
            addr_o <= 0;
            data_o <= 0;
        end else begin
            current_state <= next_state;
            bit_count <= next_count;
        end

        // Shift In Address
        if(current_state == ADDR) begin
            addr_o <= { addr_o[(A-2):0], sdi };
        end

        // Shift In Data
        if(current_state == DATA) begin
            if(bit_count == 0) begin
                data_latch <= data_i; // Latch old data
            end
            data_o <= { data_o[(W-2):0], sdi};
        end

        if(current_state == DONE) begin
            // Increment Address
            addr_o <= addr_o + 1;
        end
    end

    always_comb begin
        case (current_state)
            IDLE: begin 
                write_strobe = 0;
                next_state = ADDR; 
                next_count = 0; 
            end
            ADDR: begin
                write_strobe = 0;
                if(bit_count > (A-2)) begin
                    next_state = DATA;
                    next_count = 0;
                end else begin
                    next_state = ADDR;
                    next_count = bit_count + 1;
                end
            end
            DATA: begin
                write_strobe = 0;
                if(bit_count > (W-2)) begin
                    next_state = DONE;
                    next_count = 0;
                end else begin
                    next_state = DATA;
                    next_count = bit_count + 1;
                end
            end
            DONE: begin
                if (write)
                    write_strobe = 1;
                else
                    write_strobe = 0;
                next_state = DATA;
                next_count = 0;
            end
        endcase
    end

    assign sdo = data_latch[(W-2)-bit_count];

endmodule
