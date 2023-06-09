.text

outputc: .asciz "%c"
outputld: .asciz "%lX\n"
outputi: .asciz "%ld\n"
seteffect: .asciz "\033[%ldm"
setbackground: .asciz "\033[38;5;%ldm"
settext: .asciz "\033[48;5;%ldm"
resetall: .asciz "\033[0m"


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

    #Pop original message to r8
    popq %r8
    pushq %r8
    shr $56, %r8 #Select rightmost 

    #Pop original message to r8
    popq %r9
    pushq %r9
    shl $8, %r9
    shr $56, %r9 #Select byte #2

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

    movq $0, %rax   # no vectors registered for printing
    movq %r13, %rsi
    movq $resetall, %rdi    # put the message as argument
    call printf     # print content of rdi
    movq $0 , %rdi  # clear rdi


	popq	%rbp			# restore base pointer location 
	movq	$0, %rdi		# load program exit code
	call	exit			# exit the program

    



printloop:
    #########################
    # Functionality:
    # Input:
    # rdi = amount of times to print a character
    # rsi = ascii number of the character to be printed
    # r8 = ansi code of background color -> is stored inside r12 during subroutine
    # r9 = ansi code of text color -> is stored inside r13 during subroutine
    # Output:
    # none
    #########################

    pushq %rbp 
    movq %rsp, %rbp #reset base pointer and move stack pointer to it.
    pushq %r12 #Clear callee-saved registers
    pushq %r13

    movq %r8, %r12 #Put arguments into callee-saved registers
    movq %r9, %r13

    movq $0, %rax   # for no vector for printf

    jmp loop # jump to loop to start the loop

loop:
    cmpq $1, %rdi   # compare exponent to 0 
    jl return # if the exponent is zero we then jump to the special case where the result is 1
    dec %rdi 

    pushq %rdi #Push rdi and rsi onto the stack, as their values are changed by printf routine
    pushq %rsi

    #Compare the two values to eachother, if equal jump to the effects decoding
    cmpq %r12, %r13
    je effects


    #Print r12 nd r13, used for testing
    /*movq $0, %rax   # no vectors registered for printing
    movq %r13, %rsi
    movq $outputi, %rdi    # put the message as argument
    call printf     # print content of rdi
    movq $0 , %rdi  # clear rdi

    movq $0, %rax   # no vectors registered for printing
    movq %r12, %rsi
    movq $outputi, %rdi    # put the message as argument
    call printf     # print content of rdi
    movq $0 , %rdi  # clear rdi*/


    # Set the background color from r13 first, before setting text color 
    movq $0, %rax   # no vectors registered for printing
    movq %r13, %rsi
    movq $setbackground, %rdi    # put the message as argument
    call printf     # print content of rdi
    movq $0 , %rdi  # clear rdi

    # Set the text color from r12
    movq $0, %rax   # no vectors registered for printing
    movq %r12, %rsi
    movq $settext, %rdi    # put the message as argument
    call printf     # print content of rdi
    movq $0 , %rdi  # clear rdi

print: #Prints the character specified
    popq %rsi
    pushq %rsi

    movq $0, %rax   # for no vector for printf
    movq $outputc, %rdi  # Move output message
    call printf     # call printf
    # the character is already in rdi, so no need to move it to rdi
    #call printf
    popq %rsi
    popq %rdi
    jmp loop # and continue with the while loop

effects: #Takes the effect numbers from the assignments and jumps to the correct label to set the right effect
    cmpq $0, %r12
    je reset
    cmpq $37, %r12
    je stopblink
    cmpq $42, %r12
    je bold
    cmpq $66, %r12
    je faint
    cmpq $105, %r12
    je conceal
    cmpq $153, %r12
    je reveal
    cmpq $182, %r12
    je blink

reset:   
    movq $0, %rsi
    jmp printeffect
stopblink:
    movq $25, %rsi
    jmp printeffect
bold:
    movq $1, %rsi
    jmp printeffect
faint:
    movq $2, %rsi
    jmp printeffect
conceal:
    movq $8, %rsi
    jmp printeffect
reveal:
    movq $28, %rsi
    jmp printeffect
blink:
    movq $5, %rsi
    jmp printeffect

printeffect:
    movq $0, %rax   # no vectors registered for printing
    movq $seteffect, %rdi    # put the message as argument
    call printf     # print content of rdi
    movq $0 , %rdi  # clear rdi
    jmp print


return:
    

    popq %r13
    popq %r12
    #Subroutine epilogue
    movq %rbp, %rsp #clear the local variables from the stack
    movq $0, %rdi
    popq %rbp   #we restore the base pointer location

    ret #return from subroutine+
    
    





