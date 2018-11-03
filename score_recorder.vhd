library ieee;
use ieee.std_logic_1164.all;

entity score_recorder is
	port(input: in integer range 0 to 10000;
		reset: in std_logic;
		output : out integer range 0 to 10000);
end entity;

architecture D of score_recorder is
	signal temp: integer range 0 to 10000;
begin
	process (reset,input)
		begin
			if reset='1' then
				temp <= 0;
			else
				temp<= input;
			end if;
	end process;
	output <= temp;
end D;

