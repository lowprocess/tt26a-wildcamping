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

  wire presc_d34;
  wire presc_out;
  wire presc_inv;
  wire pico_int;
  wire pico_halt;
  wire pico_next;
  wire pico_wfi;
  wire pico_uio;
  wire sdi;
  wire scs;
  wire sck;

  presc34 p0 ( clk, presc_d34, !rst_n, presc_out );

  assign presc_d34 = ui_in[0];
  assign presc_inv = ui_in[1];
  assign sck = ui_in[2];
  assign sdi = ui_in[3];
  assign scs = ui_in[4];
  assign pico_int = ui_in[5];
  assign pico_next = ui_in[6]; 
  assign pico_uio = ui_in[7];

  assign uio_oe  = pico_uio ? 0 : 255;
  
  wire [23:0] pico_inst;
  wire [4:0] pico_addr;

  assign uo_out[0] = presc_inv ? presc_out : ~presc_out;
  assign uo_out[1] = pico_halt;
  assign uo_out[2] = pico_wfi;
  assign uo_out[3] = pico_addr[0];
  assign uo_out[4] = pico_addr[1];
  assign uo_out[5] = pico_addr[2];
  assign uo_out[6] = pico_addr[3];
  assign uo_out[7] = pico_addr[4];

  core c0 (clk, rst_n, pico_addr, pico_inst, uio_in, pico_int, pico_next, uio_out, pico_halt, pico_wfi);
  shiftreg sr (sck, sdi, scs, pico_inst);

  // List all unused inputs to prevent warnings
  wire _unused = &{ena};
endmodule
