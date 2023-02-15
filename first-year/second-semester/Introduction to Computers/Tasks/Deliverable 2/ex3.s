.data
A: .word 13
B: .word 13

.text
	add a0, zero, zero
	la a7, A
	lw a1, 0(a7)
	lw a2, 4(a7)
	
	beq a1, a2, mult
	bgt a1, a2, suma
	blt a1, a2, resta

mult:
	mul a0, a1, a2
	j end

suma:
	add a0, a1, a2
	j end

resta:
	sub a0, a2, a1
	j end

end:
	nop
	