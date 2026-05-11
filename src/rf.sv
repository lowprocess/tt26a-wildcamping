module rf
    (input logic clk_i, 
     input logic wr_en_i,
     input logic signed [pico::N-1:0] ext_data_i,
	 output logic signed [pico::N-1:0] ext_data_o,
     input logic signed [pico::N-1:0] wd_data_i,
     input logic [$clog2(pico::R)-1:0] rs_addr_i,
     input logic [$clog2(pico::R)-1:0] rd_addr_i,
     output logic signed [pico::N-1:0] rs_data_o, 
     output logic signed [pico::N-1:0] rd_data_o);
    
    logic signed [pico::N-1:0] regs [0:pico::R-1];

    always_ff @(posedge clk_i) begin : REGISTER
        if(wr_en_i & rd_addr_i != 0) begin
            regs[rd_addr_i & 5'b01111] <= wd_data_i;
        end
		  regs[4] <= ext_data_i;
          regs[0] <= 0;
    end

    always_comb begin : OUTPUT
		ext_data_o = regs[7];
        rs_data_o = regs[rs_addr_i & 5'b01111];
        rd_data_o = regs[rd_addr_i & 5'b01111]; 
    end

endmodule