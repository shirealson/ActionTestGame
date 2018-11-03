library ieee;
use ieee.std_logic_1164.all;
--by:szy 2018/10/22
entity tube_display is
	port(clk,timer_clk,clear: in std_logic;--scan frequency:1MHZ timer frequency:10hz
		 state : in std_logic_vector(5 downto 0);
		 input_number : in integer range 0 to 5000;--input_number : in integer range 0 to 15000;
		 output_tube : out STD_LOGIC_VECTOR (6 downto 0);--decide a tube's number
		 output_index : out STD_LOGIC_VECTOR (7 downto 0));--decide which tube will light

	
end entity tube_display;

architecture a of tube_display is
	signal temp_tube : std_logic_vector(6 downto 0);--tube
	signal temp_index : std_logic_vector (7 downto 0);--index
	signal i : integer range 0 to 7;
	signal j : integer range 0 to 35;
	type self_check_state is (LIGHT,OFF);
	signal state1_state : self_check_state;
	signal game_sec : integer range 0 to 132;
	signal game_state : integer range 0 to 1; --2 state : 0 off 1 display one turn's score
	signal score_sec : integer range 0 to 5; 
	signal score_state : std_logic;
	type current_state is (st0,st1,st2);
	signal current_state1 : current_state:= st0;
	signal reg : integer range 0 to 5000;
	signal d1,d2,d3,d4 : integer range 0 to 9;
	signal number1,number2,number3,number4 : integer  range 0 to 9;
	signal tube1,tube2,tube3,tube4 : std_logic_vector(6 downto 0);

