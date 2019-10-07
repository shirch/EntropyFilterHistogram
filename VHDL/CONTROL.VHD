		-- control module (implements MIPS control unit)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control IS
   PORT( 	
	Opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	Funct 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	RegDst 		: OUT 	STD_LOGIC;
	ALUSrc 		: OUT 	STD_LOGIC;
	MemtoReg 	: OUT 	STD_LOGIC;
	RegWrite 	: OUT 	STD_LOGIC;
	MemWrite 	: OUT 	STD_LOGIC;
	Branch 		: OUT 	STD_LOGIC;
	ALUControlUnit 	: OUT 	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	clock, reset	: IN 	STD_LOGIC );

END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  R_format, Lw, Sw, Beq	: STD_LOGIC;

BEGIN           
				-- Code to generate control signals using opcode bits
	--FP			 	<=  '1'  WHEN  Opcode = "111111"  ELSE '0';
	R_format 	<=  '1'  WHEN  Opcode = "000000"   ELSE '0';
	Lw          <=  '1'  WHEN  Opcode = "100011"   ELSE '0';
 	Sw          <=  '1'  WHEN  Opcode = "101011"   ELSE '0';
   Beq         <=  '1'  WHEN  Opcode = "000100"   ELSE '0';
  	RegDst    	<=  R_format;
 	ALUSrc  	<=  Lw OR Sw;
	MemtoReg 	<=  Lw;
  	RegWrite 	<=  R_format OR Lw;
   MemWrite 	<=  Sw; 
 	Branch      <=  Beq;
	--FPadd			<= '1' when (Funct="10000") else '0';--funct="100010" -sub
	--ALUControlUnit( 0 )  <=	 ((Funct(0) or Funct(3)) and R_format) when FP='0'  else FPadd;
	--ALUControlUnit( 1 ) 	<=  (NOT Funct(2) or (NOT R_format)) when FP='0' else FPadd;
	--ALUControlUnit( 2 ) 	<= ((Funct(1) and R_format) or beq) when FP='0'  else (not FPadd);
	--for now instead of regular sub we do FPsub
	ALUControlUnit( 0 )  <=	 ((Funct(0) or Funct(3)) and R_format) ;
	ALUControlUnit( 1 ) 	<=  (NOT Funct(2) or (NOT R_format)) ;
	ALUControlUnit( 2 ) 	<= ((Funct(1) and R_format) or beq) ;


   END behavior;


