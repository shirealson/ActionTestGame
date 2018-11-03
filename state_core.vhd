LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--by szy 2018/10/29
ENTITY state_core IS
	PORT(
	clk,timer_clk,reset: in std_logic;
	SW7,BTN0 : in std_logic;
	state : out std_logic_vector(5 downto 0));
END ENTITY state_core;

architecture a of state_core is


signal pre_state,nx_state : integer range 0 to 5;
--0 : off 1:self check 2: stand by 3 : game 4:gameboard
signal self_check_sec : integer range 0 to 30;
signal game_sec : integer range 0 to 132;


begin
	
	--------lower part of the state tranfer machine
	process(clk)
	begin
		
		if clk'event and clk = '1'then
			pre_state <= nx_state;--state tranfer
		end if;
		
	end process;
	-----lower part of the state machine
	process(pre_state,timer_clk,reset)--state1
	begin
	if reset = '1' then
		nx_state <= 0;
	else
		
	
	if timer_clk'event and timer_clk = '1' then
		if pre_state = 0 then
			nx_state <= 0;
			if SW7 = '1' then
				nx_state <= 1;
			end if;
			
		elsif pre_state = 1 then--self check	
			if self_check_sec < 30 then
				self_check_sec <= self_check_sec + 1;
			else
				nx_state <= 2;
				self_check_sec <= 0;
			end if;
		elsif pre_state = 2 then--stand by
			if BTN0 = '1' then
				nx_state <= 3;
			end if;
		elsif pre_state = 3 then--game
			if game_sec < 132 then
				game_sec <= game_sec + 1;
			else
				nx_state <= 4;
				game_sec <= 0;
			end if;
		elsif pre_state = 4 then--gameborad
			if BTN0 = '1' then
				nx_state <= 3;
			end if;
			
			
		end if;
	end if;
	end if;
	end process;
	
	
	
process(pre_state)
begin
	case(pre_state) is
		when 0 => state <= "100000";
		when 1 => state <= "010000";
		when 2 => state <= "001000";
		when 3 => state <= "000100";
		when 4 => state <= "000010";
		when 5 => state <= "000001";
		when others => state <= "100000";
	end case;
end process;	
end a;
			
			
			