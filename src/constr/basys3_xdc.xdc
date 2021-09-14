## FPGA4student.com: Interfacing Basys 3 FPGA with OV7670 Camera
## Pin assignment

#USB HID (PS/2)
#Bank = 16, Pin name = ,					Sch name = PS2_CLK
set_property PACKAGE_PIN C17 [get_ports ps2c]
set_property IOSTANDARD LVCMOS33 [get_ports ps2c]
set_property PULLUP true [get_ports ps2c]
#Bank = 16, Pin name = ,					Sch name = PS2_DATA
set_property PACKAGE_PIN B17 [get_ports ps2d]
set_property IOSTANDARD LVCMOS33 [get_ports ps2d]
set_property PULLUP true [get_ports ps2d]

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk100]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk100]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk100]

#    set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
#        set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
#    set_property PACKAGE_PIN V16 [get_ports {sw[1]}]
#        set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
#    set_property PACKAGE_PIN W16 [get_ports {sw[2]}]
#        set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
#    set_property PACKAGE_PIN W17 [get_ports {sw[3]}]
#        set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]

##7 segment display
##Bank = 34, Pin name = ,						Sch name = CA
#set_property PACKAGE_PIN W7 [get_ports {sseg[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sseg[0]}]
##Bank = 34, Pin name = ,					Sch name = CB
#set_property PACKAGE_PIN W6 [get_ports {sseg[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sseg[1]}]
##Bank = 34, Pin name = ,					Sch name = CC
#set_property PACKAGE_PIN U8 [get_ports {sseg[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sseg[2]}]
##Bank = 34, Pin name = ,						Sch name = CD
#set_property PACKAGE_PIN V8 [get_ports {sseg[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sseg[3]}]
##Bank = 34, Pin name = ,						Sch name = CE
#set_property PACKAGE_PIN U5 [get_ports {sseg[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sseg[4]}]
##Bank = 34, Pin name = ,						Sch name = CF
#set_property PACKAGE_PIN V5 [get_ports {sseg[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sseg[5]}]
##Bank = 34, Pin name = ,						Sch name = CG
#set_property PACKAGE_PIN U7 [get_ports {sseg[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sseg[6]}]
##Bank = 34, Pin name = ,						Sch name = DP
#set_property PACKAGE_PIN V7 [get_ports {sseg[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sseg[7]}]

##Bank = 34, Pin name = ,						Sch name = AN0
#set_property PACKAGE_PIN U2 [get_ports {an[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
##Bank = 34, Pin name = ,						Sch name = AN1
#set_property PACKAGE_PIN U4 [get_ports {an[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
##Bank = 34, Pin name = ,						Sch name = AN2
#set_property PACKAGE_PIN V4 [get_ports {an[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
##Bank = 34, Pin name = ,					Sch name = AN3
#set_property PACKAGE_PIN W4 [get_ports {an[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

# set_property PACKAGE_PIN U3 [get_ports {led_no[0]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {led_no[0]}]
# set_property PACKAGE_PIN P3 [get_ports {led_no[1]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {led_no[1]}]
# set_property PACKAGE_PIN N3 [get_ports {led_no[2]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {led_no[2]}]
# set_property PACKAGE_PIN P1 [get_ports {led_no[3]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {led_no[3]}]
# set_property PACKAGE_PIN L1 [get_ports {led_no[4]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {led_no[4]}]

    ##VGA Connector
    set_property PACKAGE_PIN G19 [get_ports {vga_r[0]}]                
        set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[0]}]
    set_property PACKAGE_PIN H19 [get_ports {vga_r[1]}]                
        set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[1]}]
    set_property PACKAGE_PIN J19 [get_ports {vga_r[2]}]                
        set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[2]}]
    set_property PACKAGE_PIN N19 [get_ports {vga_r[3]}]                
        set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[3]}]
    set_property PACKAGE_PIN N18 [get_ports {vga_b[0]}]                
        set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[0]}]
    set_property PACKAGE_PIN L18 [get_ports {vga_b[1]}]                
        set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[1]}]
    set_property PACKAGE_PIN K18 [get_ports {vga_b[2]}]                
        set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[2]}]
    set_property PACKAGE_PIN J18 [get_ports {vga_b[3]}]                
        set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[3]}]
    set_property PACKAGE_PIN J17 [get_ports {vga_g[0]}]                
        set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[0]}]
    set_property PACKAGE_PIN H17 [get_ports {vga_g[1]}]                
        set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[1]}]
    set_property PACKAGE_PIN G17 [get_ports {vga_g[2]}]                
        set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[2]}]
    set_property PACKAGE_PIN D17 [get_ports {vga_g[3]}]                
        set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[3]}]
    set_property PACKAGE_PIN P19 [get_ports vga_hsync]                        
        set_property IOSTANDARD LVCMOS33 [get_ports vga_hsync]
    set_property PACKAGE_PIN R19 [get_ports vga_vsync]                        
        set_property IOSTANDARD LVCMOS33 [get_ports vga_vsync]

