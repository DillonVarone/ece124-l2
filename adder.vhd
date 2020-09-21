library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity Adder is port (
   
   hex_A	   :  in  std_logic_vector(3 downto 0);   --4bit input
	hex_B	   :  in  std_logic_vector(3 downto 0);   --4bit input
	sum	   :  out std_logic_vector(7 downto 0)    --sum of inputs
 
); 
end Adder;

architecture Simple of Adder is

	component Concatenate port (
		
   hex_A	   :  in  std_logic_vector(3 downto 0);   --4bit input
	hex_B	   :  in  std_logic_vector(3 downto 0);   --4bit input
	
	hex_out :  out std_logic_vector(7 downto 0)		--8 bit output (hexAhexB)
	);
	end component;
	


signal add_inpA	:std_logic_vector(7 downto 0); 
signal add_inpB	:std_logic_vector(7 downto 0);
--converts inputs to 8 bits


begin

INST1: Concatenate port map("0000", hex_A, add_inpA);
INST2: Concatenate port map("0000", hex_B, add_inpB);
--concatenates 0000 with 4bit inputs

sum (7 downto 0)<= std_logic_vector(unsigned(add_inpA) + unsigned(add_inpB));
--adds inputs

end architecture Simple; 
----------------------------------------------------------------------
