--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY  ID_EX IS
	PORT(		clk		: IN 	STD_LOGIC;
				RegWriteD 		: IN 	STD_LOGIC;
				MemtoRegD 		: IN 	STD_LOGIC;
				MemWriteD 		: IN 	STD_LOGIC;
				ALUControlD 	: IN 	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				ALUSrcD 			: IN 	STD_LOGIC;
				RegDstD 			: IN 	STD_LOGIC;
				read_data_1D	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				read_data_2D	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Sign_extendD	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				RsD				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				RtD				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				RdD				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				Flush				: IN 	STD_LOGIC;
				
				RegWriteE 		: OUT 	STD_LOGIC;
				MemtoRegE 		: OUT 	STD_LOGIC;
				MemWriteE 		: OUT 	STD_LOGIC;
				ALUControlE 	: OUT 	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				ALUSrcE 			: OUT 	STD_LOGIC;
				RegDstE 			: OUT 	STD_LOGIC;
				read_data_1E	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				read_data_2E	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Sign_extendE	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				RsE				: OUT 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				RtE				: OUT 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				RdE				: OUT 	STD_LOGIC_VECTOR( 4 DOWNTO 0 ));
			
END ID_EX;

ARCHITECTURE behavior OF ID_EX IS
BEGIN
	PROCESS BEGIN
			WAIT UNTIL clk'EVENT AND clk = '1';
				if (Flush ='0') THEN 
					Sign_extendE	<= Sign_extendD;
					read_data_1E	<= read_data_1D;
					read_data_2E	<= read_data_2D;
					RsE				<= RsD;
					RtE				<= RtD;
					RdE				<= RdD;
					ALUControlE		<= ALUControlD;

					ALUSrcE 			<= ALUSrcD;
					RegDstE 			<= RegDstD;
					MemtoRegE 		<= MemtoRegD;
					RegWriteE 		<= RegWriteD;
					MemWriteE 		<= MemWriteD;
					
				ELSE
					Sign_extendE	<= (others => '0');
					read_data_1E	<= (others => '0');
					read_data_2E	<= (others => '0');
					RsE				<= (others => '0');
					RtE				<= (others => '0');
					RdE				<= (others => '0');
					ALUControlE		<= (others => '0');

					ALUSrcE 			<= '0';
					RegDstE 			<= '0';
					MemtoRegE 		<= '0';
					RegWriteE 		<= '0';
					MemWriteE 		<= '0';
				end if;
	END PROCESS;
END behavior;

