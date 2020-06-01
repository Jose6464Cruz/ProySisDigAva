----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:03:50 12/08/2019 
-- Design Name: 
-- Module Name:    Ultrasonic_Sensor - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Ultrasonic_Sensor is
	Port (Clk     : in  STD_LOGIC;
			 Echo	   : in  STD_LOGIC;
			 Req		: in  STD_LOGIC;
			 us_out		: out STD_LOGIC_VECTOR(1 downto 0);
			 Trig : out STD_LOGIC);
end Ultrasonic_Sensor;

architecture Behavioral of Ultrasonic_Sensor is

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
			Trig <= '1';
		elsif Count = TrigOn + TrigDelta then
			Trig <= '0';
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
	if (Vehicle_Height > 60000) then
		us_out <= "11";
	elsif (Vehicle_Height > 30000) then
		us_out <= "10";
	else
		us_out <= "01";
	end if;
	
	--LED <= CONV_STD_LOGIC_VECTOR(Fee, 4);
   --LED <= Fee;
  end process Fee_Generator;
  
  

end Behavioral;

