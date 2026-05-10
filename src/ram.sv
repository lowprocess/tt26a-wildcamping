module ram #(parameter A = 4, parameter W = 24)
    (input logic clk,
	 input logic [A-1:0] addr_i,
     input logic [W-1:0] data_i,
     output logic [W-1:0] data_o,
     input logic write );
     
    reg [W-1:0] memory [0:(1<<A)-1];

    always_ff @(posedge clk) begin
        if( write )
            memory[addr_i] <= data_i;
    end

    assign data_o = memory[addr_i];

endmodule