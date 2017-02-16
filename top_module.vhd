library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_module is
    Port ( data : in  STD_LOGIC_VECTOR (7 downto 0);
           valid : in  STD_LOGIC;
           start : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           valid_out : out  STD_LOGIC;
			  data_out:out std_logic_vector(255 downto 0);
			  expo: out std_logic_vector(3 downto 0)
			  );
end top_module;

architecture Behavioral of top_module is
signal start_on:std_logic;
signal count:unsigned(5 downto 0):="000000";
signal s_ahead:std_logic:='0';
signal data_internal:std_logic_vector(7 downto 0);
signal count_typecast:std_logic_vector(5 downto 0);
signal r_data:std_logic_vector(511 downto 0);

begin

registe : entity work.register_file
port map(clk=>clk,
			rst=>rst,
			w_addr=>std_logic_vector(count),
			w_en=>valid,
			s_ahead=>s_ahead,
			w_data=>data,r_data=>r_data);
			
maxb : entity work.max_finder
port map(r_data=>r_data,clk=>clk,
			rst=>rst,data_out=>data_out,valid_out=>valid_out,expo=>expo,
			s_ahead=>s_ahead);

process(rst,clk)
begin
		if rst='1' then 
		count<="000000";start_on<='0';
		s_ahead <= '0';
		elsif (rising_edge(clk)) then
				if((start='1' or start_on='1') and valid='1') then
					start_on<='1';
					count<=count+1;
					if count="000000" then 
					  s_ahead<='0';
					end if;
					if count="111111" then
						s_ahead<='1';
					end if;
				end if;
		end if;
end process;
				



end Behavioral;

