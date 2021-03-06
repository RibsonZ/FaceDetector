// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.3 (win64) Build 2018833 Wed Oct  4 19:58:22 MDT 2017
// Date        : Fri Sep  3 17:36:17 2021
// Host        : LAPTOP-UNNHVI5M running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top clock_generator -prefix
//               clock_generator_ clock_generator_stub.v
// Design      : clock_generator
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clock_generator(clk_out_50, clk_out_25, reset, locked, 
  clk_in_100)
/* synthesis syn_black_box black_box_pad_pin="clk_out_50,clk_out_25,reset,locked,clk_in_100" */;
  output clk_out_50;
  output clk_out_25;
  input reset;
  output locked;
  input clk_in_100;
endmodule
