# Exercise 1: ALU Block Diagram

Block-level diagram of the 32-bit ALU, matching the Verilog implementation in
[`exercise_2.v`](exercise_2.v). Signal names are kept identical to the code
(`final_b`, `cin`, `arithm_y`, `logic_y`, `extend_zero`).

The `AluOp` bits split the design into an **Arithmetic Part** (`add`, `sub`,
`slt`) and a **Logic Part** (`and`, `or`, `xor`, `nor`). A final multiplexer
selects the result.

## Block Diagram

```mermaid
flowchart TD
    A(["A [31:0]"])
    B(["B [31:0]"])
    OP(["AluOp [3:0]"])

    subgraph ARITH["Arithmetic Part — add / sub / slt"]
        direction TB
        INV["~B<br/>(bitwise invert)"]
        BMUX{"MUX → final_b"}
        ADD["Adder<br/>A + final_b + cin"]
        EXT["Zero-extend<br/>{31'b0, arithm_y[31]}"]
    end

    subgraph LOGICP["Logic Part — and / or / xor / nor"]
        direction TB
        LOG["Logic unit<br/>case(AluOp[1:0])"]
    end

    OUTMUX{"Output MUX<br/>case(AluOp)"}
    Y(["Result [31:0]"])

    %% ---- Arithmetic datapath ----
    B --> INV
    B --> BMUX
    INV --> BMUX
    OP -. "AluOp[1] (0=add, 1=sub/slt)" .-> BMUX
    A --> ADD
    BMUX -- final_b --> ADD
    OP -. "cin = AluOp[1]" .-> ADD
    ADD -- "arithm_y" --> OUTMUX
    ADD -- "arithm_y[31]" --> EXT
    EXT -- "extend_zero" --> OUTMUX

    %% ---- Logic datapath ----
    A --> LOG
    B --> LOG
    OP -. "AluOp[1:0]" .-> LOG
    LOG -- "logic_y" --> OUTMUX

    %% ---- Output selection ----
    OP -. "AluOp[3:0] (select)" .-> OUTMUX
    OUTMUX --> Y
```

## How the blocks map to the Verilog

| Block in diagram | Verilog module / signal | Role |
| :--- | :--- | :--- |
| `~B` + `MUX → final_b` + `cin` | `Arithmetic` (`final_b`, `cin`) | Feeds `B` for **add** or `~B` + `cin=1` (two's-complement negate) for **sub** / **slt** |
| `Adder` | `Adder` → `arithm_y` | Single shared 32-bit adder: `A + final_b + cin` |
| `Zero-extend` | `assign extend_zero = {31'b0, arithm_y[31]}` | Takes the sign bit of `A − B` and zero-extends it to the 32-bit `slt` result |
| `Logic unit` | `Logic` → `logic_y` | `case(AluOp[1:0])` → AND / OR / XOR / NOR |
| `Output MUX` | `case(AluOp)` in `ALU` → `y` | Selects `arithm_y`, `logic_y`, or `extend_zero`; unlisted opcodes → `32'bx` (don't care) |

## Control mapping

| AluOp | Operation | Selected source at Output MUX |
| :--- | :--- | :--- |
| `0000` | add | `arithm_y` (`cin=0`, `final_b=B`) |
| `0010` | sub | `arithm_y` (`cin=1`, `final_b=~B`) |
| `0100` | and | `logic_y` |
| `0101` | or  | `logic_y` |
| `0110` | xor | `logic_y` |
| `0111` | nor | `logic_y` |
| `1010` | slt | `extend_zero` |
| others | — | don't care (`32'bx`) |

