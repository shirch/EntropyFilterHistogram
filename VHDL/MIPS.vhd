				-- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY MIPS IS

	PORT( reset, clock,interrupt					: IN 	STD_LOGIC; 
		--	sigOut0 : out std_logic_vector(6 downto 0);
		--	sigOut1 : out std_logic_vector(6 downto 0);
		--	sigOut2 : out std_logic_vector(6 downto 0);
			outputCount : out std_logic_vector(31 downto 0)
			);
END 	MIPS;



ARCHITECTURE structure OF MIPS IS

COMPONENT Ifetch
   	     PORT(	Instruction 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			 PC_plus_4_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	 PCBranchD 		: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	 PCSrcD 			: IN 	STD_LOGIC;
			 StallF 			: IN 	STD_LOGIC;
        	 clock, reset 	: IN 	STD_LOGIC;
			 interrupt 		: IN 	STD_LOGIC);
	END COMPONENT; 

	COMPONENT IF_ID
	PORT(	clk 					: IN 	STD_LOGIC;
			reset 				: IN 	STD_LOGIC;
			Instruction_in 	: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			PC_plus_4_in 		: IN	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			PCSrcD				: IN 	STD_LOGIC;
			StallD 				: IN 	STD_LOGIC;
			PC_plus_4_out		: OUT 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );		
			Instruction_out 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 ));
	END COMPONENT;
	
	COMPONENT Idecode
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
			PCSrcD			: OUT 	STD_LOGIC;
			RsD			: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			RtD			: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			RdD			: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			clock,reset	: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT ID_EX
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
	END COMPONENT;
	
	COMPONENT control
	     PORT( 	Opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			Funct 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			RegDst 		: OUT 	STD_LOGIC;
			ALUSrc 		: OUT 	STD_LOGIC;
			MemtoReg 	: OUT 	STD_LOGIC;
			RegWrite 	: OUT 	STD_LOGIC;
			MemWrite 	: OUT 	STD_LOGIC;
			Branch 		: OUT 	STD_LOGIC;
			ALUControlUnit 	: OUT 	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
			clock, reset	: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT  Execute
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
	END COMPONENT;
	
	COMPONENT  EX_MEM
	PORT(		clk,reset		: IN 	STD_LOGIC;
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
	END COMPONENT;

	COMPONENT dmemory
	     PORT(	read_data 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	address 			: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        	WriteDataM 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			MemWriteM 		: IN 	STD_LOGIC;
         clock,reset			: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT MEM_WB
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
	END COMPONENT;
	
	COMPONENT WriteBack
	PORT(	read_dataW		: in 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			MemtoRegW 		: in 	STD_LOGIC;
			ALUOutW			: in 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ResultW			: out 	STD_LOGIC_VECTOR( 31 DOWNTO 0 ));
	END COMPONENT;
	
	COMPONENT Hazard_Unit
		PORT(	clk		 		: IN 	STD_LOGIC;
			RegWriteW 		: IN 	STD_LOGIC;
			RegWriteE 		: IN 	STD_LOGIC;
			RegWriteM 		: IN 	STD_LOGIC;
			RsE 				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			RtE 				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			RsD 				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			RtD 				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			WriteRegW 		: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			WriteRegM 		: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			WriteRegE 		: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			MemToRegE 		: IN 	STD_LOGIC;
			MemToRegM 		: IN 	STD_LOGIC;
			BranchD			: IN 	STD_LOGIC;
			
			ForwardAE 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			ForwardBE		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			ForwardAD 		: OUT 	STD_LOGIC;
			ForwardBD		: OUT 	STD_LOGIC;
			StallF			: OUT 	STD_LOGIC;
			StallD			: OUT 	STD_LOGIC;
			FlushE			: OUT 	STD_LOGIC );
	END COMPONENT;	

	
					-- declare signals used to connect VHDL components
	SIGNAL MemWriteM_temp 		:  	STD_LOGIC;
	SIGNAL MemWriteM1 		:  	STD_LOGIC;
	SIGNAL count				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );--integer :=0;
	SIGNAL Mem_Address		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL PC_plus_4F 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL PC_plus_4D 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL read_data_1D 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2D 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_1E 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2E 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_Extend 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_result 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_result 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data 		:  STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL ALUSrc 			: STD_LOGIC;
	SIGNAL PCBranchD 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL RegDst 			: STD_LOGIC;
	SIGNAL Regwrite 		: STD_LOGIC;
	SIGNAL MemWrite 		: STD_LOGIC;
	SIGNAL MemtoReg 		: STD_LOGIC;
	SIGNAL notReset 		: STD_LOGIC;
	SIGNAL PCSrcD 		: STD_LOGIC;
	SIGNAL StallF 		: STD_LOGIC;
	SIGNAL MemRead 			: STD_LOGIC;
	SIGNAL WriteRegW		: 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL ResultW			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALUop 			: STD_LOGIC_VECTOR(  1 DOWNTO 0 );
	SIGNAL InstructionF		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL InstructionF1		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );


	SIGNAL InstructionD		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Branch 				: STD_LOGIC;
	SIGNAL ALUControlUnit : STD_LOGIC_VECTOR(  2 DOWNTO 0 );
	SIGNAL RegWriteE 		: STD_LOGIC;
	SIGNAL MemtoRegE 		: STD_LOGIC;
	SIGNAL MemWriteE 		: STD_LOGIC;
	SIGNAL ALUControlE 	: STD_LOGIC_VECTOR(  2 DOWNTO 0 );
	SIGNAL ALUSrcE 			: STD_LOGIC;
	SIGNAL RegDstE 			: STD_LOGIC;
	SIGNAL RsD				:  	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL RtD				:  	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL RdD				:  	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL RsE				:  	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL RtE				:  	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL RdE				:  	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL Sign_extendE	:  	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ForwardAE 		:  	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL ForwardBE 		:  	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL ALUOutM       :  	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL WriteDataE		:  	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL WriteRegE		: 		STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL writeDataM		:  	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL writeRegM		:  	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL RegWriteM 	   : 		STD_LOGIC;
	SIGNAL MemtoRegM 		:  	STD_LOGIC;
	SIGNAL MemWriteM 		:  	STD_LOGIC;
	SIGNAL read_dataW		:  	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL MemtoRegW 		:  	STD_LOGIC;
	SIGNAL RegWriteW		:  	STD_LOGIC;
	SIGNAL ALUOutW			:  	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL outputTemp			:  	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL counter			:  	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL StallD 			:  	STD_LOGIC;
	SIGNAL ForwardAD     :  	STD_LOGIC;
	SIGNAL ForwardBD		:  	STD_LOGIC;
	SIGNAL BranchD			:  	STD_LOGIC;
	SIGNAL FlushE			:  	STD_LOGIC;
	SIGNAL ALUControlUnitE		:  	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL sigOut		:  	STD_LOGIC_VECTOR( 27 DOWNTO 0 );
	SIGNAL ALUResult :  	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	

BEGIN
					-- copy important signals to output pins for easy 
					-- display in Simulator
 IFE : Ifetch
	PORT MAP (	Instruction 	=> InstructionF,
    	    	PC_plus_4_out 	=> PC_plus_4F,
				PCBranchD 			=> PCBranchD,
				PCSrcD			=>PCSrcD, 
				StallF  			=>  StallF,   		
				clock 			=> clock,  
				reset 			=> notReset,
				interrupt 		=>interrupt	);

				
	IFtoID : IF_ID		
	PORT MAP (			
			clk 					=> clock,  
			reset 				=> notReset,
			Instruction_in 	=> InstructionF1,
			PC_plus_4_in 		=> PC_plus_4F,
			PCSrcD				=>PCSrcD,
			StallD 				=>  StallD,
			PC_plus_4_out		=> PC_plus_4D,	
			Instruction_out 	=> InstructionD);
			
   ID : Idecode
   	PORT MAP (	read_data_1 	=> read_data_1D,
        		read_data_2 	=> read_data_2D,
        		Instruction 	=> InstructionD,
				ResultW			=> ResultW,
				ALU_result 		=> ALUOutM,
				PC_plus_4     => PC_plus_4D,
				WriteRegW      => WriteRegW,
				RegWrite 		=> RegWriteW,
				ForwardAD      =>ForwardAD,
				ForwardBD		=>ForwardBD,
				BranchD			=>BranchD,
				Sign_extend 	=> Sign_extend,
				PCBranchD 			=> PCBranchD,
				PCSrcD			=>PCSrcD,
				RsD			=>RsD,
				RtD			=>RtD,
				RdD			=>RdD,
        		clock 			=> clock,  
				reset 			=> notReset );


		IDtoEX : ID_EX
   	PORT MAP (
				clk		=> clock,
				RegWriteD 		=> RegWrite,
				MemtoRegD 		=>MemtoReg,
				MemWriteD 		=>MemWrite,
				ALUControlD 	=>ALUControlUnit,
				ALUSrcD 			=> ALUSrc,
				RegDstD 			=> RegDst,
				read_data_1D	=>read_data_1D,
				read_data_2D	=>read_data_2D,
				Sign_extendD	=>Sign_extend,
				RsD				=>RsD,
				RtD				=>RtD,
				RdD				=>RdD,
				Flush				=>FlushE,
				
				RegWriteE 		=>RegWriteE,
				MemtoRegE 		=>MemtoRegE,
				MemWriteE 		=>MemWriteE,
				ALUControlE 	=>ALUControlUnitE,
				ALUSrcE 			=> ALUSrcE,
				RegDstE 			=> RegDstE,
				read_data_1E	=>read_data_1E,
				read_data_2E	=>read_data_2E,
				Sign_extendE	=>Sign_extendE,
				RsE				=>RsE,
				RtE				=>RtE,
				RdE				=>RdE);
				
   CTL:   control
	PORT MAP ( 	Opcode 			=> InstructionD( 31 DOWNTO 26 ),
				Funct				=>InstructionD(5 DOWNTO 0 ),
				RegDst 			=> RegDst,
				ALUSrc 			=> ALUSrc,
				MemtoReg 		=> MemtoReg,
				RegWrite 		=> RegWrite,
				MemWrite 		=> MemWrite,
				Branch 			=> BranchD,
				ALUControlUnit => ALUControlUnit,
            clock 			=> clock,
				reset 			=> notReset );

			
   EXE:  Execute
   	PORT MAP (	Read_data_1 	=> read_data_1E,
             	Read_data_2 	=> read_data_2E,
				Sign_extend 	=> Sign_extendE,
				ForwardAE 		=>ForwardAE,
				ForwardBE 		=>ForwardBE,
				ALUOutM        =>ALUOutM,
				RsE				=>RsE,
				RtE				=>RtE,
				RdE				=>RdE,
				ALUControlE		=>ALUControlUnitE,
				ALUSrc 			=> ALUSrcE,
				RegDstE 			=> RegDstE,
				ResultW 			=>ResultW,
				ALU_Result		=> ALU_Result,
				WriteDataE		=>WriteDataE,
				WriteRegE		=>WriteRegE,
            clock			=> clock,
				Reset			=> notReset );

	EXtoMEM :  EX_MEM
	PORT MAP(		clk			=>clock,
				reset			=>notReset,
				ALUResultE	=>ALU_Result,
				WriteDataE 	=>WriteDataE,
				WriteRegE 	=>WriteRegE,
				RegWriteE 		=>RegWriteE,
				MemtoRegE 		=>MemtoRegE,
				MemWriteE 		=>MemWriteE,
				
				ALUOutM			=>ALUOutM,
				writeDataM		=>writeDataM,
				writeRegM		=>WriteRegM,
				RegWriteM 	   =>RegWriteM,
				MemtoRegM 		=>MemtoRegM,
				MemWriteM 		=>MemWriteM);
				


			
   MEM:  dmemory
	PORT MAP (	read_data 		=> read_data,
				address 		=> Mem_Address,--jump memory address by 4
				WriteDataM 		=> WriteDataM,
				MemwriteM 		=> MemWriteM1, 
            clock 			=> clock,  
				reset 			=> notReset );			

	
		MEMtoWB : MEM_WB
		PORT MAP(	read_dataM		=>read_data,
        	WriteRegM 		=>WriteRegM,
			MemtoRegM 		=>MemtoRegM,
			RegWriteM		=>RegWriteM,
			ALUOutM	      =>ALUOutM,
			read_dataW		=>read_dataW,
        	WriteRegW 		=>WriteRegW,
			MemtoRegW 		=>MemtoRegW,
			RegWriteW		=>RegWriteW,
			ALUOutW			=>ALUOutW,
         clock 			=> clock,  
		   reset 			=> notReset );

	

		WB : WriteBack
		PORT MAP(	read_dataW		=>read_dataW,
				MemtoRegW 		=>MemtoRegW,
				ALUOutW			=>ALUOutW,
				ResultW			=>ResultW);

		HU : Hazard_Unit
		PORT MAP(	clk		 		=> clock,
			RegWriteW 		=>RegWriteW,
			RegWriteE 		=>RegWriteE,
			RegWriteM 		=>RegWriteM,
			RsE 				=>RsE,
			RtE 				=>RtE,
			RsD 				=>RsD,
			RtD 				=>RtD,
			WriteRegW 		=>WriteRegW,
			WriteRegM 		=>WriteRegM,
			WriteRegE 		=>WriteRegE,
			MemToRegE 		=>MemToRegE,
			MemToRegM 		=>MemToRegM,
			BranchD			=>BranchD,
			
			ForwardAE 		=>ForwardAE,
			ForwardBE		=>ForwardBE,
			ForwardAD 		=>ForwardAD,
			ForwardBD		=>ForwardBD,
			StallF			=>StallF,
			StallD			=>StallD,
			FlushE			=>FlushE );
	
	ALUResult<= counter+1;	
--	sigOut0<=sigOut(6 downto 0);
--	sigOut1<=sigOut(13 downto 7);
--	sigOut2<=sigOut(20 downto 14);
--	sigOut3<=sigOut(27 downto 21);
	notReset<= reset;
	

	outputCount<=counter;		
			Mem_Address<=  ALUOutM (9 DOWNTO 2);
			MemWriteM1<=MemWriteM;--when show='0' else MemWriteM_temp;
			InstructionF1<=InstructionF ;
			
			--ALU_Result_out<=ALU_Result;
			--outputCount_out<=outputCount;
			--interruptCounter_out<=interruptCounter;
process (clock)
begin
	if rising_edge(clock) then
		if(notReset='1') then
				counter<=X"00000000";

					count<=X"00000000";
		else
			if(count < 100000000) then
				count<= count+1;
	
			elsif(count = 100000000) then--counts clks that equals to 1 sec

				count<= count+1;
			elsif(InstructionF = X"0000000d") then
				counter<=ALUResult;--counter+1;	

				count<= X"00000000";
			else 
				count<= count+1;
		
			end if;
		end if;
	end if;
	
end process;
END structure;

