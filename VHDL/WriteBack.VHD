--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY  WriteBack IS
	PORT(	read_dataW		: in 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			MemtoRegW 		: in 	STD_LOGIC;
			ALUOutW			: in 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ResultW			: out 	STD_LOGIC_VECTOR( 31 DOWNTO 0 ));
			
END WriteBack;

ARCHITECTURE behavior OF WriteBack IS
BEGIN
	ResultW <= read_dataW when MemtoRegW='1' else ALUOutW;
				
END behavior;

