.text
#Prompt messages
message1: .asciz " \n Please read the base: \n"
message2: .asciz " \n Please read the exponent: \n"
message3: .asciz "\n The result is: \n"
indicatemessage: .asciz "\n You are here \n"


#Input variables
input: .asciz "%ld"
output: .asciz " \n The value is: %ld \n"

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
    popq %r14       # copy input1 to r14
    pushq $0        # realign stack to 64 bit alignment
#    movq $0 ,%rdi   # clear rdi 

    #Output prompt 2
    movq $0, %rax   # no vectors registered for printing
    movq $message2, %rdi    # put the message as argument
    call printf     # print content of rdi
    movq $0 , %rdi  # clear rdi 

    #Second input variable
    leaq -16(%rbp), %rsi    # load the address where the input will go
    movq $input, %rdi      # give the input location as argument for scanf
    movq $0, %rax   # no vector for scanf    
    call scanf      # receive input
    popq %r15       # copy input1 to r15
    pushq $0        # realign stack to 64 bit alignment
    movq $0 ,%rdi   # clear rdi

    movq %r14, %rdi # moves r14 (base) into rdi as first argument
    movq %r15, %rsi # moves r15 (exponent) into rsi as second argument

    #Calculating the result and putting in rbx
    call pow

    #Print output message

    movq %rax, %rsi # Move output variable
    movq $0, %rax   # for no vector for printf
    movq $output, %rdi  # Move output message
    call printf     # call printf

    #Epilogue
    movq %rbp, %rsp  # Reset the stack pointer
    pop %rbp        # Remove program base pointer
    movq $0, %rdi   #reset the rdi value
    call exit   #fin


pow:
    #Subroutine prologue
    pushq %rbp      # pushing / resetting the base pointer
    movq %rsp, %rbp # moving the stack pointer to base pointer
    #Subroutine body
    cmpq $0, %rsi   # compare exponent to 0 
    je null # if the exponent is zero we then jump to the special case where the result is 1
    movq %rdi, %rax  # we copy the base( the read value) stored in the r14 register to the rbx register
    cmpq $2, %rsi # now: as long as the exponent is bigger than two
    # ( to two because we already have the final value equal to the base, so we need exponent-1 multiplications)
    # which leaves us to compare the current exponent value to two
    jge note # if this holds(current exponent > 2) we then decrement the current exponent by 1 and move to our power function
    jmp return # we then return

null:
    movq $1, %rax # we store it in the rbx register and print it
    jmp return # then we return to main

note:
    dec %rsi # every time we multiply the value from rbx with the base we decrement the exponent stored in r15
    jmp power # and continue with the while loop

power:
    imulq %rdi, %rax    #the actual loop where we multiply the current result value with the base
    dec %rsi        #decrement the exponent
    cmpq $0, %rsi   #compare it with zero
    jne power   #if not null we continue the loop( we have not reached the end)
    jmp return #and then we return the obtained value

return:
    
    #Subroutine epilogue
    movq %rbp, %rsp #clear the local variables from the stack
    popq %rbp   #we restore the base pointer location

    ret #return from subroutine+

    
    
end:
    movq %rbp, %rsp  # Reset the stack pointer
    pop %rbp        # Remove program base pointer
    movq $0, %rdi   #reset the rdi value
    call exit   #fin


indicate:
    pushq %rbp      # resetting the base pointer
    movq %rsp, %rbp # moving the stack pointer to base pointer

    #Output prompt
    movq $0, %rax   # no vectors registered for printing
    movq $indicatemessage, %rdi    # put the message as argument
    call printf     # print content of rdi
    movq $0 , %rdi  # clear rdi

    #Subroutine epilogue
    movq %rbp, %rsp   #clear the local variables from the stack
    popq %rbp   # Remove program base pointer

    ret  #return from subroutine

