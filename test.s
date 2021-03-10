.bss
     buff:     .skip 1024

.data

.text
    
     #brainf: .string "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.\n" #intializing an 8 bit string
     action: .asciz "r" #string literal for using fopen
     format: .asciz "%s"

print:
     movq      $format,%rdi
     movq      $0,%rax
     call      printf
     ret

fileread: #rdi set to filename in main 

     pushq     %rbp
     movq      %rsp, %rbp

     movq      $action, %rsi # reading from file
     call      fopen
     pushq     %rax

     movq      %rax, %rdi #move the adress of the beggining of the file
     call      ftell # find the length of the file
     pushq     %rax #push the length to the stack 

     movq      $buff,%rdi
     movq      $1,%rsi
     popq      %rdx
     popq      %rcx
     call      fread 

     movq      %rcx,%rdi
     call      fclose

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

     #movq      $buff,%r9
     #leaq      1024(%r9),%rsi

     #movq      $format,%rdi
    # movq      $0,%rax
     #call      printf

     movq      $0,%rdi
     call      exit