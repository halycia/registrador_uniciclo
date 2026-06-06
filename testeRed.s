.data
resultados: .space 64

.text
.globl main

main:

# add
# valor esperado = 30
    li t0, 10
    li t1, 20
    add t2, t0, t1

    la t3, resultados
    sw t2, 0(t3)

# sub
# valor esperado = 10
    sub t2, t1, t0
    sw t2, 4(t3)

# and
# valor esperado = 8
    li t0, 12
    li t1, 10
    and t2, t0, t1
    sw t2, 8(t3)

# or
# valor esperado = 14
    or t2, t0, t1
    sw t2, 12(t3)

# slt
# valor esperado = 1
    li t0, 5
    li t1, 8
    slt t2, t0, t1
    sw t2, 16(t3)

# lw
# valor esperado = 1
    lw t4, 16(t3)
    sw t4, 20(t3)

# sw
# valor esperado = 1234
    li t5, 1234
    sw t5, 24(t3)

# beq
# valor esperado = 1
    li t0, 7
    li t1, 7
    beq t0, t1, beq_ok

    li t2, 0
    j beq_fim

beq_ok:
    li t2, 1

beq_fim:
    sw t2, 28(t3)

# jal
# valor esperado = 111
    jal ra, func_jal

retorno_jal:
    sw a0, 32(t3)

# jalr
# valor esperado = 222
    la t0, func_jalr
    jalr ra, 0(t0)

retorno_jalr:
    sw a1, 36(t3)

# lui
# valor esperado = 0x12345000
    lui t0, 0x12345
    sw t0, 40(t3)

# addi
# valor esperado = 99
    addi t1, zero, 99
    sw t1, 44(t3)

# sll
# valor esperado = 16
    li t0, 1
    li t1, 4
    sll t2, t0, t1
    sw t2, 48(t3)

# slli
# valor esperado = 32
    li t0, 1
    slli t2, t0, 5
    sw t2, 52(t3)

fim:
    j fim

func_jal:
    li a0, 111
    jalr zero, 0(ra)

func_jalr:
    li a1, 222
    jalr zero, 0(ra)
