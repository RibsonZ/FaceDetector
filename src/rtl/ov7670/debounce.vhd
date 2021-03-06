----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>, Wojciech Zebrowski, Miko?aj Karelus
-- source: https://www.fpga4student.com/2018/08/basys-3-fpga-ov7670-camera.html
-- Description: Convert the push button to a tick (formerly 1PPS) that can be used
-- to restart camera initialisation
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce is
    Port ( clk : in  STD_LOGIC;
           rst : in STD_LOGIC;
           i : in  STD_LOGIC;
           o : out  STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
	signal c : unsigned(23 downto 0);
	signal tick_flag : STD_LOGIC;
    constant threshold : unsigned(23 downto 0) := x"04c4b4";--x"1312D0";
	
begin
	process(clk)
	begin
        if rising_edge(clk) then
            if rst = '1' then
                c <= (others => '0');
                o <= '0';
                tick_flag <= '0';
            elsif i = '1' then
                tick_flag <= tick_flag;
                if c = threshold then
					if tick_flag = '1' then
                        o <= '0';
                    else
                        o <= '1';
                        tick_flag <= '1';
                    end if;
					c <= c;
				else
					o <= '0';
					c <= c+1; -- increment moved here to provide only one tick per click
				end if;
			else
			    tick_flag <= '0';
				c <= (others => '0');
				o <= '0';
			end if;
		end if;
	end process;

end Behavioral;

