`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  //initial begin
  //  $dumpfile("tb.fst");
  //  $dumpvars(0, tb);
  //  #1;
  //end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Replace tt_um_example with your module name:
  tt_um_lowprocess_wildcamping user_project (

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

  always #1 clk = !clk;

  reg presc_d34;
  reg presc_out;
  reg presc_inv;
  reg pico_int;
  reg pico_halt;
  reg pico_wfi;
  reg pico_uio;
  reg [4:0] pico_addr;
  reg sdi;
  reg scs;
  reg sck;
  reg sr_test;

  assign ui_in[0] = presc_d34;
  assign ui_in[1] = presc_inv;
  assign ui_in[2] = sck;
  assign ui_in[3] = sdi;
  assign ui_in[4] = scs;
  assign ui_in[5] = pico_int;
  assign ui_in[6] = pico_uio; 
  assign ui_in[7] = sr_test;

  assign uio_oe = pico_uio;

  assign presc_out = uo_out[0];
  assign pico_halt = uo_out[1];
  assign pico_wfi = uo_out[2];
  assign pico_addr[0] = uo_out[3];
  assign pico_addr[1] = uo_out[4];
  assign pico_addr[2] = uo_out[5];
  assign pico_addr[3] = uo_out[6];
  assign pico_addr[4] = uo_out[7];

  reg [23:0] rom [0:15];
  initial begin
    rom[0] = 24'hc00005 ; //jsbr start
    rom[1] = 24'h80e000 ; //load_ext: wfi r7
    rom[2] = 24'h448100 ; //addi r4, r1, 0
    rom[3] = 24'h80e000 ; //wfi r7
    rom[4] = 24'hc40000 ; //rsbr
    rom[5] = 24'h44e000 ; //start: addi r7, r0, 0
    rom[6] = 24'hc00001 ; //jsbr load_ext
    rom[7] = 24'h44c400 ; //addi r6, r4, 0
    rom[8] = 24'hc00001 ; //jsbr load_ext
    rom[9] = 24'h44a400 ; //addi r5, r4, 0
    rom[10] = 24'h0cc500 ; //mul r6, r5
    rom[11] = 24'h04e600 ; //add r7, r6
    rom[12] = 24'hc00005 ; //jsbr start
  end

  initial begin         
      $dumpfile("out.vcd");
      $dumpvars();

      presc_d34 = 0;
      presc_inv = 0;
      sck = 0;
      sdi = 0;
      scs = 1;
      pico_int = 0;
      sr_test = 0;
      pico_uio = 0;
      
      #4 rst_n = 1;
      #4 rst_n = 0;
      sck = 0;
      clk = 0;
      sdi = 0;
      scs = 1;
      for (int i = 0; i < 256; i++) begin
        #1 scs = 0;
        for (int b = 0; b < 24; b++) begin
          #40 sck = 0;
          #1 sdi = rom[pico_addr][23-b];
          #40 sck = 1;
        end
        #40 sck = 0;
        #1 scs = 1;
        rst_n = 1; // Hold reset till first address load
        if(pico_wfi) begin
          uio_in = ($random % 256);
          pico_int = 1;
        end
        #40 sck = 1;
        #40 sck = 0;
        #10 pico_int = 0;
      end
      #10 $finish;
  end

endmodule
