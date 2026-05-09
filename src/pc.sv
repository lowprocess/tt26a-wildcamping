module pc 
    (input logic clk_i, 
     input logic halt_i,
     input logic n_rst_i,
     input pico::modePC mode_i,
     input logic signed [pico::N-1:0] data_i,
     output logic [pico::A-1:0] addr_o);

    logic [pico::A-1:0] rtn_addr;

    always_ff @(posedge clk_i, negedge n_rst_i) begin
        if(~n_rst_i) begin
            addr_o <= '0;
            rtn_addr <= '0;
        end else if(~halt_i) begin
            unique case(mode_i)
                pico::INCREMENT: addr_o <= addr_o + 1'd1;
                pico::RELATIVE:  addr_o <= addr_o + pico::A'(data_i);
                pico::SUBROUTINE: begin
                    rtn_addr <= addr_o + 1'd1; // Store Return Address
                    addr_o <= pico::A'(data_i);      // Jump to Subroutine
                end
                pico::RETURN: begin
                    addr_o <= rtn_addr;        // Return to call 
                    rtn_addr <= '0;            // Clear Return Address
                end
            endcase
        end else begin
            addr_o <= addr_o;
        end
    end

endmodule
