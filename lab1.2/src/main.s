	.syntax unified
	.cpu cortex-m4
	.thumb

.text
.global main
	.equ N, -3

main:
	movs R0, #N

	cmp R0, #0
	IT LT
	movlt R4, #-1
	blt L

	cmp R0, #100
	IT GT
	movgt R4, #-1
	bgt L

	bl fib

L: b L

fib:
	movs R1, #0
	movs R2, #1

	cmp R0, #0
	IT EQ
	moveq R4, #0
	beq out

	cmp R0, #1
	IT EQ
	moveq R4, #1
	beq out

	movs R1, #0
	movs R2, #0
	movs R4, #1
	sub R0, R0, #2

loop:
	cmp R0, #0
	blt out
	sub R0, R0, #1

	mov R1, R2
	mov R2, R4
	adds R4, R1, R2
	IT VS
	movvs R4, #-2
	bvs out

	b loop

out:
	bx lr
