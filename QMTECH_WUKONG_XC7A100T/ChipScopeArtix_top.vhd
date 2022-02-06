----------------------------------------------------------------------------------
-- Engineer: SY
-- 
-- Create Date:    16:00:07 01/27/2022 
-- Module Name:    ChipScopeArtix_top - Behavioral 
-- Project Name:   ChipScopeArtix
-- Target Devices: Wukong
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ChipScopeArtix_top is

	PORT(
      LEDS : out STD_LOGIC_VECTOR(1 DOWNTO 0); 
      LEDF : out STD_LOGIC_VECTOR(7 DOWNTO 0);
		BTNF : in  STD_LOGIC_VECTOR(5 DOWNTO 0);
		KEY  : in  STD_LOGIC;
		--
		clkg : in STD_LOGIC;  --System Clk
		rst  : in STD_LOGIC   --Reset button on module
	);

end ChipScopeArtix_top;

architecture Behavioral of ChipScopeArtix_top is
--
component chipscope_icon
  PORT (
    CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CONTROL1 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0)
	 );
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

signal allkey : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal LEDF_buf : STD_LOGIC_VECTOR(7 DOWNTO 0);

begin

allkey <= async_out(0)&KEY&BTNF;
LEDF <= LEDF_buf;

KEY_P0: process(rst,clkg)
begin
if rst='0' then -- reset
	LEDS <= b"00";
	LEDF_buf <= x"00";
elsif (rising_edge(clkg)) then
	case allkey is
		when x"01" =>
			LEDS <= b"01";
			LEDF_buf <= x"05";
		when x"02" =>
			LEDS <= b"10";
			LEDF_buf <= x"77";
		when x"04" =>
			LEDS <= b"00";
			LEDF_buf <= x"0E";
		when x"08" =>
			LEDS <= b"00";
			LEDF_buf <= x"11";
		when x"40" =>
			LEDS <= b"11";
			LEDF_buf <= x"FF";
		when others => 
			LEDS <= b"00";
			LEDF_buf <= x"00";
	end case;
end if;
end process KEY_P0;

csi1 : chipscope_icon
  port map (
    CONTROL0 => control0,
    CONTROL1 => control1
	 );
	 
ila1 : coregen_ila
  port map (
    CONTROL => control0,
    CLK => clkg,
    TRIG0 => trig0);

trig0 <= async_out;
async_in <= LEDF_buf;

vio1 : coregen_vio
  port map (
    CONTROL => control1,
    ASYNC_IN => async_in,
    ASYNC_OUT => async_out);

end Behavioral;

