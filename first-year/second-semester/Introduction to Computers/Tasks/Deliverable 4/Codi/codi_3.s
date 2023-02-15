.data
resultat: .word 0

.text
main:
	add a3, zero, zero
	add a7, zero, zero
	addi a2, zero, 4
	add a3, a2, a3
	addi a7, a7, -1
	bgt a7, zero, salta

salta:
	la a0, resultat
	sw a3, 0(a0)