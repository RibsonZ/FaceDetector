----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Controller for the OV760 camera - transferes registers to the 
--              camera over an I2C like bus
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ov7670_controller is
    Port ( clk   : in    STD_LOGIC;
            xclk_in : in STD_LOGIC;
            rst : in STD_LOGIC;
			  resend :in    STD_LOGIC;
			  config_finished : out std_logic;
           sioc  : out   STD_LOGIC;
           siod  : inout STD_LOGIC;
           reset : out   STD_LOGIC;
           pwdn  : out   STD_LOGIC;
			  xclk_out  : out   STD_LOGIC
);
end ov7670_controller;

architecture Behavioral of ov7670_controller is
	COMPONENT ov7670_registers
	PORT(
		clk      : IN std_logic;
		rst      : IN std_logic;
		advance  : IN std_logic;          
		resend   : in STD_LOGIC;
		command  : OUT std_logic_vector(15 downto 0);
		finished : OUT std_logic
		);
	END COMPONENT;

	COMPONENT i2c_sender
	PORT(
		clk   : IN std_logic;
		rst   : in std_logic;
		send  : IN std_logic;
		taken : out std_logic;
		id    : IN std_logic_vector(7 downto 0);
		reg   : IN std_logic_vector(7 downto 0);
		value : IN std_logic_vector(7 downto 0);    
		siod  : INOUT std_logic;      
		sioc  : OUT std_logic
		);
	END COMPONENT;

	signal command  : std_logic_vector(15 downto 0);
	signal finished : std_logic := '0';
	signal taken    : std_logic := '0';
	signal send     : std_logic;

	constant camera_address : std_logic_vector(7 downto 0) := x"42"; -- 42"; -- Device write ID - see top of page 11 of data sheet
begin
    config_finished <= finished;
	
	send <= not finished;
	Inst_i2c_sender: i2c_sender PORT MAP(
		clk   => clk,
		rst   => rst,
		taken => taken,
		siod  => siod,
		sioc  => sioc,
		send  => send,
		id    => camera_address,
		reg   => command(15 downto 8),
		value => command(7 downto 0)
	);

	reset <= '1' when rst = '0' else '0'; 						   -- Normal mode
	pwdn  <= '0'; 						                           -- Power device up
	xclk_out  <= xclk_in;
	
	Inst_ov7670_registers: ov7670_registers PORT MAP(
		clk      => clk,
		rst      => rst,
		advance  => taken,
		command  => command,
		finished => finished,
		resend   => resend
	);
	
end Behavioral;

