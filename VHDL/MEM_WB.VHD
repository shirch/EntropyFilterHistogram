--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY  MEM_WB IS
	PORT(	read_dataM		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	WriteRegM 		: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			MemtoRegM 		: IN 	STD_LOGIC;
			RegWriteM		: IN 	STD_LOGIC;
			ALUOutM			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
         clock,reset			: IN 	STD_LOGIC ;
			
			read_dataW		: out 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	WriteRegW 		: out 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			MemtoRegW 		: out 	STD_LOGIC;
			RegWriteW		: out 	STD_LOGIC;
			ALUOutW			: out 	STD_LOGIC_VECTOR( 31 DOWNTO 0 ));
			
END MEM_WB;

ARCHITECTURE behavior OF MEM_WB IS
BEGIN
	PROCESS BEGIN
			WAIT UNTIL clock'EVENT AND clock = '1';
				ALUOutW			<= ALUOutM;
				read_dataW		<= read_dataM;
				WriteRegW		<= WriteRegM;
				RegWriteW 		<= RegWriteM;
				MemtoRegW 		<= MemtoRegM;

	END PROCESS;
END behavior;

