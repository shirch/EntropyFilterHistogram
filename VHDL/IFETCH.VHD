-- Ifetch module (provides the PC and instruction 
--memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS
	PORT(	SIGNAL Instruction 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	SIGNAL PC_plus_4_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	SIGNAL PCBranchD 		: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	SIGNAL PCSrcD 			: IN 	STD_LOGIC;
			SIGNAL StallF 			: IN 	STD_LOGIC;
        	SIGNAL clock, reset 	: IN 	STD_LOGIC;
			SIGNAL interrupt 			: IN 	STD_LOGIC);
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
	SIGNAL PC, PC_plus_4,PC_return 	 : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL Next_PC, Mem_Addr,interrupt_Address : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL curr_Instruction : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
BEGIN
						--ROM for Instruction Memory
inst_memory: altsyncram
	
	GENERIC MAP (
		operation_mode => "ROM",
		width_a => 32,
		widthad_a => 8,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "program.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		clock0     => clock,
		address_a 	=> Mem_Addr, 
		q_a 			=> curr_Instruction );
		
		interrupt_Address <= X"0d";	
		
		Instruction<=curr_Instruction;
					-- Instructions always start on word address - not byte
		PC(1 DOWNTO 0) <= "00";
					-- copy output signals - allows read inside module
		PC_plus_4_out 	<= PC_plus_4;
						-- send address to inst. memory address register
		Mem_Addr <= Next_PC;
						-- Adder to increment PC by 4        
      	PC_plus_4( 9 DOWNTO 2 )  <= PC( 9 DOWNTO 2 ) + 1;
       	PC_plus_4( 1 DOWNTO 0 )  <= "00";
						-- Mux to select Branch Address or PC + 4        
		Next_PC  <= X"00" WHEN curr_Instruction=X"0000000d" ELSE
			X"00" WHEN Reset = '1'   ELSE						
			PC( 9 DOWNTO 2 ) 			WHEN StallF ='1' 			ELSE
			PCBranchD( 9 DOWNTO 2 )  WHEN  ( PCSrcD = '1' ) ELSE
			interrupt_Address				WHEN interrupt = '1' 	ELSE
			 PC_plus_4( 9 DOWNTO 2 );
	PROCESS
		BEGIN
			WAIT UNTIL rising_edge(clock);
			IF reset = '1' THEN
				   PC( 9 DOWNTO 2) <= "00000000" ; 
			ELSE 
				IF (StallF ='1' and PCSrcD = '0' ) then
				
				ELSE
				   PC( 9 DOWNTO 2 ) <= Next_PC;
					IF (interrupt='1') then
						PC_return<=PC;
					END IF;
				END IF;
			END IF;
	END PROCESS;
END behavior;


