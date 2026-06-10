# testeRed.s testa: add, sub, and, or, slt, lw, sw E beq, jal, jalr, lui, addi, sll, slli
# Sucesso: a0=0 | Falha: a0=1

        .data
mem:    .word   0xDEADBEEF	    # usada nos testes lw/sw

        .text
        .globl  _start
_start:
# lui
        lui     t0, 1               # t0 = 0x00001000
        li      t1, 0x00001000
        bne     t0, t1, fail

# addi
        addi    t0, zero, 10        # t0 = 10
        addi    t0, t0,  -3         # t0 = 7
        li      t1, 7
        bne     t0, t1, fail

# add
        li      t0, 20
        li      t1, 22
        add     t2, t0, t1          # t2 = 42
        li      t3, 42
        bne     t2, t3, fail

# sub
        li      t0, 50
        li      t1,  8
        sub     t2, t0, t1          # t2 = 42
        bne     t2, t3, fail        # t3 ainda e 42

# and
        li      t0, 0xFF
        li      t1, 0x0F
        and     t2, t0, t1          # t2 = 0x0F
        bne     t2, t1, fail

# or
        li      t0, 0xF0
        li      t1, 0x0F
        or      t2, t0, t1          # t2 = 0xFF
        li      t3, 0xFF
        bne     t2, t3, fail

# slt
        li      t0, 3
        li      t1, 7
        slt     t2, t0, t1          # t2 = 1
        li      t3, 1
        bne     t2, t3, fail
        slt     t2, t1, t0          # t2 = 0
        bne     t2, zero, fail

# sll
        li      t0, 1
        li      t1, 4
        sll     t2, t0, t1          # t2 = 16
        li      t3, 16
        bne     t2, t3, fail

# slli
        slli    t2, t0, 5           # t2 = 1<<5 = 32
        li      t3, 32
        bne     t2, t3, fail

# sw / lw
        la      t0, mem
        li      t1, 0xABCD
        sw      t1, 0(t0)
        lw      t2, 0(t0)
        bne     t1, t2, fail

# beq
        li      t0, 5
        li      t1, 5
        beq     t0, t1, beq_ok
        j       fail
beq_ok:

# jal / jalr
        jal     ra, subrotina       # chama subrotina
        li      t3, 0xBEEF
        bne     t4, t3, fail

# sucesso
        li      a0, 0
        li      a7, 93
        ecall

subrotina:
        li      t4, 0xBEEF
        jalr    zero, ra, 0         # retorna (testa jalr)

fail:
        li      a0, 1
        li      a7, 93
        ecall
