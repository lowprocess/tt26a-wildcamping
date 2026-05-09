module core import pico::*;
    (input logic clk_i, 
     input logic n_rst_i,
	  output logic [A-1:0] prog_addr,
	  input logic [W_INST-1:0] prog_data,
     input logic [N-1:0] ext_data_i,
     input logic ext_int_i,
     output logic signed [N-1:0] result_o,
     output logic halt_o, wfi_o);

    // Control Signals
    modePC mode_pc;
    flagsALU flags_alu;
    funcALU func_alu;
    logic a_imm_alu;
    opCode op_code;
    logic wr_en_rf;
    logic wfi_core;
	 
    logic edge_trig;
    edge_detect ed0 (.clk_i(clk_i), .sig_i(ext_int_i), .edge_o(edge_trig));
    dec dec0 (.mode_pc_o(mode_pc), .op_code_i(op_code), .wr_en_rf_o(wr_en_rf), .a_imm_alu_o(a_imm_alu), .func_alu_o(func_alu), .flags_alu_i(flags_alu), .halt_core_o(halt_o), .wfi_core_o(wfi_core), .ext_int_i(edge_trig));

    // Datapath
    logic [W_INST-1:0] instruction;
    logic [W_RADDR-1:0] rd_addr, rs_addr;
    logic signed [W_IMM-1:0] immediate;

	 assign wfi_o = wfi_core;
	 
	 assign instruction = prog_data;
    // Calculate instruction offsets to generate signals
    assign immediate = instruction[0               +: W_IMM];
    assign rs_addr   = instruction[W_IMM           +: W_RADDR];
    assign rd_addr   = instruction[W_IMM+W_RADDR   +: W_RADDR];
    assign op_code   = opCode'(instruction[W_IMM+2*W_RADDR +: W_OPCODE]);   
	 
    logic signed [N-1:0] rs_data, rd_data, alu_wb;
	 
    pc  pc0  (.clk_i(clk_i), .halt_i(halt_o||wfi_core), .n_rst_i(n_rst_i), .mode_i(mode_pc), .data_i(immediate), .addr_o(prog_addr));
    rf  rf0  (.clk_i(clk_i), .wr_en_i(wr_en_rf), .ext_data_i(ext_data_i), .ext_data_o(result_o), .wd_data_i(alu_wb), .rs_addr_i(rs_addr), .rd_addr_i(rd_addr), .rs_data_o(rs_data), .rd_data_o(rd_data));
	 alu alu0 (.a_i(a_imm_alu ? immediate : rd_data), .b_i(rs_data), .op(func_alu), .r_o(alu_wb), .flags_o(flags_alu));

    always_ff @(posedge clk_i) begin      
        $display("%x, %x, %x", prog_addr, instruction, result_o);
    end

endmodule