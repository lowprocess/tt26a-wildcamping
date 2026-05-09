module alu import pico::*; 
    (input logic signed [N-1:0] a_i,
     input logic signed  [N-1:0] b_i,
     input funcALU op,
     output logic signed [N-1:0] r_o,
     output flagsALU flags_o);

    logic signed sub;
    logic signed [N+1:0] tmp;
    logic signed [N:0] r_as;
    always_comb begin
        sub = (op == F_SUB);
        // Altera Cookbook Example 'XOR in front of Carry Chain'
        tmp = {1'b0, a_i, sub} + {sub, {N{sub}} ^ b_i, sub};
        r_as = tmp[N+1:1];
    end

    // Partition overflow and carry logic
    ovf ov0 (.a(a_i[7]), .b(b_i[7]), .r(r_o[7]), .s(sub), .c(flags_o.Carry), .v(flags_o.Overflow));

    always_comb begin
        flags_o.Zero = ~|r_as;
        flags_o.Negative = r_as[N-1];
    end

    always_comb begin
        unique case(op)
            F_ADD, 
            F_SUB: r_o = r_as[N-1:0];
            F_MUL: r_o = a_i * b_i;
            F_AND: r_o = a_i & b_i;
            F_OR:  r_o = a_i | b_i;
            F_XOR: r_o = a_i ^ b_i;
            F_NOT: r_o = ~ a_i;
            F_A:   r_o = a_i;
            default: r_o = 'd0;
        endcase
    end

endmodule