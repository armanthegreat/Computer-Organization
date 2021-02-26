.text
    hstring: .asciz "Assignment 2: inout\n"
    

    inout:
        

.global main
    main:
        pushq %rbp
        movq %rsp, %rbp
        movq $hstring, %rdi
        movq $0, %rax
        call printf
        call inout
        movq $0, %rdi
        call exit
        

    
       




    

