library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity MPG is
 Port ( en: out STD_LOGIC;
        input: in STD_LOGIC;
        clk: in STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
    
    signal Q1: std_logic;
    signal Q2: std_logic;
    signal Q3: std_logic;
    signal cnt_int: std_logic_vector(31 downto 0):=x"00000000";
    
begin
    en<= Q2 and (not Q3);
    
   counter1: process(clk)
    begin
        if clk'event and clk='1' then
            cnt_int <= cnt_int + 1;
        end if;
     end process;
     
    counter2: process(clk)
     begin
        if clk'event and clk='1' then
            if cnt_int(15 downto 0) = "1111111111111111" then
                Q1 <= input;
            end if;
        end if;
     end process;
     
     counter3: process(clk)
     begin 
        if clk'event and clk = '1' then
            Q2 <= Q1;
            Q3 <= Q2;
        end if;
     end process;

end Behavioral;
