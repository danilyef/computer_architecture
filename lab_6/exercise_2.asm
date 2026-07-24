.text
main:
	# array left base adress
	lui $s0, 0x0000
	ori $s0, $s0, 0x0000
	
	# array right base adress
	lui $s1, 0x0000
	ori $s1, $s1, 0x0024
	
	# sad array base adress
	lui $s2, 0x0000
	ori $s2, $s2, 0x0048
	
	# image size
	addi $s3, $0, 9
	
	# load left array
	addi $t0, $0, 10
	sw $t0, 0($s0)
			
	addi $t0, $0, 20
	sw $t0, 4($s0)
	
	addi $t0, $0, 30
	sw $t0, 8($s0)
	
	addi $t0, $0, 40
	sw $t0, 12($s0)
	
	addi $t0, $0, 50
	sw $t0, 16($s0)
	
	addi $t0, $0, 60
	sw $t0, 20($s0)

	addi $t0, $0, 70
	sw $t0, 24($s0)	
	
	addi $t0, $0, 80
	sw $t0, 28($s0)
	
	addi $t0, $0, 90
	sw $t0, 32($s0)
	
	# load right array
	addi $t0, $0, 1
	sw $t0, 0($s1)
	
	addi $t0, $0, 2
	sw $t0, 4($s1)
	
	addi $t0, $0, 3
	sw $t0, 8($s1)
	
	addi $t0, $0, 4
	sw $t0, 12($s1)
	
	addi $t0, $0, 5
	sw $t0, 16($s1)
	
	addi $t0, $0, 6
	sw $t0, 20($s1)

	addi $t0, $0, 7
	sw $t0, 24($s1)	
	
	addi $t0, $0, 8
	sw $t0, 28($s1)
	
	addi $t0, $0, 9
	sw $t0, 32($s1)
	
	# call Absolute difference
	addi $t0, $0, 0 #index i = 0
	
loop_abs_diff:
	beq $t0, $s3, main_2
	sll $t1, $t0, 2 # $t1 = i * 4 byte offset for left and right array
	
	add $t2, $s0, $t1 # Adress left_array[i]
	lw $a0, 0($t2) # $a0 = left_array[i]
	
	add $t3, $s1, $t1 # Adress right_array[i]
	lw $a1, 0($t3) # $a1 = right_array[i]
	
	jal abs_diff #call abs_diff function
	
	add $t4, $s2, $t1 # Adress sad_array[i]
	sw $v0, 0($t4) # sad_array[i] = $v0
	
	addi $t0, $t0, 1 # index = index + 1
	j loop_abs_diff
		
main_2:
	add $a0, $s2, $0 # $a0 = address of sad_array
	add $a1, $0, $s3 # $a1 = 9
	jal recursive_sum
	add $s4, $0, $v0
	j end
	
	
abs_diff:
	# Arguments:
        # $a0 = pixel_left
        # $a1 = pisel_right
	slt $t5, $a0, $a1
	beq $t5, 1, if_left_less
	#IF pixel_left > pixel_right
	sub $v0, $a0, $a1
	jr $ra

if_left_less:
	sub $v0, $a1, $a0
	jr $ra
	
	
recursive_sum:
	# $a0 - adress of sad_array[0]
	# $a1 - images size $s2
	addi $sp, $sp, -16 # make room on stack
	sw $a0, 12($sp) # store $a0 on stack
	sw $a1, 8($sp) # store $a1 on stack
	sw $ra, 4($sp) # store $ra on stack
	
	bne $a1, $0, else #if image_size != 0, go to else
	addi $v0, $0, 0 # in case image_size == 0, return 0
	addi $sp, $sp, 16 # restore $sp
	jr $ra
else:
	addi $a1, $a1, -1 # image_size = image_size - 1
	jal recursive_sum # recursive call
	
	lw $ra, 4($sp) # restore $ra
	lw $a1, 8($sp) # restore $a1
	lw $a0, 12($sp) # restore $a0 
	
	addi $t0, $a1, -1
	sll $t0, $t0, 2 #offset for the sad_array[size-1]
	add $t1, $a0, $t0 # sad_array[size-1]
	lw $t3, 0($t1) # value of sad_array[size-1]
	
	addi $sp, $sp, 16 # restore $sp
	
	add $v0, $t3 ,$v0
	jr $ra	
	
end:
	j end


# Differences are: 9, 18, 27, 36, 45, 54, 63, 72, 81
# Recursive sum: 405





