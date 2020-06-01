----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:05:20 12/08/2019 
-- Design Name: 
-- Module Name:    Aprover - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Aprover is
    Port (Clk    : in  STD_LOGIC;
          Rst    : in  STD_LOGIC;
          SW     : in STD_LOGIC;
			 Servo  : out STD_LOGIC);
end Servo_Controller;

architecture Behavioral of Aprover is

  --The PERIOD "T" to control a Servo Motor is constant and has a value of 20,000 usec (micro seconds)
  constant T : integer := 20_000;
  

 
 -- Any name can be used for the states
  -- The state coding given below is binary, which is the default
  -- Other state codings could have been used.
  type state_values is (StOn, StOff);
  signal next_state, present_state : state_values;
  
 
 -- Signals used by the Frequency divider
  constant Fosc      : integer := 100_000_000;      -- Oscillator Frequency for Nexys3 board
  constant Fdiv      : integer := 1_000_000;      -- Desired Timebase Frequency --Timebase of 1 microsecond
  constant CtaMax    : integer := Fosc / Fdiv;    -- Maximum count to obtain desired outputfreq
  signal   Cont      : integer range 0 to CtaMax; -- Define the counter
  signal   Timebase  : std_logic; 					  -- Flag used to indicate that timebase has ellapsed
  
  
 --Define the variables that will be holding duration between states
 signal t1 : integer range 0 to 2_000; 	--Maximum value for t1 is 2,000 microseconds
 signal t2 : integer range 0 to T; 	      --t2 = T - t1 (T=t1 + t2)


 ----Signals to determine StateDuration time and  State Count
  ----Determine the amount of second to remaind in a state
  signal   StateDuration : integer range 0 to T; ---- Largest 
  --- Counts how many second have elapsed in the state
  signal   StateCount    : integer range 0 to T;
  

begin
  -- Frequency divider process to obtain a Timebase signal used by the FSM
  FreqDiv: process(Rst,Clk)
  begin
    if Rst = '1' then
	   Cont <= 0;
	 elsif (rising_edge(Clk)) then
	   if Cont = CtaMax-1 then
        Cont     <= 0;
        Timebase <= '1';
      else		  
	     Cont     <= Cont + 1;
		  Timebase <= '0';
		end if;
	end if;
  end process FreqDiv;
  
  -- State Register Process
  -- Holds the current state of the FSM
  statereg: process (Clk,Rst)
  begin
    -- Asynchronous Reset
    if Rst = '1' then
	   present_state <= StOff;
		StateCount <= 0;
	 elsif rising_edge(Clk) then
	   if (Timebase = '1') then
		if (StateCount = StateDuration - 1)then 
	     present_state <= next_state;
		  StateCount <= 0; 
		  else 
		  StateCount <= StateCount +1; 
		  end if; 
		end if;
	 end if;
  end process statereg;
  
  
  --Calculate the valuse for t1 and t2
  t1 <= (((CONV_INTEGER(SW) * 1000))) + 1000; --es igual a (SW/16 + 1) * 1000
															--CONV_INTEGER convierte el vectw SWITCH en un numero entero
															--para poder ser utilizado con los demas enteros de la ecuación
  t2 <= T - t1;
												
  
  -- Define the Next-State Logic Process
  -- Will obtain the next state based on the inputs and current state
  fsm: process (present_state, t1, t2)
  begin
    case present_state is
      when StOn       => 
			next_state <= StOff; 
			StateDuration <= t1;
			
      when StOff =>
			next_state <= StOn;
			StateDuration <= t2;
     
      when others =>
			next_state <= StOff;
			StateDuration <= t1;
	 end case;
  end process fsm;
  
  -- If implementing a Moore Machine use the following process
  -- The output of a Moore Machine is determined by the present_state only
  output: process (present_state)
  begin
    case present_state is
	   when StOn       =>
			Servo <= '1';
	  
	   when StOff =>
			Servo <= '0';
     
	   when others       =>
			Servo <= '1';
     end case;
  end process output;

end Behavioral;

