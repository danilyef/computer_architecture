.text
main:
	addi $a0, $0, 5
	jal fibonacci
	add $s3, $0, $v0
	j end
	
fibonacci: 
	addi $sp, $sp, -8 #make space on stack to save $a0 and $ra
	sw $a0, 0($sp) # save $a0 on stack
	sw $ra, 4($sp) # save $ra on stack
	
	addi $t0, $0, 1 #constant for while loop
	addi $t1, $0, 0 # a
	addi $t2, $0, 1 # b
	add $t3, $t1, $t2 # c, which must be returned
	
while: 
	ble $a0, $t0, result
	add $t3, $t1, $t2 # c, which must be returned
	add $t1, $0, $t2 # a = b
	add $t2, $0, $t3 # b = c
	sub $a0, $a0, 1 # n--
	j while
result:
	add $v0, $0, $t3
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
end:
	li $v0, 10
	syscall
	
	


	

