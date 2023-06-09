.text
#Prompt messages
message1: .asciz " \n Please read the input: \n"
message3: .asciz "\n The result is: \n"
indicatemessage: .asciz "\n You are here \n"


#Input variables
input: .asciz "%ld"
output: .asciz " \n The value is: %ld \n"
indicatevar: .asciz " \n The value over here is: %ld \n"

.global main

main:

    #Prologue
    pushq %rbp      #pushing the base pointer
    movq %rsp, %rbp # copying the stack pointer to the base pointer

    #Body

    #Input part
    #Output prompt
    movq $0, %rax   # no vectors registered for printing
    movq $message1, %rdi    # put the message as argument
    call printf     # print content of rdi
    movq $0 , %rdi  # clear rdi

    #First input variable
    subq $16, %rsp   # reserve stack space
    leaq -16(%rbp), %rsi    # load the address where the input will go
    movq $input, %rdi      # give the input location as argument for scanf
    movq $0, %rax   # no vector for scanf    
    call scanf      # receive input
    
    popq %rdi       # copy input1 to r14
    pushq $0        # realign stack to 64 bit alignment
#    movq $0 ,%rdi   # clear rdi 


    #Calculating the result and putting in rbx

    #movq $0, %rax
    call factorial
    

    #Print output message

    movq %rax, %rsi # Move output variable
    movq $0, %rax   # for no vector for printf
    movq $output, %rdi  # Move output message
    call printf     # call printf


    #Epilogue
    movq %rbp, %rsp  # Reset the stack pointer
    popq %rbp        # Remove program base pointer
    movq $0, %rdi   #reset the rdi value
    call exit   #fin


factorial:
    pushq %rbp      #resets base pointer for subroutine epilogue
    movq %rsp, %rbp #sets stack pointer to base pointer

    pushq %rdi      #pushes current input value onto stack (for first recursion step n, then n-1)
    cmp $1, %rdi    #checks if current rdi is 1
    jle factorial_base   #if 1 <= rdi, it returns the function, 
    #which starts recursion or if input is 1, returns
    decq %rdi       # decreases the base for the next recursion step

    call factorial #calls next recursion step
#    call indicate
 

    /*pushq %rdi
    movq %rbx, %rsi # Move output variable
    movq $0, %rax   # for no vector for printf
    movq $indicatevar, %rdi  # Move output message
    call printf     # call printf
    popq %rdi*/

    popq %rdi           # pop the most recent value from the stack
    imulq %rdi, %rax    # multiply the current result with the recent value
    jmp factorial_end   # jump to the end of the subroutine,
    # to go into the next recursion step or final

    

factorial_base:
    movq $1, %rax       # puts 1 in rbx (result), to start recursion
    # or to return 1 if input <= 1
#    call indicate

factorial_end:
    movq %rbp, %rsp     #resets stack pointer
    popq %rbp           #pops base pointer
#    call indicate
    ret                 #return, to previous recursion or to main


/*indicate:
    pushq %rbp      # resetting the base pointer
    movq %rsp, %rbp # moving the stack pointer to base pointer
    movq %rax, %r13
    movq %rdi, %r12 

    #Output prompt
    movq $0, %rax   # no vectors registered for printing
    movq $indicatemessage, %rdi    # put the message as argument
    call printf     # print content of rdi
    movq $0 , %rdi  # clear rdi

    movq %r13, %rax
    movq %r12, %rdi
    #Subroutine epilogue
    movq %rbp, %rsp   #clear the local variables from the stack
    popq %rbp   # Remove program base pointer

    ret  #return from subroutine*/

