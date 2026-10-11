MIPS 32-bit Single-Cycle Processor

A VHDL implementation of a 32-bit MIPS processor, structured on a single-cycle architecture.
This project demonstrates fundamental datapath and control unit design while extending the standard
instruction set with bitwise logical operations and custom conditional branching.   
(For complete technical details, datapath schematics, and machine code formats,
please refer to the documentatie (1).docx and schematic.pdf files included in this repository).

Features:
Single-Cycle Architecture: Unlike pipelined designs, every instruction is fetched,
                           decoded, and completely executed in a single clock cycle,
                           eliminating data and control hazards.  
Extended Instruction Set (Custom Instructions)
Hardware Validation: The project was not only validated in the software simulator but also
                     successfully synthesized and tested directly on a physical FPGA board.
