.data
source: .asciiz "Hello"
destination: .space 6

.text
main:
	la $s1, source 
	la $s2, destination
	addi $s3, $0, 6 # how many bytes to copy

while:
	beq $0, $s3, result # when to exit while loop
	
	lb $t4, 0($s1) # load byte from source
	sb $t4, 0($s2) # save byte to destination
	
	addi $s1, $s1, 1 # new source address
	addi $s2, $s2, 1 # new destination adress 
	addi $s3, $s3, -1 # one less byte to copy
	
	j while
	
	
result:
	li $v0, 10
	syscall
	



	

