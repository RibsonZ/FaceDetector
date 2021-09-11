// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.3 (win64) Build 2018833 Wed Oct  4 19:58:22 MDT 2017
// Date        : Thu Sep  9 11:02:05 2021
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
module integral_image_buffer(clka, wea, addra, dina, douta, clkb, web, addrb, dinb, 
  doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[14:0],dina[19:0],douta[19:0],clkb,web[0:0],addrb[14:0],dinb[19:0],doutb[19:0]" */;
  input clka;
  input [0:0]wea;
  input [14:0]addra;
  input [19:0]dina;
  output [19:0]douta;
  input clkb;
  input [0:0]web;
  input [14:0]addrb;
  input [19:0]dinb;
  output [19:0]doutb;
endmodule
