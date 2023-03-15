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
            B"100_000_011_0001000",              -- 0. 8188   BEQ $0,$3,8
            B"110_101_001_0000001",              -- 1. D481   BGE $5,$1,1
            B"010_110_001_0000100",              -- 2. 5884   LW $1,4($6)
            B"110_101_010_0000001",              -- 3. D501   BGE $5,$2,1
            B"010_110_010_0000100",              -- 4. 5904   LW $2,4($6)
            B"001_000_000_0000001",              -- 5. 2001   ADDI $0,$0,1
            B"001_110_110_0000100",              -- 6. 3B04   ADDI $6,$6,4
            B"010_110_101_0000100",              -- 7. 5A84   LW $5,4($6)
            B"111_0000000000000",                -- 8. E000   J 0
            B"110_100_010_0000010",              -- 9. D102   BGE $4,$2,2
            B"000_010_001_010_0_001",            --10. 08A1   SUB $2,$2,$1
            B"111_0000000001001",                --11. E009   J 9
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
