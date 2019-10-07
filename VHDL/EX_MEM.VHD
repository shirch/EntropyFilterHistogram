--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY  EX_MEM IS
	PORT(		clk,reset		: IN 	STD_LOGIC;
				--enable			: IN 	STD_LOGIC;
				ALUResultE		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				WriteDataE 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				WriteRegE 		: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				RegWriteE 		: IN 	STD_LOGIC;
				MemtoRegE 		: IN 	STD_LOGIC;
				MemWriteE 		: IN 	STD_LOGIC;
				
				ALUOutM			: out 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				writeDataM		: out 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				writeRegM		: out 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				RegWriteM 	   : out		STD_LOGIC;
				MemtoRegM 		: out 	STD_LOGIC;
				MemWriteM 		: out 	STD_LOGIC);
				
			
END EX_MEM;

ARCHITECTURE behavior OF EX_MEM IS

	

BEGIN
	PROCESS BEGIN
			WAIT UNTIL clk'EVENT AND clk = '1';
				ALUOutM			<= ALUResultE;
				WriteDataM		<= WriteDataE;
				WriteRegM		<= WriteRegE;
				
				MemtoRegM 		<= MemtoRegE;
				RegWriteM 		<= RegWriteE;
				MemWriteM 		<= 	MemWriteE;
				
				

	END PROCESS;
END behavior;

