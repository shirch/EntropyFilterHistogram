--created by Adir and Shir 13.6.18

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.all;


entity Entropy is
port(
	iGrey						: in std_logic_vector(11 downto 0);
	iX_Cont,iY_Cont		: in 	std_logic_vector(15 downto 0); 
	iDVAL, iCLK, iRST		: in std_logic;
	oRed,oGreen,oBlue		: out std_logic_vector(11 downto 0)
	);
end Entropy;

architecture behv of Entropy is

--types 
type lineBuffer 	is array (0 to 639) of std_logic_vector( 11 DOWNTO 0 );
type sizeHist 		is array (0 to 15) of integer range 0 to 25;						--size of each column in histogram
type values  		is array (0 to 4) of integer; 										--all pixels of the window
type p_logp 		is array (0 to 15) of std_logic_vector (9 DOWNTO 0);			--all 25 posibilities of p*logp
type counter 		is array (0 to 24) of integer;										
type hist 			is array (0 to 15) of counter;										--histogram with 16 columns
type windowLine   is array(0 to 4) of integer; 											--line in window

--signals
signal line2	: lineBuffer;																	--lines in frame
signal line3	: lineBuffer;
signal line4	: lineBuffer;
signal line5	: lineBuffer;
signal windowValue1 : values;																	--pixels in the window
signal windowValue2 : values;																	
signal windowValue3 : values;
signal windowValue4 : values;
signal windowValue5 : values;
signal histogram    : hist;																	
signal plogp 		  : p_logp;
signal columnSize   : sizeHist;

	
begin

process (iCLK, iRST)
		
