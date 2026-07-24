# Lab 6: MIPS Assembly Programming

Lab 6 of the **Design of Digital Circuits** course. The goal is to write MIPS assembly programs that exercise arithmetic, control flow, memory access, and procedure calls (including recursion with a managed stack).

---

## Files

| File | Description |
|------|-------------|
| [exercise_1.asm](exercise_1.asm) | Sum of the integer range `[A, B]` with an error path |
| [exercise_2.asm](exercise_2.asm) | Sum of Absolute Differences (SAD) over two arrays using `abs_diff` and a recursive `recursive_sum` |

---

## Exercise 1: Sum of an Integer Range

Computes the sum of all integers from `A` to `B` inclusive.

- **Inputs:** `A` (`$t0`) and `B` (`$t1`), initialized to `2` and `10`
- **Output:** the running sum in `$t2`
- **Validation:** `slt` checks that `B >= A`; if `B < A` the program branches to `error` and returns `-1` in `$t2`
- **Loop:** accumulates `sum = sum + A`, increments `A`, and terminates when `A == B`

For `A = 2`, `B = 10` the result is `54`.

---

## Exercise 2: Sum of Absolute Differences (SAD)

Compares two 9-element integer arrays element-by-element, stores the absolute differences into a third array, and then sums them recursively.

### Memory layout

| Base address | Array |
|--------------|-------|
| `0x0000` (`$s0`) | left array |
| `0x0024` (`$s1`) | right array |
| `0x0048` (`$s2`) | SAD (result) array |

The left array is loaded with `10, 20, ..., 90` and the right array with `1, 2, ..., 9`.

### Procedures

- **`abs_diff`** — takes two pixel values in `$a0`/`$a1`, uses `slt` to pick the larger operand, and returns `|$a0 - $a1|` in `$v0`.
- **`recursive_sum`** — recursively sums the SAD array. It saves `$a0`, `$a1`, and `$ra` on the stack (`$sp` adjusted by 16 bytes per frame), recurses with a decremented size, and adds `sad_array[size-1]` on the way back up. The base case (`size == 0`) returns `0`.

### Flow

1. `loop_abs_diff` walks index `i = 0..8`, loading `left[i]` and `right[i]`, calling `abs_diff`, and writing the result to `sad_array[i]`.
2. `main_2` passes the SAD array base address and size to `recursive_sum` and stores the total in `$s4`.

Differences: `9, 18, 27, 36, 45, 54, 63, 72, 81` — recursive sum = **405**.
