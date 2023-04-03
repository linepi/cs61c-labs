.globl map

.text
main:
    jal ra, create_default_list
    mv s0, a0
    jal ra, print_list
    # print a newline
    jal ra, print_newline

    # load your args
    mv a0, s0
    la a1, square

    # issue the call to map
    jal ra, map

    # print the list
    add a0, s0, x0
    jal ra, print_list
    jal ra, print_newline

    addi a0, x0, 10
    ecall #Terminate the program
    
map:
    addi sp, sp, -12
    sw ra, 8(sp)
    sw s1, 4(sp)
    sw s0, 0(sp)
    
    beq a0, x0, done    # If we were given a null pointer (address 0), we're done.

    add s0, a0, x0  # Save address of this node in s0
    add s1, a1, x0  # Save address of function in s1

    lw a0, 0(s0)
    jalr ra, s1, 0
    sw a0, 0(s0)

    lw a0, 4(s0)
    mv a1, s1

    jal ra, map
done:
    lw s0, 0(sp)
    lw s1, 4(sp)  
    lw ra, 8(sp)
    addi sp, sp, 12
    jr ra

square:
    mul a0 ,a0, a0
    jr ra

create_default_list:
    addi sp, sp, -12
    sw  ra, 0(sp)
    sw  s0, 4(sp)
    sw  s1, 8(sp)
    li  s0, 0       # pointer to the last node we handled
    li  s1, 0       # number of nodes handled
loop:   #do...
    li  a0, 8
    jal ra, malloc      # get memory for the next node
    
    slli t1, s1, 2
    sw  t1, 0(a0)   # node->value = 4 * i
    sw  s0, 4(a0)   # node->next = last
    mv s0, a0  # last = node
    addi    s1, s1, 1   # i++
    li t0, 10
    bne s1, t0, loop    # ... while i!= 10
    lw  ra, 0(sp)
    lw  s0, 4(sp)
    lw  s1, 8(sp)
    addi sp, sp, 12
    jr ra

print_list:
    bne a0, x0, printMeAndRecurse
    jr ra       # nothing to print
printMeAndRecurse:
    mv t0, a0  # t0 gets current node address
    
    lw  a1, 0(t0)   # a1 gets value in current node
    addi a0, x0, 1      # prepare for print integer ecall
    ecall
    addi    a1, x0, ' '     # a0 gets address of string containing space
    addi    a0, x0, 11      # prepare for print char syscall
    ecall
    
    lw  a0, 4(t0)   # a0 gets address of next node
    jal x0, print_list  # recurse. We don't have to use jal because we already have where we want to return to in ra

# modify a1, a0
print_newline:
    addi    a1, x0, '\n' # Load in ascii code for newline
    addi    a0, x0, 11
    ecall
    jr  ra


malloc:
    mv a1, a0
    li a0, 9
    ecall
    jr  ra
