library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity Concatenate is port (
   
   hex_A	   :  in  std_logic_vector(3 downto 0);   --4bit input
	hex_B	   :  in  std_logic_vector(3 downto 0);   --4bit input
	hex_out :  out std_logic_vector(7 downto 0)    --8 bit output (hexAhexB)
 
); 
end Concatenate;

architecture simple of Concatenate is

begin

hex_8bit <= hex_A & hex_B;
--concatenates hex_A and hex_B

end architecture simple; 
----------------------------------------------------------------------
