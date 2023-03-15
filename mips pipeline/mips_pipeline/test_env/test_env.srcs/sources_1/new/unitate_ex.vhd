library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity unitate_ex is
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
end unitate_ex;

architecture Behavioral of unitate_ex is

signal rez: STD_LOGIC_VECTOR(15 downto 0);
signal mux: STD_LOGIC_VECTOR(15 downto 0);
signal AluCtrl: STD_LOGIC_VECTOR(2 downto 0);

begin
    
    mux <= RD2 when ALUSrc='0' else Ext_Imm;
    
    process (ALUOp, func)
        begin
        case ALUOp is
            when "00"=> AluCtrl <= func; 
            when "01"=> AluCtrl <= "000"; 
            when "10"=> AluCtrl <= "001"; 
            when "11"=> AluCtrl <= "101";  
            when others => AluCtrl <= "XXX";
      end case;
    end process;
    
    process(RD1, sa, mux, AluCtrl)
        begin
        case AluCtrl is
               when "000" => rez <=RD1+mux;
               when "001" => rez <=RD1-mux;
               when "010" => if sa='1' then
                            rez <= RD1(14 downto 0)& '0';
                            end if;
               when "011" => if sa='1' then
                             rez <='0'&RD1(15 downto 1);
                             end if;
               when "100" => rez<=RD1 and mux;
               when "101" => rez<=RD1 or mux;
               when "110" => rez<=RD1 xor mux;
               when others => if sa='1' then
                            rez <=RD1(15)&RD1(15 downto 1);
                            end if;   
       end case;    
    end process;
    
    ALURes <= rez;
    zero <= '1' when rez = X"0000" else '0';
    Zero_1 <= '1' when rez <= X"0000" else '0';
    Branch <= rez_pc + Ext_Imm;
    
end Behavioral;
