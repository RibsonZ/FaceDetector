-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.3 (win64) Build 2018833 Wed Oct  4 19:58:22 MDT 2017
-- Date        : Fri Sep  3 17:36:17 2021
-- Host        : LAPTOP-UNNHVI5M running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top clock_generator -prefix
--               clock_generator_ clock_generator_stub.vhdl
-- Design      : clock_generator
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_generator is
  Port ( 
    clk_out_50 : out STD_LOGIC;
    clk_out_25 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in_100 : in STD_LOGIC
  );

end clock_generator;

architecture stub of clock_generator is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out_50,clk_out_25,reset,locked,clk_in_100";
begin
end;
