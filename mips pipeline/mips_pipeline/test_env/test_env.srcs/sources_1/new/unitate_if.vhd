library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity unitate_if is
        Port (clk: in STD_LOGIC;
        en: in STD_LOGIC;
        rst: in STD_LOGIC;
        jmp: in STD_LOGIC;
        PCSrc: in STD_LOGIC;
        jmp_adress:in STD_LOGIC_VECTOR(15 downto 0);
        branch_adress: in STD_LOGIC_VECTOR(15 downto 0);
        instr: out STD_LOGIC_VECTOR(15 downto 0);
        PC: out STD_LOGIC_VECTOR(15 downto 0));
end unitate_if;

architecture Behavioral of unitate_if is

signal rez_PC: std_logic_vector(15 downto 0) := x"0000";
signal sum: std_logic_vector(15 downto 0) := x"0000";
signal rez_mux1: STD_LOGIC_VECTOR(15 downto 0) := x"0000";
signal rez_mux2: STD_LOGIC_VECTOR(15 downto 0) := x"0000";

type rom_array is array(0 to 255) of std_logic_vector(15 downto 0);
constant rom: rom_array := (
            B"001_000_000_0000000",      -- 0. 2000   ADDI $0, $0, 0
            B"001_000_001_1100011",      -- 1. 20E3   ADDI $1, $0, 99
            B"001_000_010_0011101",      -- 2. 211D   ADDI $2, $0, -99
            B"001_000_011_0001000",      -- 3. 2188   ADDI $3, $0, 8
            B"001_000_100_0000000",      -- 4. 2200   ADDI $4, $0, 0
            B"001_000_110_0000000",      -- 5. 2300   ADDI $6, $0, 0
            B"010_110_101_0000100",      -- 6. 5A84   LW $5,4($6)
            B"100_000_011_0010011",      -- 7. 8193   BEQ $0,$3,19
            B"001_000_110_0000000",      -- 8. 2300   ADDI $6,$0,0
            B"001_000_110_0000000",      -- 9. 2300   ADDI $6,$0,0
            B"001_000_110_0000000",      --10. 2300   ADDI $6,$0,0
            B"110_101_001_0000100",      --11. D484   BGE $5,$1,4
            B"001_000_110_0000000",      --12. 2300   ADDI $6,$0,0
            B"001_000_110_0000000",      --13. 2300   ADDI $6,$0,0
            B"001_000_110_0000000",      --14. 2300   ADDI $6,$0,0
            B"010_110_001_0000100",      --15. 5884   LW $1,4($6)
            B"110_010_101_0000100",      --16. CA84   BGE $2,$5,4
            B"001_000_110_0000000",      --17. 2300   ADDI $6,$0,0
            B"001_000_110_0000000",      --18. 2300   ADDI $6,$0,0
            B"001_000_110_0000000",      --19. 2300   ADDI $6,$0,0
            B"010_110_010_0000100",      --20. 5904   LW $2,4($6)
            B"001_000_000_0000001",      --21. 2001   ADDI $0,$0,1
            B"001_110_110_0000001",      --22. 3B01   ADDI $6,$6,1
            B"001_000_000_0000000",      --23. 2000   ADDI $0,$0,0
            B"001_000_000_0000000",      --24. 2000   ADDI $0,$0,0
            B"001_000_000_0000000",      --25. 2000   ADDI $0,$0,0
            B"010_110_101_0000100",      --26. 5A84   LW $5,4($6)
            B"111_0000000000111",        --27. E007   J 7
            B"001_000_110_0000000",      --28. 2300   ADDI $6,$0,0
            B"110_100_010_0000101",      --29. D105   BGE $4,$2,5
            B"001_000_110_0000000",      --30. 2300   ADDI $6,$0,0
            B"001_000_110_0000000",      --31. 2300   ADDI $6,$0,0
            B"001_000_110_0000000",      --32. 2300   ADDI $6,$0,0
            B"000_010_001_010_0_001",    --33. 08A1   SUB $2,$2,$1
            B"111_0000000011101",        --34. E01D   J 29
            B"001_000_110_0000000",      --35. 2300   ADDI $6,$0,0
            others => B"000_010_010_010_0_101"); --    0005   OR $2, $2, $2
            
begin

    pc_proces: process(clk,rst)
    begin
        if rst = '1' then
            rez_PC <= x"0000";
        else
        if clk'event and clk='1' then
            if en = '1' then
                rez_PC<=rez_mux2;
            end if;
        end if;
        end if;
     end process;
     
     --PC +1
     sum <= rez_PC + 1;
    
     --rezultate MUX-uri
     rez_mux1<=branch_adress when PCSrc = '1' else sum;
     rez_mux2<=jmp_adress when jmp ='1' else rez_mux1;
        
     -- ROM
     instr <= rom (conv_integer(rez_PC));
      
      PC <= sum;
     
end Behavioral;
