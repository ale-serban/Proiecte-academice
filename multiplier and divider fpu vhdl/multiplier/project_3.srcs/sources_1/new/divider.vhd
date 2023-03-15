library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
-- use STD.textio.all; -- basic I/O
-- use IEEE.std_logic_textio.all; -- I/O for logic types

entity divider is
Port ( x : in STD_LOGIC_VECTOR (31 downto 0);
y : in STD_LOGIC_VECTOR (31 downto 0);
z : out STD_LOGIC_VECTOR (31 downto 0));
end divider;

architecture Behavioral of divider is

begin
process(x,y)
variable x_mantissa : STD_LOGIC_VECTOR (22 downto 0);
variable x_exponent : STD_LOGIC_VECTOR (7 downto 0);
variable x_sign : STD_LOGIC;
variable y_mantissa : STD_LOGIC_VECTOR (22 downto 0);
variable y_exponent : STD_LOGIC_VECTOR (7 downto 0);
variable y_sign : STD_LOGIC;
variable z_mantissa : STD_LOGIC_VECTOR (22 downto 0);
variable z_exponent : STD_LOGIC_VECTOR (7 downto 0);
variable z_sign : STD_LOGIC;

variable a : STD_LOGIC_VECTOR (25 downto 0);
-- holds the result of the division of the mantissas
-- a = a0.a-1a-2a-3... a<2 e a>1/2
-- 0 to -23 if a0=1 and -1 to -24 if a0=0. a-25 to round.

variable partial_remainder : STD_LOGIC_VECTOR (24 downto 0);
-- the partial remainder requires one extra bit for the shift left
-- P = partial_remainder = xx.xxxx ... < 4
variable tmp_remainder : STD_LOGIC_VECTOR (24 downto 0);

variable exponent_aux : STD_LOGIC_VECTOR (8 downto 0);
-- nine bits = 8+1 to detect underflow and overflow

begin
x_mantissa := x(22 downto 0);
x_exponent := x(30 downto 23);
x_sign := x(31);
y_mantissa := y(22 downto 0);
y_exponent := y(30 downto 23);
y_sign := y(31);

z_sign := x_sign xor y_sign;

if (y_exponent="11111111") then -- x/inf = 0
z_exponent := "00000000";
z_mantissa := (others=>'0');
else
if (y_exponent=0 or x_exponent=255) then -- result = infinity
-- x/0 or inf/x = inf
z_exponent := "11111111";
z_mantissa := (others=>'0');
else
exponent_aux := ('0' & x_exponent) - ('0' & y_exponent) + 127;

partial_remainder := "01" & x_mantissa; -- P = 1.F1

-- Area with a comparator: 1,851 4 input LUT
-- Area joining comparacion and subtraction: 1,324 4 input LUT

digit_loop: for i in 25 downto 0 loop
tmp_remainder := partial_remainder - ("01" & y_mantissa);

if ( tmp_remainder(24)='0' ) then
-- result is non negative: partial_remainder >= ("01" & y_mantissa)
-- note that tmp_remainder < 2 so bit 24 should be zero
a(i):='1';
partial_remainder := tmp_remainder;
else
a(i):='0';
end if;

partial_remainder := partial_remainder(23 downto 0) & '0'; -- sll
-- P/2 < y && y < 2 => P < 4

end loop digit_loop;

a := a + 1; -- round

if (a(25)='1') then -- a=1.xxxx
z_mantissa := a(24 downto 2);
else -- a=0.1xxxx
z_mantissa := a(23 downto 1);
exponent_aux := exponent_aux - 1;
end if;

-- z_exponent > 0-254+127-1 = -128 = 1 1000 0000 b
-- y_exponent = 255 is infinity that was previously taken care
-- z_exponent < 255-0+127 = 382 = 1 0111 1110 b
if (exponent_aux(8)='1') then
if (exponent_aux(7)='1') then -- underflow
z_exponent := "00000000";
z_mantissa := (others=>'0');
else -- overflow
z_exponent := "11111111";
z_mantissa := (others=>'0');
end if;
else
z_exponent := exponent_aux(7 downto 0);
end if;

end if;
end if;

z(22 downto 0) <= z_mantissa;
z(30 downto 23) <= z_exponent;
z(31) <= z_sign;

end process;
end Behavioral;