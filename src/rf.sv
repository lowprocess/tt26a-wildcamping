module rf import pico::*; 
    (input logic clk_i, 
     input logic wr_en_i,
     input logic signed [N-1:0] ext_data_i,
	  output logic signed [N-1:0] ext_data_o,
     input logic signed [N-1:0] wd_data_i,
     input logic [$clog2(R)-1:0] rs_addr_i,
     input logic [$clog2(R)-1:0] rd_addr_i,
     output logic signed [N-1:0] rs_data_o, 
     output logic signed [N-1:0] rd_data_o);
    
    logic signed [N-1:0] regs [0:R-1];

    always_ff @(posedge clk_i) begin : REGISTER
        if(wr_en_i) begin
            regs[rd_addr_i] <= wd_data_i;
        end
		  regs[0] <= 8'b0;
		  regs[4] <= ext_data_i;
    end
	 
	 //wire [7:0] q_a = (address_a == 'd0) ? 'd0 : (address_a == 'd30) ? ext_i : sub_wire0[7:0];
	 //wire [7:0] q_b = (address_b == 'd0) ? 'd0 : (address_b == 'd30) ? ext_i : sub_wire1[7:0];


    always_comb begin : OUTPUT
		  ext_data_o = regs[8];
        rs_data_o = regs[rs_addr_i];
        rd_data_o = regs[rd_addr_i]; 
    end

endmodule