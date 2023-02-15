.data
Dades0: .word 0b0000110000001011 #3083
Dades1: .word 0b0000000000010001 #17

.text
	sub a0, a0, a0
	la a7, Dades0
	lw a1, 0(a7) # carreguem el valor de Dades0 al registre a1
	lw a2, 4(a7) # carreguem el valor de Dades1 al registre a2

loop:
	add a0, a0, a1 # A0 <= A0+A1
	addi a2, a2, -1 # decrementem el valor de A2
	bgt a2, zero, loop # salta a loop si el registre a2 > zero

end:
	nop