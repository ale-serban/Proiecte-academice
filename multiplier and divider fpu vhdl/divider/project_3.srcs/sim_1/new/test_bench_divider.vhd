----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/18/2023 08:59:25 PM
-- Design Name: 
-- Module Name: test_bench_multiplication - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_bench_divider is
--  Port ( );
end test_bench_divider;

architecture Behavioral of test_bench_divider is

component divider is
Port ( x : in STD_LOGIC_VECTOR (31 downto 0);
y : in STD_LOGIC_VECTOR (31 downto 0);
z : out STD_LOGIC_VECTOR (31 downto 0));
end component;
signal x_aux, y_aux, z_aux : std_logic_vector(31 downto 0) := x"00000000";

begin
div: divider port map (x_aux, y_aux, z_aux);
process 
begin 
wait for 100 ps;

--y_aux <= "01000001101001000000000000000000"; --20.5
--x_aux <= "01000000000000000000000000000000"; --2
--		--z = (2) / (20.5) = 0.0975
--		-- z will be "00111101110001111100111000001100" => 3DC7 CE0C
----------------------------------------------------------

--x_aux <= "01000001101001000000000000000000"; --20.5
--y_aux <= "01000000000000000000000000000000"; --2
--		--z = (20.5) / (2) = 10.25
--		-- z will be "01000001001001000000000000000000" => 4124 0000

------------------------------------------------------------

--x_aux <= "01000000001000000000000000000000"; --2.5
--y_aux <= "00111111000000000000000000000000"; --0.5
--		--z = (2.5) / (0.5) = 5
--		-- z will be "01000000101000000000000000000000" => 40a00000

--------------------------------------------------------------

x_aux <= "01111111111111111111111111111111"; -- 2^-149
y_aux <= "00000000000000000000000000000010"; -- 2
        -- z should be 2^-150
		-- z will be underflow
		
wait;
end process;

end Behavioral;
