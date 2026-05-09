module edge_detect 
   (input logic clk_i,
    input logic sig_i,
    output logic edge_o);

    logic [2:0] stages;

    // Synchronously detect rising or falling edge 
    assign edge_o = (stages[2] & ~stages[1]) | (~stages[2] & stages[1]);

    always_ff @(posedge clk_i) begin
        stages[0] <= sig_i;
        stages[1] <= stages[0];
        stages[2] <= stages[1];
    end
endmodule