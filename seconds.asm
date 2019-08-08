#****************************
# William Archbold
# January 31 2019
# CSC 225 Computer Architecture and Assembly Language
#****************************

#----------------------------------------------------------------------------------------------------
# Homework 2
# Write a program that runs on SPIM that allows the user to enter the number of hours, minutes and 
# seconds and then prints out the total time in seconds. Name the source code file “seconds.asm”.
#----------------------------------------------------------------------------------------------------
        
		.data
msg:   	.asciiz "Enter hours: "    #.asciiz tells assembler to write a c style string with null termination
msg2:	.asciiz "Enter minutes: "
msg3:	.asciiz "Enter seconds: "

msg4:	.asciiz "Total seconds is: "

msg5:	.asciiz "\n"
	
        .text
        .globl main
main:   
	li $v0, 4       # syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
        la $a0, msg     # argument: string
        syscall         # print the string
	li $v0, 5
	syscall
	# $v0 has hours
	add $s0, $0, $v0	# move hours to $s0

	li $v0, 4       # syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
        la $a0, msg2     # argument: string
        syscall         # print the strings
	li $v0, 5
	syscall
	# $v0 has minutes
	add $s1, $0, $v0	# move minutes to $s1

	li $v0, 4       # syscall 4 (print_str) # http://students.cs.tamu.edu/tanzir/csce350/reference/syscalls.html
        la $a0, msg3     	# argument: string
        syscall         	# print the string
	li $v0, 5
	syscall
	# $v0 has minutes
	add $s2, $0, $v0	# move seconds to $s2

	# ((hours * 60) + minutes) * 60 + seconds
	li $t0, 60		#store 60 into register to use MIPS multiply instruction next
	mul $t1, $t0, $s0	#get total minutes from hours
	add $t1, $t1, $s1	#add minutes to minutes
	mul $t1, $t1, $t0	#convert minutes to seconds
	add $s3, $t1, $s2	#add seconds to seconds

	li $v0, 4		#print string
	la $a0, msg4		#argument 
	syscall
	li $v0, 1		#print integer
	add $a0, $0, $s3	#put seconds into parameter
	syscall

	li $v0, 4		#print string
	la $a0, msg5		#argument string
	syscall			#print newline

        jr $ra          	# return to caller