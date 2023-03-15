library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity unitate_mem is
 Port ( en: in STD_LOGIC;
        MemWrite: in STD_LOGIC;
        ALURes: in STD_LOGIC_VECTOR(15 downto 0);
        RD2: in STD_LOGIC_VECTOR(15 downto 0);
        MemData: out STD_LOGIC_VECTOR(15 downto 0);
        clk: in STD_LOGIC;
        ALU_out: out STD_LOGIC_VECTOR(15 downto 0));
end unitate_mem;

architecture Behavioral of unitate_mem is

type aray is array (0 to 31) of std_logic_vector(15 downto 0);
signal mem: aray := (      
            x"0000",    --0
            x"0063",    --99
            x"0000",    --0
            x"0008",    --8
            x"0007",    --7
            x"0004",    --4
            x"0003",    --3
            x"0004",    --4
            x"0005",    --5
            x"0006",    --6 
            x"0007",    --7
            x"0008",    --8
            others => x"ffff");
            
begin

    process(clk)
    begin
        if (clk'event and clk = '1') then
            if en = '1' then
                if MemWrite = '1' then 
                    mem (conv_integer (ALURes)) <= rd2;
                end if;
            end if;
        end if;
    end process;
    
    MemData <= mem (conv_integer (ALURes));
    ALU_out <= ALURes;

end Behavioral;
