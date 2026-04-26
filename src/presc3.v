module presc3 (
    input clk_in,
    input reset,
    output clk_out
);
    reg [1:0] counter;
    reg clk_p, clk_n;

    // Counter on rising edge
    always @(posedge clk_in or posedge reset) begin
        if (reset)
            counter <= 2'b0;
        else if (counter == 2'd2) // Count 0, 1, 2 (Divide by 3)
            counter <= 2'b0;
        else
            counter <= counter + 1'b1;
    end

    // Signal A: High for 1.5 cycles
    always @(posedge clk_in or posedge reset) begin
        if (reset)
            clk_p <= 1'b0;
        else if (counter < 2'd1) // Change at 1/3 of cycle
            clk_p <= 1'b1;
        else
            clk_p <= 1'b0;
    end

    // Signal B: Same as A but on falling edge
    always @(negedge clk_in or posedge reset) begin
        if (reset)
            clk_n <= 1'b0;
        else
            clk_n <= clk_p;
    end

    // OR the two signals for 50% duty cycle
    assign clk_out = clk_p | clk_n;

endmodule