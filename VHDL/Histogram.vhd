--created by Adir and Shir 11.6.18

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.std_logic_arith.all;

entity histogram is
port(
	iGrey	: in std_logic_vector(11 downto 0); 
	iX_Cont,iY_Cont		: in std_logic_vector(15 downto 0); 
	iDVAL						: in std_logic;
	iCLK, iRST				: in std_logic;
	oRed						: out std_logic_vector(11 downto 0);
	oGreen					: out std_logic_vector(11 downto 0);
	oBlue						: out std_logic_vector(11 downto 0)
	);
end histogram; 


architecture behv of histogram is
	
	--type
	type hist is array (0 to 15) of std_logic_vector(19 downto 0);
	
	--signals
	signal grey_array : hist;
	signal grey_array_out : hist;
	signal tempGrey : std_logic_vector(11 downto 0);
	signal output, mDVAL : std_logic; 
	signal x_counter, y_counter : std_logic_vector(15 downto 0); 

begin
	-- divide x, y counters by 2
	x_counter <= '0' & iX_Cont (15 downto 1);						--divide in order to use conV_INTEGER
	y_counter <= '0' & iY_Cont (15 downto 1);						--divide in order to use conV_INTEGER
	mDVAL  <= iDVAL;
	oBlue <= tempGrey; 
	oRed <= 	tempGrey; 
	oGreen <= tempGrey; 

process(iCLK, iRST)

	variable numOfLevels 		: integer := 16;
	variable columnBound			: integer := 256;   				--4096/16
	variable columnWidth			: integer := 40;   				--640/16
	variable yInt 	: integer;
	variable xInt : integer;
	variable oppY : integer;
	variable grey_Value : integer;
	begin
	if (rising_edge(iCLK)) then
		
		yInt := CONV_INTEGER(y_counter);
		xInt := CONV_INTEGER(x_counter);
		
		if(iRST = '0') then 									--reset: white screen
			for i in 0 to numOfLevels-1 loop
				grey_array(i) <= (others => '0');
				grey_array_out(i) <= (others => '0');
			end loop;  
			tempGrey <= (others => '1'); 

		elsif (iDVAL = '1') then							--active frame
			grey_Value 	:= CONV_INTEGER(unsigned(iGrey));
			for i in 0 to numOfLevels-1 loop
				if ((grey_Value >= i*columnBound) and (grey_Value < (i+1)*columnBound)) then			--checks bounds
					grey_array(i) <= grey_array(i) + 1;
				end if;
			end loop;
			
			if ((xInt = 0) and (yInt = 0)) then													--checking the edge
				for i in 0 to numOfLevels-1 loop
					grey_array_out(i) <= grey_array(i);
					grey_array(i) <= (others => '0');
				end loop;
			end if;
			
			for i in 0 to numOfLevels-1 loop														--paints the columns
				oppY := 480-yInt;																		--calculate real value of y
				if (xInt >= (columnWidth*i) and  xInt < (columnWidth*(i+1))) then 			
					if ((oppY * 640) < grey_array_out(i)) then 						
						tempGrey <= (others => '0'); 												--paint in black					
					else				
						tempGrey <= (others => '1'); 		   									--paint in white								
					end if;
				end if;
			end loop;	
		end if;
	end if;
end process;
end behv;
