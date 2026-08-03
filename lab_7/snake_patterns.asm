
.data
pattern: .word 0x00200000,0x00004000,0x00000080,0x00000001,0x00000002,0x00000004,0x00000008,0x00000400,0x00020000,0x01000000,0x02000000,0x04000000
speeds:  .word 2000000, 1000000, 500000, 250000
   

.text      
   addi $t5,$0,48       # initialize the length of the display pattern (in bytes)
   lw $t3, 0x7ff4($0)   # read the 2-bit speed step from the switches (MMIO input)

   add $t3, $t3, $t3       
   add $t3, $t3, $t3    # because offset is in bytes -> we need * 4

   add $t3, $t5, $t3    # correct offset for the speeds
   lw $t3, 0($t3)  # load the value of the speeds

restart:   
   addi $t4,$0,0

forward:
   beq $t5,$t4, restart
   lw $t0,0($t4)
   sw  $t0, 0x7ff0($0) # send the value to the display
   
   addi $t4, $t4, 4 # increment to the next address
   addi $t2, $0, 0 # clear $t2 counter

wait:
   beq $t2,$t3,forward	
   addi  $t2, $t2, 1     # increment counter
   j wait
