library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity random_direction is
	port(dclk: in std_logic;
		direction  : out std_logic_vector(3 downto 0));
end random_direction;

architecture a of random_direction is
	signal temp_num : integer range 0 to 3;
begin
process (dclk)
begin
	if dclk'event and dclk = '1' then
		if temp_num = 3 then
			temp_num <= 0;
		else
			temp_num <= temp_num + 1;
		end if;
	end if;
end process;

process (temp_num)
begin
	case(temp_num) is
		when 0=>direction<="1000";
		when 1=>direction<="0100";
		when 2=>direction<="0010";
		when 3=>direction<="0001";
	end case;
end process;
end a;