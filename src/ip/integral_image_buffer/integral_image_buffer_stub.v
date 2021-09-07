// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.3 (win64) Build 2018833 Wed Oct  4 19:58:22 MDT 2017
// Date        : Tue Sep  7 10:20:37 2021
// Host        : LAPTOP-UNNHVI5M running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/wojci/OneDrive/Dokumenty/AGH/S4/UEC2/FaceDetection/FaceDetector/src/ip/integral_image_buffer/integral_image_buffer_stub.v
// Design      : integral_image_buffer
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_0,Vivado 2017.3" *)
module integral_image_buffer(clka, ena, wea, addra, dina, clkb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[14:0],dina[19:0],clkb,addrb[14:0],doutb[19:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [14:0]addra;
  input [19:0]dina;
  input clkb;
  input [14:0]addrb;
  output [19:0]doutb;
endmodule
