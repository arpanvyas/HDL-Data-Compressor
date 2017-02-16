library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity register_file is
port (
	clk, rst: in std_logic;
	w_en: in std_logic;
	w_addr: in std_logic_vector (5 downto 0) ;
	w_data: in std_logic_vector (7 downto 0) ;
	r_data: out std_logic_vector (511 downto 0);
	s_ahead:in std_logic
	);
end register_file;


architecture Behavioral of register_file is

type array_type is array (63 downto 0) of std_logic_vector(7 downto 0);
signal array1,array2: array_type;
signal array_index:integer;

begin
	process(clk,rst)
	begin
		if(rst='1') then
		array1<= (others=>(others=>'0'));
		elsif(rising_edge(clk)) then
			if(w_en='1') then
				array1(array_index)<=w_data;
			end if;
		end if;
	end process;
	array_index<=to_integer(unsigned(w_addr));
	process(clk,rst)
	begin
		if(rst='1') then
		array2<= (others=>(others=>'0'));
		elsif(rising_edge(clk)) then
		 if ( s_ahead ='1' ) then 
		  array2 <= array1 ;
		 end if ;
		end if;
	end process;
	
	

	
	
	x_gen : for i in 0 to 63 generate
	  r_data((i*8+7) downto i*8)<= array2(i);
	end generate;
	

end Behavioral;

