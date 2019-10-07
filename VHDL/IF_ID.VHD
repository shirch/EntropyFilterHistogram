--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY  IF_ID IS
	PORT(	clk 					: IN 	STD_LOGIC;
			reset 				: IN 	STD_LOGIC;
			Instruction_in 	: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			PC_plus_4_in 		: IN	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			PCSrcD				: IN 	STD_LOGIC;
			StallD 				: IN 	STD_LOGIC;
			PC_plus_4_out		: OUT 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );		
			Instruction_out 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 ));
END IF_ID;

ARCHITECTURE behavior OF IF_ID IS
	

BEGIN
	PROCESS BEGIN
			WAIT UNTIL (clk'EVENT) AND (clk = '1');
				IF PCSrcD = '1' then
					Instruction_out			<= (others => '0');
					PC_plus_4_out		<= (others => '0');
				ELSE
					if StallD = '1' THEN	
						-- Stall
					else
						Instruction_out			<= Instruction_in;
						PC_plus_4_out		<= PC_plus_4_in; 
					end if;		
				END IF; 
	END PROCESS;
END behavior;

