.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0) # a0: n

    jal ra, factorial

    mv a1, a0
    li a0, 1
    ecall # Print Result

    li a1, '\n'
    li a0, 11
    ecall # Print newline

	li a0, 10
    ecall # Exit

factorial:
	addi sp, sp, -4
	sw ra, 0(sp)

	mv t0, a0
	li a0, 1
	beq t0, x0, end
	mv a0, t0
	# mul them
	addi sp, sp, -4
	sw a0, 0(sp)

	addi a0, a0, -1
	jal ra, factorial
	lw t0, 0(sp)
	mul a0, a0, t0

	addi sp, sp, 4
end:
	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra
