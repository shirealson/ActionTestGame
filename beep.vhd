library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--by szy 2018/11/3
--design frequency : 1Mhz
entity beep is
	port(
		clk : in std_logic;
		state : in std_logic_vector(5 downto 0);
		device : out std_logic
		);
end entity beep;

architecture a of beep is
signal tone : integer range 0 to 27;
signal tone_frequency : integer range 0 to 2047;
signal clk4 : std_logic;--4hz
signal tmp : integer  range 0 to 124999;-- for the 4hz div
signal tmp2 : integer range 0 to 2048;--for the div tone
signal music_sec : integer range 0 to 30 := 0;
signal music_clk : std_logic;--final output frequency
signal bool_play : std_logic := '0';
begin

div_4 : process(clk)
begin
if clk'event and clk = '1' then
		if tmp = 124999 then
			tmp <= 0;clk4 <= not clk4;
		else
			tmp <= tmp + 1;
		end if;
end if;
end process div_4;


search : process(tone)
begin
	case tone is
		when 1 => tone_frequency<=1911;
		when 2 => tone_frequency<=1702;
		when 3 => tone_frequency<=1517;
		when 4 => tone_frequency<=1432;
		when 5 => tone_frequency<=1275;
		when 6 => tone_frequency<=1136;
		when 7 => tone_frequency<=1012;
		when 11 => tone_frequency<=955;
		when 12 => tone_frequency<=851;
		when 13 => tone_frequency<=758;
		when 14 => tone_frequency<=715;
		when 15 => tone_frequency<=637;
		when 16 => tone_frequency<=568;
		when 17 => tone_frequency<=506;
		when 21 => tone_frequency<=478;
		when 22 => tone_frequency<=425;
		when 23 => tone_frequency<=379;
		when 24 => tone_frequency<=359;
		when 25 => tone_frequency<=319;
		when 26 => tone_frequency<=284;
		when 27 => tone_frequency<=253;
		when others => tone_frequency<=0;
	end case;

end process search;

xin_baodao : process(state,clk4)
begin
	if state = "000001" and bool_play = '0' then
		bool_play <= '1';
	else
		if clk4'event and clk4 = '1' then
			if bool_play = '1' then --play
				if music_sec <= 30 then
					music_sec <= music_sec + 1;
				end if;
				
				case music_sec is
					when 0 => tone<=6;  -- -6
					when 1 => tone<=13;  --3
					when 2 => tone<=12;  --2
					when 3 => tone<=13;  --3
					when 4 => tone<=15;  --5
					when 5 => tone<=13;  --3
					when 6 => tone<=12;  --2
					when 7 => tone<=13;  --3
					when 8 => tone<=13;  --3
					when 9 => tone<=0;  --0
					when 10 => tone<=0;  --0
					when 11 => tone<=6;  ---6
					when 12 => tone<=13;  --3
					when 13 => tone<=12;  --2
					when 14 => tone<=13;  --3
					when 15 => tone<=16;  --6
					when 16 => tone<=13;  --3
					when 17 => tone<=12;  --2
					when 18 => tone<=13;  --3
					when 19 => tone<=13;  --3
					when 20 => tone<=0;  --0
					when 21 => tone<=0;  --0
					when 22 => tone<=0;  --
					when 23 => tone<=0;  --
					when 24 => tone<=0;  --
					when 25 => tone<=0;  --
					when 26 => tone<=0;  --
					when 27 => tone<=0;  --
					when 28 => tone<=0;  --
					when 29 => tone<=0;  --
					when 30 => 
						bool_play <= '0';--stop play
						music_sec <= 0;--reset
				end case;
			else
				tone <= 0;
				
			end if; 
		end if;
	end if;
end process xin_baodao;

div_tone : process(tone_frequency,clk)
begin
	if clk'event and clk = '1' then
		if not (tone_frequency = 0) then
			if tmp2 = tone_frequency then
				tmp2 <= 0;music_clk <= not music_clk;
			else
				tmp2 <= tmp2 + 1;
			end if;
		else
			music_clk <= '0';
		end if;
	end if;
end process div_tone;

device <= music_clk;

end a;
