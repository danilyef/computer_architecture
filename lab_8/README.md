# Lab 8: Extending the ALU with Shift and Multiply

Lab 8 of the **Design of Digital Circuits** course. The goal is to speed up the assembly program from Lab 6 and then extend the ALU of the MIPS processor with three new instructions — `srl`, `multu`, and `mflo` — without disturbing the operations that already work.

---

## Goals
* Rewrite the Lab 6 assembly program so that it runs faster, and validate it in the MARS simulator.
* Extend the `ALU.v` interface with a 6-bit `aluop` and a 5-bit shift amount.
* Implement a right shift, an unsigned multiplication with an internal `Lo` register, and a move-from-`Lo` operation.
* Verify the modified processor with the provided testbench.

## File Structure
* **`ALU.v`**: The Arithmetic Logic Unit from Lab 5. **(You will modify this file in Task 2)**.
* **`MIPS.v`**: The processor from the previous lab. The debugging outputs `DATA` and `ADDRESS` have been added to make waveform inspection easier.
* **`MIPS_test.v`**: Testbench that clocks the processor and exposes its `result` output.
* **`ControlUnit.v`**: Instruction decoding. `ALUControl` is already 6 bits wide and forwards the `Funct` field for R-type instructions.
* **`DataMemory.v` / `datamem_h.txt`**: Data memory implementation and its initial hexadecimal content.
* **`InstructionMemory.v` / `insmem_h.txt`**: Instruction ROM containing the program op-codes.
* **`RegisterFile.v` / `reg_half_synthmodel.v`**: Register file implementation.
* **`MIPS.ucf`**: Pin constraints for the FPGA starter kit.
* **`lab_9.xpr`**: The provided Vivado project (from `Lab9_student.zip` on the course website).

---

## Task 1: A Faster Assembly Program

Use the MARS simulator to write a faster version of the program from Lab 6.

* Make sure the code stays functional by testing it with smaller values first — a full-speed delay loop takes far too long to observe in a simulator.
* If you run into problems with MARS or with the assembly syntax, refer back to Lab 7.

---

## Task 2: Modify the Processor

Download `Lab9_student.zip` from the course website. It contains a Vivado project with the processor from the previous lab (`MIPS.v`), a testbench (`MIPS_test.v`), and the `ALU.v` you have to modify.

### New ALU operations

| aluop | Mnemonic | Behavior |
| :--- | :--- | :--- |
| `000010` | srl | Shift `b` right by `ShAmt` bits and drive the result |
| `011001` | multu | Multiply `a` by `b` and store the product in the internal register `Lo` |
| `010010` | mflo | Copy the present value of `Lo` to the output |

### Requirements

1. The ALU accepts a **6-bit `aluop`** signal instead of the current 4-bit one.
2. The ALU accepts a **5-bit `ShAmt`** (shift amount) from the MIPS.
3. When `aluop` is `6'b000010` (`srl`), input `b` is shifted right by `ShAmt` bits.
4. When `aluop` is `6'b011001` (`multu`), `a` and `b` are multiplied and the result is written to an internal 32-bit register `Lo`. Because this is a register, the ALU interface also needs **clock and reset** signals.
5. When `aluop` is `6'b010010` (`mflo`), the present value of `Lo` is copied to the output.

Make sure that the other instructions are **not affected**.

*Note:* `ControlUnit.v` already produces a 6-bit `ALUControl`, but `MIPS.v` currently passes only `ALUControl[3:0]` to the ALU. The shift amount comes from the `Funct`-adjacent field of the instruction word, so the top-level connections in `MIPS.v` have to be widened and extended along with the ALU itself.

---

## Verification

Run the testbench and confirm that the three new operations behave as specified and that the arithmetic, logic, and `slt` results from Lab 5 are unchanged.
