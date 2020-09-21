library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity LogicProcessor is port (
   
   hex_A	   :  in  std_logic_vector(3 downto 0);   --4 bit input
	hex_B	   :  in  std_logic_vector(3 downto 0);   --4 bit input
	
	control_and :  in std_logic;  --control signal for AND
	control_or 	:  in std_logic;	--control signal for OR
	control_xor :  in std_logic;	--control signal for XOR
	
	logic_func	:  out  std_logic_vector(3 downto 0)  --output
 
); 
end LogicProcessor;

architecture simple of LogicProcessor is

signal control	:	std_logic_vector(2 downto 0); --3 bit control signal

begin

control(0) <= control_and; 
control(1) <= control_or;
control(2) <= control_xor;
--maps control signals

with control select						                   		--control-and, control_or, control_xor   
	logic_func 				    			   <= hex_A AND hex_B when "001",   --AND
														hex_A OR hex_B when "010",		--OR
														hex_A XOR hex_B when "100",	--XOR
														"0000" when others; --			--Error, outputs 0s

end architecture simple; 
----------------------------------------------------------------------
