module pc import pico::*; 
    (input logic clk_i, 
     input logic halt_i,
     input logic n_rst_i,
     input modePC mode_i,
     input logic signed [N-1:0] data_i,
     output logic [A-1:0] addr_o);

    logic [A-1:0] rtn_addr;

    always_ff @(posedge clk_i, negedge n_rst_i) begin
        if(~n_rst_i) begin
            addr_o <= '0;
            rtn_addr <= '0;
        end else if(~halt_i) begin
            unique case(mode_i)
                INCREMENT: addr_o <= addr_o + 1'd1;
                RELATIVE:  addr_o <= addr_o + A'(data_i);
                SUBROUTINE: begin
                    rtn_addr <= addr_o + 1'd1; // Store Return Address
                    addr_o <= A'(data_i);      // Jump to Subroutine
                end
                RETURN: begin
                    addr_o <= rtn_addr;        // Return to call 
                    rtn_addr <= '0;            // Clear Return Address
                end
            endcase
        end else begin
            addr_o <= addr_o;
        end
    end

endmodule
