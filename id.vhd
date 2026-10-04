----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2026 00:54:08
-- Design Name: 
-- Module Name: id - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity id is
Port (
clk: in std_logic;
en: in std_logic;
RegWrite: in std_logic;
Instr: in std_logic_vector(25 downto 0);
RegDst: in std_logic;
WD: in std_logic_vector(31 downto 0);
ExtOp: in std_logic;
RD1: out std_logic_vector(31 downto 0);
RD2: out std_logic_vector(31 downto 0);
ExtImm: out std_logic_vector(31 downto 0);
func: out std_logic_vector(5 downto 0);
sa: out std_logic_vector(4 downto 0)
 );
end id;

architecture Behavioral of id is

type mat is array(31 downto 0) of std_logic_vector(31 downto 0);
signal mem: mat:=(others=>x"00000000");
signal WA: std_logic_vector(4 downto 0):=(others=>'0');

begin

WA<=Instr(20 downto 16) when RegDst='0' else Instr(15 downto 11);
RD1<=mem(conv_integer(Instr(25 downto 21)));
RD2<=mem(conv_integer(Instr(20 downto 16)));
func<=Instr(5 downto 0);
sa<=Instr(10 downto 6);

process(ExtOp, Instr)
begin
      if ExtOp='0' then
         ExtImm<="0000000000000000" & Instr(15 downto 0);
      elsif Instr(15)='0' then
          ExtImm<="0000000000000000" & Instr(15 downto 0);
      else
          ExtImm<="1111111111111111" & Instr(15 downto 0);
      end if;
end process;

process(clk)
begin

    if rising_edge(clk) then
       if RegWrite='1' and en='1' then
          if WA/="00000" then --nu se scrie in reg 0
          mem(conv_integer(WA))<=WD;
          end if;
       end if;
    end if;

end process;

end Behavioral;
