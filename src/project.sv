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

  assign uio_oe  = ui_in[2] ? 0 : 255;

  wire presc;
  wire clk_out;
  wire pico_int;
  wire pico_halt;
  wire pico_wfi;

  presc34 p0 ( clk, presc, !rst_n, clk_out );

  assign presc = ui_in[0];
  assign pico_int = ui_in[1];

  assign uo_out[0] = clk_out;
  assign uo_out[1] = pico_halt;
  assign uo_out[2] = pico_wfi;
  assign uo_out[3] = 0;
  assign uo_out[4] = 0;
  assign uo_out[5] = 0;
  assign uo_out[6] = 0;
  assign uo_out[7] = ~ui_in[7]; // Test Inverter

  wire [3:0] addr;
  wire [23:0] inst;

  rom r0 (addr, inst);
  core c0 (clk, rst_n, addr, inst, uio_in, pico_int, uio_out, pico_halt, pico_wfi);

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, ui_in[6:3], uio_in};
endmodule
