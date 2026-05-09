/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_lowprocess_wildcamping (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.

  assign uio_oe  = 255;

  wire presc;
  wire clk_out;

  presc34 p0 ( clk, presc, !rst_n, clk_out );

  assign presc = ui_in[0];
  assign uo_out[0] = clk_out;
  assign uo_out[6:3] = 0;
  assign uo_out[7] = ~ui_in[7]; // Test Inverter

  wire pico_int;
  wire pico_halt;
  wire pico_wfi;

  assign pico_int = ui_in[1];
  assign uo_out[1] = pico_halt;
  assign uo_out[2] = pico_wfi;

  wire [3:0] rom_addr;
  wire [23:0] rom_data;
  rom r0 ( clk, rom_addr, rom_data );
  core c0 ( clk, ena, rom_addr, rom_data, uio_in, pico_int, uio_out, pico_halt, pico_wfi);

//    (input logic clk_i, 
//     input logic n_rst_i,
//  output logic [A-1:0] prog_addr,
	  //input logic [W_INST-1:0] prog_data,
    // input logic [N-1:0] ext_data_i,
    // input logic ext_int_i,
    // output logic signed [N-1:0] result_o,
    // output logic halt_o, wfi_o);


  // List all unused inputs to prevent warnings
  wire _unused = &{ena};
endmodule
