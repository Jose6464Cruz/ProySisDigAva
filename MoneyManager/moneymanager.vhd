----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:40:51 12/08/2019 
-- Design Name: 
-- Module Name:    moneymanager - moneymanager_Arch 
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
use IEEE.std_logic_arith.all;

entity moneymanager is
    Generic
		   ( n : integer := 3;  --Number of Address bus lines
			  m : integer := 4); --Number of Data bus lines
	 
	 
	 Port ( --Dinero 		: in 
           Switches		: in   STD_LOGIC_VECTOR (7 downto 0);
			  --Rst		: in 	 STD_LOGIC;
			  Add  : in   STD_LOGIC;
			  Addr : in   STD_LOGIC_VECTOR (7 downto 0);	--Address
           --WE   : in   STD_LOGIC;								--Write Enable
           Din  : in   STD_LOGIC_VECTOR (m-1 downto 0);
           Clk  : in   STD_LOGIC;
           Dout : inout  STD_LOGIC_VECTOR (m-1 downto 0);
           Money: out  STD_LOGIC_VECTOR (7 downto 0));
end moneymanager;

architecture moneymanager_Arch of moneymanager is

	--signal Dinero_x: STD_LOGIC_VECTOR (7 downto 0);
	
	--MATRIX declaration for RWM
	type type_RWM is array (0 to (2**n) - 1) of STD_LOGIC_VECTOR (m-1 downto 0);
	
	--A RWM should be declared as a signal because the contents can be changed or will be changing
	signal RWM : type_RWM;

begin

	process(Add, Din, Switches, Addr, Clk, RWM)
	
	variable Recharge : integer := conv_integer(Din) + conv_integer(Switches); 
	--variable sum		: STD_LOGIC_VECTOR (7 downto 0);
	--Dout <= conv_std_logic_vector(Recharge, 8);

	begin
	

	Recharge := 0;
	Dout <= conv_std_logic_vector(Recharge, 4);
	--Reading from a RWM performed by asynchronously 
	Money <= RWM(conv_integer(Addr)) & "0000";	--Valor en la coordenada "Address" convertida de STD_LOGIC_VECTOR
													-- a valor ENTERO
													
	--Writiing to a RWM is performed synchronously 
	--process (Clk)
		
		if (rising_edge(Clk)) then
			if(Add = '1') then	
				RWM (conv_integer(Addr)) <= Dout;
			end if;
		end if;
	end process;
	
end moneymanager_Arch;

