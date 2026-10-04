----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.04.2026 16:50:24
-- Design Name: 
-- Module Name: UE - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UE is
Port (
RD1: in std_logic_vector(31 downto 0);
RD2: in std_logic_vector(31 downto 0);
Ext_Imm: in std_logic_vector(31 downto 0);
Pc4: in std_logic_vector(31 downto 0);
AluSRC: in std_logic;
sa: in std_logic_vector(4 downto 0);
func: in std_logic_vector(5 downto 0);
AluOp: in std_logic_vector(1 downto 0);
GTZ: out std_logic;
GETZ: out std_logic;
Zero: out std_logic;
ALURes: out std_logic_vector(31 downto 0);
BranchAddress: out std_logic_vector(31 downto 0) );
end UE;

architecture Behavioral of UE is
signal ALUCtrl: std_logic_vector(2 downto 0):=(others=>'0');
signal a,b,c, aux: std_logic_vector(31 downto 0):=(others=>'0');

begin
a<=RD1;
b<=RD2 when AluSRC='0' else Ext_Imm;
aux<=Ext_Imm(29 downto 0)&"00";

process(AluOp, func)
begin

case AluOp is 
     when "00" => 
          case func is 
               when "000001" => ALUCtrl<="001";
               when "000010" => ALUCtrl<="010";
               when "000011" => ALUCtrl<="011";
               when "000100" => ALUCtrl<="100";
               when "000101" => ALUCtrl<="101";
               when "000110" => ALUCtrl<="110";
               when "000111" => ALUCtrl<="111";
               when others=> ALUCtrl<="000";
          end case;
    when "01" => ALUCtrl<="001";
    when "10" => ALUCtrl<="010";
    when others=> ALUCtrl<="000";
end case;
end process;

process(ALUCtrl,a,b,sa)
begin
    case ALUCtrl is 
         when "001"=> c<=a+b;
         when "010"=> c<=a-b;
         when "101"=> c<=a and b;
         when "110" => c<= a or b;
         when "011" => c<= to_stdlogicvector(to_bitvector(b) sll conv_integer(sa));
         when "100" => c<= to_stdlogicvector(to_bitvector(b) srl conv_integer(sa));
         when "111" => c<= a xor b;
         when others=> c<= to_stdlogicvector(to_bitvector(b) sll conv_integer(a));
    end case;

end process;

Zero<='1' when c=x"00000000" else '0';
GTZ<='0' when (c(31)='1' or c=x"00000000") else '1';
GETZ<='1' when (c(31)='0' or c=x"00000000") else '0';

BranchAddress<=aux+Pc4;

ALURes<=c;


end Behavioral;
