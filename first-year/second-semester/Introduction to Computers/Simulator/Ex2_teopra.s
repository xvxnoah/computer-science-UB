.data
x:
.word 98
.half 12
.byte 32

.text
la a0, x
lw a1, 0(a0)
lw a2, 4(a0)
add a3, a1, a2
sw a3, 12(a0)