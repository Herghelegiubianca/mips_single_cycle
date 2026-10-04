----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.04.2026 22:49:31
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
Port (
MEMWrite: in std_logic;
Address: in std_logic_vector(31 downto 0);
WriteData: in std_logic_vector(31 downto 0);
clk: in std_logic;
en: in std_logic;
ReadData: out std_logic_vector(31 downto 0));
end MEM;

architecture Behavioral of MEM is

type mat is array(63 downto 0) of std_logic_vector(31 downto 0);
signal mm: mat:=(0=>x"00000005",
                 1=>x"00000001",
                 2=>x"00000002",
                 3=>x"00000003",
                 4=>x"00000004",
                 5=>x"00000005",
                 others=>x"00000000");

begin

process(clk)
begin
    if rising_edge(clk) then
       if en='1' and MEMWrite='1' then
          mm(conv_integer(Address(7 downto 2)))<=WriteData;
       end if;
    end if;
end process;

ReadData<=mm(conv_integer(Address(7 downto 2)));

end Behavioral;
