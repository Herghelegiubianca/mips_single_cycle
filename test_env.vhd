----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2026 17:09:20
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
Port (
btn: in std_logic_vector(4 downto 0);
clk: in std_logic;
sw: in std_logic_vector(15 downto 0);
led: out std_logic_vector(15 downto 0);
cat: out std_logic_vector(6 downto 0);
an: out std_logic_vector(7 downto 0) );
end test_env;

architecture Behavioral of test_env is
signal en: std_logic:='1';
signal Br_gtz,gtz: std_logic :='0';
signal ALUSrc, PCSrc: std_logic :='0';
signal Branch: std_logic :='0';
signal Jump: std_logic :='0';
signal ALUOp: std_logic_vector(1 downto 0):=(others=>'0');
signal MemWrite: std_logic :='0';
signal MemToReg: std_logic :='0';
signal RegWrite: std_logic :='0';
signal ExtOp: std_logic :='0';
signal RegDst: std_logic :='0';
signal Br_getz,getz,zro: std_logic :='0';
signal RD1,RD2,ExtImm: std_logic_vector(31 downto 0):=(others=>'0');
signal func: std_logic_vector(5 downto 0):=(others=>'0');
signal sa: std_logic_vector(4 downto 0):=(others=>'0');
signal BranchAddress, JumpAddress: std_logic_vector(31 downto 0):=(others=>'0');

component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component MPG;

component ifetch is
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
end component ifetch;

component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component SSD;

component id is
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
end component id;

component ic is
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
end component;

component UE is
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
end component UE;

component MEM is
Port (
MEMWrite: in std_logic;
Address: in std_logic_vector(31 downto 0);
WriteData: in std_logic_vector(31 downto 0);
clk: in std_logic;
en: in std_logic;
ReadData: out std_logic_vector(31 downto 0));
end component MEM;

signal instruction, pc4,rez,alurez, MemData, outpt: std_logic_vector(31 downto 0):=(others=>'0');

begin

MPG1: MPG port map(en, btn(0),clk);
ifetch1: ifetch port map(clk,en,btn(1),Jump,PCSrc,instruction,pc4,JumpAddress,BranchAddress);
SSD1:SSD port map(clk,outpt,an,cat);
ic1: ic port map(instruction (31 downto 26), Br_gtz, ALUSrc,Branch,Jump,ALUOp,MemWrite,MemToReg,RegWrite,ExtOp,RegDst,Br_getz);
id1: id port map(clk,en,RegWrite,instruction(25 downto 0), RegDst,rez,ExtOp, RD1, RD2, ExtImm,func,sa);
ue1: UE port map(RD1,RD2,ExtImm,pc4,ALUSrc,sa,func, ALUOp,gtz,getz,zro,alurez,BranchAddress);
mem1: MEM port map(MemWrite,alurez,RD2,clk,en,MemData);

PCSrc<=(Br_gtz and gtz) or (Br_getz and getz) or (Branch and zro);
JumpAddress<=pc4(31 downto 28)&instruction(25 downto 0)&"00";
rez<=MemData when MemToReg='1' else alurez;

process(sw)
begin
       case sw(8 downto 5) is
       when "0000" => outpt<=instruction;
       when "0001" => outpt<=pc4;
       when "0010" => outpt<=RD1;
       when "0011" => outpt<=RD2;
       when "0100" => outpt<=ExtImm;
       when "0101" => outpt<=alurez; 
       when "0110" => outpt<=MemData;
       when "0111" => outpt<=rez;
       when "1000"=> outpt<=JumpAddress;
       when "1001"=> outpt<=BranchAddress;
       when others => outpt<=rez;    
       end case;
end process;

end behavioral;
