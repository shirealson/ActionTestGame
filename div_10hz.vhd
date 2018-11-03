library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity div_10hz is
	port(dclk: in std_logic;
		 dclear: in std_logic;
		 clk_10 : out std_logic;
		 clk_1000 : out std_logic);
end div_10hz;

architecture a of div_10hz is
	signal tmp: integer range 0 to 49999;
	signal tmp2 : integer range 0 to 499;
	signal clktmp1 : std_logic;
	signal clktmp2 : std_logic;
begin
process (dclear,dclk)
begin
	if dclear='1' then
		tmp <= 0;
	elsif dclk'event and dclk = '1' then
		if tmp = 49999 then
			tmp <= 0;clktmp1 <= not clktmp1;
		else
			tmp <= tmp + 1;
		end if;
	end if;
end process;

process (dclear,dclk)
begin
	if dclear='1' then
		tmp2 <= 0;
	elsif dclk'event and dclk = '1' then
		if tmp2 = 499 then
			tmp2 <= 0;clktmp2 <= not clktmp2;
		else
			tmp2 <= tmp2 + 1;
		end if;
	end if;
end process;

clk_10 <= clktmp1;
clk_1000 <= clktmp2;
end a;