## LEDs
set_property PACKAGE_PIN U16 [get_ports {led}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led}]
					
## Buttons
#Bank = 14, Sch name = BTNU
set_property PACKAGE_PIN T18 [get_ports {reset_in}]
    set_property IOSTANDARD LVCMOS33 [get_ports {reset_in}]
#Bank = 14, Sch name = BTNC
set_property PACKAGE_PIN U18 [get_ports btnc]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnc]
#Bank = 14, Sch name = BTNL
set_property PACKAGE_PIN W19 [get_ports btnl]                        
     set_property IOSTANDARD LVCMOS33 [get_ports btnl]
#Bank = 14, Sch name = BTNR
set_property PACKAGE_PIN T17 [get_ports btnr]						
         set_property IOSTANDARD LVCMOS33 [get_ports btnr]


## OV7670 Camera header pins

##Pmod Header JB
##Sch name = JB1
set_property PACKAGE_PIN A14 [get_ports {ov7670_pwdn}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ov7670_pwdn}]
##Sch name = JB2
set_property PACKAGE_PIN A16 [get_ports {ov7670_data[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ov7670_data[0]}]
##Sch name = JB3
set_property PACKAGE_PIN B15 [get_ports {ov7670_data[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ov7670_data[2]}]
##Sch name = JB4
set_property PACKAGE_PIN B16 [get_ports {ov7670_data[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ov7670_data[4]}]
##Sch name = JB7
set_property PACKAGE_PIN A15 [get_ports {ov7670_reset}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ov7670_reset}]
##Sch name = JB8
set_property PACKAGE_PIN A17 [get_ports {ov7670_data[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ov7670_data[1]}]
##Sch name = JB9
set_property PACKAGE_PIN C15 [get_ports {ov7670_data[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ov7670_data[3]}]
##Sch name = JB10 
set_property PACKAGE_PIN C16 [get_ports {ov7670_data[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ov7670_data[5]}]
  

##Pmod Header JC
##Sch name = JC1
set_property PACKAGE_PIN K17 [get_ports {ov7670_data[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ov7670_data[6]}]
##Sch name = JC2
set_property PACKAGE_PIN M18 [get_ports ov7670_xclk]					
	set_property IOSTANDARD LVCMOS33 [get_ports ov7670_xclk]
##Sch name = JC3
set_property PACKAGE_PIN N17 [get_ports ov7670_href]					
	set_property IOSTANDARD LVCMOS33 [get_ports ov7670_href]
##Sch name = JC4
set_property PACKAGE_PIN P18 [get_ports ov7670_siod]					
	set_property IOSTANDARD LVCMOS33 [get_ports ov7670_siod]
	set_property PULLUP TRUE [get_ports ov7670_siod]
##Sch name = JC7
set_property PACKAGE_PIN L17 [get_ports {ov7670_data[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ov7670_data[7]}]
##Sch name = JC8
set_property PACKAGE_PIN M19 [get_ports ov7670_pclk]					
	set_property IOSTANDARD LVCMOS33 [get_ports ov7670_pclk]
    set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {ov7670_pclk_IBUF}]
##Sch name = JC9
set_property PACKAGE_PIN P17 [get_ports ov7670_vsync]					
	set_property IOSTANDARD LVCMOS33 [get_ports ov7670_vsync]
##Sch name = JC10
set_property PACKAGE_PIN R18 [get_ports ov7670_sioc]					
	set_property IOSTANDARD LVCMOS33 [get_ports ov7670_sioc]

