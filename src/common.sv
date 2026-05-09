// Common Defines for ELEC6234 PicoMIPS Core
// Written by Byron Theobald - April 2021

package pico;

parameter A = 4; // Memory Address Width
parameter N = 8;  // Data Bus Width
parameter R = 32; // Register File Size

typedef enum logic [1:0] {  // Program Counter Mode Select
    INCREMENT  = 2'h1,      // Increment program memory address
    RELATIVE   = 2'h2,      // Add immediate value to PC (TODO: Consider using ALU and doing comparison ops differently)
    SUBROUTINE = 2'h3,      // Jump to subroutine specified (Within tob 8b for timebeing)
    RETURN     = 2'h0       // Return to subroutine call + 1
} modePC;

// Define Instruction Format

parameter W_OPCODE = 6;
parameter W_RADDR  = 5;
parameter W_IMM    = 8;
parameter W_INST   = 24;

// Opcode Format  
// 5 4 3 2 1 0
// S I C X X X
// S = Special
// I = Immediate
// C = Conditional
typedef enum logic [W_OPCODE-1:0] {  // Decoder Operation Code
    O_HALT = 6'h00,    // Fully halts CPU execution
    O_ADD  = 6'h01,    // rd = AR, rs = B 
    O_SUB  = 6'h02,    
    O_MUL  = 6'h03,    
    O_AND  = 6'h04,
    O_OR   = 6'h05,
    O_XOR  = 6'h06,
    O_NOT  = 6'h07,
    O_BEQ  = 6'h08,    // rd = A,  rs = B, imm = O    
    O_BNE  = 6'h09,    
    O_ADDI = 6'h11,   // rd = R,  rs = B, imm = A    // Allows zero-register ($0) load with immediate without pre-init
    O_SUBI = 6'h12,                                  // Increment is still possible with ADDI $1, $1, (1) (0 init required)
    O_MULI = 6'h13,   
    O_ANDI = 6'h14,
    O_ORI  = 6'h15,
    O_XORI = 6'h16,
    O_NOTI = 6'h17,
    O_JSBR = 6'h30, // Jump to Subroutine
    O_RSBR = 6'h31, // Subroutine return
    O_WFIV = 6'h20 // Wait for Interrupt and Output RD
} opCode;

// ALU Functions
typedef enum logic [2:0] {
    F_A   = 3'h0,
    F_ADD = 3'h1,
    F_SUB = 3'h2,
    F_MUL = 3'h3,
    F_AND = 3'h4,
    F_OR  = 3'h5,
    F_XOR = 3'h6,
    F_NOT = 3'h7
} funcALU;

// ALU Flags
typedef struct packed {
    logic Zero;
    logic Negative;
    logic Overflow;
    logic Carry;
} flagsALU;

endpackage

// Use https://hlorenzi.github.io/customasm/web/ as an assembler
/*#bits 24

#subruledef op
{
	add => 0b000001
	sub => 0b000010
	mul => 0b000011
	and => 0b000100
	or  => 0b000101
	xor => 0b000110
	not => 0b000111
}

#subruledef opi
{
	addi => 0b010001
	subi => 0b010010
	muli => 0b010011
	andi => 0b010100
	ori  => 0b010101
	xori => 0b010110
	noti => 0b010111
	beq => 0b001000
	bne => 0b001001
}

#subruledef ops
{
	wfiv => 0x20
}

#ruledef
{
    nop => 0x040000
	halt => 0x000000
	{o:ops} r{rd_num} => o`6 @ rd_num`5 @ 0b0000000000000 
	{o:op} r{rd_num}, r{rs_num} => o`6 @ rd_num`5 @ rs_num`5 @ 0x00
	{o:opi} r{rd_num}, r{rs_num}, {imm: s8} => o`6 @ rd_num`5 @ rs_num`5 @ imm`8
	jsbr {imm: u8} => 0xc000 @ imm`8
	rsbr => 0xc40000
}

addi r1, r4, 0
mul r2, r1
addi r8, r2, 0
addi r2, r1, 0*/