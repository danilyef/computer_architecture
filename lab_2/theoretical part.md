# Theoretical Part: 1-Bit Full Adder

A full adder sums three 1-bit inputs — operand **A**, operand **B**, and carry-in **CI** — producing a sum bit **S** and a carry-out **CO**.

---

## Task 1: Truth Table

| CI | B | A | CO | S |
|:--:|:-:|:-:|:--:|:-:|
|  0 | 0 | 0 |  0 | 0 |
|  0 | 0 | 1 |  0 | 1 |
|  0 | 1 | 0 |  0 | 1 |
|  0 | 1 | 1 |  1 | 0 |
|  1 | 0 | 0 |  0 | 1 |
|  1 | 0 | 1 |  1 | 0 |
|  1 | 1 | 0 |  1 | 0 |
|  1 | 1 | 1 |  1 | 1 |

---

## Task 2: Boolean Equations

Notation: `·` = AND, `+` = OR, `'` = NOT, `⊕` = XOR.

### Carry-Out (CO)

Starting from the minterms where CO = 1:

```
CO = A·B·CI' + A·B'·CI + A'·B·CI + A·B·CI
   = A·B·(CI' + CI) + CI·(A·B' + A'·B)
   = A·B + CI·(A ⊕ B)
```

### Sum (S)

Starting from the minterms where S = 1:

```
S = A·B·CI + A·B'·CI' + A'·B·CI' + A'·B'·CI
  = A·(B·CI + B'·CI') + A'·(B·CI' + B'·CI)
  = A·(B XNOR CI)     + A'·(B ⊕ CI)

Let Y = B ⊕ CI  →  B XNOR CI = Y'

  = A·Y' + A'·Y
  = A ⊕ Y
  = A ⊕ B ⊕ CI
```

### Final Equations

| Output | Equation |
|--------|----------|
| **CO** | `A·B + CI·(A ⊕ B)` |
| **S**  | `A ⊕ B ⊕ CI`       |
