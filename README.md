# Multi-Cycle Pipelined RISC-V Processor

## Project Overview

This project involves designing and implementing a **multi-cycle, 5-stage pipelined RISC-V-based processor**. The processor is built following the RISC-V ISA (Instruction Set Architecture) principles, supporting core ALU operations such as **ADD, SUB, AND, OR, XOR, and NOP**. The design and simulation are verified through RTL and testbench implementations.

## Features

- **5-Stage Pipeline:** 
  - Instruction Fetch (IF)
  - Instruction Decode (ID)
  - Execute (EX)
  - Memory Access (MEM)
  - Write Back (WB)
  
- **Core ALU Operations:**
  - **ADD** (Addition)
  - **SUB** (Subtraction)
  - **AND** (Bitwise AND)
  - **OR** (Bitwise OR)
  - **XOR** (Bitwise XOR)
  - **NOP** (No Operation)

- **Instruction Set Architecture (ISA):** 
  - Follows the R-type instruction format for register-to-register operations.

## Block Components

1. **Program Counter (PC):** 
   - Holds the address of the current instruction. Increments by 1 to fetch the next instruction.  
2. **Program Memory:** 
   - Stores the instructions for the processor. Instructions are fetched during the Instruction Fetch (IF) stage.
3. **Instruction Decoder:** 
   - Decodes the fetched instruction into its opcode, func3, func7, and register addresses (RS1, RS2, RD).
4. **Control Unit:** 
   - Generates control signals based on the opcode and func fields. Determines ALU operations, register writes, and immediate data extension.
5. **ALU (Arithmetic Logic Unit):** 
   - Performs arithmetic and logic operations based on control signals.
6. **Register Set:** 
   - Contains 32 general-purpose registers. Provides access to source registers (RS1, RS2) and writes the result to the destination register (RD). 
7. **Pipeline Registers:** 
   - Stores intermediate values and control signals between pipeline stages to ensure smooth operation.

## Pipeline Stages

1. **Instruction Fetch (IF):** 
   - Fetches the instruction from program memory based on the Program Counter (PC).
2. **Instruction Decode (ID):** 
   - Decodes the fetched instruction, identifying the operation and required registers.
3. **Execute (EX):** 
   - The ALU performs the specified operation on the operands read from registers.
4. **Memory Access (MEM):** 
   - Accesses data memory for load/store instructions. (Not used in current ALU operations.)
5. **Write Back (WB):** 
   - Writes the result from the ALU back to the destination register.

## Instruction Format

The R-type instruction format is used for register-to-register operations:
- **Opcode:** Determines the operation type (e.g., `0110011` for arithmetic operations).
- **RD:** Destination register.
- **Func3 & Func7:** Further specify the ALU operation (e.g., ADD, SUB).
- **RS1 & RS2:** Source registers for the operands.

## Design Limitations

- **No Branch/Jump Handling:** The current design does not handle branch or jump instructions.
- **No Hazard Detection:** The design does not resolve data or control hazards.
- **No Halt Operation:** The PC increments indefinitely without the ability to halt execution.

## Applications

- **Embedded Systems:** Suitable for real-time applications such as IoT and automotive systems.
- **Networking Devices:** Can be used in routers and switches for efficient data processing.
- **High-Performance Computing:** Useful in parallel processing tasks.
- **Mobile Devices and Gaming Consoles:** Pipelined processors enhance performance for multitasking and graphical performance.

## Verification

- A **testbench** has been implemented to verify the correctness of ALU operations and the pipelined design.
- Results from the simulation include:
  - **Load Operation**
  - **ALU Operations**