--variables
	variable entropy_out	: integer := 0;	
	variable columnBound : integer := 256;				--4096/16
	variable windowLine1 : windowLine;					--lines in the window
	variable windowLine2 : windowLine;
	variable windowLine3 : windowLine;
	variable windowLine4 : windowLine;
	variable windowLine5 : windowLine;


	begin
	if (iRST = '0') then 									--reset
		for i in 0 to 639 loop
			line2(i) <= (others => '0');
			line3(i) <= (others => '0');
			line4(i) <= (others => '0');
			line5(i) <= (others => '0');	
		end loop;
		entropy_out := 0;

	elsif (rising_edge(iCLK)) then
		entropy_out := 0;
		if (iDVAL = '1') then											--checking if active frame

			windowLine5(4) := windowLine5(3);						--shifting fifth line to the left
			windowLine5(3) := windowLine5(2);
			windowLine5(2) := windowLine5(1);   
			windowLine5(1) := windowLine5(0);
			windowLine5(0) := to_integer(unsigned(line5(0)));	--sets the next element in the frame
			
			windowLine4(4) := windowLine4(3);						--shifting forth line to the left
			windowLine4(3) := windowLine4(2);
			windowLine4(2) := windowLine4(1);   
			windowLine4(1) := windowLine4(0);
			windowLine4(0) := to_integer(unsigned(line4(0)));	--sets the next element in the frame
			
			windowLine3(4) := windowLine3(3);						--shifting third line to the left
			windowLine3(3) := windowLine3(2);
			windowLine3(2) := windowLine3(1);   
			windowLine3(1) := windowLine3(0);
			windowLine3(0) := to_integer(unsigned(line3(0)));	--sets the next element in the frame
			
			windowLine2(4) := windowLine2(3);						--shifting second line to the left
			windowLine2(3) := windowLine2(2);
			windowLine2(2) := windowLine2(1);
			windowLine2(1) := windowLine2(0);
			windowLine2(0) := to_integer(unsigned(line2(0)));	--sets the next element in the frame
			
			windowLine1(4) := windowLine1(3);						--shifting first line to the left
			windowLine1(3) := windowLine1(2);
			windowLine1(2) := windowLine1(1);
			windowLine1(1) := windowLine1(0);
			windowLine1(0) := to_integer(unsigned(iGrey));		--sets the next element in the frame
			
			
			for i in 1 to 639 loop  									--shifting buffers
				line2(i-1) <= line2(i);
				line3(i-1) <= line3(i);
				line4(i-1) <= line4(i);
				line5(i-1) <= line5(i);
			end loop;
			
			line2(639) 	<= iGrey;																--new pixle 
			line3(639) 	<= std_logic_vector(to_unsigned(windowLine2(0),12));		--transfer pixels between lines
			line4(639) 	<= std_logic_vector(to_unsigned(windowLine3(0),12));
			line5(639) 	<= std_logic_vector(to_unsigned(windowLine4(0),12));
			
			for i in 0 to 4 loop																	--histogram calculation
				windowValue1(i) <= windowLine1(i);
				windowValue2(i) <= windowLine2(i);
				windowValue3(i) <= windowLine3(i);
				windowValue4(i) <= windowLine4(i);
				windowValue5(i) <= windowLine5(i);
				
				for k in 0 to 15 loop															
					if ((windowValue1(i) >= k*columnBound) and (windowValue1(i) < (k+1)*columnBound)) then
						histogram(k)(i)<=1;														--using 0 or 1 because increase integer doesnt work
					else
						histogram(k)(i)<=0;
					end if;
					
					if ((windowValue2(i) >= k*columnBound) and (windowValue2(i) < (k+1)*columnBound)) then
						histogram(k)(i+5)<=1;
					else
						histogram(k)(i+5)<=0;
					end if;
					
					if ((windowValue3(i) >= k*columnBound) and (windowValue3(i) < (k+1)*columnBound)) then
						histogram(k)(i+10)<=1;
					else
						histogram(k)(i+10)<=0;
					end if;
					
					if ((windowValue4(i) >= k*columnBound) and (windowValue4(i) < (k+1)*columnBound)) then
						histogram(k)(i+15)<=1;
					else
						histogram(k)(i+15)<=0;
					end if;
					
					if ((windowValue5(i) >= k*columnBound) and (windowValue5(i) < (k+1)*columnBound)) then
						histogram(k)(i+20)<=1;
					else
						histogram(k)(i+20)<=0;
					end if;
				end loop;
			end loop;
				
			for i in 0 to 15 loop																		--sums up the size of each column in histogram 
				columnSize(i) <= 	histogram(i)(0)+ histogram(i)(1)+ histogram(i)(2)+ histogram(i)(3)+ histogram(i)(4)+ histogram(i)(5)+
										histogram(i)(6)+ histogram(i)(7)+ histogram(i)(8)+ histogram(i)(9)+ histogram(i)(10)+histogram(i)(11)+
										histogram(i)(12)+histogram(i)(13)+histogram(i)(14)+ histogram(i)(15)+histogram(i)(16)+histogram(i)(17)+
										histogram(i)(18)+histogram(i)(19)+histogram(i)(20)+ histogram(i)(21)+histogram(i)(22)+histogram(i)(23)+
										histogram(i)(24);
			end loop;
										
			for i in 0 to 15 loop									  --sets the right value of plogp according to histogram size normalized to 1024
				case (columnSize(i)) is
					when 0 => 		plogp(i) <= (others => '0'); --0
					when 1 => 		plogp(i) <= "0101100101";    --357
					when 2 => 		plogp(i) <= "1000110000";	  --560
					when 3 => 		plogp(i) <= "1010110111";    --695
					when 4 => 		plogp(i) <= "1100101011";    --811
					when 5 => 		plogp(i) <= "1101111000";    --888
					when 6 => 		plogp(i) <= "1110110010";    --946
					when 7 => 		plogp(i) <= "1111011001";    --985
					when 8 => 		plogp(i) <= "1111110101";    --1013
					when 9 => 		plogp(i) <= "1111111111";    --1023
					when 10 => 		plogp(i) <= "1111110101";    --1013
					when 11 => 		plogp(i) <= "1111110101";    --1013
					when 12 => 		plogp(i) <= "1111000110";    --966
					when 13 => 		plogp(i) <= "1110110010";    --946
					when 14 => 		plogp(i) <= "1101111000";    --888
					when 15 => 		plogp(i) <= "1101010010";    --850
					when 16 => 		plogp(i) <= "1100011000";    --792
					when 17 => 		plogp(i) <= "1011001010";    --714
					when 18 => 		plogp(i) <= "1010010000";    --656
					when 19 => 		plogp(i) <= "1001000011";    --579
					when 20 => 		plogp(i) <= "0111100011";    --483
					when 21 => 		plogp(i) <= "0100110101";    --309
					when 22 => 		plogp(i) <= "0100110101";    --309
					when 23 => 		plogp(i) <= "0011010100";    --212
					when 24 => 		plogp(i) <= "0001100000";    --96
					when 25 => 		plogp(i) <= (others => '0'); --0
					when others => plogp(i) <= (others => '0'); --0
				end case;
			end loop;

			entropy_out := 	to_integer(unsigned(plogp(0)))+to_integer(unsigned(plogp(1)))+         --sum up plogp and set output
									to_integer(unsigned(plogp(2)))+to_integer(unsigned(plogp(3)))+
									to_integer(unsigned(plogp(4)))+to_integer(unsigned(plogp(5)))+
									to_integer(unsigned(plogp(6)))+to_integer(unsigned(plogp(7)))+
									to_integer(unsigned(plogp(8)))+to_integer(unsigned(plogp(9)))+
									to_integer(unsigned(plogp(10)))+to_integer(unsigned(plogp(11)))+
									to_integer(unsigned(plogp(12)))+to_integer(unsigned(plogp(13)))+
									to_integer(unsigned(plogp(14)))+to_integer(unsigned(plogp(15)));
			
			oRed <=  std_logic_vector(to_unsigned(entropy_out,12));												
			oGreen <=  std_logic_vector(to_unsigned(entropy_out,12));
			oBlue <=  std_logic_vector(to_unsigned(entropy_out,12));
					
		end if;
	end if;
end process;
end behv;