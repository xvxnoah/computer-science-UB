.data
base: .word 4
altura: .word 8
divisor: .word 2
resultat: .word 0

.text
	la a0, base
	lw a1, 0(a0)
	lw a2, 4(a0)
	lw a3, 8(a0)
	
	add a4, zero, zero
	mul a4, a1, a2
	div a4, a4, a3
	sw a4, 12(a0) 