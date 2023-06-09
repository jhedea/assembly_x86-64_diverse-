.global brainfuck
	.text #text file
	.globl	mem #global file
	.bss #selection available for code
	.align 32 #s 32 bit alligned stack  
	.type	mem, @object # object tipe
	.size	mem, 30000 #size of the output array
mem:
	.zero	30000 #initialize all with zero
	.globl	ptr #global pointer for array
	.section	.data.rel.local,"aw" #data section allocated
	.align 8 #8 bit alligned frame
	.type	ptr, @object # object type
	.size	ptr, 8 #8 bit alligned pointer
ptr:
	.quad	mem #quads for memory 
	.text #text
	.globl	goToLoopEnd	 #the helpful subroutine
	.type	goToLoopEnd, @function	#same as above
goToLoopEnd:
	pushq	%rbp	#push base pointer
	movq	%rsp, %rbp #copy stack pointer to base pointer
	movq	%rdi, -24(%rbp)	#move input on the stack
	movl	$1, -4(%rbp)	#put 1 at the given location to start the loop
	jmp	searchLoop	#start the loop if not at the end
paranth:
	movq	-24(%rbp), %rax #allocate memory
	movq	(%rax), %rax #move memory address to know where to find the pair
	leaq	1(%rax), %rdx #subrtract one from pointer
	movq	-24(%rbp), %rax #move character to rax
	movq	%rdx, (%rax) #move the new content
	movq	-24(%rbp), %rax #move the pair to rax
	movq	(%rax), %rax #move the memory address
	movzbl	(%rax), %eax #move the other memory address
	movsbl	%al, %eax #get content to eax
	cmpl	$91, %eax #compre char to [
	je	pair0 #if equal jump to pair0
	cmpl	$93, %eax #same for ]
	je	pair1 #jump to pair1
	jmp	se #if not a pair jump to se
pair0:
	addl	$1, -4(%rbp) #add one to the index
	jmp	searchLoop #continue
pair1:  
	subl	$1, -4(%rbp) #add one to the index 
	jmp	searchLoop #continue
se:
	nop #not an operation, basically we got nothing to execute
searchLoop:
	cmpl	$0, -4(%rbp) #if the loop is over
	jg	paranth #we go to the paranth to execute the command
	nop #not an op
	nop #not an op
	popq	%rbp #pop the pointer value that we saved
	ret #return
	.size	goToLoopEnd, .-goToLoopEnd #set size
	.globl	goToLoopStart #set size
	.type	goToLoopStart, @function #set the function type
goToLoopStart:
	pushq	%rbp #puch base pointer
	movq	%rsp, %rbp #copy stack pointer
	movq	%rdi, -24(%rbp) #get message
	movl	$1, -4(%rbp) #move index
	jmp	loopStart #jump to loopStart
cont:
	movq	-24(%rbp), %rax #allocate memory
	movq	(%rax), %rax #get current memory location
	leaq	-1(%rax), %rdx #subtract one from index
	movq	-24(%rbp), %rax #move content to rax
	movq	%rdx, (%rax) #move content to the memory loc
	movq	-24(%rbp), %rax #get content to rax
	movq	(%rax), %rax #get memory loc 1
	movzbl	(%rax), %eax #take it to half the memory capacity
	movsbl	%al, %eax #move it to eax
	cmpl	$91, %eax #compare it to open bracket
	je	opb
	cmpl	$93, %eax #same for closed
	jne	loopStart #jump to clb
	addl	$1, -4(%rbp) #add 1 to the index
	jmp	loopStart #go to the loop Start
opb:
	subl	$1, -4(%rbp) #subtract one from while index
	jmp	loopStart #continue

loopStart:
	cmpl	$0, -4(%rbp) #compare if over
	jg	cont #if not jump to cont
	nop #no operation
	nop #same
	popq	%rbp #pop the previous memory location
	ret #return to start
	.size	goToLoopStart, .-goToLoopStart #size
	.globl	interpret #public
	.type	interpret, @function #typec
brainfuck:
interpret: #Main function which executes the program
	pushq	%rbp #push the pase pointer
	movq	%rsp, %rbp #copy the stack pointer
	subq	$32, %rsp #reserve memory location
	movq	%rdi, -24(%rbp) #get the message
	movq	-24(%rbp), %rax #move the output
	movq	%rax, -8(%rbp) #get output for writing
	jmp	mainF
exec: #The start of the loop, get the next char
	movq	-8(%rbp), %rax #reserve memory
	movzbl	(%rax), %eax #get memory address
	movsbl	%al, %eax #get content
	subl	$43, %eax  #reserve memory 
	cmpl	$50, %eax #compare if the search is not over
	ja	nextS # jump to nextS
	movl	%eax, %eax #be sure not null
	leaq	0(,%rax,4), %rdx #displacement to get the next char
	leaq	nextChar(%rip), %rax #get the next char
	movl	(%rdx,%rax), %eax #move the character to inspect
	cltq #sign extension
	leaq	nextChar(%rip), %rdx #decrement the index
	addq	%rdx, %rax #add the displacement to memory loation
	jmp	*%rax #jump to the memory address pinted to by rax
	.section	.rodata #new section
	.align 4  #allign stack
	.align 4 #allign stack
nextChar:
	.long	stop4-nextChar
	.long	putC2-nextChar
	.long	stop5-nextChar
	.long	putC-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	stop3-nextChar
	.long	nextS-nextChar
	.long	stop1-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	nextS-nextChar
	.long	putnew-nextChar
	.long	nextS-nextChar
	.long	.L17-nextChar
	.text
stop1:
	movq	ptr(%rip), %rax #get the new char
	addq	$1, %rax #add 1 to index
	movq	%rax, ptr(%rip) #move the new char
	jmp	nextOp #continue with the execution
stop3:
	movq	ptr(%rip), %rax #same as above
	subq	$1, %rax #subtract 1
	movq	%rax, ptr(%rip)
	jmp	nextOp
stop4:
	movq	ptr(%rip), %rax #same as above
	movzbl	(%rax), %edx
	addl	$1, %edx
	movb	%dl, (%rax)
	jmp	nextOp
stop5:
	movq	ptr(%rip), %rax #same as above
	movzbl	(%rax), %edx
	subl	$1, %edx
	movb	%dl, (%rax)
	jmp	nextOp
putC:
	movq	ptr(%rip), %rax #same as above
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	%eax, %edi
	call	putchar@PLT
	jmp	nextOp
putC2:
	call	getchar@PLT #same as above
	movl	%eax, %edx
	movq	ptr(%rip), %rax
	movb	%dl, (%rax)
	jmp	nextOp
putnew:
	movq	ptr(%rip), %rax #this time we get the end part
	movzbl	(%rax), %eax
	testb	%al, %al #if not null we jump
	jne	nextOp
	leaq	-8(%rbp), %rax
	movq	%rax, %rdi #else, we still have chars
	call	goToLoopEnd
	jmp	nextOp
.L17:
	movq	ptr(%rip), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	nextOp
	leaq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	goToLoopStart
	jmp	nextOp
nextS:
	nop #nothing to do
	jmp	nextOp #jump to nextOp

nextOp:
	movq	-8(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -8(%rbp)
mainF:
	movq	-8(%rbp), %rax #get the message from the stack
	movzbl	(%rax), %eax #get the mem address
	testb	%al, %al #test if not null
	jne	exec #jump to exec
	nop
	nop
	leave
	ret
	