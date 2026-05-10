module tb_serial_ram;
    reg sck;
    reg sdi;
    wire sdo;
    reg scs;
    reg swe;
    reg reset;

    wire [3:0] ram_ai;
    wire [23:0] ram_di;
    wire [23:0] ram_do;
    wire ram_we;

    serial s0 (sck, sdi, sdo, scs, swe, reset, ram_ai, ram_di, ram_do, ram_we);
    ram r0 (sck, ram_ai, ram_di, ram_do, ram_we);

    always #1 sck = !sck;

    initial begin         
        $dumpfile("out.vcd");
        $dumpvars (0);
        sck = 0;
        sdi = 0;
        reset = 1;
        #10 scs = 1;
        #10 reset = 0; 
        #1 scs = 0;
        #1 swe = 1;
        #8 sdi = 0;

        for (int i = 0; i < 16*24; i++)
           #2 sdi = $random % 2;
        
        #2 sdi = 0;
        #2 scs = 1;
        #2 scs = 0;
        #2 swe = 0;
        #360 scs = 1;
        #10 $finish;
    end
endmodule