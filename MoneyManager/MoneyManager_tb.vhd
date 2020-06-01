--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:19:28 12/08/2019
-- Design Name:   
-- Module Name:   C:/Proyectos Rick/MoneyManager/MoneyManager_tb.vhd
-- Project Name:  MoneyManager
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: moneymanager
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY MoneyManager_tb IS
END MoneyManager_tb;
 
ARCHITECTURE behavior OF MoneyManager_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT moneymanager
    PORT(
         Din : IN  std_logic_vector(3 downto 0);
         Switches : IN  std_logic_vector(7 downto 0);
         --Rst : IN  std_logic;
         Add : IN  std_logic;
			--Dinero_x : inout STD_LOGIC_VECTOR (7 downto 0);
         Money : inOUT  std_logic_vector(7 downto 0));
    END COMPONENT;
    

   --Inputs
   signal Din : std_logic_vector(3 downto 0) := (others => '0');
   signal Switches : std_logic_vector(7 downto 0) := (others => '0');
   --signal Rst : std_logic := '0';
   signal Add : std_logic := '0';

 	--Outputs
   signal Money : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
--   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: moneymanager PORT MAP (
          Din => Din,
          Switches => Switches,
          --Rst => Rst,
          Add => Add,
          Money => Money
        );

--    Clock process definitions
--   <clock>_process :process
--   begin
--		<clock> <= '0';
--		wait for <clock>_period/2;
--		<clock> <= '1';
--		wait for <clock>_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
--
--      wait for <clock>_period*10;

      -- insert stimulus here 
		
--		BCD <= "00010010";
--		Add <= '0';
--		Rst <= '1';
--		
--		wait for 100 ns;
--		
--		
--		BCD <= "00010010";
--		Add <= '1';
--		Rst <= '0';
--		
--		wait for 100 ns;
--		
--		
		Din <= "00000010";
		Switches <= "00010010";
		Add <= '1';

		
		wait for 100 ns;
		
		Din <= "00010110";
		Switches <= "00000100";
		Add <= '1';

		

      wait;
   end process;

END;
