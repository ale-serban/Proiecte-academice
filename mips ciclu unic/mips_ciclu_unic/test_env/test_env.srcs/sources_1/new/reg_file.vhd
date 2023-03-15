library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity reg_file is
    Port ( ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           reg_wr : in STD_LOGIC;
           enable: in STD_LOGIC);
end reg_file;

architecture Behavioral of reg_file is

type reg_arr is array (0 to 7) of std_logic_vector(15 downto 0);
signal reg: reg_arr := ( 
                  others=>X"0000");

begin

    rf: process(clk)
    begin
        if (clk'event and clk='1') then
            if reg_wr = '1' then
                if enable='1' then
                    reg(conv_integer(wa)) <= wd;
                end if;
            end if;
        end if;
    end process;

    rd1 <= reg(conv_integer(ra1));
    rd2 <= reg(conv_integer(ra2));

end Behavioral;
