#****************************
# William Archbold 
# March 20 2019
# CSC 225 Computer Architecture and Assembly Language
#****************************

#----------------------------------------------------------------------------------------------------
# Homework 5 part 1
# Write a program that uses a function to determine whether a number is prime. Prompt the user for an 
# integer and output whether the integer is prime. Continue prompting the user for a new number until 
# a negative one(-1) is entered.
#----------------------------------------------------------------------------------------------------

	.data
msg:	.asciiz "Enter an integer: "
msg2:	.asciiz "The number is prime\n"
msg3:	.asciiz	"The number is not prime\n"

	
	
	.text
	.globl main

main:					# this program does not handle negative integers and zero
prompt:	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label msg

	li $v0, 5			# system call code read integer
	syscall				# read the integer and returns in v0

	li $t0, -1			#load -1 into t0 so we can check if user input is negative -1
	beq $v0, $t0, quit		#if user input = -1 then goto quit

	li $t0, 1			#check if user input is 1 so we don't need to enter loop
	beq $v0, $t0, yes		#if user input = 1 then go to yes and print prime status

	li $t0, 2			#check if user input is 2 so we don't need to enter loop
	beq $v0, $t0, yes		#if user input = 2 then go to yes and print prime status

loop:	div $v0, $t0			#divide user input by counter to check for remainder
	mfhi $t1			#assign remainder value from the above division command to t1 register
	beq $t1, $0, no			#if the remainder equals 0 then branch to no
	addi $t0, $t0, 1		#increment loop counter by 1 
	bne $v0, $t0, loop		#stop the loop if the the counter reaches the users input and go to yes
	
	
	
	

yes:	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg2			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label msg2
	j prompt

no:	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg3			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label msg3
	j prompt






quit:	jr $ra		