
-- ====================================================================
--
--	File Name:		4bit7seg.vhd
--	Description:	Basic 4bit7seg 
--					
--	Date: 8/5/18
--	Designer:		Adir and Shir Chen
--
-- ====================================================================

-- libraries decleration
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity FourBit7seg is
	port (
	A : in std_logic_vector(3 downto 0);
	F : out std_logic_vector(6 downto 0));
end FourBit7seg;

architecture arc of FourBit7seg is  

begin  
process(A)
begin
	case A is
	when "0000" => F<= "1000000";   --"0"
	when "0001" => F<= "1111001";   --"1"
	when "0010" => F<= "0100100";   --"2"
	when "0011" => F<= "0110000";   --"3"
	when "0100" => F<= "0011001";   --"4"
	when "0101" => F<= "0010010";   --"5"
	when "0110" => F<= "0000010";   --"6"
	when "0111" => F<= "1111000";   --"7"
	when "1000" => F<= "0000000";   --"8"
	when "1001" => F<= "0010000";   --"9"
	when "1010" => F<= "0001000";   --"A" 
	when "1011" => F<= "0000011";   --"B"
	when "1100" => F<= "1000110";   --"C"
	when "1101" => F<= "0100001";   --"D"
	when "1110" => F<= "0000110";   --"E"
	when "1111" => F<= "0001110";   --"F"
	when others => F<= "1111111";   --reset
	end case;
	        
end process;
	
end arc;

