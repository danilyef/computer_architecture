

.text
main:
	addi $t0, $0, 2  # A
	addi $t1, $0, 10 # B

	addi $t4, $t0, -1 # A-1
	multu $t0, $t4 # A * (A-1)
	mflo $t0 # save result in the register $t0
	
	addi $t4, $t1, 1 # B+1
	multu $t1, $t4 # B * (B+1)
	mflo $t1 # save result in the register $t1
	
	sub $t2, $t1, $t0 #  B * (B+1) - A * (A-1)
	srl $t2, $t2, 1   # divide by 2