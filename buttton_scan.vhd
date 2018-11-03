LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.MATH_REAL.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY button_scan IS
PORT(
      clk:IN STD_LOGIC;
	  kbrow0,kbrow1,kbrow2,kbrow3:IN STD_LOGIC;
	  button_output : out std_logic_vector(3 downto 0)
);
END ENTITY button_scan;

architecture a of button_scan is
	SIGNAL up,down,left,right : std_logic:='0';
	SIGNAL clk500:STD_LOGIC;--button scan frequency
	SIGNAL clk50k:STD_LOGIC; 
	SIGNAL clk1:INTEGER RANGE 0 TO 49999;
	SIGNAL clk3:INTEGER RANGE 0 TO 499;
	SIGNAL kbcols:STD_LOGIC_VECTOR(0 TO 3); 
	
	
begin
	P1:PROCESS(clk)                         --º¸≈Ã…®√Ë500hz 1m / 500 = 2000
	begin
	if clk'event and clk='1'then
		if clk1=999 then 
			clk1<=0;clk500<=not clk500;
		else
			clk1<=clk1+1;
		end if;
	end if;
	end process P1;
	
	P2:PROCESS(clk)                           --∞¥º¸∑÷∆µ1khz 1M / 1k = 1000
	begin
	if clk'event and clk='1'then
		if clk3=499 then 
			clk3<=0;clk50k<=not clk50k;
		else
			clk3<=clk3+1;
		end if;
	end if;
	end process P2;
	
	saomiao:process(clk500)                        --º¸≈Ã…®√Ë
	begin
	if(clk500'event and clk500='1')then
		case kbcols is
			when "0111" => kbcols<="1011";
			when "1011" => kbcols<="1101";
			when "1101" => kbcols<="1110";
			when "1110" => kbcols<="0111";
			when others => kbcols<="0111";
		end case;
	end if;
	end process saomiao;
	
	--------------------------------------------------------------------------------------------------------------
--∞¥º¸…Ë÷√”Î∑¿∂∂
	KEY1:process(kbrow2,clk50k)                      --up
	variable count1: integer range 0 to 99:=0;
	begin
	if(clk50k'event and clk50k='1')then
		if(kbcols="1011")then
			if(up='0')then
				if(count1=99)then
					count1:=0;
					up<='1';
				else
					if(kbrow3='0')then
						count1:=count1+1;
					else
						count1:=0;
					end if;
				end if;
			else
				if(kbrow3='1')then
					up<='0';
				end if;
			end if;
		end if;
	end if;
	end process KEY1;

	KEY2:process(kbrow0,clk50k)                      --down
	variable count1: integer range 0 to 99:=0;
	begin
	if(clk50k'event and clk50k='1')then
		if(kbcols="1011")then
			if(down='0')then
				if(count1=99)then
					count1:=0;
					down<='1';
				else
					if(kbrow1='0')then
						count1:=count1+1;
					else
						count1:=0;
					end if;
				end if;
			else
				if(kbrow1='1')then
					down<='0';
				end if;
			end if;
		end if;
	end if;
	end process KEY2;

	KEY3:process(kbrow1,clk50k)                      --left
	variable count1: integer range 0 to 99:=0;
	begin
	if(clk50k'event and clk50k='1')then
		if(kbcols="0111")then
			if(left='0')then
				if(count1=99)then
					count1:=0;
					left<='1';
				else
					if(kbrow2='0')then
						count1:=count1+1;
					else
						count1:=0;
					end if;
				end if;
			else
				if(kbrow2='1')then
					left<='0';
				end if;
			end if;
		end if;
	end if;
	end process KEY3;

	KEY4:process(kbrow1,clk50k)                      --right
	variable count1: integer range 0 to 99:=0;
	begin
	if(clk50k'event and clk50k='1')then
		if(kbcols="1101")then
			if(right='0')then
				if(count1=99)then
					count1:=0;
					right<='1';
				else
					if(kbrow2='0')then
						count1:=count1+1;
					else
						count1:=0;
					end if;
				end if;
			else
				if(kbrow2='1')then
					right<='0';
				end if;
			end if;
		end if;
	end if;
	end process KEY4;
	
	OUTPUT_KEY : process(up,down,left,right)
	begin
	if up = '1' then
		button_output <= "1000";
	elsif down = '1' then
		button_output <= "0100";
	elsif left = '1' then
		button_output <= "0010";
	elsif right = '1' then
		button_output <= "0001";
	else
		button_output <= "0000";
	end if;
	end process OUTPUT_KEY;
end a;
	
	
	
