.bss
     buff:     .skip 1024

.data

.text
    
     #brainf: .string "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.\n" #intializing an 8 bit string
     action: .asciz "r" #string literal for using fopen
     format: .asciz "%d"

#print:
    # pushq     %rbp
     #movq      %rsp,%rbp

    # movq      $format,%rdi
    # movq      $0,%rax
    # call      printf
     #popq      %rbp
     #ret

fileread: #rdi set to filename in main 

     pushq     %rbp #-8
     movq      %rsp, %rbp

     subq      $16,%rsp
     movq      $action, %rsi # reading from file
     call      fopen
     movq      %rax,-8(%rbp)
     
     movq      %rax, %rdi #pointer to the address of the file 
	movq      $0, %rsi #offset
	movq      $2, %rdx #seekend
	call      fseek 
     
     
     movq      -8(%rbp), %rdi #move the adress of the beggining of the file
     call      ftell # find the length of the file
     movq      %rax,-16(%rbp) #push the length to the stack #-16
     
     movq      -8(%rbp), %rdi #pointer to the address of the file 
	movq      $0, %rsi #offset
	movq      $0, %rdx #seekend
	call      fseek 
     
     movq      $buff,%rdi
     movq      $1,%rsi
     movq      -16(%rbp),%rdx
     movq      -8(%rbp),%rcx
     call      fread

     movq      -8(%rbp),%rdi
     call      fclose

     popq      %rax
     movq      %rbp,%rsp
     popq      %rbp
     ret

operationTable:

     .quad     0x3E   # move up (>) #case0
     .quad     0x3C   # move down(<) #case1
     .quad     0x2B   # plus(+) #case2
     .quad     0x2D   # minus(-) #case3
     .quad     0x2D # Input (,) #case4
     .quad     0x2E # Output (.) #case5
     .quad     0x5B # start loop ([) #case6
     .quad     0x5D # end loop (]) #case7





.global main
main:

     pushq     %rbp
     movq      %rsp, %rbp
     
     movq      8(%rsi),%rdi   # argv[1] (file name)
     
     call      fileread

     movq      %rax,%r9


     movq      $0,%rdi
     call      exit