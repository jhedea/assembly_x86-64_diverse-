.text

outputc: .asciz "%c"
outputld: .asciz "%lX\n"
outputi: .asciz "%ld\n"

.include "final.s"

.global main

# ************************************************************
# Subroutine: decode                                         *
# Description: decodes message as defined in Assignment 3    *
#   - 2 byte unknown                                         *
#   - 4 byte index                                           *
#   - 1 byte amount                                          *
#   - 1 byte character                                       *
# Parameters:                                                *
#   first: the address of the message to read                *
#   return: no return value                                  *
# ************************************************************
decode:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

    # set address as 0
    movq $0, %rsi
    pushq %rdi
	
body: 
    # put 8 bytes of message (memory location rdi) into rax from position rsi 
    popq %rdi #pops rdi (original full message) from the stack
    movq (%rdi, %rsi, 8), %rax #takes the part from rdi which is relevant and puts it in rax
    pushq %rdi #pushes the original message back
    pushq %rax #pushes the relevant byteset

    # shift to the character
    # take character from rax
    # movq %rax, %r14 #moving the initial address value to r14
    popq %rsi #pops relevant byteset to rsi 
    pushq %rsi #pushes relevant byteset
    shl $56, %rsi   # finding the ascii code for the character
    shr $56 ,%rsi   # shift it to the right
    


    # shift to amount of prints
    # pushq %rdi #pushes current rdi (the message) onto the stack, to retrieve after printing
    # movq %rax ,%r15 #moving the initial address value to r15
    popq %rdi # pops relevant byteset
    pushq %rdi # push relevant byteset
    shl $48, %rdi #shifting it to the left 
    shr $56, %rdi   # shifting it to the right

    # call the print function
    call printloop
     
    # pops the byteset into rsi
    popq %rsi
    shl $16, %rsi
    shr $32, %rsi #shortens rsi to contain just the address


    # check whether address is 0, if so exit
    cmpq $0, %rsi
    je returndecode
    # otherwise jump to start of loop
    jmp body


returndecode:
    #Subroutine epilogue
    movq %rbp, %rsp #clear the local variables from the stack
    movq $0, %rdi
    popq %rbp   #we restore the base pointer location

    ret #return from subroutine

main:
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer


	movq	$MESSAGE, %rdi	# first parameter: address of the message
	call	decode			# call decode

	popq	%rbp			# restore base pointer location 
	movq	$0, %rdi		# load program exit code
	call	exit			# exit the program





printloop:
    #########################
    # Functionality:
    # Input:
    # rdi = amount of times to print a character
    # rsi = ascii number of the character to be printed
    # Output:
    # none
    #########################

    pushq %rbp 
    movq %rsp, %rbp #reset base pointer and move stack pointer to it.
    

    movq $0, %rax   # for no vector for printf

    jmp loop # jump to loop to start the loop

loop:
    cmpq $1, %rdi   # compare exponent to 0 
    jl return # if the exponent is zero we then jump to the special case where the result is 1
    
    dec %rdi 

    #movq %rdi, %rsi # Move output variable
    pushq %rdi  #stores rdi (amount of prints) on stack
    pushq %rsi  #stores rsi (character number) on stack

    
    movq $0, %rax   # for no vector for printf
    movq $outputc, %rdi  # Move output message
    call printf     # call printf

    # the character is already in rdi, so no need to move it to rdi
    #call printf

    popq %rsi
    popq %rdi
    jmp loop # and continue with the while loop


return:
    
    #Subroutine epilogue
    movq %rbp, %rsp #clear the local variables from the stack
    movq $0, %rdi
    popq %rbp   #we restore the base pointer location

    ret #return from subroutine+
    





