### Theoretical part: Converting a Binary Number to 7-Segment Display Encoding 

Fill in the truth table below to map the 4-bit binary inputs (S3-S0) to the corresponding 7-segment outputs (a-g) for hexadecimal characters 0 through F.

**Active-Low Logic Reminder:**
* Output **`0`** = Segment **GLOWS** 
* Output **`1`** = Segment **OFF** 

*(Example: To display "0", all segments except "g" must glow.)*


| Display | S3 | S2 | S1 | S0 | a | b | c | d | e | f | g |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **0** | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| **1** | 0 | 0 | 0 | 1 | 1 | 0 | 0 | 1 | 1 | 1 | 1 |
| **2** | 0 | 0 | 1 | 0 | 0 | 0 | 1 | 0 | 0 | 1 | 0 |
| **3** | 0 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 1 | 1 | 0 |
| **4** | 0 | 1 | 0 | 0 | 1 | 0 | 0 | 1 | 1 | 0 | 0 |
| **5** | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 0 | 1 | 0 | 0 |
| **6** | 0 | 1 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| **7** | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 1 | 1 | 1 | 1 |
| **8** | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| **9** | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| **A** | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| **B** | 1 | 0 | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 |
| **C** | 1 | 1 | 0 | 0 | 0 | 1 | 1 | 0 | 0 | 0 | 1 |
| **D** | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 1 | 0 |
| **E** | 1 | 1 | 1 | 0 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
| **F** | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 1 | 0 | 0 | 0 |



### Equations:

A  = nS_3 * nS_2 * nS_1 * S_0 + nS_3 * S_2 * nS_1 * nS_0 + S_3 * nS_2 * S_1 * S_0 + S_3 *S_2 * nS_1 * S_0 
= nS_3 * nS_1 * (nS_2 * S_0 + S_2 * nS_0) + S_3 * S_0 * (nS_2 * S_1 + S_2 * nS_1)
=   nS_3 * nS_1 * (S_0 ⊕ S_2)  +  S_3 * S_0 *  (S_2 ⊕ S_1)


B = nS_3 * S_2 * nS_1 * S_0 + nS_3 * S_2 * S_1 * nS_0 + S_3 * nS_2 * S_1 * S_0 + S_3 * S_2 * nS_1 * nS_0 + S_3 * S_2 * S_1 * nS_0 + S_3 * S_2 * S_1 * S_0
= nS_3 * S_2  *  (S_1 ⊕ S_0) + S_3 * (S_1 * S_0 + S_2  * nS_0 ) 


C = nS_3 * nS_2 * S_1 * nS_0 + S_3 * S_2 * nS_1 * nS_0  + S_3 * S_2 * S_1 * nS_0  + S_3 * S_2 * S_1 * S_0 
= S_1 * nS_0 * (nS_3 * nS_2 + S_3 * S_2) + S_3 * S_2  * ( nS_1 * nS_0  + * S_1 * S_0)
= S_1 * nS_0 * (S_3 XNOR S_2) + S_3 * S_2  * (S_1 XNOR S_0)


D =  nS_3 * nS_2 * nS_1 * S_0 + nS_3 * S_2 * nS_1 * nS_0  + nS_3 * S_2 * S_1 * S_0  + S_3 * nS_2 * S_1 * nS_0 + S_3 * S_2 * S_1 * S_0 
=  nS_3 * nS_1 * (S_2 ⊕ S_0) + S_3 * S_1 * (S_2 xnor S_0) + nS_3 * S_2 * S_1 * S_0

let Y = S_2 xnor S_0, then nY = S_2 ⊕ S_0

=  nS_3 * nS_1 * nY + S_3 * S_1 * Y + nS_3 * S_2 * S_1 * S_0
= (S_3 xnor S_1) * (S_1 xnor Y) + nS_3 * S_2 * S_1 * S_0
= (S_3 xnor S_1) * (S_1 xnor S_2 xnor S_0) + nS_3 * S_2 * S_1 * S_0

E = nS_3 * nS_2 * nS_1 * S_0 + nS_3 * nS_2 * S_1 * S_0 + nS_3 * S_2 * nS_1 * nS_0 + nS_3 * S_2 * nS_1 * S_0 + nS_3 * S_2 * S_1 * S_0 + S_3 * nS_2 * nS_1 * S_0 
=  nS_3 * nS_2 * S_0 + nS_3 * S_2 * nS_1 + nS_3 * S_2 * S_1 * S_0 + S_3 * nS_2 * nS_1 * S_0 
= nS_2 * S_0 * (nS_3 + S_3 * nS_1) + nS_3 * S_2 * (nS_1 + S_1 * S_0)
= nS_2 * S_0 * (nS_3 + nS_1) + nS_3 * S_2 * (nS_1 + S_0)
= nS_2 * S_0 * nS_3 + nS_2 * S_0 * nS_1 + nS_3 * S_2 * nS_1 +  nS_3 * S_2 * S_0
= nS_3 * S_0 + nS_2 * S_0 * nS_1 + nS_3 * S_2 * nS_1


F = nS_3 * nS_2 * nS_1 * S_0 + nS_3 * nS_2 * S_1 * nS_0 + nS_3 * nS_2 * S_1 * S_0 + nS_3 * S_2 * S_1 * S_0 + S_3 * S_2 * nS_1 * S_0 
=  nS_3 * nS_2 * (S_1 ⊕ S_0 + S_1 * S_0) + S_2 * S_0 * (S_3 ⊕ S_1)
=  nS_3 * nS_2 * ( S_1 + S_0) + S_2 * S_0 * (S_3 ⊕ S_1)


G = nS_3 * nS_2 * nS_1 * nS_0  + nS_3 * nS_2 * nS_1 * S_0 + nS_3 * S_2 * S_1 * S_0 + S_3 * S_2 * nS_1 * nS_0 
= nS_3 * nS_2 * nS_1 + S_2 * (nS_3 * S_1 * S_0 + S_3 * nS_1 * nS_0)


nS_3 * nS_2 * nS_1 * nS_0 