----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2026 01:17:56
-- Design Name: 
-- Module Name: ic - Behavioral
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

entity ic is
Port (
Instr: in std_logic_vector(5 downto 0);
Br_gtz: out std_logic;
ALUSrc: out std_logic;
Branch: out std_logic;
Jump: out std_logic;
ALUOp: out std_logic_vector(1 downto 0);
MemWrite: out std_logic;
MemToReg: out std_logic;
RegWrite: out std_logic;
ExtOp: out std_logic;
RegDst: out std_logic;
Br_getz: out std_logic );
end ic;

architecture Behavioral of ic is

begin

    process(Instr)
    begin
        case Instr is
        when "000000" => RegDst<='1';
                         ExtOp<='0';
                         ALUSrc<='0';
                         Branch<='0';
                         Br_gtz<='0';
                         Br_getz<='0';
                         Jump<='0';
                         MemWrite<='0';
                         MemToReg<='0';
                         RegWrite<='1';
                         ALUOp<="00";
        when "001001" => RegDst<='0';
                         ExtOp<='1';
                         ALUSrc<='1';
                         Branch<='0';
                         Br_gtz<='0';
                         Br_getz<='0';
                         Jump<='0';
                         MemWrite<='0';
                         MemToReg<='0';
                         RegWrite<='1';
                         ALUOp<="01";
        when "001010" => RegDst<='0';
                         ExtOp<='1';
                         ALUSrc<='1';
                         Branch<='0';
                         Br_gtz<='0';
                         Br_getz<='0';
                         Jump<='0';
                         MemWrite<='0';
                         MemToReg<='1';
                         RegWrite<='1';
                         ALUOp<="01";
        when "001011" => RegDst<='0';
                         ExtOp<='1';
                         ALUSrc<='1';
                         Branch<='0';
                         Br_gtz<='0';
                         Br_getz<='0';
                         Jump<='0';
                         MemWrite<='1';
                         MemToReg<='0';
                         RegWrite<='0';
                         ALUOp<="01";  
       when "001100" => RegDst<='0';
                         ExtOp<='1';
                         ALUSrc<='0';
                         Branch<='1';
                         Br_gtz<='0';
                         Br_getz<='0';
                         Jump<='0';
                         MemWrite<='0';
                         MemToReg<='0';
                         RegWrite<='0';
                         ALUOp<="10";
        when "001111" => RegDst<='0';
                         ExtOp<='0';
                         ALUSrc<='0';
                         Branch<='0';
                         Br_gtz<='0';
                         Br_getz<='0';
                         Jump<='1';
                         MemWrite<='0';
                         MemToReg<='0';
                         RegWrite<='0';
                         ALUOp<="00"; 
        when "001101" => RegDst<='0';
                         ExtOp<='1';
                         ALUSrc<='0';
                         Branch<='0';
                         Br_gtz<='0';
                         Br_getz<='1';
                         Jump<='0';
                         MemWrite<='0';
                         MemToReg<='0';
                         RegWrite<='0';
                         ALUOp<="10";
        when "001110" => RegDst<='0';
                         ExtOp<='1';
                         ALUSrc<='0';
                         Branch<='0';
                         Br_gtz<='1';
                         Br_getz<='0';
                         Jump<='0';
                         MemWrite<='0';
                         MemToReg<='0';
                         RegWrite<='0';
                         ALUOp<="10";
        when others => 
             RegDst <= '0';
             ExtOp <= '0';
             ALUSrc <= '0';
             Branch <= '0';
             Br_gtz <= '0';
             Br_getz <= '0';
             Jump <= '0';
             MemWrite <= '0';
             MemToReg <= '0';
             RegWrite <= '0';
             ALUOp <= "00";
        end case;                      
end process;                    
                         


end Behavioral;
