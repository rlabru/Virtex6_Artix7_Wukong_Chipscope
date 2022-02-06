----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:20:13 02/05/2022 
-- Design Name: 
-- Module Name:    ChipScopePhy3_top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ChipScopePhy3_top is
port(
	clk : in std_logic;
	led : out std_logic_vector(7 downto 0)
	);
end ChipScopePhy3_top;

architecture Behavioral of ChipScopePhy3_top is
-- +var **********************************************************************************
component chipscope_icon
  PORT (
    CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CONTROL1 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));
end component;
signal control0 : std_logic_vector(35 downto 0);
signal control1 : std_logic_vector(35 downto 0);
--
component coregen_ila
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CLK : IN STD_LOGIC;
    TRIG0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
	 );
end component;
signal trig0 : std_logic_vector(7 downto 0);
--
component coregen_vio
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    ASYNC_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    ASYNC_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	 );
end component;
signal async_in : std_logic_vector(7 downto 0);
signal async_out : std_logic_vector(7 downto 0);
--

SIGNAL clk1, CLK2 : std_logic;                                       
signal led_buf : STD_LOGIC_VECTOR(7 DOWNTO 0);

-- -var **********************************************************************************
begin 

led <= led_buf;

P1:PROCESS(clk)
VARIABLE count:INTEGER RANGE 0 TO 9999999;
BEGIN                                                                
    IF clk'EVENT AND clk='1' THEN
       IF count<=4999999 THEN                           
          clk1 <= '0';
          count := count + 1;                          
        ELSIF count >= 4999999 AND count <= 9999999 THEN
          clk1 <= '1';
          count := count + 1;
        ELSE 
		    count := 0;
        END IF;                                                      
     END IF;                                          
END PROCESS;

P3:PROCESS(CLK1)   
begin
    IF clk1'event AND clk1='1' THEN  
       clk2 <= not clk2;
    END IF; 
END PROCESS P3;     

P2:PROCESS(clk2)                                              
variable count1:INTEGER RANGE 0 TO 16;
BEGIN
IF clk2'event AND clk2='1' THEN
   if count1 <= 9 then
      if count1 = 9 then
         count1 := 0;
      end if;
      CASE count1 IS
			WHEN 0 => led_buf <= "11100000";
			WHEN 1 => led_buf <= "11010000";
			WHEN 2 => led_buf <= "10110000";
			WHEN 3 => led_buf <= "01110000";
			WHEN 4 => led_buf <= "01010000";
			WHEN 5 => led_buf <= "10100000";
			WHEN 6 => led_buf <= "10010000";
			WHEN 7 => led_buf <= "01100000";
			WHEN 8 => led_buf <= "11110000";
			WHEN OTHERS=> led_buf <= "11111111";              
      END CASE;
      count1 := count1 + 1;
    end if;
end if;
end process;

-- +debug chipscope
csi1 : chipscope_icon
  port map (
    CONTROL0 => control0,
    CONTROL1 => control1
	 );

ila1 : coregen_ila
  port map (
    CONTROL => control0,
    CLK => clk,
    TRIG0 => trig0);

trig0 <= async_out;
async_in <= led_buf;

vio1 : coregen_vio
  port map (
    CONTROL => control1,
    ASYNC_IN => async_in,
    ASYNC_OUT => async_out
	 );
-- -debug chipscope

end Behavioral;

