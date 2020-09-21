library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Error_check is port (
   
   pb_in	   :  in  std_logic_vector(3 downto 0);   -- The control signals for the circuit
   
   inhibitor :  out std_logic    --1 if error in inputs detected
); 
end Error_check;


architecture Simple of Error_check is

begin
   with pb_in select						     --inhibitor        PB3210      -- Active Button   
	inhibitor 				    			   <= '0' when "1111",    -- [None]
														'0' when "1110",    -- [PB0]
														'0' when "1101",    -- [PB1]
														'0' when "1011",    -- [PB2]
														'0' when "0111",    -- [PB3]
														'1' when  others;   -- [More than 1]
										 
end architecture Simple; 
----------------------------------------------------------------------