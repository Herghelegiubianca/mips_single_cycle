----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2026 16:31:22
-- Design Name: 
-- Module Name: ifetch - Behavioral
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

entity ifetch is
Port (
clk: in std_logic;
en: in std_logic;
rst: in std_logic;
jump: in std_logic;
pcsrc: in std_logic;
instruction: out std_logic_vector(31 downto 0);
pc4: out std_logic_vector(31 downto 0);
jumpAddress: in std_logic_vector(31 downto 0);
branchAddress: in std_logic_vector(31 downto 0) );
end entity ifetch;

architecture Behavioral of ifetch is

signal pc, q: std_logic_vector(31 downto 0):=(others=>'0');

type mat is array(31 downto 0) of std_logic_vector(31 downto 0);
signal mem: mat:=(0=>B"001010_00000_00001_0000000000000000", --x"28010000" | LW $1, 0($0) | ma asigur ca nu am nimic in registrul 1
                  1=>B"001001_00001_00001_1111111111111111", --x"2421FFFF" | ADDI $1, $1, -1 | trebuie sa efectuez o scadere ulterior, deci adun in registrul 1 valoarea -1
                  2=>B"001001_00000_00010_0000000000000000", --x"24020000" | ADDI $2, $0, 0 | ma asigur ca nu am nimic in registrul 2
                  3=>B"001010_00010_00101_0000000000000100", --x"28450004" | LW $5, 4($2) | incarc in registrul 5 valoarea aflata in memorie la adresa 0, adica dimensiunea sirului de nr pe care urmeaza sa il procesez
                  4=>B"001100_00001_00000_0000000000000111", --x"30200007" | BEQ $1, $0, 7 | verific daca valoarea din registrul 1 (contorul pt parcurgerea sirului) a ajuns la 0, in caz afirmativ sar peste urmatoarele 7 instructiuni (bucla de modificare)
                  5=>B"001010_00010_00011_0000000000000100", --x"28430004" | LW $3, 4($2)  | salvez in registrul 3 valoarea elementului curent din sir (sirul se afla in memorie incepand cu adresa 4)
                  6=>B"001010_00010_00100_0000000000001000", --x"28440008" | LW $4, 8($2)  | salvez in registrul 4 valoarea elementului urmator din sir (sirul se afla in memorie incepand cu adresa 4)                                    
                  7=>B"000000_00011_00100_00011_00000_000001",--x"00641801" | ADD $3, $3, $4 | adun cele 2 valori luate din memorie anterior si salvez rezultatul in memorie (xn=xn+xn+1)
                  8=>B"001011_00010_00011_0000000000000100", --x"2C430004"  | SW $3, 4($2) | salvez valoarea din registrul 3 in memorie la adresa elementului curent din sir
                  9=>B"001001_00010_00010_0000000000000100", --x"24420004"  | ADDI $2, $2, 4 | incrementez valoarea din registrul 2, registru care are rol de index sau contor
                  10=>B"001001_00001_00001_1111111111111111",--x"2421FFFF"  | ADDI $1, $1, -1 | decrementez valoarea din registrul 1 pentru a facilita ulterior oprirea buclei de modificare a elementelor sirului
                  11=>B"001111_00000000000000000000000100",    --x"3C000004" | J 4 | sar la adresa 4 / instructiunea de la adresa 4 / instructiunea nr 4
                  12=>B"001010_00010_00011_0000000000000100",--x"28430004"  | LW $3, 4($2) | salvez in registrul 3 valoarea elementului curent din sir
                  13=>B"000000_00011_00101_00011_00000_000001",--x"00651801" | ADD $3, $3, $5 | adun valoarea din registrul 3 cu cea din registrul 5, am ajuns la ultimul element din sir si acesta trebuie modificat sa ia valoarea sa adunata cu valoarea primului element (salvata la inceput in registrul 5) 
                  14=>B"001011_00010_00011_0000000000000100", --x"2C430004" | SW $3, 4($2) | salvez valoarea din registrul 3 in memorie la adresa elementului curent din sir
                  15=>B"001010_00000_00001_0000000000000000", --x"28010000" | LW $1, 0($0) | analog buclei de modificare, o incep pe cea de citire, asigurandu-ma ca in registrul 1 am dimensiunea sirului de numere
                  16=>B"001001_00000_00010_0000000000000000", --x"24020000" | ADDI $2, $0, 0 | ma asigur ca in registrul 2 nu am nimic
                  17=>B"001100_00001_00000_0000000000000100", --x"30200004" | BEQ $1, $0, 4  | in cazul in care termin bucla de citire (valoarea din registrul 1 ajunge la 0) sar peste urmatoarele 4 instructiuni
                  18=>B"001010_00010_00011_0000000000000100", --x"28430004" | LW $3, 4($2) | salvez in registrul 3 valoarea elementului curent din sir
                  19=>B"001001_00010_00010_0000000000000100", --x"24420004" | ADDI $2, $2, 4 | incrementez valoarea din registrul 2, registru care are rol de index sau contor                                                                     
                  20=>B"001001_00001_00001_1111111111111111", --x"2421FFFF" | ADDI $1, $1, -1 | decrementez valoarea din registrul 1 pentru a facilita ulterior oprirea buclei de citire a elementelor sirului                             
                  21=>B"001111_00000000000000000000010001",     --x"3C000011" | J 17 | sar la adresa 17 / instructiunea de la adresa 17 / instructiunea nr 17                                              
                  others=>x"00000000"              );
                  

begin

process(clk,rst)
begin
      if rst='1' then
         q<=x"00000000";
      elsif rising_edge(clk) then 
         if en='1' then
         q<=pc;
         end if;
      end if;
end process;

process(jump, pcsrc, jumpAddress, branchAddress, q)
begin
      if jump='1' then
         pc<=jumpAddress;
      else
         if pcsrc='1' then
             pc<=branchAddress;
         else
            pc<=q+4;
         end if;
      end if;


end process;

pc4<=q+4;
instruction<=mem(conv_integer(q(6 downto 2)));


end Behavioral;
