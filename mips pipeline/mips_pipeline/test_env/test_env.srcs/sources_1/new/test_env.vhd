library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity test_env is
 Port ( clk : in STD_LOGIC;
         btn : in STD_LOGIC_VECTOR (4 downto 0);
         sw : in STD_LOGIC_VECTOR (15 downto 0);
         an : out STD_LOGIC_VECTOR (3 downto 0);
         cat : out STD_LOGIC_VECTOR (6 downto 0);
         led : out STD_LOGIC_VECTOR (15 downto 0)
        );
end test_env;

architecture Behavioral of test_env is

component MPG is
       PORT( en: out STD_LOGIC;
       input: in STD_LOGIC;
       clk: in STD_LOGIC);
end component;

component SSD is
    Port ( digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component unitate_if is
        Port (clk: in STD_LOGIC;
        en: in STD_LOGIC;
        rst: in STD_LOGIC;
        jmp: in STD_LOGIC;
        PCSrc: in STD_LOGIC;
        jmp_adress:in STD_LOGIC_VECTOR(15 downto 0);
        branch_adress: in STD_LOGIC_VECTOR(15 downto 0);
        instr: out STD_LOGIC_VECTOR(15 downto 0);
        PC: out STD_LOGIC_VECTOR(15 downto 0));
end component;

component unitate_id is
        Port (clk: in STD_LOGIC;
              RegWrite: in STD_LOGIC;
              Instr: in STD_LOGIC_VECTOR(15 downto 0);
              RegDst: in STD_LOGIC;
              ExtOp: in STD_LOGIC;
              WD: in STD_LOGIC_VECTOR(15 downto 0);
              RD1: out STD_LOGIC_VECTOR(15 downto 0);
              RD2: out STD_LOGIC_VECTOR(15 downto 0);
              Ext_Imm: out STD_LOGIC_VECTOR(15 downto 0);
              func: out STD_LOGIC_vector(2 downto 0);
              sa: out STD_LOGIC;
              en: in STD_LOGIC);
end component;

component unitate_ex is
          Port (rez_pc: in STD_LOGIC_VECTOR(15 downto 0);
          RD1: in STD_LOGIC_VECTOR(15 downto 0);
          ALUSrc:in STD_LOGIC;
          RD2: in STD_LOGIC_VECTOR(15 downto 0);
          Ext_Imm: in STD_LOGIC_VECTOR(15 downto 0);
          sa: in STD_LOGIC;
          func: in STD_LOGIC_VECTOR(2 downto 0);
          ALUOp: in STD_LOGIC_VECTOR(1 downto 0);
          Branch: out STD_LOGIC_VECTOR(15 downto 0);
          Zero: out STD_LOGIC;
          Zero_1: out STD_LOGIC;
          ALURes: out STD_LOGIC_VECTOR(15 downto 0));
end component;

component unitate_mem is
         Port ( en: in STD_LOGIC;
                MemWrite: in STD_LOGIC;
                ALURes: in STD_LOGIC_VECTOR(15 downto 0);
                RD2: in STD_LOGIC_VECTOR(15 downto 0);
                MemData: out STD_LOGIC_VECTOR(15 downto 0);
                clk: in STD_LOGIC;
                ALU_out: out STD_LOGIC_VECTOR(15 downto 0));
end component;

signal enable1: std_logic;
signal enable2: std_logic;
signal DIGIT0, DIGIT1, DIGIT2, DIGIT3 : std_logic_vector(3 downto 0) := "0000";
signal jumpA: std_logic_vector(15 downto 0):=X"0000";
signal branchA: std_logic_vector(15 downto 0):=X"0000";
signal instr: std_logic_vector(15 downto 0);
signal rez_pc: std_logic_vector(15 downto 0);
signal rez: std_logic_vector(15 downto 0);

signal WriteData: STD_LOGIC_VECTOR(15 downto 0):=X"0000";
signal RegDst: STD_LOGIC;
signal RegWrite: STD_LOGIC;
signal ExtOp: STD_LOGIC;
signal RD1: STD_LOGIC_VECTOR(15 downto 0);
signal RD2: STD_LOGIC_VECTOR(15 downto 0);
signal ExtImm: STD_LOGIC_VECTOR(15 downto 0);
signal func: STD_LOGIC_VECTOR(2 downto 0);
signal sa: STD_LOGIC;
signal PCSrc: STD_LOGIC;

signal ALUSrc: STD_LOGIC:='0';
signal Branch: STD_LOGIC:='0';
signal BranchGE: STD_LOGIC:='0';
signal Jump:  STD_LOGIC:='0';
signal ALUOP:  STD_LOGIC_VECTOR(1 downto 0):="00";
signal MemWrite:  STD_LOGIC:='0';
signal MemReg:  STD_LOGIC:='0';

signal ALURes:STD_LOGIC_VECTOR(15 downto 0):=X"0000";
signal zero: STD_LOGIC:='0';
signal zero1: STD_LOGIC:='0';
signal MemData: STD_LOGIC_VECTOR(15 downto 0):=X"0000";
signal ALURes_out:STD_LOGIC_VECTOR(15 downto 0):=X"0000";

signal RegIF_ID: STD_LOGIC_VECTOR(31 downto 0);
signal RegID_EX: STD_LOGIC_VECTOR(78 downto 0);
signal RegEX_Mem: STD_LOGIC_VECTOR(57 downto 0);
signal RegMem_Wb: STD_LOGIC_VECTOR(36 downto 0);
signal writeAddressReg: STD_LOGIC_VECTOR(2 downto 0);

begin
    mpg1: MPG port map(enable1, btn(0), clk);
    mpg2: MPG port map(enable2, btn(1), clk);
    u_if: unitate_if port map(clk, enable1, enable2, Jump, PCSrc, jumpA, branchA, instr, rez_pc);
    u_id: unitate_id port map(clk, RegMem_Wb(0) ,RegIF_ID(15 downto 0), RegDst, ExtOp, WriteData, RD1, RD2, ExtImm, func, sa, enable1);
    u_ex: unitate_ex port map(RegID_EX(30 downto 15),RegID_EX(78 downto 63),RegID_EX(6),RegID_EX(62 downto 47),RegID_EX(46 downto 31),RegID_EX(11),RegID_EX(14 downto 12),RegID_EX(5 downto 4),branchA,zero,zero1,ALURes);
    u_mem: unitate_mem port map(enable1, RegEX_Mem(2), RegEX_Mem(41 downto 26), RegEX_Mem(25 downto 10) ,MemData ,clk ,ALURes_out);
    afis: SSD port map(digit0 => rez(3 downto 0), digit1 =>rez(7 downto 4), digit2 => rez(11 downto 8), digit3 => rez(15 downto 12), clk => clk, an => an, cat => cat);

    process(clk)
    begin
        if rising_edge(clk) then
            if enable1 = '1' then
              RegIF_ID(15 downto 0) <= instr;
              RegIF_ID(31 downto 16) <= rez_pc;
            end if;
         end if; 
    end process;
    
    process(clk)
    begin   if rising_edge(clk) then
                if enable1 = '1' then
                    RegID_EX(0) <= Branch;
                    RegID_EX(1) <= BranchGE;
                    RegID_EX(2) <= MemReg;
                    RegID_EX(3) <= MemWrite;
                    RegID_EX(5 downto 4) <= AluOp; 
                    RegID_EX(6) <= AluSrc;
                    RegID_EX(7) <= RegWrite;
                    RegID_EX(10 downto 8) <= writeAddressReg;
                    RegID_EX(11) <= sa;
                    RegID_EX(14 downto 12) <= func;
                    RegID_EX(30 downto 15) <=  RegIF_ID(31 downto 16);
                    RegID_EX(46 downto 31) <= ExtImm;
                    RegID_EX(62 downto 47) <= RD2;
                    RegID_EX(78 downto 63) <= RD1;
                end if; 
            end if;
    end process;
        
    process(clk)
    begin
        if rising_edge(clk) then
            if enable1 = '1' then
             RegEX_Mem(0) <= RegID_EX(0); --Branch
             RegEX_Mem(1) <= RegID_EX(1); --BranchGE
             RegEX_Mem(2) <=  RegID_EX(3); --MemWrite
             RegEX_Mem(3) <= RegID_EX(7);  --RegWrite
             RegEX_Mem(4) <= RegID_EX(2);   --MemReg
             RegEX_Mem(7 downto 5) <= RegID_EX(10 downto 8); --writeAddressReg
             RegEX_Mem(8) <= zero;
             RegEX_Mem(9) <= zero1;
             RegEX_Mem(25 downto 10) <= RegID_EX(62 downto 47);  --RD2
             RegEX_Mem(41 downto 26) <= AluRes;
             RegEX_Mem(57 downto 42) <= branchA;       
            end if;
         end if; 
    end process;
        
    process(clk)
    begin
        if rising_edge(clk) then
            if enable1 = '1' then
                RegMem_Wb(0) <= RegEX_Mem(3); --RegWrite
                RegMem_Wb(1) <= RegEX_Mem(4); --MemReg
                RegMem_Wb(4 downto 2) <= RegEX_Mem(7 downto 5); --WriteAddress
                RegMem_Wb(20 downto 5) <= RegEX_Mem(41 downto 26);  --AluRes
                RegMem_Wb(36 downto 21) <= MemData;  
            end if;
         end if; 
    end process;
    
    --UC
    process(instr)
    begin
        BranchGE  <= '0';
        RegDst    <= '0';
        RegWrite  <= '0';
        AluSrc    <= '0';
        ExtOp     <= '0';
        MemWrite  <= '0';
        MemReg    <= '0';
        Branch    <= '0';
        Jump      <= '0';
        ALUOP     <= "00";
    
    --instr 
    case instr(15 downto 13) is 
        when "000" => RegDst <= '1'; RegWrite <= '1'; ALUOP <= "00"; --tip R
        when "001" => RegWrite <= '1'; ALUSrc <= '1'; ExtOp <= '1'; ALUOP <= "01"; --addi
        when "010" => RegWrite <= '1'; ALUSrc <= '1'; ExtOp <= '1'; MemReg <= '1'; ALUOP <= "01"; --lw
        when "100" => ExtOp <= '1'; Branch <= '1'; ALUOP <= "10"; --beq
        when "110" => ExtOp <= '1'; BranchGE <= '1'; ALUOP <= "10"; --bge
        when others => Jump <= '1'; ALUOP <= "XX"; --jump
    end case;
    end process;
    
    WriteData <= RegMem_Wb(36 downto 21) when RegMem_Wb(1)='0' else RegMem_Wb(20 downto 5);
    jumpA <= "000" & instr(12 downto 0);
    PCSrc <= (zero and Branch) or (zero1 and BranchGE);
    
    process(sw(2 downto 0))
    begin
        case sw(2 downto 0) is
            when "000" => rez <= RegIF_ID(15 downto 0);
            when "001" => rez <= RegIF_ID(31 downto 16);
            when "010" => rez <= RD1;
            when "011" => rez <= RD2;
            when "100" => rez <= ExtImm;
            when "101" => rez <= ALURes;
            when "110" => rez <= MemData;
            when "111" => rez <= WriteData;
        end case;  
    end process;
        
end Behavioral;
