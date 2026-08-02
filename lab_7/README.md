# Lab 7: Full System Integration 

This repository contains the files and instructions for Lab 7, where we assemble a MIPS processor and implement memory-mapped I/O to demonstrate a "crawling snake" program on an FPGA starter kit. Lab 7 consists of 2 parts.

## Part 1

## Goals
* Assemble the components of the MIPS processor (ALU, Memories, Control Unit).
* Implement memory-mapped I/O (MMIO) to communicate with external hardware.
* Run a simple assembly program to display a looping "snake" on the 7-segment LED display.

## File Structure
* **`top.v` / `top.xdc`**: Top-level hierarchy and constraints connecting the MIPS processor to the FPGA board I/O.
* **`MIPS.v`**: The main processor module. **(You will modify this file in Part 1)**.
* **`DataMemory.v` / `datamem_h.txt`**: Data memory implementation and its initial hexadecimal content.
* **`Instruction_Memory.v` / `insmem_h.txt`**: Instruction ROM containing the program op-codes.
* **`RegisterFile.v` / `reg_half.v` / `reg_half.ngc`**: Register file implementation.
* **`ALU.v`**: The Arithmetic Logic Unit (from Lab 5).
* **`Control_Unit.v`**: Instruction decoding and control signal generation.
* **`snake_patterns.asm`**: Assembly program that implements the crawling snake pattern.

## Instructions

### Step 1: Assemble the MIPS Processor
Open the `MIPS.v` file. You will need to instantiate and connect the following components using the provided block diagram (Figure 2 in the manual) as a reference:
1. **Instruction Memory**: Connect the Program Counter (PC). Remember to discard the 2 least significant bits and use bits `[7:2]` for the 64-word address.
2. **ALU**: Connect the 4-bit `Aluop` signal appropriately based on the 6-bit controller output.
3. **Data Memory**: Similar to the instruction memory, use the 6 most significant bits `[7:2]` of the address.
4. **Control Unit**: Instantiate and connect the control lines.

### Step 2: Implement Memory-Mapped I/O (MMIO)
Extend the processor to communicate with external peripherals by completing the incomplete signal assignments in `MIPS.v`.
* Assign the logic for `DataMemWrite`, `IOWriteData`, `IOAddr`, and `IOWriteEn`.
* The MMIO address range for I/O operations is `0x00007FF0` to `0x00007FFF`. 
* Address `0x00007FF0` is specifically reserved for the 28-bit output register controlling the four 7-segment LEDs.

### Step 3: Run the Crawling Snake Program
1. Ensure all components are wired correctly. The provided `snake_patterns.asm` corresponds to the hexadecimal dumps loaded into the instruction and data memories.
2. Generate the programming file (bitstream) in Xilinx Vivado.
3. Program the FPGA board.
4. You should observe a crawling snake pattern moving across the four digits of the 7-segment display.

### Optional Challenge
Change the snake's motion pattern or use a switch input to change the direction of the snake's motion. This requires modifying the assembly program and memory configurations.
