#****************************
# William Archbold
# April 5 2019
# CSC 225 Computer Architecture Assembly Language
#****************************

#----------------------------------------------------------------------------------------------------
# Project 1
# Write a program that allows the user to accomplish the following:  
# 1. Enter and print 3 integers 
# 2. Compute the sum, product and average of the three integers
# 3. Determine and print the smallest of the three integers
# 4. Determine and print the largest of the three integers
#----------------------------------------------------------------------------------------------------
	
	.data
msg:	.asciiz "Enter integer 1: "
msg2:	.asciiz "Enter integer 2: "
msg3:	.asciiz	"Enter integer 3: "
msg4:	.asciiz "The 3 integers: "
msg5:	.asciiz	"\nThe sum: "
msg6:	.asciiz "\nThe product: "
msg7:	.asciiz "\nThe average: "
msg8:   .asciiz "\nThe smallest: "
msg9:	.asciiz "\nThe largest: "
newln:	.asciiz "\n"
comma:	.asciiz ", "

	.text
	.globl main

main:	addi $sp, $sp, -16		# create 16 bytes of stack space. 12 for the 3 integers and 4 for return address 
	sw $ra, 0($sp)			# store mains return address
	sw $s0, 4($sp)			# store caller's local variable s0 to not wipe out someone elses s0
	sw $s1, 8($sp)			# store caller's local variable s1 to not wipe out someone elses s1	
	sw $s2, 12($sp)			# store caller's local variable s2 to not wipe out someone elses s2

	li $v0, 4			# load immediate syscall 4, which is print_str # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label msg "Enter integer 1: "
	
	li $v0, 5			# system call code read integer
	syscall				# read the integer and return integer v0

	addi $s0, $v0, 0		# store v0, the first user's integer, into s0

	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg2			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label msg2 "Enter integer 2: "
	
	li $v0, 5			# system call code read integer
	syscall				# read the integer and returns in v0

	addi $s1, $v0, 0		# store v0, the second integer, into s1

	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg3			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label msg3 "Enter integer 3: "
	
	li $v0, 5			# system call code read integer
	syscall				# read the integer and returns in v0

	addi $s2, $v0, 0		# store v0, the third integer, into s2

	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg4			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label msg4 "The three integers: "

	li $v0, 1			# system call code print integer
	add $a0, $zero, $s0		# move s0, first integer, into a0 for printing
	syscall				# print integer associated with value in register s0

	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, comma			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label comma

	li $v0, 1			# system call code print integer
	add $a0, $zero, $s1		# move s1, second integer, into a0 for printing
	syscall				# print integer associated with value in register s1

	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, comma			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label comma

	li $v0, 1			# system call code print integer
	add $a0, $zero, $s2		# move s3, third integer, into a0 for printing
	syscall				# print integer associated with value in register s2

	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg5			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label msg5 "The sum: "

	li $v0, 1			# system call code print integer
	add $a0, $s0, $s1		# a0 = s0 + s1;
	add $a0, $a0, $s2		# ao += s2;
	syscall				# print integer associated with value in register a0

	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg6			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label msg6 "The product: "

	
	li $v0, 1			# system call code print integer
	mul $a0, $s0, $s1		# a0 = s0 * s1;
	mul $a0, $a0, $s2		# ao = a0 * a2;
	syscall				# print integer associated with value in register a0

	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg7			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label msg7

	li $v0, 1			# system call code print integer
	add $a0, $s0, $s1		# a0 = s0 + s1;
	add $a0, $a0, $s2		# ao += s2;
	addi $t0, $zero, 3		# no divide immediate command so need to store immediate into a register
	div $a0, $a0, $t0		# divide a0 source by second source t0, value 3, and result is stored in destination a0	
	syscall				# print integer associated with value in register a0	

	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg8			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label msg8	

	li $v0, 1			# system call code print integer
	add $a0, $s0, $zero		# assume smallest is first integer
	slt $t0, $s0, $s1		# if s0 is less than s1 set t0 to 1 otherwise set to 0
	bne $t0, $zero, skip1		# if t0 = 0 i.e. s0 is greater than s1 then go to next line otherwise goto skip1
	add $a0, $s1, $zero		# s1 is smaller than s0 so set s1 as smallest 
skip1:	slt $t0, $a0, $s2		# if a0 is less than s2 set t0 to 1 otherwise set to 0
	bne $t0, $zero, skip2		# if t0 = 0 i.e. a0 is greater than s2 then go to next line otherwise goto skip2
	add $a0, $s2, $zero		# capture fact that s2 is smallest 
skip2:  syscall				# print integer associated with value in register a0, which will be smallest integer

	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg9			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label msg9	

	li $v0, 1			# system call code print integer
	add $a0, $s0, $zero		# assume largest is first integer
	slt $t0, $s1, $s0		# if s1 is less than s2 set t0 to 1 otherwise set to 0
	bne $t0, $zero, skip3		# if t0 = 0 i.e. s1 is greater than s0 then go to next line otherwise goto skip3
	add $a0, $s1, $zero		# s0 is smaller than s1 so set s1 as largest
skip3:	slt $t0, $s2, $a0		# if s2 is less than a0 set t0 to 1 otherwise set to 0
	bne $t0, $zero, skip4		# if t0 = 0 i.e. s2 is greater than a0 then go to next line otherwise goto skip4
	add $a0, $s2, $zero		# capture fact that s2 is largest
skip4:  syscall				# print integer associated with value in register a0, which will be largest integer	

	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, newln			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label newln
 
	lw $ra, 0($sp)			# store mains return address
	lw $s0, 4($sp)			# restore caller's local variable s0 to not wipe out someone elses s0
	lw $s1, 8($sp)			# restore caller's local variable s1 to not wipe out someone elses s1	
	lw $s2, 12($sp)			# restore caller's local variable s2 to not wipe out someone elses s2
	addi $sp, $sp, 16		# remove 16 bytes of stack space. 12 for the 3 integers and 4 for return address

	jr $ra					#jump register or go back to calling return address 
	

	