# Lab 2: Mapping Your Circuit to an FPGA

Lab 2 of the **Design of Digital Circuits** course. The goal is to implement combinational logic circuits in structural Verilog and map them onto an FPGA.

---

## Exercises

### Exercise 1: Decoder
Design a **2-to-4 decoder** (2 inputs, 4 outputs) using structural Verilog.

- Use primitive gate instantiations only: `and`, `or`, `not`, etc. (see slides 24–31)
- Bitwise operators (`&`, `|`, `~`) are **not allowed**

**Solution:**
```bash
iverilog -o exercise_1 exercise_1.v -s testbench1 && vvp exercise_1
```

### Exercise 2: Multiplexer
Design multiplexers using structural gate-level Verilog.

- **a)** 2:1 MUX — select one of two inputs using a single select line
- **b)** 4:1 MUX — build from multiple instances of the 2:1 MUX

**Solution:**
```bash
# 2:1 MUX
iverilog -o exercise_2 exercise_2.v -s testbench2 && vvp exercise_2

# 4:1 MUX
iverilog -o exercise_2 exercise_2.v -s testbench3 && vvp exercise_2
```

### Exercise 3: 1-Bit Full Adder
Implement a structural 1-bit full adder with carry-in and carry-out.

See [theoretical part](theoretical%20part.md) for the truth table and derived boolean equations.

```verilog
module FullAdder (input a, input b, input ci, output s, output co);
    // Implement structural logic (gates) here
endmodule
```

**Solution:**
```bash
iverilog -o exercise_3 exercise_3.v -s testbench1 && vvp exercise_3
```

### Exercise 4: 4-Bit Ripple-Carry Adder
Chain four `FullAdder` instances to build a 4-bit adder, propagating carry between stages.

**Solution:**
```bash
iverilog -o exercise_4 exercise_4.v -s testbench1 && vvp exercise_4
```
