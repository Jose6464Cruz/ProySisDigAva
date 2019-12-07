----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:33:25 11/29/2019 
-- Design Name: 
-- Module Name:    Height - Height_Arch 
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.std_logic_arith.all;

entity Height is
    Port (Clk     : in  STD_LOGIC;
			 Echo	   : in  STD_LOGIC;
			 Req		: in  STD_LOGIC;
			 LED		: out STD_LOGIC_VECTOR(3 downto 0);
			 Trigger : out STD_LOGIC);
end Height;

architecture Height_Arch of Height is

  -- Signals used by the Frequency divider
  constant Sample_Count   : integer := 100_000;   -- Maximum count to obtain desired outputfreq
  constant TrigOn			  : integer := 0;
  constant TrigDelta		  : integer := 1000;		  -- 10 Microseconds Trigger wave
  signal   Count	  		  : integer range 0 to Sample_Count; -- Counter
  signal   CountE         : integer range 0 to Sample_Count; -- Echo Counter 
  signal	  Echo_time      : integer range 0 to Sample_Count; -- Signal to Fee
  
  -- Constants used by the Fee Generator
  constant Total_Height : integer := 120000;				-- 20 cm is the distance from the sensor to the ground
  -- Signal used by the Fee Generator
  --signal	  Fee 			: STD_LOGIC_VECTOR(3 downto 0);	-- Fee goes from 0 to 200 Pesos
  
begin
  -- Trigger pulse sending time
  Distance: process(Clk)
  variable Sent : std_logic := '1';
  begin
	if (rising_edge(Clk)) then
	   -- Trigger pulse
		if (Count = TrigOn) then
			Trigger <= '1';
		elsif Count = TrigOn + TrigDelta then
			Trigger <= '0';
			Sent 	  := '1';
		end if;
		
		-- Echo receive pulse
		if (Echo = '1') then
			CountE <= CountE + 1;
		elsif (Echo = '0' and Sent = '1') then
			Echo_time <= CountE;
			CountE <= 0;
			Sent 	 := '0';
		end if;
		  
		-- Resets counter
		if (Count /= Sample_Count-1) then
        Count <= Count + 1;
      elsif(Req = '1') then	  
	     Count <= 0;
		end if;
		
	end if;
  end process Distance;
  
  -- Fee Generator
  Fee_Generator: process(Req, Echo_time)--, Fee)
  variable Vehicle_Height : integer := 0;
  begin
	Vehicle_Height := Total_Height - Echo_time;	
	if (Vehicle_Height > 90000) then
		LED <= "1000";
	elsif (Vehicle_Height > 60000) then
		LED <= "0100";
	elsif (Vehicle_Height > 30000) then
		LED <= "0010";
	else
		LED <= "0001";
	end if;
	
	--LED <= CONV_STD_LOGIC_VECTOR(Fee, 4);
   --LED <= Fee;
  end process Fee_Generator;
  
  
  
end Height_Arch;

