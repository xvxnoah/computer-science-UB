.data
uno:
.word 21
.word 22

.text
la a0, uno
principi:
lw a1, 0(a0)
lw a2, 4(a0)
sub a1, a1, a2
bnez a1, principi