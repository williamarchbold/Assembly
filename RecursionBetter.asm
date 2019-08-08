#****************************
# William Archbold
# February 21 2019
# CSC 225 Computer Architecture Assembly Language
#****************************

#----------------------------------------------------------------------------------------------------
# Homework 3 
# Using SPIM, implement a recursive function to calculate the factorial of a number. Allow the user 
# to enter a number and print the factorial.
#----------------------------------------------------------------------------------------------------

		.data
msg:	.asciiz	"Enter integer: "		#.asciiz tells assembler to write a c style string with null termination
msg2:	.asciiz	"The factorial value is: "	
msg3:	.asciiz "\n"

	.text
	.globl main

main:	
	addi $sp, $sp, -8		# create 8 bytes of stack space
	sw $ra, 0($sp)			# store mains return address on stack so we can do jal to f
	sw $s0, 4($sp)			# store caller's local variable s0 so we can use s0 it in function
	
	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg			# argument: string
	syscall				# print the string
	
	li $v0, 5			# system call code read integer
	syscall				# read the integer and returns in v0
	
	add $a0, $zero, $v0		# call method f returns factorial in $v0
	jal f
	add $s0, $zero, $v0		# preserve f return value				
	
	li $v0, 4
	la $a0, msg2
	syscall
	
	li $v0, 1			# system call code print integer
	add $a0, $zero, $s0		# move f return value to a0
	syscall	

	li $v0, 4
	la $a0, msg3
	syscall
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8		#releases stack space
	jr $ra			 

f:	
	addi $sp, $sp, -8		# create 8 bytes of stack space
	sw $ra, 0($sp)			# store f return address on stack so we can do jal to f
	sw $s0, 4($sp)			# store caller's local variable s0 so we can use s0 it in function

	add $s0, $a0, $zero		# store parameter n into s0
	
	beq $a0, $zero, ret1		#if parameter n = 0 return 
	addi $a0, $a0, -1		# n -= 1
	jal f
	mul $v0, $v0, $s0		# v0 * s0 = v0; return n * fact(n-1)

	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra

ret1:	lw $ra, 0($sp)			
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	li $v0, 1			#store 1 into v0
	jr $ra
	