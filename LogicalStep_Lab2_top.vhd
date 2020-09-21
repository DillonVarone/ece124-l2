library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab2_top is port (
   clkin_50			: in	std_logic;							--	clock signal
	pb					: in	std_logic_vector(3 downto 0);	--	button inputs
 	sw   				: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds				: out std_logic_vector(7 downto 0); -- for displaying the switch content
   seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  	: out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  	: out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab2_top;

architecture SimpleCircuit of LogicalStep_Lab2_top is
--
-- Components Used ---
------------------------------------------------------------------- 
  component SevenSegment port (
   hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   ); 
   end component;
	
	component segment7_mux port (
		clk		: in std_logic := '0';						--	clock signal to cycle 7 segment display
		DIN2		: in std_logic_vector(6 downto 0);		-- first hex number(Seg7_A)
		DIN1		: in std_logic_vector(6 downto 0);		--	second hex number(seg7_B)
		DOUT		: out std_logic_vector(6 downto 0);		--	output hex to be displayed
		DIG2		: out std_logic;								-- select display 2
		DIG1		: out std_logic								-- select display 1
	);
	end component;
	
	component two_one_mux port (
		input_A	   :  in  std_logic_vector(7 downto 0); -- 8 bit input selected when control 0
		input_B	   :  in  std_logic_vector(7 downto 0); -- 8 bit input selected when control 1
		control		:  in	 std_logic;							 -- control
		output		:  out std_logic_vector(7 downto 0)  -- 8 bit output
	
	);
	end component;
	
	component adder port (
		hex_A	   :  in  std_logic_vector(3 downto 0);   --4 bit unsigned integer(1 digit hex)
		hex_B	   :  in  std_logic_vector(3 downto 0);   --4 bit unsigned integer(1 digit hex)
		sum	   :  out std_logic_vector(7 downto 0)    --8 bit unsigned integer(2 digit hex)
	); 
	end component;
	
	component Concatenate port (
		
   hex_A	   :  in  std_logic_vector(3 downto 0);   --4 bit input
	hex_B	   :  in  std_logic_vector(3 downto 0);   --4 bit input	
	hex_out :  out std_logic_vector(7 downto 0)		--8 bit output (hexAhexB)
	);
	end component;
	
	component LogicProcessor port (
		
   hex_A	   :  in  std_logic_vector(3 downto 0);   --4bit input
	hex_B	   :  in  std_logic_vector(3 downto 0);   --4bit input
	
	control_and :  in std_logic;  --logical AND on A,B when 1
	control_or 	:  in std_logic;	--logical OR on A,B when 1
	control_xor :  in std_logic;	--logical XOR on A,B when 1
	
	logic_func	:  out  std_logic_vector(3 downto 0)  --result of logic or 0000
	);
	end component;
	
	component Error_check port (
	
   pb_in	   :  in  std_logic_vector(3 downto 0);   -- pushbuttons   
   inhibitor : out std_logic								-- 1 if multiple pbs pressed
	);
	end component;
	
	
-- Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--
	
	signal hex_A		: std_logic_vector(3 downto 0); --hex value mapped to switches 3 to 0
	signal hex_B		: std_logic_vector(3 downto 0); --hex value mapped to switches 7 to 4
	
	signal seg7_A		: std_logic_vector(6 downto 0); --value for left display
	signal seg7_B		: std_logic_vector(6 downto 0); --value for right display
	
	signal hex_AB	 	: std_logic_vector(7 downto 0);	--concatenated hex_A & hex_B
	
	signal logic_func				: std_logic_vector(3 downto 0); --4 bit output of LogicProcessor
	signal logic_func_8bit		: std_logic_vector(7 downto 0); --8 bit output of 0000&logic_func
	
	signal sum						: std_logic_vector(7 downto 0);-- 8 bit sum of hex_A+hex_B
	
	signal mux_output_A 			: std_logic_vector(7 downto 0);-- hex_AB, sum
	
	signal control_and			: std_logic; --control signal for AND
	signal control_or				: std_logic; --control signal for OR
	signal control_xor			: std_logic; --control signal for XOR
	signal control					: std_logic; --control for mux
	signal inhibitor				: std_logic; --control in case of error
	signal mux_output_seg7		: std_logic_vector (7 downto 0); --seg7 output 
	signal led_out					: std_logic_vector (7 downto 0);	--8 bit led signal
-- Here the circuit begins

begin

hex_A <= sw(3 downto 0);
hex_B <= sw(7 downto 4);
--assigns switches to hex_A (7654) and hex_B (3210)

control_and <= NOT pb(0); 
control_or  <= NOT pb(1);
control_xor <= NOT pb(2);
control		<= NOT pb(3);
--Buttons are default active low, inverts signal so 1 when pressed


--COMPONENT HOOKUP


	INST1: Error_check port map(pb, inhibitor);
--checks for mutliple button inputs
	
	INST2: Concatenate port map(hex_A, hex_B, hex_AB);
--hex_A&hex_B
	
	INST3: adder port map(hex_A, hex_B, sum);
--adds hex_A and hex_B
	
	INST4: two_one_mux port map(hex_AB, sum, control, mux_output_A);
--outputs (mux_output_A) hex_AB when control 0, else sum
	
	INST5: LogicProcessor port map(hex_A, hex_B, control_and, control_or, control_xor, logic_func);
--performs AND, OR, XOR on hex_A, hex_B, outputs result
	
	INST6: Concatenate port map("0000", logic_func, logic_func_8bit);
--0000&logic_func
	
	INST7: two_one_mux port map(logic_func_8bit, sum, control, led_out);
--outputs (led_out) logic_func_8bit when control 0, else sum
	
	INST8: two_one_mux port map(led_out, "11111111", inhibitor, leds);
--outputs (leds)  led_out when inhibitor 0, 11111111 when inhibitor 1
	
	INST9: two_one_mux port map(mux_output_A, "10001000", inhibitor, mux_output_seg7);
--outputs (leds)  max_outout_A when inhibitor 0, 10001000 (88 in hex) when inhibitor 1 
 
	INST10: SevenSegment port map(mux_output_seg7 (7 downto 4), seg7_B);
   INST11: SevenSegment port map(mux_output_seg7 (3 downto 0), seg7_A);
--decodes 8 bit value (2 digit hex) to seven segment signal
	
	INST12: segment7_mux port map(clkin_50, seg7_A, seg7_B, seg7_data, seg7_char2, seg7_char1);
--sends signals to 7 segement displays
	
end SimpleCircuit;

