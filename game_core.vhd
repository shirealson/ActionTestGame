LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--by:szy 2018/10/29
ENTITY game_core IS
	PORT(
	clk,game_clk : in std_logic;
	state : in std_logic_vector(5 downto 0);
	input_direction : in std_logic_vector(3 downto 0);--the direction receive from the random_direction
	button : in std_logic_vector(3 downto 0);--receive the button input
	lock_direction : out std_logic_vector(3 downto 0);--output the lock direction
	tube_number : out integer range 0 to 5000);--output the score to the tubes
END ENTITY game_core;

architecture a of game_core is
signal game_sec : integer range 0 to 13200;--the whole game time 13.8s
-----direction lock : keep the direction unchange in the game turn
signal random_direction : std_logic_vector(3 downto 0);
signal direction_lock : std_logic;
signal direction : std_logic_vector(3 downto 0);
signal score1,score2,score3 : integer range 0 to 5000;
signal total_score : integer range 0 to 5000;
signal timer : integer range 0 to 5000;--record the time
signal continue_game : std_logic;--each time you can press once
signal input_button : std_logic_vector(3 downto 0);
begin

process(game_clk)
begin
if game_clk'event and game_clk = '1' then
	if state = "000100" then
		if game_sec < 13800 then
			game_sec <= game_sec + 1;
		end if;
		--game_sec < 2100000 countdown
		if game_sec >= 2099 and game_sec < 2100 then -- game period : lock|display|off|unlock/display
				direction <= "1000";
				direction <= random_direction;
				timer <= 0;
				continue_game <= '1';
		elsif game_sec >= 2100 and game_sec < 2800 then
			input_button <= button;
			if input_button = "0000" and continue_game = '1' then-- if the button no pressed and you can continue
				timer <= timer + 1;
				
				
			elsif continue_game = '1' and not(input_button = "0000") then
				
				if input_button = direction then
					score1 <= timer;--correct
				else
					score1 <= 5000;--wrong
				end if;
				continue_game <= '0';
			end if;
		elsif game_sec > 2800 and game_sec < 5799 then
			if continue_game = '1' then--to solve no pressing the button
				score1 <= 5000;
			end if;
			tube_number <= score1;--display the score
			direction_lock <= '0';--unlock direction
		elsif game_sec >= 5799 and game_sec < 5800 then--turn 2 start
				direction <= random_direction;
				timer <= 0;
				continue_game <= '1';
		elsif game_sec >= 5800 and game_sec < 6500 then
			input_button <= button;
			if input_button = "0000" and continue_game = '1' then-- if the button no pressed and you can continue
				timer <= timer + 1;
				
				
			elsif continue_game = '1' and not(input_button = "0000") then
				if input_button = direction then
					score2 <= timer ;--correct
				else
					score2 <= 5000;--wrong
				end if;
				continue_game <= '0';
			end if;
		elsif game_sec >=6500 and game_sec < 9499 then
			if continue_game = '1' then--to solve no pressing the button
				score2 <= 5000;
			end if;
			tube_number <= score2;--display the score
			direction_lock <= '0';--unlock direction
		elsif game_sec >= 9499 and game_sec < 9500 then--turn 3 start
				direction <= random_direction;
				timer <= 0;
				continue_game <= '1';
		elsif game_sec >= 9500 and game_sec < 10200 then
			input_button <= button;
			if input_button = "0000" and continue_game = '1' then-- if the button no pressed and you can continue
				timer <= timer + 1;
				
				
			elsif continue_game = '1' and not(input_button = "0000") then
				if input_button = direction then
					score3 <= timer;--correct
				else
					score3 <= 5000;--wrong
				end if;
				continue_game <= '0';
			end if;
		elsif game_sec >=10200 and game_sec < 13200 then
			if continue_game = '1' then--to solve no pressing the button
				score3 <= 5000;
			end if;
			tube_number <= score3;--display the score
			direction_lock <= '0';--unlock direction
		end if;
	else
		
		game_sec <= 0;--when not used ,reset the information and display the total score
		tube_number <= total_score;
	end if;
end if;
end process;

process(score1,score2,score3)
begin
total_score <= (score1 + score2 + score3) / 3;
end process;

process (direction)
begin
	lock_direction <= direction;--write lock direction into OUTPUT
end process;

process(input_direction)
begin
	if game_clk'event and game_clk = '1' then
		random_direction <= input_direction;
	end if;
end process;

end a;


