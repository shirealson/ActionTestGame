library ieee;
use ieee.std_logic_1164.all;
--by:szy 2018/10/22
entity dot_display is
	port(clk,timer_clk,clear: in std_logic;--scan frequency:1MHZ timer frequency:10hz
		 state : in std_logic_vector(5 downto 0);
		 direction : in std_logic_vector(3 downto 0);
		 outputR : out std_logic_vector(7 downto 0);
		 outputC : out std_logic_vector(7 downto 0));
		 

	
end entity dot_display;

architecture a of dot_display is
	signal tempR : std_logic_vector(7 downto 0);--Row
	signal tempC : std_logic_vector (7 downto 0);--Col
	signal i : integer range 0 to 7;
	signal j : integer range 0 to 35;
	signal state1_state : std_logic;
	signal game_sec : integer range 0 to 132;
	signal game_state : integer range 0 to 4;--0: off 1 : number 3 2:number2 3:number3 4:the direction
	signal score_state : std_logic;-- 0: off 1:light
	signal score_sec : integer range 0 to 5;

begin
	 
	-------lower part of the state machine
	process(timer_clk,j,state)
	begin
	if timer_clk'event and timer_clk = '1' then
		if state = "010000" then--state1: self_check	
			
					--initialize timer
				if j < 35 then
					j<= j + 1;
				end if;
					--blink 3 times,then light off
				if j<5 then
					state1_state <= '1';
				elsif j<10 then
					state1_state<= '0';
				elsif j<15 then
					state1_state <= '1';
				elsif j<20 then
					state1_state <= '0';
				elsif j<25 then
					state1_state <= '1';
				elsif j<30 then
					state1_state <= '0';
				else
					state1_state <= '0';
				end if;
			
		elsif state = "000100" then
				j <= 0;--reset for next self_check
					--initialize timer
				if game_sec < 132 then--the whole game period : 13.8s a game period : lock 0.1s |light 0.5s|off 0.2s| unlock 0.1s
					game_sec <= game_sec + 1;
				end if;
					--count down
				if game_sec<5 then
					game_state <= 3;
				elsif game_sec<7 then
					game_state <= 0;
				elsif game_sec<12 then
					game_state <= 2;
				elsif game_sec < 14 then
					game_state <= 0;
				elsif game_sec<19 then
					game_state <= 1;
				elsif game_sec < 21 then --display :3 2 1
					game_state <= 0;
				elsif game_sec < 26 then--the first direction
					game_state <= 4;--light
				elsif game_sec < 28 then
					game_state <= 0;--off
				elsif game_sec <= 58 then -- wait 3 second
					game_state <= 0;
				elsif game_sec < 63 then--the second direction
					game_state <= 4;--light
				elsif game_sec < 65 then
					game_state <= 0;--off
				elsif game_sec <= 95 then --wait 3 second
					game_state <= 0;
				elsif game_sec < 100 then--the third direction
					game_state <= 4;--light
				elsif game_sec < 102 then
					game_state <= 0;--off
				elsif game_sec <= 132 then--wait 3 second
					game_state <= 0;
				else
					game_state <= 0;
				end if; 
			
		elsif state = "000010" then --state4: display the scoreboard
				game_sec <= 0; --reset the game_sec for next play
				if score_sec = 5 then
					score_sec <= 0;
					score_state <= not score_state;
				else
					score_sec <= score_sec + 1;
				end if;
			
		end if;
	end if;	
	end process;
			
		--upper part of the state machine
	process(game_state,state1_state,clk,state)
	begin
		if clk'event and clk = '1' then --initialize scan counter
				if i=7 then
					i<=0;
				else
					i<=i+1;
				end if;
		end if;
		-------------------------------------------------------------------
		---------------display--------------------------------------
		if state = "100000" then--off
			tempC <= "00000000";
			tempR <= "00000000";
		elsif state = "010000" then --self check
			
	 
			
			
			
			if state1_state = '1' then	
				case(i) is
					when 7 => tempC <= "11111111";tempR<="01111111";
					when 6 => tempC <= "11111111";tempR<="10111111";
					when 5 => tempC <= "11111111";tempR<="11011111";
					when 4 => tempC <= "11111111";tempR<="11101111";
					when 3 => tempC <= "11111111";tempR<="11110111";
					when 2 => tempC <= "11111111";tempR<="11111011";
					when 1 => tempC <= "11111111";tempR<="11111101";
					when 0 => tempC <= "11111111";tempR<="11111110";
					when others => i<=0;
				end case;
			else
				case(i) is
					when 7 => tempC <= "00000000";tempR<="01111111";
					when 6 => tempC <= "00000000";tempR<="01000000";
					when 5 => tempC <= "00000000";tempR<="11011111";
					when 4 => tempC <= "00000000";tempR<="11101111";
					when 3 => tempC <= "00000000";tempR<="11110111";
					when 2 => tempC <= "00000000";tempR<="11111011";
					when 1 => tempC <= "00000000";tempR<="11111101";
					when 0 => tempC <= "00000000";tempR<="11111110";
					when others => i<=0;
				end case;
			end if;
		
		
		elsif state = "000100" then --state:game
			if game_state = 0 then
				tempC <= "00000000";
				tempR <= "00000000";
			elsif game_state = 3 then --number3
				case(i) is
					when 7 => tempC <= "11111111";tempR<="01111111";
					when 6 => tempC <= "00000001";tempR<="10111111";
					when 5 => tempC <= "00000001";tempR<="11011111";
					when 4 => tempC <= "11111111";tempR<="11101111";
					when 3 => tempC <= "00000001";tempR<="11110111";
					when 2 => tempC <= "00000001";tempR<="11111011";
					when 1 => tempC <= "00000001";tempR<="11111101";
					when 0 => tempC <= "11111111";tempR<="11111110";
					when others => i<=0;
				end case;
			elsif game_state = 2 then--number 2
				case(i) is
					when 7 => tempC <= "11111111";tempR<="01111111";
					when 6 => tempC <= "00000001";tempR<="10111111";
					when 5 => tempC <= "00000001";tempR<="11011111";
					when 4 => tempC <= "11111111";tempR<="11101111";
					when 3 => tempC <= "10000000";tempR<="11110111";
					when 2 => tempC <= "10000000";tempR<="11111011";
					when 1 => tempC <= "10000000";tempR<="11111101";
					when 0 => tempC <= "11111111";tempR<="11111110";
					when others => i<=0;
				end case;
			elsif game_state = 1 then
				case(i) is
					when 7 => tempC <= "00011000";tempR<="01111111";
					when 6 => tempC <= "00011000";tempR<="10111111";
					when 5 => tempC <= "00011000";tempR<="11011111";
					when 4 => tempC <= "00011000";tempR<="11101111";
					when 3 => tempC <= "00011000";tempR<="11110111";
					when 2 => tempC <= "00011000";tempR<="11111011";
					when 1 => tempC <= "00011000";tempR<="11111101";
					when 0 => tempC <= "00011000";tempR<="11111110";
					when others => i<=0;
				end case;
			elsif game_state = 4 then
				if direction = "1000" then --up
					case(i) is
						when 7 => tempC <= "11100111";tempR<="01111111";
						when 6 => tempC <= "10100101";tempR<="10111111";
						when 5 => tempC <= "10100101";tempR<="11011111";
						when 4 => tempC <= "10100101";tempR<="11101111";
						when 3 => tempC <= "10111101";tempR<="11110111";
						when 2 => tempC <= "10000001";tempR<="11111011";
						when 1 => tempC <= "10000001";tempR<="11111101";
						when 0 => tempC <= "11111111";tempR<="11111110";
						when others => i<=0;
					end case;
				elsif direction = "0100" then --down
					case(i) is
						when 7 => tempC <= "11111111";tempR<="01111111";
						when 6 => tempC <= "10000001";tempR<="10111111";
						when 5 => tempC <= "10000001";tempR<="11011111";
						when 4 => tempC <= "10111101";tempR<="11101111";
						when 3 => tempC <= "10100101";tempR<="11110111";
						when 2 => tempC <= "10100101";tempR<="11111011";
						when 1 => tempC <= "10100101";tempR<="11111101";
						when 0 => tempC <= "11100111";tempR<="11111110";
						when others => i<=0;
					end case;
				elsif direction = "0010" then --left
					case(i) is
						when 7 => tempC <= "11111111";tempR<="01111111";
						when 6 => tempC <= "10000001";tempR<="10111111";
						when 5 => tempC <= "11111001";tempR<="11011111";
						when 4 => tempC <= "00001001";tempR<="11101111";
						when 3 => tempC <= "00001001";tempR<="11110111";
						when 2 => tempC <= "11111001";tempR<="11111011";
						when 1 => tempC <= "10000001";tempR<="11111101";
						when 0 => tempC <= "11100111";tempR<="11111110";
						when others => i<=0;
					end case;
				elsif direction = "0001" then --right
					case(i) is
						when 7 => tempC <= "11111111";tempR<="01111111";
						when 6 => tempC <= "10000001";tempR<="10111111";
						when 5 => tempC <= "10011111";tempR<="11011111";
						when 4 => tempC <= "10010000";tempR<="11101111";
						when 3 => tempC <= "10010000";tempR<="11110111";
						when 2 => tempC <= "10011111";tempR<="11111011";
						when 1 => tempC <= "10000001";tempR<="11111101";
						when 0 => tempC <= "11111111";tempR<="11111110";
						when others => i<=0;
					end case;
				end if;
			end if;
		elsif state = "000010" then
			if score_state = '1' then
				case(i) is --display the love
					when 7 => tempC <= "01100110";tempR<="01111111";
					when 6 => tempC <= "11111111";tempR<="10111111";
					when 5 => tempC <= "11111111";tempR<="11011111";
					when 4 => tempC <= "11111111";tempR<="11101111";
					when 3 => tempC <= "11111111";tempR<="11110111";
					when 2 => tempC <= "01111110";tempR<="11111011";
					when 1 => tempC <= "00111100";tempR<="11111101";
					when 0 => tempC <= "00011000";tempR<="11111110";
					when others => i<=0;
				end case;
			else
				case(i) is
					when 7 => tempC <= "00000000";tempR<="01111111";
					when 6 => tempC <= "00000000";tempR<="10111111";
					when 5 => tempC <= "00000000";tempR<="11011111";
					when 4 => tempC <= "00000000";tempR<="11101111";
					when 3 => tempC <= "00000000";tempR<="11110111";
					when 2 => tempC <= "00000000";tempR<="11111011";
					when 1 => tempC <= "00000000";tempR<="11111101";
					when 0 => tempC <= "00000000";tempR<="11111110";
					when others => i<=0;
				end case;
			end if;
		end if;
	end process;
		
	

	---output
outputR<=tempR;
outputC<=tempC;


end a;
	
			
			
		
		
		
		
	
	