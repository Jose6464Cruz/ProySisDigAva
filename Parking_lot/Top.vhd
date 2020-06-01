----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:05:52 12/03/2019 
-- Design Name: 
-- Module Name:    Top - Parking_lot_Arch 
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

entity Top is
    Port ( Clk 	 			: in   STD_LOGIC;							  -- 100 MHz FPGA Clock
           Money 				: in   STD_LOGIC_VECTOR(7 downto 0);  -- Switches to input amount of money
           Recharge  		: in   STD_LOGIC;							  -- Button to confirm recharge
			  Echo	   		: in  STD_LOGIC;							  -- Ultrasonic input
			  Req					: in  STD_LOGIC;							  -- Button to get height fee
			  Trigger 			: out STD_LOGIC;							  -- Ultrasonic output
           Servo 				: out  STD_LOGIC;							  -- Servo PWM signal
			  Clk_signal_Scan : in  STD_LOGIC;							  -- External CLK given by PS2 protocol
			  Rst             : in  std_logic;							  -- Reset button B8
           Data_Scan       : in  STD_LOGIC;							  -- Data that comes from the scanner
           Red   				: out  STD_LOGIC_VECTOR (2 downto 0); -- RGB Red
           Green 				: out  STD_LOGIC_VECTOR (2 downto 0); -- RGB Green
           Blue  				: out  STD_LOGIC_VECTOR (1 downto 0); -- RGB Blue
           Hsync 				: out  STD_LOGIC;							  -- Horizontal synchronization signal
           Vsync 				: out  STD_LOGIC);						  -- Vertical synchronization signal
end Top;

