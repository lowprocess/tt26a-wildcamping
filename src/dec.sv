module dec
    (output pico::modePC mode_pc_o,
     input pico::opCode op_code_i,
     output logic wr_en_rf_o,
     output logic a_imm_alu_o,
     output pico::funcALU func_alu_o,
     input pico::flagsALU flags_alu_i,
     output logic halt_core_o,
     output logic wfi_core_o,
     input logic ext_int_i );

    logic op_sub, op_imm;
    logic [2:0] op_code;
    assign op_imm = op_code_i[4];
    assign op_sub = op_code_i[3];
    assign op_code = op_code_i[2:0];

    logic flag_zero;
    assign flag_zero = flags_alu_i.Zero;

    always_comb begin
        // In the event that we encounter an unknown instruction, 
        // This will cause return to address 0 or return to subroutine call
        // Core may also halt in this case if configured which will gate PC clock.
        mode_pc_o = pico::RETURN;
        wr_en_rf_o = 1'b0;
        a_imm_alu_o = 1'b0;

        func_alu_o = pico::funcALU'(op_sub ? pico::F_SUB : op_code);

        halt_core_o = 1'b0;
        a_imm_alu_o = op_imm; // Check for Immediate bit
		  wfi_core_o = 1'b0;
		  
        unique case (op_code_i)
            pico::O_ADD, pico::O_ADDI, 
            pico::O_SUB, pico::O_SUBI, 
            pico::O_MUL, pico::O_MULI, 
            pico::O_AND, pico::O_ANDI, 
            pico::O_OR,  pico::O_ORI, 
            pico::O_XOR, pico::O_XORI, 
            pico::O_NOT, pico::O_NOTI: begin
                mode_pc_o = pico::INCREMENT;
                wr_en_rf_o = 1'b1;
            end
            pico::O_BEQ: begin
                mode_pc_o = pico::modePC'(flag_zero ? pico::RELATIVE : pico::INCREMENT);
            end
            pico::O_BNE: begin
                mode_pc_o = pico::modePC'(~flag_zero ? pico::RELATIVE : pico::INCREMENT);
            end
            pico::O_HALT: begin
                halt_core_o = 1'b1;
            end
            pico::O_JSBR: begin
                mode_pc_o = pico::SUBROUTINE;
            end
            pico::O_RSBR: begin
                mode_pc_o = pico::RETURN;
            end
            pico::O_WFIV: begin
                mode_pc_o = pico::INCREMENT;
                wfi_core_o = ~ext_int_i;
            end
            default: begin
                halt_core_o = 1'b1; // 
                //$error("Unimplemented Opcode %h", op_code_i);
            end
        endcase
    end

endmodule