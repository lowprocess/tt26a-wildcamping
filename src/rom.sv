import pico::*;
module rom
    (input logic refresh_clk,
	 input logic [pico::A-1:0] addr_i,
    output logic [pico::W_INST-1:0] data_o);
 
    //(* ram_init_file = "prog_test.mif" *) reg [pico::W_INST-1:0] rom [0:(1<<pico::A)-1];
	 
	 // Initialise Altera Sync RAM and JTAG Interface
	 //alt_rom ar0 (addr_i, refresh_clk, data_o);
	 
    //initial $readmemh("prog.hex", rom);
    
    reg [pico::W_INST-1:0] rom [0:(1<<pico::A)-1];

    initial begin
        rom[0] = 24'h442400;
        rom[1] = 24'h0C4100;
        rom[2] = 24'h450200;
        rom[3] = 24'h444100;        
    end

    assign data_o = rom[addr_i];
  
endmodule