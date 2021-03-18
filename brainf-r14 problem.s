
.text
printformar: .asciz "%c"
scanformat: .asciz "%lc"

.global brainfuck

# Main subroutine
brainfuck:
  pushq %rbp          # Prolog for the stack
  movq %rsp, %rbp

  movq %rdi, %r12     # %rdi has my char so I move it to my pointer (%r12)

  movq $999999, %rdi  # Creating new cells in %rdi to store the characters
  movq $1 , %rsi      # The size of each cell is 1 byte (8bit) 
  call calloc         # Calling the C function (we need the two lines above for this function)

  movq %rax, %r13     # %r13 execute instructions
  movq $0, %r14       # Initialize %r14 (this requires less time than moving 0 in the register)
                      # %r14 is my counter and I need to initialize it to use it later

  #decq %r12           # Decrementing the pointer (now its not pointing at anything)

operations:
  #incq  %r12          # Incrementing the pointer again (now its pointing at the first cell)
  
  movb  (%r12), %r15b   # Copy the value inside the pointer (in 8 bits because is a character) to the reg %r15b

  cmpb  $0, %r15b       # If it is 0 then end the program
  je    end

  cmpb  $43, %r15b      # If it is + then go to add
  je    add

  cmpb  $45, %r15b      # If it is - then go to min
  je    min

  cmpb  $60, %r15b      # If it is < then go to previous
  je    previous

  cmpb  $62, %r15b      # If it is > then go to next
  je    next

  cmpb  $44, %r15b      # If it is , then go to input
  je    input

  cmpb  $46, %r15b      # If it is . then go to output
  je    output

  cmpb  $91, %r15b      # If it is [ then go to lpstart
  je    lpstart

  cmpb  $93, %r15b      # If it is ] then go to lpend
  je    lpend

  jmp   operations        # Go back to the loop

  add:
  incb  (%r13)
  incq  %r12        # Add 1 to the value in %r13
  jmp   operations        # Jump back to the operations

  min:
  decb  (%r13) 
  incq  %r12         # Decrement the value in %r13 by 1
  jmp   operations        # Jump back to the operations

  next:
  inc %r13  
  incq  %r12           # Increment %r13 by 1 position
  jmp operations          # Jump back to the operations
  
  previous:
  dec %r13 
  incq  %r12            # Decrement %r13 by 1 position
  jmp operations          # Jump back to the operations

  lpstart:
  cmpb  $0, (%r13)
  #je     lp    # If the value stored by %r13 is zero then go to lpskip
  je    lpskip        # Jump to lpskip loop

  pushq   %r12 
  incq  %r12        # Push %r12 into the stack (it has the character that I need)
  jmp   operations        # Jump back to operations

  lp:
      incq  %r12
      jmp   lpskip

  lpskip:             
  #incq  %r12          # Increment %r12 by 1 to fetch the next instruction 
  movb  (%r12), %r15b   # Copy the character inside %r12 to %r15b

  cmpb  $91, %r15b      # If it is [ then go to inc_counter
  je    inc_counter

  cmpb  $93, %r15b      # If it is ] then go to dec_counter
  je    dec_counter

  incq  %r12 
  jmp   lpskip        # Jump back to lpskip

  inc_counter:
  incq  %r14 
  incq  %r12          # Add 1 to the counter to move it to the next cell
  jmp   lpskip        # Jump back to lpskip

  dec_counter:
  incq  %r12 

  #cmpq  $2, %r14      # Compare 0 to %r14
  #jle    lps
  decq    %r14

  cmpq $0,%r14
  je    operations        # If the counter is 0 then go back to operations

          # Decrement %r14 to move to the previous cell
  jmp   lpskip        # Go back to lpskip

  lps:
    movq    $0,%r14
    jmp     lpskip

  lpend:
  popq  %r12          # Take out of the stack the value stored in %r12
  incq  %r12          # Decrement the pointer to the starting position
  jmp   operations        # Goes back to operations

  output:
  movq    $printformar, %rdi    # Loads the character into %rdi
  movq    (%r13), %rsi     # Copy the value stored in %r13 to %rsi
  movq    $0, %rax          # Clear %rax
  call    printf           # Prints the result of the cells till they are all on the screen 

  incq  %r12 
  jmp     operations           # Jump back to the operations

  input:
  movq    $scanformat, %rdi    # Loads the character into %rdi
  movq    %r13, %rsi       # Copy the value of %r13 to %rsi
  movq    $0, %rax        # Initialize the %rax register
  call    scanf            # Scan the number
  
  incq  %r12 
  jmp     operations           # Jump back to the operations

end:                    # Clear the stack and end the result
  movq %rbp, %rsp
  popq %rbp
  ret

