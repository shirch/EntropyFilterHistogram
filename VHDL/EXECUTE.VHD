--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;


ENTITY  Execute IS
	PORT(	RsE 				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			RtE 				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			RdE			 	: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			ALUControlE		: IN 	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
			RegDstE 			: IN 	STD_LOGIC;
			ALUSrc 			: IN 	STD_LOGIC;
			ResultW 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extend		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ForwardAE 		: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			ForwardBE 		: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			Read_data_1 	: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Read_data_2		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALUOutM        : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_Result 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			WriteDataE		: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			WriteRegE		: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			clock, reset	: IN 	STD_LOGIC );
END Execute;

ARCHITECTURE behavior OF Execute IS
SIGNAL Ainput, Binput, Btemp 	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALU_output_mux		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );



BEGIN


	
	WriteRegE<=RtE when regDstE='0' else RdE;
	
	
	Ainput <= Read_data_1 when ForwardAE="00" else
				ResultW when ForwardAE="01" else
				ALUOutM;
						-- ALU input mux
	Btemp <= Read_data_2 when ForwardBE="00" else
				ResultW when ForwardBE="01" else
				ALUOutM;
	
   Binput <= Btemp when ALUSrc='0' else Sign_extend;

	WriteDataE<=Btemp;
				
						-- Select ALU output        
	ALU_Result <= X"0000000" & B"000"  & ALU_output_mux( 31 ) WHEN  ALUControlE = "111" ELSE
			ALU_output_mux( 31 DOWNTO 0 );


PROCESS ( ALUControlE, Ainput, Binput )
	BEGIN
					-- Select ALU operation
 	CASE ALUControlE IS
						-- ALU performs ALUresult = A_input AND B_input
		WHEN "000" 	=>	ALU_output_mux 	<= Ainput AND Binput; 
							
						-- ALU performs ALUresult = A_input OR B_input
     	WHEN "001" 	=>	ALU_output_mux 	<= Ainput OR Binput;
							
						-- ALU performs ALUresult = A_input + B_input
	 	WHEN "010" 	=>	ALU_output_mux 	<= Ainput + Binput;
							
						-- ALU performs FP_add
 	 	WHEN "011" 	=>	ALU_output_mux <= X"00000000" ;
							
						-- ALU performs FP_sub
 	 	WHEN "100" 	=>	ALU_output_mux <= X"00000000" ;
							
						-- ALU performs FP_mul
 	 	WHEN "101" 	=>	ALU_output_mux <= X"00000000" ;
							
						-- ALU performs ALUresult = A_input -B_input --!!!changed to FPsub
 	 	WHEN "110" 	=>	ALU_output_mux 	<= Ainput - Binput;
							
						-- ALU performs SLT 
  	 	WHEN "111" 	=>	ALU_output_mux 	<= Ainput - Binput ;
							
 	 	WHEN OTHERS	=>	ALU_output_mux 	<= X"00000000" ;
							
  	END CASE;
  END PROCESS;
END behavior;

