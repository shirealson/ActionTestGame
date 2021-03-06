LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
----by:szy 2018/10/26
ENTITY ActionTestGame IS
	PORT(
	main_clk,main_reset: in std_logic;
	main_SW7,main_BTN0 : in std_logic;
	main_kbrow:IN STD_LOGIC_VECTOR(3 downto 0);--keyboard input
	main_keyborad_col : out std_logic_vector(3 downto 0) := "0000";
	main_beep : out std_logic;
	main_output_state : out std_logic_vector(5 downto 0);
	main_outputR : out std_logic_vector(7 downto 0);--decide dot's row
	main_outputC : out std_logic_vector(7 downto 0);--decide dot's col
	main_output_tube : out STD_LOGIC_VECTOR (6 downto 0);--decide a tube's number
	main_output_index : out STD_LOGIC_VECTOR (7 downto 0)--decide which tube will light
	);
END ENTITY ActionTestGame;
--clk:1MHZ
--timer_clk:10hz timer_clk = clk / 100000

architecture a of ActionTestGame is
signal main_timer_clk : std_logic;
signal main_game_clk : std_logic;
signal main_state : std_logic_vector(5 downto 0);
signal main_direction : std_logic_vector(3 downto 0);
signal main_lock_direction : std_logic_vector(3 downto 0);
signal main_tube_number : integer range 0 to 5000;	
signal main_keyboard_input : std_logic_vector(3 downto 0);
	
	component tube_display
		port(clk,timer_clk,clear: in std_logic;--scan frequency:1MHZ timer frequency:10hz
		 state : in std_logic_vector(5 downto 0);
		 input_number : in integer range 0 to 5000;--input_number : in integer range 0 to 15000;
		 output_tube : out STD_LOGIC_VECTOR (6 downto 0);--decide a tube's number
		 output_index : out STD_LOGIC_VECTOR (7 downto 0));--decide which tube will light
	end component;
	
	component dot_display
		port(clk,timer_clk,clear: in std_logic;--scan frequency:1MHZ timer frequency:10hz
		 state : in std_logic_vector(5 downto 0);
		 direction : in std_logic_vector(3 downto 0);
		 outputR : out std_logic_vector(7 downto 0);
		 outputC : out std_logic_vector(7 downto 0));
	end component;
	
	component state_core
		PORT(
			clk,timer_clk,reset: in std_logic;
			SW7,BTN0 : in std_logic;
			state : out std_logic_vector(5 downto 0));
	end component;
	
	component random_direction
		PORT(
			dclk: in std_logic;
			direction  : out std_logic_vector(3 downto 0));
	end component;
	component game_core
		PORT(
			clk,game_clk : in std_logic;
			state : in std_logic_vector(5 downto 0);
			input_direction : in std_logic_vector(3 downto 0);--the direction receive from the random_direction
			button : in std_logic_vector(3 downto 0);--receive the button input
			lock_direction : out std_logic_vector(3 downto 0);--output the lock direction
			tube_number : out integer range 0 to 5000);--output the score to the tubes
	end component;
	
	component button_scan
		PORT(
			game_clk:IN STD_LOGIC;
			kbrow:IN STD_LOGIC_VECTOR(3 downto 0);
			button_output : out std_logic_vector(3 downto 0)
			);
	end component;
	
	component div_10hz 
		port(dclk: in std_logic;
		 dclear: in std_logic;
		 clk_10 : out std_logic;
		 clk_1000 : out std_logic);
	end component;
	
	component beep
		port(
		clk : in std_logic;
		state : in std_logic_vector(5 downto 0);
		device : out std_logic
		);
	end component;
	


begin
p1 : game_core port map(clk=>main_clk,game_clk=>main_game_clk,state=>main_state,input_direction=>main_direction,
						button=>main_keyboard_input,lock_direction=>main_lock_direction,tube_number=>main_tube_number);
p2 : state_core port map(clk=>main_clk,timer_clk=>main_timer_clk,reset=>main_reset,SW7=>main_SW7,BTN0=>main_BTN0,
						state=> main_state);
p3 : dot_display port map(clk=>main_clk,timer_clk=>main_timer_clk,clear=>main_reset,state=>main_state,
						outputR=>main_outputR,outputC=>main_outputC,
						direction=>main_lock_direction);
p4 : tube_display port map(clk=>main_clk,timer_clk=>main_timer_clk,clear=>main_reset,state=>main_state,input_number => main_tube_number,
						output_tube=>main_output_tube,output_index=>main_output_index);
p5 : random_direction port map(dclk=>main_clk,direction=>main_direction);

p6 : button_scan port map(game_clk=>main_game_clk,
						kbrow=>main_kbrow,
						button_output => main_keyboard_input);
p7 : div_10hz port map(dclk=>main_clk,dclear=>main_reset,clk_10 => main_timer_clk,clk_1000 => main_game_clk);
p8 : beep port map(clk=>main_clk,state=>main_state,device=>main_beep);
main_output_state <= main_state;						
----connect every component
end a;

