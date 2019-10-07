--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY  Hazard_Unit IS
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
END Hazard_Unit;

ARCHITECTURE behavior OF Hazard_Unit IS
SIGNAL BranchStall,LWStall 		: STD_LOGIC;
BEGIN

--PROCESS
	--BEGIN
		--WAIT UNTIL clk'EVENT AND clk = '0';

  StallD<=LWStall or BranchStall;
  StallF<=LWStall or BranchStall;
  FlushE<=LWStall or BranchStall;
  
  --if(((BranchD='1') and (RegWriteE='1') and (RtD=WriteRegE or RsD=WriteRegE)) or ((BranchD='1') and (MemToRegM='1') and (RtD=WriteRegM or RsD=WriteRegM))) then 
	--BranchStall<= '1';
  --else 
  --BranchStall<= '0';
  --end if;
  BranchStall<= '1' when ((BranchD='1') and (RegWriteE='1') and (RtD=WriteRegE or RsD=WriteRegE))
							 or ((BranchD='1') and (MemToRegM='1') and (RtD=WriteRegM or RsD=WriteRegM)) else '0';
  --if((((RsD = RtE) or (RtD=RtE)) and (MemToRegE ='1')) ) then LWStall<= '1';
  --else LWStall<= '0';
  --end if;
	LWStall<= '1' when (((RsD = RtE) or (RtD=RtE)) and (MemToRegE ='1')) else '0';
 --if  ((RsE/="00000")and(RsE=WriteRegM) and (RegWriteM = '1')) then   ForwardAE<=	"10";
 --elsif ((RsE/="00000")and(RsE = WriteRegW) and (RegWriteW = '1')) then ForwardAE<=	"01";
 --else ForwardAE<=	"00";
 --end if;
  ForwardAE<=	"10" when((RsE/="00000")and(RsE=WriteRegM) and (RegWriteM = '1')) else 
					"01" when((RsE/="00000")and(RsE = WriteRegW) and (RegWriteW = '1')) else 
					"00";
 --if  ((RtE/="00000")and(RtE=WriteRegM) and (RegWriteM = '1')) then ForwardBE<=	"10";
 --elsif ((RtE/="00000")and(RtE = WriteRegW) and (RegWriteW = '1'))then ForwardBE<=	"01";
 --else  ForwardBE<=	"00";
 --end if;
 ForwardBE<=	"10" when((RtE/="00000")and(RtE=WriteRegM) and (RegWriteM = '1')) else 
					"01" when((RtE/="00000")and(RtE = WriteRegW) and (RegWriteW = '1')) else 
					"00"; 
--if ((RsD/="00000")and(RsD=WriteRegM) and (RegWriteM = '1')) then 	ForwardAD<=	'1';	
--else	ForwardAD<=	'0';
--end if;
	ForwardAD<=	'1' when((RsD/="00000")and(RsD=WriteRegM) and (RegWriteM = '1')) else 
					'0';
--if  ((RtD/="00000")and(RtD=WriteRegM) and (RegWriteM = '1')) then ForwardBD<=	'1';
--else ForwardBD<=	'0';
--end if;
  ForwardBD<=	'1' when((RtD/="00000")and(RtD=WriteRegM) and (RegWriteM = '1')) else 
					'0';
--END PROCESS;

END behavior;

