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

entity Height is
    Port (Clk     : in  STD_LOGIC;
          Rst     : in  STD_LOGIC;
			 Echo	   : in  STD_LOGIC;
			 Trigger : out STD_LOGIC);
end Height;

architecture Height_Arch of Height is

  -- Signals used by the Frequency divider
  constant Sample_Count   : integer := 2000;   -- Maximum count to obtain desired outputfreq
  constant TrigOn			  : integer := 0;
  constant TrigDelta		  : integer := 1000;
  signal   Count	  		  : integer range 0 to Sample_Count; -- Define the counter
  signal   CountE         : integer range 0 to Sample_Count; -- Define the counter 
  signal	  Echo_time      : integer range 0 to Sample_Count;
  
  -- Constants used by the Fee Generator
  constant Total_Height : real := 20.0;				-- 20 cm is the distance from the sensor to the ground
  -- Signal used by the Fee Generator
  signal	  Fee 			: integer range 0 to 200;	-- Fee goes from 0 to 200 Pesos
  
begin
  -- Trigger pulse sending time
  Trigg_pulse: process(Rst,Clk)
  begin
    if Rst = '1' then
	   Count 	<= 0;
		Trigger  <= '0';
		
	 elsif (rising_edge(Clk)) then
	   -- Trigger pulse
		if Count = TrigOn then
			Trigger <= '1';
		elsif Count = TrigOn + TrigDelta then
			Trigger <= '0';
		end if;
		
		-- Reset counter
		if Count = Sample_Count-1 then
        Count <= 0;
      else		  
	     Count <= Count + 1;
		end if;
		
	end if;
  end process Trigg_pulse;
  
  -- Echo pulse receiving time
  Echo_pulse: process(Clk)
  begin
   if Rst = '1' then
		Count <= 0;
		
	elsif (rising_edge(Clk)) then
		-- Echo receive
		if Echo = '1' then
			CountE <= CountE + 1;
		elsif (Echo = '0') then
			Echo_time <= CountE;
			CountE <= 0;
		end if;
	end if;
  end process Echo_pulse;
  
  -- Fee Generator
  Fee_Generator: process(Echo_time, CountE)
  variable Distance,Vehicle_Height : real := 0.0;
  
  begin
	if CountE = 0 then
		Distance := Real(Echo_time)*34.0/200.0;
		Vehicle_Height := Total_Height - Distance;	
		if (Vehicle_Height < 5.0) then
			Fee <= 50;
		elsif (Vehicle_Height < 10.0) then
			Fee <= 100;
		elsif (Vehicle_Height < 15.0) then
			Fee <= 150;
		else
			Fee <= 200;
		end if;
	end if;	
  end process Fee_Generator;
  
end Height_Arch;

