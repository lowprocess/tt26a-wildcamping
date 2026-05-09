module serial (
    input sck
    input sdi,
    output sdo,
    input write,
    input reset,
);

reg [2:0] addr;
reg [15:0] data_shift;
reg [2:0] registers [8:0];

enum bit[2:0] {
    R0_CTRL_A,
    R1_CTRL_B,
    R2_COUNTER_TOP_L
    R3_COUNTER_TOP_H
    R4_ACCUM0_ADD_A
    R5_ACCUM0_ADD_B
    R6_ACCUM0_ADD_C
    R7_ACCUM0_ADD_D
    R8_ACCUM1_ADD_A
    R9_ACCUM1_ADD_B
    R10_ACCUM1_ADD_C
    R11_ACCUM1_ADD_D
    R12_ACCUM2_ADD_A
    R13_ACCUM2_ADD_B
    R14_ACCUM2_ADD_C
    R15_ACCUM2_ADD_D
} register_map;