----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:03:24 12/08/2019 
-- Design Name: 
-- Module Name:    BC_Reader - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BC_Reader is
	Port ( Clk_signal_Scan : in  STD_LOGIC;
			  Rst             : in  std_logic;
           Data_Scan       : in  STD_LOGIC;
           Data_Out        : out  STD_LOGIC_VECTOR (7 downto 0));
end BC_Reader;

architecture Behavioral of BC_Reader is

signal Reg: STD_LOGIC_VECTOR(10 downto 0) := "00000000000";
signal cont : integer range 0 to 119 := 0;

begin

process(Clk_signal_Scan,cont,rst)
begin
   if Rst = '1' then
       Cont <= 0;
		 Reg <= (others => '0');
   elsif(falling_edge(Clk_signal_Scan) )then
		if(cont < 119) then
			Reg <= Data_Scan & Reg(10 downto 1);
			cont <= cont + 1;
	   end if; 
   end if;
end process; 

Data_Out <= Reg(7 downto 0);

end Behavioral;

