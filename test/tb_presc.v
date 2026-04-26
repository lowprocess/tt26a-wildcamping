module tb_presc3;
    reg clk_gen;
    reg reset;
    reg presc;

    wire clk_out;

    presc34 p3 (clk_gen, presc, reset, clk_out);

    initial begin         
        $dumpfile("out.vcd");
        $dumpvars (0);
        clk_gen = 0;
        presc = 0;
        reset = 1;
        #10 reset = 0;
        #50 presc = 1;
        #100 $finish;
    end

    always #1 clk_gen = !clk_gen;
endmodule