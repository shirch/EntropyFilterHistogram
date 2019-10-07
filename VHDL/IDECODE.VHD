						--  Idecode module (implements the register file for
LIBRARY IEEE; 			-- the MIPS computer)
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Idecode IS
	  PORT(	read_data_1	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Instruction : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ResultW	 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_result	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			PC_plus_4	: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			WriteRegW	: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			RegWrite 	: IN 	STD_LOGIC;
			ForwardAD 	: IN 	STD_LOGIC;
			ForwardBD	: IN 	STD_LOGIC;
			BranchD		: IN 	STD_LOGIC;
			Sign_extend : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			PCBranchD  : OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			RsD			: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			RtD			: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			RdD			: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			PCSrcD			: OUT 	STD_LOGIC;
			clock,reset	: IN 	STD_LOGIC );
END Idecode;


ARCHITECTURE behavior OF Idecode IS
TYPE register_file IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL register_array				: register_file;
	SIGNAL write_register_address 		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_data					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_register_1_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_2_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL Instruction_immediate_value	: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	SIGNAL Branch_Add 			: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL RD1com					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL RD2com					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_extend_temp		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_1_temp		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2_temp		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL EqualD					: STD_LOGIC;
BEGIN
	read_register_1_address 	<= Instruction( 25 DOWNTO 21 );
   	read_register_2_address 	<= Instruction( 20 DOWNTO 16 );

   	Instruction_immediate_value <= Instruction( 15 DOWNTO 0 );
					-- Read Register 1 Operation
	read_data_1_temp <= register_array( 
			      CONV_INTEGER( read_register_1_address ) );
					-- Read Register 2 Operation		 
	read_data_2_temp <= register_array( 
			      CONV_INTEGER( read_register_2_address ) );
					-- Mux for Register Write Address
    	write_register_address <= WriteRegW;
					-- Mux to bypass data memory for Rformat instructions
	write_data <= ResultW;
					-- Sign Extend 16-bits to 32-bits
    	Sign_extend_temp <= X"0000" & Instruction_immediate_value
		WHEN Instruction_immediate_value(15) = '0'
		ELSE	X"FFFF" & Instruction_immediate_value;
					-- Adder to compute Branch Address
	Branch_Add	<= PC_plus_4( 9 DOWNTO 2 ) +  Sign_extend_temp( 7 DOWNTO 0 ) ;
	PCBranchD(1 downto 0) 	<= "00";
	PCBranchD(9 downto 2)   <= Branch_Add;
	
	Sign_extend <= Sign_extend_temp;
	RD1com <= ALU_result when ForwardAD='1' else read_data_1_temp;
	RD2com <= ALU_result when ForwardBD='1' else read_data_2_temp;
	EqualD <= '1' when RD1com=RD2com else '0';
	PCSrcD <= EqualD and BranchD ;
	
	read_data_1<= read_data_1_temp;
	read_data_2<=read_data_2_temp;
	RsD	<= Instruction(25 downto 21);
	RtD	<= Instruction(20 downto 16);
	RdD	<= Instruction(15 downto 11);
PROCESS
	BEGIN
		WAIT UNTIL clock'EVENT AND clock = '0';
		IF reset = '1' THEN
					-- Initial register values on reset are register = reg#
					-- use loop to automatically generate reset logic 
					-- for all registers
			FOR i IN 0 TO 31 LOOP
				register_array(i) <= CONV_STD_LOGIC_VECTOR( i, 32 );
 			END LOOP;
					-- Write back to register - don't write to register 0
  		ELSIF RegWrite = '1' AND write_register_address /= 0 THEN
		      register_array( CONV_INTEGER( write_register_address)) <= write_data;
		END IF;
		--if (ForwardAD='1' ) then 	RD1com <= ALU_result;
		--else RD1com <= read_data_1_temp;
		--end if;
		--if (ForwardBD='1') then RD2com <= ALU_result;
		--else RD2com <= read_data_2_temp;
		--end if;
		--if( RD1com=RD2com ) then EqualD <= '1';
		--else EqualD <= '0';
		--end if;
		--PCSrcD <= EqualD and BranchD ;
	END PROCESS;
END behavior;


