# Lab 7: Full System Integration 

This repository contains the files and instructions for Lab 7, where we assemble a MIPS processor and implement memory-mapped I/O to demonstrate a "crawling snake" program on an FPGA starter kit. Lab 7 consists of 2 parts.

## Part 1

## Goals
* Assemble the components of the MIPS processor (ALU, Memories, Control Unit).
* Implement memory-mapped I/O (MMIO) to communicate with external hardware.
* Run a simple assembly program to display a looping "snake" on the 7-segment LED display.

## File Structure
* **`top.v`**: Top-level hierarchy connecting the MIPS processor to the board I/O. **(You will modify this file in Part 2)**.
* **`MIPS.v`**: The main processor module. **(You will modify this file in Part 1)**.
* **`DataMemory.v` / `datamem_h.txt`**: Data memory implementation and its initial hexadecimal content.
* **`InstructionMemory.v` / `insmem_h.txt`**: Instruction ROM containing the program op-codes.
* **`RegisterFile.v` / `reg_half.v`**: Register file implementation.
* **`ALU.v`**: The Arithmetic Logic Unit (from Lab 5).
* **`ControlUnit.v`**: Instruction decoding and control signal generation.
* **`clockdiv.v`**: Divides the board clock down to the 10 MHz internal clock.
* **`snake_patterns.asm`**: Assembly program that implements the crawling snake pattern.
* **`sim/`**: Icarus Verilog testbenches — run `./sim/run.sh` to simulate without hardware (`snake`/`aluctrl` for Part 1, `top` for Part 2).

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
2. Run `./sim/run.sh` (see `sim/`). You should observe the 12 display patterns written to I/O address `0x0` in a repeating cycle — the crawling snake as it would appear across the four digits of the 7-segment display.

## Part 2

## Goals
* Extend the top-level hierarchy to read two switch inputs and pass them to the processor.
* Modify the assembly program (`snake_patterns.asm`) to read the 2-bit switch value and adjust the speed of the crawling snake.
* Optionally, change the snake's crawling pattern or toggle its direction.

## Instructions

### Step 1: Extend the Memory-Mapped I/O
Part 1 used MMIO to drive the display; Part 2 adds an input register, so the I/O map becomes:
* **`0x00007FF0`**: (output, 28 bits) Value sent to the 7-segment display.
* **`0x00007FF4`**: (input, 2 bits) Speed step value (0, 1, 2 or 3) read from the switches.

In `top.v`, create a 2-bit input signal for the switches and drive the 32-bit `IOReadData` from it depending on the `IOAddr` value. Only the 2 least significant bits of `IOReadData` carry the switch state.

### Step 2: Modify the Assembly Program
Update `snake_patterns.asm` so the delay loop threshold depends on the switch value.
1. Read the 2-bit value from `0x00007FF4` with `lw`, then scale the loop counter from it so the snake moves faster or slower.


### Step 3: Verify in Simulation
1. Run `./sim/run.sh top` to exercise `top.v` including the `SWITCH` input, and `./sim/run.sh` to re-check everything against the new memory dumps.
2. Compare the reported display-update interval across `+switch=0` through `+switch=3`. Until the assembly reads `0x7FF4` the interval must stay the same; once Step 2 is done it must change with the switch value.
