# Assembly Exercises (MIPS)

MIPS assembly exercises, written for [MARS](http://courses.missouristate.edu/kenvollmar/mars/) / SPIM.

| File | Exercise |
| --- | --- |
| `fibonacci.asm` | 1 — Fibonacci `fib(n)` |
| `rep_movsb.asm` | 2 — MIPS equivalent of x86 `REP MOVSB` |

---

## 1. Fibonacci

The Fibonacci number `F(n)` is recursively defined as

```
F(n) = F(n - 1) + F(n - 2),  where F(1) = 1 and F(2) = 1
```

So `F(3) = F(2) + F(1) = 1 + 1 = 2`, and so on.

Write the MIPS assembly for the `fib(n)` function, which computes the Fibonacci
number `F(n)`:

```c
int fib(int n)
{
    int a = 0;
    int b = 1;
    int c = a + b;
    while (n > 1) {
        c = a + b;
        a = b;
        b = c;
        n--;
    }
    return c;
}
```

### Solution — `fibonacci.asm`

Implemented as a real callable procedure: `main` puts `n` in `$a0`, calls
`jal fibonacci`, and reads the result out of `$v0`. The procedure saves `$a0`
and `$ra` on the stack and restores them before `jr $ra`.

| C variable | MIPS register |
| --- | --- |
| `n` (argument) | `$a0` |
| `a` | `$t1` |
| `b` | `$t2` |
| `c` (return value) | `$t3` → `$v0` |

The `while (n > 1)` test becomes `ble $a0, $t0, result` with `$t0 = 1`, i.e.
fall out of the loop as soon as `n <= 1`.

---

## 2. MIPS equivalent of x86 `REP MOVSB`

MIPS is a simple ISA. Complex ISAs — such as Intel's x86 — often use one
instruction to perform the function of many instructions in a simple ISA. Here
you implement the MIPS equivalent for a single Intel x86 instruction,
`REP MOVSB`, which is specified as follows.

The `REP MOVSB` instruction uses three fixed x86 registers: `ECX` (count),
`ESI` (source), and `EDI` (destination). The "repeat" (`REP`) prefix on the
instruction indicates that it will repeat `ECX` times. Each iteration, it moves
one byte from memory at address `ESI` to memory at address `EDI`, and then
increments both pointers by one. Thus, the instruction copies `ECX` bytes from
address `ESI` to address `EDI`.

**(a)** Write the corresponding assembly code in MIPS ISA that accomplishes the
same function as this instruction. You can use any general purpose register.
Indicate which MIPS registers you have chosen to correspond to the x86
registers used by `REP MOVSB`. Try to minimize code size as much as possible.

### Solution — `rep_movsb.asm`

Register mapping:

| x86 register | MIPS register | Meaning |
| --- | --- | --- |
| `ESI` | `$s1` | source address |
| `EDI` | `$s2` | destination address |
| `ECX` | `$s3` | byte count (loop counter) |

The loop body is the copy (`lb` / `sb`) plus the three pointer/counter updates:

```asm
while:
	beq  $0, $s3, result   # exit when count == 0
	lb   $t4, 0($s1)       # byte <- [ESI]
	sb   $t4, 0($s2)       # [EDI] <- byte
	addi $s1, $s1, 1       # ESI++
	addi $s2, $s2, 1       # EDI++
	addi $s3, $s3, -1      # ECX--
	j    while
result:
```

Seven instructions replace the single x86 `REP MOVSB` — a concrete example of
the CISC/RISC trade-off: x86 encodes the whole loop in two bytes, while MIPS
spells out each elementary step.

The test data in `.data` copies the 6 bytes of `"Hello"` (5 characters plus the
NUL terminator) into a 6-byte `.space` buffer.
