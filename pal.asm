#****************************
# William Archbold
# April 5 2019
# CSC 225 Computer Architecture Assembly Language
#****************************

#----------------------------------------------------------------------------------------------------
# Homework 5 part 2
# Write a program that prompts the user to enter a word and use a function to 
# determine whether the word is a palindrome. Continue prompting for words until
# the user presses "enter" without any text input(null).
#----------------------------------------------------------------------------------------------------
	
	.data
msg:	.asciiz "Enter a string: "
msg2:	.asciiz "String is a palindrome\n"
msg3:	.asciiz	"String is not a palindrome\n"
buffer:	.space 1001	#this is a pseudo instruction to tell encoder to reserve 1001 bytes of space. extra 1 is to match with next line after buffer


	.text
	.globl main

main:	addi $sp, $sp, -8		# create 8 bytes of stack space. 4 bytes for $ra and another 4 bytes for padding 
	sw $ra, 0($sp)			# store mains return address

prompt:
	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label msg

	li $v0, 8			# system call code read integer
	la $a0, buffer			# need an input buffer for user to load string into
	li $a1, 1000			# maximum number of characters to be read 
	syscall				# read the string and returns in v0

	la $a0, buffer			# pointer that will increment through memory
	add $t0, $0, $0			# set actual counter to 0

	addi $t2, $0, 10		# set \n value to t2

length:	lbu $t1, ($a0)			# dereference a0 and byte value into t1
	beq $t1, $0, exitlength		# if end of string then exit loop
	beq $t1, $t2, exitlength	# if newline reached then exit loop
	addi $t0, $t0, 1		# incremement loop
	addi $a0, $a0, 1		# increment pointer 
	j length			# go back to beginning of loop


exitlength:
	beq $t0, $0, epilogue		# if length is zero goto epilogue to quit program
	la $a0, buffer			# set pointer back to beginning of the string, which will be a parameter to palindrome function
	add $a1, $t0, $0		# set up parameter that reflects length of string for palindrome function 
	jal palindrome			# call palindrome method
	
	beq $v0, $0, printfail		# if return value of palindrome method is zero goto printfail
	
	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg2			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label msg2
	j prompt			# loop back to prompt

printfail:
	li $v0, 4			# syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
	la $a0, msg3			# load address which tells assembler and linker to create 2x i type 32 bit instructions
	syscall				# print string associated with data label msg3
	j prompt			# loop back to prompt 


epilogue:
	lw $ra, 0($sp)			# store mains return address
	addi $sp, $sp, 8		# remove 8 bytes of stack space. 4 bytes for $ra and another 4 bytes for padding
	jr $ra				# return from main (quit program)


# method palindrome decides if string is a palindrome. Inputs are the string and string length. Output is true or false
palindrome:				
	add $t0, $a0, $a1		# pointer 1 past last character
	
loop: 	addi $t0, $t0, -1		# pointer is now at last character of string
	sltu $t1, $a0, $t0		# represent while condition where beginner pointer is less than ending pointer
	beq $t1, $0, pass		# if above returns 1 then continue down, but if returns 0 than we know the beginning pointer has past ending pointer and succeded at finding a palindrome	
	lbu $t1, ($t0)			# dereference pointer at end of string
	lbu $t2, ($a0)			# dereference pointer at beginning of string
	bne $t1, $t2, fail		# compare two characters and if not same goto fail
	addi $a0, $a0, 1		# move pointer for beginning of string up by 1 byte (char)
	j loop
	
pass:	addi $v0, $0, 1			# set return value equal to 1 (true)
	jr $ra
	
fail:	addi $v0, $0, 0			# set return value equal to 0 (false)
	jr $ra				# return to calling method


	

	
	





	
