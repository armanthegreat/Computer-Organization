.text
    hstring: .asciz "Hello World!\n"

.global main
    main:
        pushq %rbp
        movq %rsp, %rbp
        movq $hstring, %rdi
        movq $0, %rax
        call printf
        movq $0, %rdi
        call exit

