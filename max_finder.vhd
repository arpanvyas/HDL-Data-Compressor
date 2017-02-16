library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity max_finder is
port	(
			r_data:in std_logic_vector(511 downto 0);
			rst,clk:in std_logic;
			s_ahead:in std_logic;
			data_out:out std_logic_vector(255 downto 0);
			valid_out:out std_logic;
			expo: out std_logic_vector(3 downto 0)
);
end max_finder;

architecture Behavioral of max_finder is
signal max_s: unsigned(7 downto 0);
signal lead0,lead0_minus:unsigned (3 downto 0);
type array_type32 is array (31 downto 0) of std_logic_vector(7 downto 0);
signal array32: array_type32;
type array_type16 is array (15 downto 0) of std_logic_vector(7 downto 0);
signal array16: array_type16;
type array_type8 is array (7 downto 0) of std_logic_vector(7 downto 0);
signal array8: array_type8;
type array_type4 is array (3 downto 0) of std_logic_vector(7 downto 0);
signal array4: array_type4;
type array_type2 is array (1 downto 0) of std_logic_vector(7 downto 0);
signal array2: array_type2;

signal max_up,lead0_up:std_logic:='0';

signal valid_out1,valid_out2: std_logic;
signal s_ahead_shift: unsigned(6 downto 0);


begin

process(clk,rst)
begin
		if rst='1' then max_s<="00000000";
		elsif rising_edge(clk) then
				for i in 0 to 31 loop
					if(unsigned(r_data(i*8+7 downto i*8))>unsigned(r_data(i*8+256+7 downto i*8+256))) then
					array32(i)<=r_data(i*8+7 downto i*8);
					else array32(i)<=r_data(i*8+256+7 downto i*8+256);
					end if;
				end loop;
				
				for j in 0 to 15 loop
					if(unsigned(array32(j))>unsigned(array32(j+16))) then
					array16(j)<=array32(j);
					else array16(j)<=array32(j+16);
					end if;
				end loop;
				
				for k1 in 0 to 7 loop
					if(unsigned(array16(k1))>unsigned(array16(k1+8))) then
					array8(k1)<=array16(k1);
					else array8(k1)<=array16(k1+8);
					end if;
				end loop;
				
				for k in 0 to 3 loop
					if(unsigned(array8(k))>unsigned(array8(k+4))) then
					array4(k)<=array8(k);
					else array4(k)<=array8(k+4);
					end if;
				end loop;
				
				for m in 0 to 1 loop
					if(unsigned(array4(m))>unsigned(array4(m+2))) then
					array2(m)<=array4(m);
					else array2(m)<=array4(m+2);
					end if;
				end loop;
				
				if(unsigned(array2(1))>unsigned(array2(0))) then max_s<=unsigned(array2(1));
				else max_s<=unsigned(array2(0));
				end if;
			end if;
--	max_v:=unsigned(r_data(7 downto 0));
--	for i in 0 to 64 loop
--		if (i<64) then
--			if(unsigned(r_data(i*8+7 downto i*8))>max_v) then 
--			max_v:=unsigned(r_data(i*8+7 downto i*8));
--			end if;
--		end if;
--	if (i=64) then max_s<=max_v;
--	end if;
--	end loop;
end process;


process(max_s)
begin
			if    max_s(7)='1' then lead0<="0000";
			elsif max_s(6)='1' then lead0<="0001";
			elsif max_s(5)='1' then lead0<="0010";
			elsif max_s(4)='1' then lead0<="0011";
			else   					 lead0<="0100";
			end if;
end process;

process(valid_out2)
begin
	if valid_out2='1' then
	for i in 0 to 63 loop
			
			case lead0 is  
				when "0000" =>
							data_out(i*4+3 downto i*4)<=r_data(7+i*8 downto i*8+4);
				when "0001" =>
							data_out(i*4+3 downto i*4)<=r_data(6+i*8 downto i*8+3);
				when "0010" =>
							data_out(i*4+3 downto i*4)<=r_data(5+i*8 downto i*8+2);
				when "0011" =>
							data_out(i*4+3 downto i*4)<=r_data(4+i*8 downto i*8+1);
				when "0100" =>
							data_out(i*4+3 downto i*4)<=r_data(3+i*8 downto i*8);
				when others =>
				null;
			end case;
	end loop;
	expo<=std_logic_vector(4-lead0);
	end if;
	
	
end process;
	

--shift register:6 DFF for shifteing s_ahead 6 clocks ahead=>valid_out
process(rst,clk)
begin
	if rst='1' then s_ahead_shift<="0000000";valid_out<='0';
	elsif rising_edge(clk) then
		s_ahead_shift(6)<=s_ahead;
		for i in 0 to 5 loop
			s_ahead_shift(i)<=s_ahead_shift(i+1);
		end loop;
		valid_out<=std_logic(s_ahead_shift(0));
		valid_out2<=std_logic(s_ahead_shift(0));
	end if;
	
end process;
	
end Behavioral;

