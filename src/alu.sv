module alu
    (input logic signed [pico::N-1:0] a_i,
     input logic signed  [pico::N-1:0] b_i,
     input pico::funcALU op,
     output logic signed [pico::N-1:0] r_o,
     output pico::flagsALU flags_o);

    logic signed sub;
    logic signed [pico::N+1:0] tmp;
    logic signed [pico::N:0] r_as;
    logic signed [pico::N-1:0] r_sr;

    assign sub = (op == pico::F_SUB);
    // Altera Cookbook Example 'XOR in front of Carry Chain'
    assign tmp = {1'b0, a_i, sub} + {sub, {pico::N{sub}} ^ b_i, sub};
    assign r_as = tmp[pico::N+1:1];

    // Partition overflow and carry logic
    ovf ov0 (.a(a_i[7]), .b(b_i[7]), .r(r_o[7]), .s(sub), .c(flags_o.Carry), .v(flags_o.Overflow));

    assign flags_o.Zero = ~|r_as;
    assign flags_o.Negative = r_as[pico::N-1];
    assign r_sr = r_as[pico::N-1:0];

    always_comb begin
        unique case(op)
            pico::F_ADD, 
            pico::F_SUB: r_o = r_sr;
            pico::F_MUL: r_o = a_i * b_i;
            pico::F_AND: r_o = a_i & b_i;
            pico::F_OR:  r_o = a_i | b_i;
            pico::F_XOR: r_o = a_i ^ b_i;
            pico::F_NOT: r_o = ~ a_i;
            pico::F_A:   r_o = a_i;
            default: r_o = 'd0;
        endcase
    end

endmodule