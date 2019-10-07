
-- ====================================================================
--
--	File Name:		16bit7seg.vhd
--	Description:	Basic 16bit7seg 
--					
--	Date: 8/5/18
--	Designer:		Adir and Shir Chen
--
-- ====================================================================

-- libraries decleration
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SixteenBit7seg is

	port (
	--LOAlu, HIAlu : in std_logic_vector (7 downto 0);
	SW8 : in std_logic;	
	FPin : in std_logic_vector (31 downto 0);
	--OP : in std_logic_vector(3 downto 0);	            
	F : out std_logic_vector (27 downto 0));
	
end SixteenBit7seg;

architecture arc of SixteenBit7seg is  

--component decleration
component FourBit7seg 
  port(
 A : in std_logic_vector(3 downto 0);
 F : out std_logic_vector(6 downto 0));
end component;
	
signal sig1,sig2,sig3,sig4 : std_logic_vector(3 downto 0);	
 
begin  
  F1: FourBit7seg port map(sig1,F(6 downto 0));
  F2: FourBit7seg port map(sig2,F(13 downto 7));
  F3: FourBit7seg port map(sig3,F(20 downto 14));
  F4: FourBit7seg port map(sig4,F(27 downto 21));

process(SW8,FPin)
begin
	--if((OP = "1010") or OP = "1011") then         --floating point
	 if(SW8 = '1') then                          --high 
	  sig1 <= FPin(19 downto 16);
	  sig2 <= FPin(23 downto 20);
	  sig3 <= FPin(27 downto 24);
	  sig4 <= FPin(31 downto 28);
	 else                                        --low
	  sig1 <= FPin(3 downto 0);
	  sig2 <= FPin(7 downto 4);
	  sig3 <= FPin(11 downto 8);
	  sig4 <= FPin(15 downto 12);
	 end if;
	
	--else                                         --ALU 
	--  sig1 <= LOAlu(3 downto 0);
	--  sig2 <= LOAlu(7 downto 4);
	--  sig3 <= HIAlu(3 downto 0);
	--  sig4 <= HIAlu(7 downto 4);
	--end if;   
end process;
	
end arc;