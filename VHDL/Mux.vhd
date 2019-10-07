
-- simple multiplexer unit because we dont know how to write it in verilog
--==========Library===========
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all; 
use ieee.std_logic_arith.all;


entity Mux is
port(
		sel1, sel2			: in std_logic;
		iGrey,iGreen,iRed,iBlue, iHistR, iHistG, iHistB, iEntropyR, iEntropyG, iEntropyB : in std_logic_vector(11 downto 0); 
		oRed, oGreen, oBlue : out std_logic_vector(11 downto 0)
							   
	);
end Mux; 


architecture behv of Mux is
signal mux_select :  std_logic_vector(1 downto 0); 
begin
mux_select <= sel2 & sel1;
oRed <= iGrey when mux_select = "01" 
	else iHistR when mux_select ="11" 
	else iEntropyR when mux_select ="10" 
	else iRed;
oGreen <= iGrey when mux_select = "01" 
	  else iHistG when mux_select ="11" 
	  else  iEntropyG when mux_select ="10" 
	  else iGreen;
oBlue <=  iGrey when mux_select = "01" 
	  else iHistB when mux_select ="11" 
	  else  iEntropyB when mux_select ="10" 
	  else iBlue;

end behv;