# Lab 3: Verilog for Combinational Circuits

Lab 3 of the **Design of Digital Circuits** course. The goal is to design and implement a 7-segment display decoder and integrate it with a ripple-carry adder from the previous lab.

---

## Files

| File | Description |
|------|-------------|
| [exercise_1.v](exercise_1.v) | `Decoder` module + standalone testbench |
| [exercise_2.v](exercise_2.v) | `DisplayNumber` top-level module + visual testbench |
| [theoretical part.md](theoretical%20part.md) | Truth table and Boolean equations for all 7 segments |

---

## Exercise 1: 7-Segment Decoder

Implements a `Decoder` module that converts a **4-bit binary input** (hex 0–F) into **7 active-low control signals** for a 7-segment display.

```
module Decoder(input [3:0] a, output reg [6:0] s)
```

- **Input:** `a[3:0]` — 4-bit value (0x0–0xF)
- **Output:** `s[6:0]` — segment signals ordered `[g][f][e][d][c][b][a]`
- **Active-low:** a segment is ON when the corresponding bit is `0`
- Implemented with a behavioral `always @(*) case` block covering all 16 hex values; default case turns all segments off (`7'b1111111`)

The testbench (`tb_BinaryToDisplay`) loops through all 16 inputs and prints each result as a binary pattern.

---

## Exercise 2: Adder + Decoder Integration

Builds on Exercise 1 and Lab 2 by wiring a `FourBitAdder` and `Decoder` together into a `DisplayNumber` top-level module.

```
module DisplayNumber(input [3:0] a, input [3:0] b, output [6:0] s1, output s2)
```

- **Inputs:** two 4-bit operands `a` and `b`
- **Output `s1[6:0]`:** 7-segment encoding of the lower 4 bits of the sum
- **Output `s2`:** overflow/carry-out bit (the 5th bit of the sum); driven high when the result exceeds 15

### Module hierarchy

```
DisplayNumber
├── FourBitAdder   (ripple-carry, reused from Lab 2)
│   └── FullAdder  (×4, gate-level: AND/XOR/OR primitives)
└── Decoder        (behavioral case statement)
```

### Testbench

`tb_DisplayNumber` runs four test vectors and draws an ASCII 7-segment display for each result:

| Test | a | b | Sum | s1 (display) | s2 (overflow) |
|------|---|---|-----|--------------|---------------|
| 1 | 2 | 3 | 5 | `5` | OFF |
| 2 | 7 | 5 | 12 | `C` | OFF |
| 3 | 8 | 8 | 16 | `0` | ON |
| 4 | 15 | 15 | 30 | `E` | ON |

---

## Theoretical Part

The [theoretical part](theoretical%20part.md) derives the Boolean equations for each of the 7 segments (a–g) from the truth table using algebraic minimization (factoring and XOR/XNOR identities). These equations document the logic underlying the `case` implementation.
