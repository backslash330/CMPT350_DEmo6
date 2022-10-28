.data
first_prompt: .asciiz "Enter a floating point number: "
second_prompt: .asciiz "Enter another floating point number: "
nl: .asciiz "\n"
addition_prompt: .asciiz "The sum of the two numbers is: "
subtraction_prompt: .asciiz "The two numbers subtracted are: "
multiplication_prompt: .asciiz "The product of the two numbers is: "
division_prompt: .asciiz "The quotient of the two numbers is: "
positive_message: .asciiz "THe sum is positive (or zero)"
negative_message: .asciiz "The sum is negative"
calculating_message: .asciiz "Calculating base 2 exponent..."
exponent_message: .asciiz "Exponent is  "
.text
main:
	# prompt the user for the first number
	li $v0, 4
	la $a0, first_prompt
	syscall

	# read the first floating point number
	li $v0, 6
	syscall

	# the result is in $f0
	# move it into $f22
	mov.s $f2, $f0

	# prompt the user for the second number4
	li $v0, 4
	la $a0, second_prompt
	syscall

	# read the second floating point number
	li $v0, 6
	syscall

	# store the second floating point number in $f3
	mov.s $f3, $f0

	# add the two numbers
	add.s $f12, $f2, $f3

	# print the result of the addition
	li $v0, 4
	la $a0, addition_prompt
	syscall

	li $v0, 2
	mfc1 $a0, $f0
	syscall

	# print a newline
	li $v0, 4
	la $a0, nl
	syscall

	# subtract the two floating point numbers
	sub.s $f12, $f2, $f3
	
	# print the result of the subtraction
	li $v0, 4
	la $a0, subtraction_prompt
	syscall

	li $v0, 2
	mfc1 $a0, $f0
	syscall

	# print a newline
	li $v0, 4
	la $a0, nl
	syscall

	# multiply the two floating point numbers
	mul.s $f12, $f2, $f3
	
	# print the result of the multiplication
	li $v0, 4
	la $a0, multiplication_prompt
	syscall

	li $v0, 2
	mfc1 $a0, $f0
	syscall

	# print a newline
	li $v0, 4
	la $a0, nl
	syscall

	# divide the two floating point numbers
	div.s $f12, $f2, $f3

	# print the result of the division
	li $v0, 4
	la $a0, division_prompt
	syscall

	li $v0, 2
	mfc1 $a0, $f0
	syscall

	# print a newline
	li $v0, 4
	la $a0, nl
	syscall

	# Find the sign of the sum of the two values without brancing using bitwise instructions
	# e.g  if the two inputs are 3.14 and –6.28, the sum is –3.14 and the sign is negative
	# if the two inputs are 3.14 and 6.28, the sum is 9.42 and the sign is positive

	# add the two numbers
	add.s $f12, $f2, $f3

	# move the sum into $f4
	mov.s $f4, $f12

	# put the number into a register
	mfc1 $t0, $f4

	# copy the number into $t1, to find the exponent later
	move $t1, $t0

	# shift the sign bit into the least significant bit
	srl $t0, $t0, 31

	# print the appropriate message
	li $v0, 4
	beq $t0, $zero, positive
	# if the sign bit is 1, the number is negative
	# print the negative message
	la $a0, negative_message
	syscall
	j end

positive:
	# print the positive message
	la $a0, positive_message
	syscall

end:

	# print a newline
	li $v0, 4
	la $a0, nl
	syscall

	# Find the base 2 exponent of the sum of the two values without branching using bitwise instructions
	# using t1 shift left 1 and then shift right 24
	sll $t1, $t1, 1
	srl $t1, $t1, 24

	# subtract 127 from the exponent (bias)
	addi $t1, $t1, -127

	# print the exponent message
	li $v0, 4
	la $a0, exponent_message
	syscall

	# print the exponent
	li $v0, 1
	move $a0, $t1
	syscall

	# print a newline
	li $v0, 4
	la $a0, nl
	syscall


Exit:
	li $v0, 10
	syscall
