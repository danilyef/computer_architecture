# LAB 5: Implementing an ALU

## Overview
The primary goal of this lab is to design and implement a 32-bit Arithmetic Logic Unit (ALU) in Verilog. Additionally, this lab introduces how to evaluate a circuit's speed (maximum operational frequency) and area (FPGA resource utilization) within Vivado. You will reuse this ALU as a core component for a small micro-controller built in subsequent exercises. 

## System Specifications
- **Inputs:** Two 32-bit inputs, `A` and `B`, and a 4-bit control signal, `AluOp`.
- **Outputs:** A 32-bit `Result` and an additional 1-bit `Zero` flag. The `Zero` flag must be set to 'logic-1' if all bits of the `Result` are 0.
- **Behavior:** The ALU must execute seven distinct instructions based on the `AluOp` control signal.
  
**ALU Control Table:**

| AluOp | Mnemonic | Result | Description |
| :--- | :--- | :--- | :--- |
| 0000 | add | A + B | Addition |
| 0010 | sub | A - B | Subtraction |
| 0100 | and | A and B | Bitwise AND |
| 0101 | or | A or B | Bitwise OR |
| 0110 | xor | A xor B | Bitwise XOR |
| 0111 | nor | A nor B | Bitwise NOR |
| 1010 | slt | (A < B) [31] | Set on Less Than |
| Others| | Don't Care | |

*Note 1:* The bitwise operations are `and`, `or`, `xor`, and `nor`. 
*Note 2:* You must extend the result of the `slt` instruction to 32 bits (i.e., 32'b00 or 32'b01).
*Note 3:* Values of `AluOp` not listed in the table do not correspond to any specific operation; the circuit's behavior for these states does not matter as the `Result` will be ignored. You can use this "don't care" condition to simplify your circuit.

## Required Tasks

### Part 1: Designing the Block Diagram
- **Draw the Diagram:** On paper, draw a block-level diagram of the ALU that implements the operations listed in the control table. 
- **Components:** You are free to use arbitrary size adders, multiplexers, logic gates, zero/sign extenders, comparators, and shifters to build your design.
- **Suggested Strategy:** Consider analyzing the `AluOp` bits to split the design into an *Arithmetic Part* (for `add`, `sub`, `slt`) and a *Logic Part* (for bitwise operations). For example, `AluOp[2]` can be used to control a multiplexer that selects between the arithmetic and logic outputs. 

### Part 2: Verilog Implementation & Analysis
- **Implementation:** Replace each block of your diagram with its Verilog description and use consistent signal names. Synthesize and implement your design. 
- **Written Calculation:** Exhaustive testing of this circuit is practically impossible due to the large number of input bits. Calculate exactly how long it would take to test the ALU exhaustively, assuming you can test 1 input combination every second. 
