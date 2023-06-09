	.file		#the current file
	.text	#text file
	.globl	luhn # we create the program to be global
	.type	luhn, @function #type function, created to calulate
	#whether the string put as input is a valid credit
	#card number based on luhn algorithm
	#we have the given hash function
	#based on digit analysis
luhn:
	pushq	%rbp #push the base pointer
	movq	%rsp, %rbp #copy the stack pointer to the base pointer
	subq	$80, %rsp # create space for the given input
	movq	%rdi, -72(%rbp) #move the input in the given space
	movl	$0, -64(%rbp) #allocate memory for each character in the string #0
	#we move each digit in the decimal system down the stack
	# in the given possible luhn format
	movl	$2, -60(%rbp) #2
	movl	$4, -56(%rbp) #4
	movl	$6, -52(%rbp) #6
	movl	$8, -48(%rbp) #8
	movl	$1, -44(%rbp) #1
	movl	$3, -40(%rbp) #3
	movl	$5, -36(%rbp) #5
	movl	$7, -32(%rbp) #7
	movl	$9, -28(%rbp) #9
	movl	$1, -8(%rbp) #1
	movl	$0, -12(%rbp) #0
	movq	-72(%rbp), %rax #we move the current string value to rax
	movq	%rax, %rdi #then to rdi
	call	strlen@PLT #calculate the length with the c-type strlen
	movl	%eax, -4(%rbp) #we move the part down the stack
	jmp	loopgen #jump to the loop
ternary:
	movl	-4(%rbp), %eax #current character
	movslq	%eax, %rdx #move it to rdx
	movq	-72(%rbp), %rax #get the next character
	addq	%rdx, %rax #add the two to rax
	movzbl	(%rax), %eax #move the memory location to eax
	movsbl	%al, %eax #copy the memory location al
	subl	$48, %eax  #subtract 48 to get the new one
	movl	%eax, -16(%rbp) #move the sum on the stack
	cmpl	$0, -8(%rbp) #compare the next value to 0
	jne	nextchar #if not null jump to next
	movl	-16(%rbp), %eax  #move sum to eax
	cltq	#extend eax to rax
	movl	-64(%rbp,%rax,4), %eax #get the next pair
	jmp	reminder #jump to remainder
nextchar:
	movl	-16(%rbp), %eax #get the next
.reminder:
	addl	%eax, -12(%rbp) #add the next value
	cmpl	$0, -8(%rbp) #compare to 0
	sete	%al #set al
	movzbl	%al, %eax #move it to eax 
	movl	%eax, -8(%rbp) #move eax on the stack
loopgen:
	movl	-4(%rbp), %eax #get the current character/digit
	leal	-1(%rax), %edx #decrement the iteration index
	movl	%edx, -4(%rbp) # we get the char of the current token
	testl	%eax, %eax #test if we do not have a null excemption
	jne	ternary # if not, jump to ternary
	movl	-12(%rbp), %ecx #we get the next character
	movslq	%ecx, %rax # we then move it to rax
	imulq	$1717986919, %rax, %rax #we double the value of every second digit
	shrq	$32, %rax #we shift 32 bits to the right
	sarl	$2, %eax #multiply by 2
	movl	%ecx, %esi #we move the given sum on this position to esi
	sarl	$31, %esi #we circularly shift right 31 bits
	subl	%esi, %eax #subtration from the mod operation
	movl	%eax, %edx #move the given value to edx
	movl	%edx, %eax #then to eax
	sall	$2, %eax #circluarly shift left 2 bits
	addl	%edx, %eax #add the sum to eax
	addl	%eax, %eax #double eax
	subl	%eax, %ecx #move to ecx
	movl	%ecx, %edx #then to edx
	testl	%edx, %edx #test not null
	sete	%al #set al
	movzbl	%al, %eax #move to eax for testing
	leave
	ret
input1:
	.string	"79927398713" #input
input2:
	.string	"4332432432432333" #input
input3:
	.string	"50330310160033" #input
input4:
	.string	"2670921160089" #input
trueval:
	.string	"Valid card number" #output if valid
falseval:
	.string	"Not a valid card number" #output if not valid
printing:
	.string	"%16s\t%s\n" #printing all of them at the same time
	.text #text file 
	.globl	main #global
	.type	main, @function #f unction type
main:
	pushq	%rbp #push the base pointer
	movq	%rsp, %rbp #copy the base pointer to the stack pointer
	subq	$48, %rsp # create space for input
	leaq	input1(%rip), %rax # move current input pointed to by rip to rax
	movq	%rax, -48(%rbp) #move rax on the stack
	leaq	input2(%rip), %rax #same for input 2
	movq	%rax, -40(%rbp)#move rax on the stack
	leaq	input3(%rip), %rax #same for input 3
	movq	%rax, -32(%rbp)#move rax on the stack
	leaq	input4(%rip), %rax #same for input 44
	movq	%rax, -24(%rbp)#move rax on the stack
	movq	$0, -16(%rbp) #clear the rest 
	movl	$0, -4(%rbp) #clear the rest of the stack frame
	jmp	compute
valuea:
	movl	-4(%rbp), %eax #get current memory location
	cltq #sign extend eax to rax for memory purposes
	movq	-48(%rbp,%rax,8), %rax #get the whole string
	movq	%rax, %rdi #move it to rdi
	call	luhn  #call luhn with rdi as its parameter
	testl	%eax, %eax #test if not null
	je	nulle	#if so jump to nulle
	leaq	trueval(%rip), %rax #else put trueval to rax for printing
	jmp	print1 #then jump to printval
nulle:
	leaq	falseval(%rip), %rax #put falseval to rax for printing
print1:
	movl	-4(%rbp), %edx #get the current memory location
	movslq	%edx, %rdx #extend to rdx
	movq	-48(%rbp,%rdx,8), %rcx #put the string to rcx
	movq	%rax, %rdx #move 
	movq	%rcx, %rsi #copy it to rsi
	leaq	printing(%rip), %rdi #call printing to rdi
	movl	$0, %eax #clear eax
	call	printf@PLT #call printf from c library
	addl	$1, -4(%rbp) #add 1 to the memory location
compute: 
	movl	-4(%rbp), %eax # get current string location
	cltq #sign extend eax to rax for memory purposes
	movq	-48(%rbp,%rax,8), %rax #get the current full string
	testq	%rax, %rax #test if not null
	jne	valuea  #then jump to valuea
	movl	$0, %eax #clear eax
	leave #leave the funciton
	ret #return to address