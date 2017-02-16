library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
use IEEE.std_logic_textio.all;

entity tb is
end tb;

architecture Behavioral of tb is
  signal   clk,rst,start,valid,valid_out : STD_LOGIC;
  signal   data :  STD_LOGIC_VECTOR (7 downto 0);
  signal	  data_out : STD_LOGIC_VECTOR (255 downto 0);
  signal   expo :  STD_LOGIC_VECTOR (3 downto 0);
begin
	compr: entity work.top_module
	port map ( clk=> clk,rst=> rst, start=>start,valid=>valid, valid_out=>valid_out,data=>data,
					data_out=>data_out,expo=>expo);
	
	process
	begin
	clk<='0'; wait for 20 ns;
	clk<='1'; wait for 20 ns;
	end process;
		
	process
		variable vari:unsigned(7 downto 0):="00000000";
		file  input_file : text is in  "input_cases.txt";
		variable line_taking: line;
		variable data_take: std_logic_vector(7 downto 0);
		file  output_file : text is out "output_cases_vhdl.txt";
		variable line_putting: line;
		variable data_give: std_logic_vector(255 downto 0);
		
		begin
		
		rst<='1';start<='0';
		wait until rising_edge(clk);
		rst<='0'; valid<='1';start<='1';
		
		
		if (not endfile(input_file)) then
			readline(input_file, line_taking);
			read(line_taking, data_take);
			data<=data_take;
		end if;
		
		wait until rising_edge(clk);
	
		start<='0';
		loop 
				if (not endfile(input_file)) then
					readline(input_file, line_taking);
					read(line_taking, data_take);
					data<=data_take;
				
					if valid_out='1' then
							data_give:=data_out;
							write(line_putting,data_give);
							writeline(output_file,line_putting);
					end if;	
					
				else
					if valid_out='1' then
							data_give:=data_out;
							write(line_putting,data_give);
							writeline(output_file,line_putting);
					end if;	
					exit;
				end if;
					
				
				wait until rising_edge(clk);
		end loop;
		
		
		file_close(output_file);
		file_close(input_file);
	end process;
	



end Behavioral;




