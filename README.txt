Welcome to RISCV Project

The RISC-V processor is based on a "reduced instruction set computer" (RISC) architecture, which emphasizes simplicity by using a smaller set of instructions compared to more complex architectures. The 'V' in RISC-V denotes the 5th generation of this architecture. It is an open-source hardware instruction set architecture (ISA) based on the RISC principles, allowing developers to create custom hardware and software implementations.

cpu_riscv is designed to implement a basic RISC-V processor pipeline, which includes the following components:

Program Counter (PC): Increments the PC to fetch the next instruction.
Program Memory: Holds the instructions to be executed.
Instruction Decoder: Decodes the instruction and extracts fields like opcode, func3, func7, and register addresses.
Control Unit: Generates control signals like ALU opcode and load/write enable based on the opcode and function codes.
ALU: Performs arithmetic and logical operations based on the ALU opcode.
Register Set: Stores and provides operands to the ALU and writes back the results.
Pipeline Registers: Synchronizes various stages of the pipeline, holding values like ALU results and register addresses between stages.
This design is meant to simulate a simplified version of a multi-stage pipelined RISC-V processor.