begin
	
	-----tranlate--------------------------

	translate : process(input_number,clk)
	
	begin
	if clk'event and clk='1' then 
		if current_state1 = st0 then
       
			reg <= input_number;
                    
            d1<=0;d2<=0;d3<=0;d4<=0;
            current_state1<=st1; 
                 
		elsif current_state1 = st1 then 
            if  reg>999 then 
            reg<=reg-1000;   
            d1 <= d1 + 1;   
                     --current_state1<=st1;     
            elsif  reg>99  then 
                reg<=reg-100;      
                d2 <= d2 + 1;  
                     --current_state1<=st1;          
            elsif  reg>9   then 
                reg<=reg-10;     
                d3 <= d3 + 1;       
                     --current_state1<=st1;  
            elsif  reg>0    then 
                reg<=reg-1;      
                d4 <= d4 + 1;     
                     --current_state1<=st1;  
            else
				current_state1<=st2; 
            end if;
                
		else
            current_state1 <=st0;
            number1<=d1;number2<=d2;number3<=d3;number4<=d4;
            case(number1) is
				when 0 => tube1 <= "1111110";--tranlate number to tube vector
				when 1 => tube1 <= "0110000";
				when 2 => tube1 <= "1101101";
				when 3 => tube1 <= "1111001";
				when 4 => tube1 <= "0110011";
				when 5 => tube1 <= "1011011";
				when 6 => tube1 <= "1011111";
				when 7 => tube1 <= "1110000";
				when 8 => tube1 <= "1111111";
				when 9 => tube1 <= "1111011";
				when others => tube1 <= "0000000";
			end case;
			case(number2) is
				when 0 => tube2 <= "1111110";--tranlate number to tube vector
				when 1 => tube2 <= "0110000";
				when 2 => tube2 <= "1101101";
				when 3 => tube2 <= "1111001";
				when 4 => tube2 <= "0110011";
				when 5 => tube2 <= "1011011";
				when 6 => tube2 <= "1011111";
				when 7 => tube2 <= "1110000";
				when 8 => tube2 <= "1111111";
				when 9 => tube2 <= "1111011";
				when others => tube2 <= "0000000";
			end case;
			case(number3) is
				when 0 => tube3 <= "1111110";--tranlate number to tube vector
				when 1 => tube3 <= "0110000";
				when 2 => tube3 <= "1101101";
				when 3 => tube3 <= "1111001";
				when 4 => tube3 <= "0110011";
				when 5 => tube3 <= "1011011";
				when 6 => tube3 <= "1011111";
				when 7 => tube3 <= "1110000";
				when 8 => tube3 <= "1111111";
				when 9 => tube3 <= "1111011";
				when others => tube3 <= "0000000";
			end case;
			case(number4) is
				when 0 => tube4 <= "1111110";--tranlate number to tube vector
				when 1 => tube4 <= "0110000";
				when 2 => tube4 <= "1101101";
				when 3 => tube4 <= "1111001";
				when 4 => tube4 <= "0110011";
				when 5 => tube4 <= "1011011";
				when 6 => tube4 <= "1011111";
				when 7 => tube4 <= "1110000";
				when 8 => tube4 <= "1111111";
				when 9 => tube4 <= "1111011";
				when others => tube4 <= "0000000";
			end case;
		end if;
	end if; 
	end process translate;
	
	
			-------lower part of the state machine
	-------lower part of the state machine
	process(timer_clk,j,state)
	begin
	if timer_clk'event and timer_clk = '1' then
		if state = "010000" then	
			
					--initialize timer
				if j < 35 then
					j<= j + 1;
				end if;
					--blink 3 times,then light off
				if j<5 then
					state1_state <= LIGHT;
				elsif j<10 then
					state1_state<= OFF;
				elsif j<15 then
					state1_state <= LIGHT;
				elsif j<20 then
					state1_state <= OFF;
				elsif j<25 then
					state1_state <= LIGHT;
				elsif j<30 then
					state1_state <= OFF;
				else
					state1_state <= OFF;
				end if;
		elsif state = "000100" then--game period
					--initialize timer
				j <= 0;
				if game_sec < 132 then--the whole game period : 13.8s a game period : lock 0.1s |light 0.5s|off 0.2s| unlock 0.1s
					game_sec <= game_sec + 1;
				end if;
					--count down
				if game_sec > 21 and game_sec <= 132 then --while playing
					game_state <= 1;--light
				else
					game_state <= 0;
				end if; 
		elsif state = "000010" then --state : score board
				game_sec <= 0; --reset the timer for next play
					--initialize timer
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
	process(state1_state,clk,state)
	begin
		if clk'event and clk = '1' then --initialize scan counter
				if i=7 then
					i<=0;
				else
					i<=i+1;
				end if;
		end if;
		
		if state = "100000" then
			temp_tube <= "0000000";
			temp_index <= "00000000";
		elsif state = "010000" then
			
	 
			
			
			-------------------------------------------------------------------
			---------------display--------------------------------------
			if state1_state = LIGHT then	
				case(i) is
					when 0 => temp_tube <= "1111111";temp_index<="01111111";
					when 1 => temp_tube <= "1111111";temp_index<="10111111";
					when 2 => temp_tube <= "1111111";temp_index<="11011111";
					when 3 => temp_tube <= "1111111";temp_index<="11101111";
					when 4 => temp_tube <= "1111111";temp_index<="11110111";
					when 5 => temp_tube <= "1111111";temp_index<="11111011";
					when 6 => temp_tube <= "1111111";temp_index<="11111101";
					when 7 => temp_tube <= "1111111";temp_index<="11111110";
					when others => i<=0;
				end case;
			else
				case(i) is
					when 0 => temp_tube <= "0000000";temp_index<="01111111";
					when 1 => temp_tube <= "0000000";temp_index<="10111111";
					when 2 => temp_tube <= "0000000";temp_index<="11011111";
					when 3 => temp_tube <= "0000000";temp_index<="11101111";
					when 4 => temp_tube <= "0000000";temp_index<="11110111";
					when 5 => temp_tube <= "0000000";temp_index<="11111011";
					when 6 => temp_tube <= "0000000";temp_index<="11111101";
					when 7 => temp_tube <= "0000000";temp_index<="11111110";
					when others => i<=0;
				end case;
			end if;
		
		
		elsif state = "000100" then
			
			if game_state = 0 then
				case(i) is
					when 0 => temp_tube <= "0000000";temp_index<="01111111";
					when 1 => temp_tube <= "0000000";temp_index<="10111111";
					when 2 => temp_tube <= "0000000";temp_index<="11011111";
					when 3 => temp_tube <= "0000000";temp_index<="11101111";
					when 4 => temp_tube <= "0000000";temp_index<="11110111";
					when 5 => temp_tube <= "0000000";temp_index<="11111011";
					when 6 => temp_tube <= "0000000";temp_index<="11111101";
					when 7 => temp_tube <= "0000000";temp_index<="11111110";
					when others => i<=0;
				end case;
			else
				case(i) is
					when 0 => temp_tube <= tube1;temp_index<="01111111";
					when 1 => temp_tube <= tube2;temp_index<="10111111";
					when 2 => temp_tube <= tube3;temp_index<="11011111";
					when 3 => temp_tube <= tube4;temp_index<="11101111";
					when 4 => temp_tube <= "0000000";temp_index<="11110111";
					when 5 => temp_tube <= "0000000";temp_index<="11111011";
					when 6 => temp_tube <= "0000000";temp_index<="11111101";
					when 7 => temp_tube <= "0000000";temp_index<="11111110";
					when others => i<=0;
				end case;
			end if;
		
		
		elsif state = "000010" then
			
			if score_state = '0' then
				case(i) is
					when 0 => temp_tube <= "0000000";temp_index<="01111111";
					when 1 => temp_tube <= "0000000";temp_index<="10111111";
					when 2 => temp_tube <= "0000000";temp_index<="11011111";
					when 3 => temp_tube <= "0000000";temp_index<="11101111";
					when 4 => temp_tube <= "0000000";temp_index<="11110111";
					when 5 => temp_tube <= "0000000";temp_index<="11111011";
					when 6 => temp_tube <= "0000000";temp_index<="11111101";
					when 7 => temp_tube <= "0000000";temp_index<="11111110";
					when others => i<=0;
				end case;
			else
				case(i) is
					when 0 => temp_tube <= tube1;temp_index<="01111111";
					when 1 => temp_tube <= tube2;temp_index<="10111111";
					when 2 => temp_tube <= tube3;temp_index<="11011111";
					when 3 => temp_tube <= tube4;temp_index<="11101111";
					when 4 => temp_tube <= "0000000";temp_index<="11110111";
					when 5 => temp_tube <= "0000000";temp_index<="11111011";
					when 6 => temp_tube <= "0000000";temp_index<="11111101";
					when 7 => temp_tube <= "0000000";temp_index<="11111110";
					when others => i<=0;
				end case;
			end if;
		else
			case(i) is
					when 0 => temp_tube <= "0000000";temp_index<="01111111";
					when 1 => temp_tube <= "0000000";temp_index<="10111111";
					when 2 => temp_tube <= "0000000";temp_index<="11011111";
					when 3 => temp_tube <= "0000000";temp_index<="11101111";
					when 4 => temp_tube <= "0000000";temp_index<="11110111";
					when 5 => temp_tube <= "0000000";temp_index<="11111011";
					when 6 => temp_tube <= "0000000";temp_index<="11111101";
					when 7 => temp_tube <= "0000000";temp_index<="11111110";
					when others => i<=0;
			end case;		
		end if;
	end process;
	
	---output
output_index<=temp_index;
output_tube<=temp_tube;	

end a;