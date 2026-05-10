module rom
    (input logic [pico::A-1:0] addr_i,
    output logic [pico::W_INST-1:0] data_o);
 
    //(* ram_init_file = "prog_test.mif" *) reg [pico::W_INST-1:0] rom [0:(1<<pico::A)-1];
	 
	 // Initialise Altera Sync RAM and JTAG Interface
	 //alt_rom ar0 (addr_i, refresh_clk, data_o);
	 
    //initial $readmemh("prog.hex", rom);
    
    reg [pico::W_INST-1:0] rom [0:(1<<pico::A)-1];

    initial begin
        rom[0] = 24'hc00005;  // jsbr start
        rom[1] = 24'hfc0000;  // load_ext: wfi
        rom[2] = 24'h448100;  // addi r4, r1, 0
        rom[3] = 24'hfc0000;  // wfi
        rom[4] = 24'hc40000;  // rsbr
        rom[5] = 24'h44e000;  // start: addi r7, r0, 0
        rom[6] = 24'hc00001;  // jsbr load_ext
        rom[7] = 24'h44c400;  // addi r6, r4, 0
        rom[8] = 24'hc00001;  // jsbr load_ext
        rom[9] = 24'h44a400;  // addi r5, r4, 0
        rom[10] = 24'h0cc500; // mul r6, r5
        rom[11] = 24'h04e600; // add r7, r6
        rom[12] = 24'hc00005; // jsbr start
    end

    assign data_o = rom[addr_i];
  
endmodule

