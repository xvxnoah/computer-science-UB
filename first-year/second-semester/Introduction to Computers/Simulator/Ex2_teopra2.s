.data
x:
.word 98
.half 12
.byte 32

.text
la a0, x
lw a1, 0(a0)
lw a2, 4(a0)
beq a1, a2, PROD
blt a1, zero, a1_ZERO
blt a2, zero, SUMA
sub a3, a1, a2
j FINAL

#comentari

PROD:
mul a3, a1, a2
j FINAL

a1_ZERO:
blt a2, zero, CHANGE
j SUMA


CHANGE:
sub a3, zero, a1
sub a4, zero, a2
sw a3, 12(a0)
sw a4, 16(a0)
j FINAL

SUMA:
add a3, a1, a2
j FINAL

FINAL:
j FINAL