library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity unitate_id is
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
end unitate_id;

architecture Behavioral of unitate_id is

component reg_file is
    Port ( ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           reg_wr : in STD_LOGIC;
           enable: in STD_LOGIC);
end component;

signal WriteAdress: STD_LOGIC_VECTOR(2 downto 0):="000";
signal RA1: STD_LOGIC_VECTOR(2 downto 0):="000";
signal RA2: STD_LOGIC_VECTOR(2 downto 0):="000";

begin

    RA1<=Instr(12 downto 10);
    RA2<=Instr(9 downto 7);
    rf: reg_file port map(RA1, RA2, WriteAdress, WD, RD1, RD2, clk, RegWrite, en);
    
    process(RegDst, Instr)
    begin
    case RegDst is
        when '0' => WriteAdress <= Instr(9 downto 7);
        when others => WriteAdress <= Instr(6 downto 4);
    end case;
    end process;
    
    process(ExtOp, Instr)
    begin
        case ExtOp is
            when '0' => Ext_Imm <= "000000000"&Instr(6 downto 0);
            when  others => if Instr(6)='1' then
                Ext_Imm <= "111111111"&Instr(6 downto 0);
            else Ext_Imm <= "000000000"&Instr(6 downto 0);
                            end if;
        end case;
    end process;
    
    sa<=instr(3);
    func<=instr(2 downto 0);

end Behavioral;
