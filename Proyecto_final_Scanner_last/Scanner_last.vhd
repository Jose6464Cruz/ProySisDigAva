----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:50:45 12/06/2019 
-- Design Name: 
-- Module Name:    Scanner_Last - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Scanner_Last is
    Port ( Clk             : in  STD_LOGIC;
           Clk_signal_Scan : in  STD_LOGIC;
			  Rst             : in  std_logic;
           Data_Scan       : in  STD_LOGIC;
           Data_Out        : out  STD_LOGIC_VECTOR (7 downto 0));
end Scanner_Last;

architecture Behavioral of Scanner_Last is
signal Reg: STD_LOGIC_VECTOR(10 downto 0) := "00000000000";
signal cont : integer range 0 to 11 := 0;
--signal regtemp : STD_LOGIC_VECTOR (197 downto 0);

begin

process(Clk,Clk_signal_Scan,cont,rst)
variable Flag_first : STD_LOGIC := '1';
begin
   if Rst = '1' then
       Cont <= 0;
		 Reg <= (others => '0');
   elsif(falling_edge(Clk) )then
		if(Clk_signal_Scan = '0' and Flag_first = '1' and cont < 11) then
			Reg <= Data_Scan & Reg(10 downto 1);
			cont <= cont + 1;
			Flag_first := '0';
		elsif(Clk_signal_Scan = '1') then
			Flag_first := '1';
	   end if; 
   end if;
end process; 


Data_Out <= Reg(7 downto 0);

end Behavioral;

