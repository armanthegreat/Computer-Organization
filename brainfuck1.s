.text
	readformat: .asciz "%lc"
	printformat: .asciz "%c"


.global brainfuck

brainfuck:
	pushq 	%rbp
	movq 	%rsp, %rbp

	movq	%rdi, %r14 # adress of string buffer 

	movq 	$10000, %rdi  #creating 1000 cells initialized to 0 
 	movq 	$1 , %rsi    #each cell having the size of 1 byte
 	call 	calloc  

	movq	%rax,%r15 #move pointer to first cell 

	movq	$0,%r13 #Counter to compare number of opening and closing brackets 

	operations:
			movb	(%r14),%r12b

			cmpb	$0,%r12b
			je		end

			cmpb    $0x2B,%r12b #[+]
			je		add

			cmpb    $0x2D,%r12b #[-]
			je		subtract

			cmpb    $0x3E,%r12b#[>]
			je		next
			
			cmpb    $0x3C,%r12b#[<]
			je		previous

			cmpb    $0x2E,%r12b#[.]
			je		output

			cmpb    $0x2C,%r12b
			je		output #should be input

			cmpb	$0x5B,%r12b
			je		lpstart

			cmpb	$0x5D,%r12b
			je		lpend

			incq	%r14	#ignore invalid values (else)
			jmp		operations

		add:
			incq	(%r15)
			incq	%r14 
			jmp		operations
		
		subtract:
			decq 	(%r15)
			incq	%r14
			jmp		operations
		
		next:
			incq	%r15
			incq	%r14
			jmp		operations

		previous:
			decq	%r15
			incq	%r14
			jmp		operations


		input:
			movq    $readformat, %rdi    
			movq    %r15, %rsi            
			call    scanf  
			incq	%r14          	
			jmp     operations           

		output:
			movq    $printformat, %rdi    
			movq    (%r15), %rsi          
			movq    $0, %rax              
			call    printf    

			incq	%r14     	    
			jmp     operations

		lpstart:
			pushq	%r14		#save adress of loop start
			incq	%r14
			jmp		operations

		lpend:
			popq	%r14
			cmpq	$0,(%r15)
			jne		lpstart
			jmp		lpskip
			

		lpskip:
			movb	(%r14),%r12b
			
			cmpb	$0x5B,%r12b #Compare current operation with [
			je		lpinc

			cmpb	$0x5D,%r12b #Compare current operation with ]
			je		lpdec

			incq	%r14
			jmp		lpskip

		lpinc:		
			incq	%r13
			incq	%r14
			jmp		lpskip

		lpdec:
			incq	%r14
			decq	%r13
			cmpq	$0,%r13
			jne		lpskip

			jmp		operations

	
		end:
			movq	%rbp, %rsp
			popq 	%rbp
			ret

			