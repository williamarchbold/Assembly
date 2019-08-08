#****************************
# William Archbold
# May 3 2019
# CSC 225 Computer Architecture Assembly Language
#****************************

#----------------------------------------------------------------------------------------------------
# Final Project
# This program accepts a one-line string (max of 100 characters) from the keyboard, removes all the 
# white space, digits, punctuation, and other special characters and prints out the result with only 
# the letters. The program also prints out a frequency table of how often each letter was used. 
#----------------------------------------------------------------------------------------------------

	.data
msg:	.asciiz "Enter a string: "
newln:	.asciiz "\n"
buffer: .space 102 #allows us to keep 101 chars plus 1 null. a buffer is an uninitialized array
	.align 2			# 2^2=4 alignment
WORD:	.space 26*4
title:	.asciiz "Letter Frequency Table\n"

	.text
	.globl main

main:	addi $sp, $sp, -16		# create 16 bytes of stack space. 12 for the 3 integers and 4 for return address 
	sw $ra, 0($sp)			# store mains return address
	sw $s0, 4($sp)			# store caller's local variable s0 to not wipe out someone elses s0
	sw $s1, 8($sp)			# store caller's local variable s1 to not wipe out someone elses s1	
	sw $s2, 12($sp)			# store caller's local variable s2 to not wipe out someone elses s2

restart:

	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label msg
	
	li $v0, 8			# system call code read string
	la $a0, buffer			# load address of buffer into a0
	li $a1, 101			# load immidate 101 value into a1 because a0 pointer won't know how large buffer is. a1 is always numb of chars to read+1
	syscall				# read the string and returns in v0

	la $a0, buffer
	lbu $t0, 0($a0)	
	li $t1, 10			# newline char
	beq $t0, $t1, exit		# if newline char go to exit 
	beq $t0, $zero, exit		# if null char go to exit

					# clear the whole array so the counts go back to zero

	la $t0, WORD			# load address of WORD into t0
	li $t1, 26			# load immediate 26, which is the number of letters in alphabet, into t1

initLoop:
	sw $zero, 0($t0)		# store zero in zeroeth index of WORD or clearing the element within the array
	addi $t0, $t0, 4		# increment the pointer by 1 element (4 bytes)
	addi $t1, $t1, -1		# decrement the loop counter
	bne $t1, $zero, initLoop	# if loop counter doesn't equal zero than go back to beginning of initLoop

					# main loop: look at each character and compress and/or count it

	la $a0, buffer			# a0 is the source (read from source) pointer set to buffer address
	add $a1, $a0, $zero		# a1 is the target (write to target) pointer set to buffer address
loop:	lbu $t0, 0($a0)			# t0 will be the byte value of current char. using lbu rather than lb because chars are positive
	addi $a0, $a0, 1		# increment a0 1 byte to move the pointer
	beq $t0, $zero, done		# this will be the end of the loop when $t0 pointer reaches null char (8bits) and branches to done
	sltiu $t1, $t0, 65		# compare current char with ASCII value 65, which is 'A'
	bne $t1, $zero, loop		# if current chars' value < 65 then it's not a letter so we go back in the loop 
	sltiu $t1, $t0, 123		# compare current char with ASCII value 123, which is '{' aka z+1
	beq $t1, $zero, loop		# if current chars' value is >= 123 then it's not a letter so we go back in loop
	sltiu $t1, $t0, 91		# if current char is < Z+1  
	bne $t1, $zero, countUpper	# if above returns true then we want to keep the char (Uppercase char) 
	sltiu $t1, $t0, 97		# and if current char is < a
	bne $t1, $zero, loop		# then we reject it and go back to loop

	addi $t2, $t0, -97		# upper case character, subtract 'a' to put letter index into $t2

keep:	
	la $t3, WORD			# load a pointer to the base of the WORD array
	sll $t2, $t2, 2			# multiply letter index by size of a word 
	add $t3, $t3, $t2		# put together the pointer (address of WORD) and the letter offset to the count of the right letter
	lw $t2, 0($t3)			# fetch count of current letter at the pointer in t3 into t2
	addi $t2, $t2, 1		# increment the count of current letter by 1
	sw $t2, 0($t3)			# store the count of current letter back into the pointer in t3

	sb $t0, 0($a1)			# store current char in target pointer array
	addi $a1, $a1, 1		# increment target pointer by 1 byte
	j loop				# go back to loop 

countUpper:
	addi $t2, $t0, -65		# lowercase characater, subtract 'A', to put letter index into $t2
	j keep

done:	sb $zero, 0($a1)		# force to memory a null terminating character at last location where target pointer is pointing to
	
	li $v0, 4			# load the print string code
	la $a0, buffer			# a0 is the address of the string
	syscall				# print string associated with data label buffer	

	li $v0, 4			# load the print string code
	la $a0, newln			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label newln	
 
	li $v0, 4			# syscall 4 (print_str)
	la $a0, title			# a0 is the address of the string
	syscall				# print string associated with data label buffer

					# print first row of counts

	la $s0, WORD			# initialize pointer starting with first element of WORD array. setting up loop
	li $s1, 13			# initilize loop counter with value 13

row1Loop:				# this will print the counts for the first row presented to the user
	lw $a0, 0($s0)			# loading count element pointed to by pointer at 0 of s0

	li $v0, 1			# load 1 into v0, which is the print integer function code
	syscall				# print integer

	li $v0, 11			# print single character function code
	li $a0, 32			# ascii space
	syscall				# print the space char

	addi $s0, $s0, 4		# increment the pointer to go to next element of the array
	addi $s1, $s1, -1		# decrement the loop counter by one
	bne $s1, $zero, row1Loop	# if counter is not zero go back to beginning of row1Loop

	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, newln			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label newln	

					# start second row, don't reinitialize s0, it points to the second row already
	li $s1, 13			# initilize loop counter with value 13

row2Loop:	
	lw $a0, 0($s0)			# load count from pointer to next element of array

	li $v0, 1			# function code 1 is print integer
	syscall				# print the integer

	li $v0, 11			# print the single character function code
	li $a0, 32			# ascii space
	syscall				# print the space char

	addi $s0, $s0, 4		# increment the pointer to go to next element of the array	
	addi $s1, $s1, -1		# decrement the loop counter by one
	bne $s1, $zero, row2Loop	# if counter is not zero go back to beginning of row1Loop


	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, newln			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label newln	

	j restart			# go back through loop

exit: 
	lw $ra, 0($sp)			# store mains return address
	lw $s0, 4($sp)			# restore caller's local variable s0 to not wipe out someone elses s0
	lw $s1, 8($sp)			# restore caller's local variable s1 to not wipe out someone elses s1	
	lw $s2, 12($sp)			# restore caller's local variable s2 to not wipe out someone elses s2
	addi $sp, $sp, 16		# remove 16 bytes of stack space. 12 for the 3 integers and 4 for return address

	jr $ra
	

	