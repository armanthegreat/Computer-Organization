.global brainfuck

format_str: .asciz "We should be executing the following code:\n%s"

# Your brainfuck subroutine will receive one argument:
# a zero terminated string which is the code to execute.
.text
	readformat: .asciz "%lc"
	printformat: .asciz "%c"

brainfuck:
	pushq 	%rbp
	movq 	%rsp, %rbp

	movq	%rdi, %rcx # adress of string buffer 

	movq 	$1000, %rdi  #creating 1000 cells initialized to 0 
 	movq 	$1 , %rsi    #each cell having the size of 1 byte
 	call 	calloc  

	movq	%rax,%rdx #move pointer to first cell 

	movq	$1,%r10 #Counter to compare number of opening and closing brackets 

	operations:
			movb	(%rcx),%r9b
			
			cmpb	$0,%r9b
			je		end

			cmpb    $0x2B,%r9b #[+]
			je		add

			cmpb    $0x2D,%r9b #[-]
			je		subtract

			cmpb    $0x3E,%r9b#[>]
			je		next
			
			cmpb    $0x3C,%r9b#[<]
			je		previous

			cmpb    $0x2E,%r9b#[.]
			je		output

			cmpb    $0x2C,%r9b
			je		input

			cmpb	$0x5B,%r9b
			je		lpstart

			cmpb	$0x5D,%r9b
			je		lpend

			incq	%rcx	#ignore invalid values (else)
			jmp		operations

		add:
			incq	(%rdx)
			incq	%rcx 
			jmp		operations
		
		subtract:
			decq 	(%rdx)
			incq	%rcx
			jmp		operations
		
		next:
			incq	%rdx
			incq	%rcx
			jmp		operations

		previous:
			decq	%rdx
			incq	%rcx
			jmp		operations


		input:
			movq    $readformat, %rdi    
			movq    %rdx, %rsi            
			call    scanf  
			incq	%rcx          	
			jmp     operations           

		output:
			movq    $printformat, %rdi    
			movq    %rdx, %rsi          
			movq    $0, %rax              
			call    printf    

			incq	%rcx         
			jmp     operations

		lpstart:
			pushq	%rcx		#save adress of loop start
			incq	%rcx
			jmp		operations

		lpend:
			popq	%rcx
			cmpq	$0,(%rdx)
			jne		lpstart
			jmp		lpskip

		lpskip:
			incq	%rcx
			movb	(%rcx),%r9b

			cmpb	$0x5B,%r9b #Compare current operation with [
			je		lpinc

			cmpb	$0x5D,%r9b #Compare current operation with ]
			je		lpdec

			jmp		lpskip

		lpinc:		
			incq	%r10
			jmp		lpskip

		lpdec:
			decq	%r10
			cmpq	$0,%r10
			jne		lpskip
			incq	%rcx
			jmp		operations

		end:
			movq	%rbp, %rsp
			popq 	%rbp
			ret