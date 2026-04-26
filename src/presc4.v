module presc4 (
    input clk_in,
    input reset,
    output clk_out
);
    reg [1:0] counter;

    // Counter on rising edge
    always @(posedge clk_in or posedge reset) begin
        if (reset)
            counter <= 2'b0;
        else
            counter <= counter + 1'b1;
    end

    assign clk_out = counter[1];

endmodule