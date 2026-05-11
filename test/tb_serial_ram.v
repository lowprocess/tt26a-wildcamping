module tb_serial_ram;
    reg clk;
    reg sck;
    reg sdi;
    reg scs;

    wire [23:0] out;

    shiftreg s0 (clk, sck, sdi, scs, out);

    always #1 clk = !clk;
    always #4 sck = !sck;

    initial begin         
        $dumpfile("out.vcd");
        $dumpvars (0);
        sck = 0;
        clk = 0;
        sdi = 0;
        scs = 1;
        #10 scs = 0;
        for (int i = 0; i < 24; i++)
           #8 sdi = $random % 2;
        #1 scs = 1;
        #10 $finish;
    end
endmodule