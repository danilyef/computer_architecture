

.text
main:
	addi $t0, $0, 2  # A
	addi $t1, $0, 10 # B
	slt  $t3, $t1, $t0 # if B < A -> error
	bne $t3, $0, error
	add $t2, $0, $t1 # Sum

loop:
	beq $t0, $t1, end # if A == B -> done
	add $t2, $t2, $t0 # sum = sum + a
	addi $t0, $t0, 1 # A = A + 1
	j loop 
	
error:
	addi $t2, $0, -1 
end:
	j end