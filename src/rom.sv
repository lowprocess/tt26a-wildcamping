module rom import pico::*;
    (input logic refresh_clk,
	 input logic [A-1:0] addr_i,
    output logic [W_INST-1:0] data_o);
 
    (* ram_init_file = "prog_test.mif" *) reg [W_INST-1:0] rom [0:(1<<A)-1];
	 
	 // Initialise Altera Sync RAM and JTAG Interface
	 //alt_rom ar0 (addr_i, refresh_clk, data_o);
	 
    //initial $readmemh("prog.hex", rom);
    
    assign data_o = rom[addr_i];
  
endmodule