architecture Parking_lot_Arch of Top is

	--Declaracion de todos los componentes usados en el diseño
	
	--Componente U1: calcula la cantidad de dinero del usuario y da la opción
					  -- de cargar más dinero
  component MoneyManager
  port ( mon : in STD_LOGIC_VECTOR(7 downto 0); -- Switches 7 to 0
			rech : in STD_LOGIC;							-- Button
			check : in STD_LOGIC_VECTOR(7 downto 0); -- Actual funds signal
			Enough_money : out STD_LOGIC);			  -- 1 or 0
  end component;
  
  --Componente U2: Obtiene el valor numérico del código de barras y lo compara
					 -- con valores en memoria para aprovar o recharazar este
  component BC_Reader
  port (   Clk_signal_Scan : in  STD_LOGIC;		-- External CLK Pin
			  Rst             : in  std_logic;		-- Resets the reading
           Data_Scan       : in  STD_LOGIC;		-- Scanned data serially
           Data_Out        : out  STD_LOGIC_VECTOR (7 downto 0));	-- Character from the barcode
  end component;
  
  --Componente U3: Obtiene la altura del vehiculo para el posterior uso de este dato
  component Ultrasonic_Sensor
  port (  Clk     : in  STD_LOGIC;					-- FPGA CLK
			 Echo	   : in  STD_LOGIC;					-- Ultrasonic input
			 Req		: in  STD_LOGIC;					-- Press button to get the reading
			 US_out	: out STD_LOGIC_VECTOR(1 downto 0);	-- Signal that indicates fee group
			 Trig : out STD_LOGIC);						-- Ultrasonic output
  end component;
  
  --Componente U4: Usa los componentes anteriores y el State Reg para saber a qué estado 
					 -- paras o en qué estado quedarse para proseguir a los outputs
  component Next_State
  port ( State_reg : in STD_LOGIC_VECTOR(2 downto 0);	-- Receives state_reg
			BC_data : in STD_LOGIC_VECTOR (7 downto 0);  -- Barcode 8 bit signal
			US_data : in STD_LOGIC_VECTOR(1 downto 0);	-- Ultrasonic 2 but signal
			en_money  : in STD_LOGIC;							-- 1 or 0 from money manager
			check_money : out STD_LOGIC_VECTOR(7 downto 0); -- Gives the actual funds
			N_S     : out STD_LOGIC_VECTOR(2 downto 0));	-- Next state signal
  end component;
  
  --Componente U5: Shift Register 
  component Present_State
  port ( state_reg : in STD_LOGIC_VECTOR(2 downto 0);	  -- Receives State_reg
			servo     : out STD_LOGIC;							  -- Outputs servo signals
			n_s       : out STD_LOGIC_VECTOR(2 downto 0)); -- Outputs State_reg 
  end component;
  
  --Componente U6: Usa el estado de la maquina para abrir o no el servo/pluma. Modulo servo controller
  component Aprover	
  port (  Clk    : in  STD_LOGIC;								-- FPGA Clock
          Rst    : in  STD_LOGIC;								-- 
          SW     : in STD_LOGIC;
			 Servo  : out STD_LOGIC);
  end component;
  
  -- VGA controller component
  -- Generated the necessary timing for the VGA signal
  component VGA
  port (
    Clk    : in  STD_LOGIC; -- Board Clock
	 Rst    : in  STD_LOGIC; -- Board Reset
    X      : out STD_LOGIC_VECTOR(9 downto 0); -- X coordinate of the screen
	 Y      : out STD_LOGIC_VECTOR(9 downto 0); -- Y coordinate of the screen
	 Active : out STD_LOGIC; -- When '1', indicates you are in the screen where pixels can be drawn
	 Hsync  : out STD_LOGIC; -- Horizontal synchronization signal
	 Vsync  : out STD_LOGIC);-- Vertical synchronization signal
  end component;
  
  -- Component that will contain the image/figure that
  -- will appear on the screen
  component VGA_Display
  port (
	 img : in  STD_LOGIC_VECTOR (2 downto 0);
    Clk : in  STD_LOGIC;
	 Xin : in  STD_LOGIC_VECTOR(9 downto 0); -- Column screen coordinate
	 Yin : in  STD_LOGIC_VECTOR(9 downto 0); -- Row screen coordinate
	 En  : in  STD_LOGIC; -- When '1', pixels can be drawn 
	 R   : out STD_LOGIC_VECTOR(2 downto 0); -- 3-bit Red channel
	 G   : out STD_LOGIC_VECTOR(2 downto 0); -- 3-bit Green channel
	 B   : out STD_LOGIC_VECTOR(1 downto 0));-- 2-bit Blue channel
  end component;
  
  --Señales embebidas
  signal X_emb      : STD_LOGIC_VECTOR(9 downto 0);
  signal Y_emb      : STD_LOGIC_VECTOR(9 downto 0);  
  signal Active_emb : STD_LOGIC;
  signal Data_Out_sig : STD_LOGIC_VECTOR(7 downto 0);
  signal check_sig : STD_LOGIC_VECTOR(7 downto 0); 
  signal enough_money_sig : STD_LOGIC;
  signal US_out_sig : STD_LOGIC_VECTOR(1 downto 0);
  signal SW_sig     : STD_LOGIC;
  signal next_state_sig  : STD_LOGIC_VECTOR(2 downto 0);
  signal state_reg   : STD_LOGIC_VECTOR(2 downto 0);

begin

	U1: MoneyManager
  port map (
    mon => money,
	 rech => recharge,
	 check => check_sig,
	 enough_money => enough_money_sig );
	 
	 U2: BC_Reader
  port map (
    Clk_signal_Scan,
	 Rst,
	 Data_Scan,
	 Data_Out => Data_Out_sig);
	 
	 U3: Ultrasonic_Sensor
  port map (
    Clk,
	 Echo,
	 Req,
	 Trig => Trigger,
	 us_out => US_out_sig);
	 
	 U4: Next_State
  port map (
    State_reg => state_reg,
	 BC_data => Data_Out_sig,
	 en_money => enough_money_sig,
	 check_money => check_sig,
	 US_data => US_out_sig,
	 N_S     => next_state_sig);
	 
	 U5: Present_State
  port map (
	 state_reg => next_state_sig,
    servo => SW_sig,
	 n_S => state_reg);
	 
	 U6: Aprover
  port map (
    Clk,
	 Rst,
	 SW => SW_sig,
	 servo => Servo);
	 
	 U7: VGA
  port map (
    Clk,
	 Rst,
	 X_emb,
	 Y_emb,
	 Active_emb,
    Hsync,
	 Vsync);
	 
	U8 : VGA_DISPLAY
  port map (
	 img => state_reg,
    Clk => Clk,
    Xin => X_emb,
	 Yin => Y_emb,
    En  => Active_emb,
	 R   => Red,
	 G   => Green,
	 B   => Blue);
	 

end Parking_lot_Arch;

