	.syntax unified
	.cpu cortex-m4
	.thumb

.data
	result: .word 0
	max_size: .word 0

.text
	m: .word 0x5E
	n: .word 0x60

.global main
main:
	ldr R0, =m
    ldr R0, [R0]
    ldr R1, =n
    ldr R1, [R1]
    ldr R2, =result
    ldr R7, =max_size

    mov R8, SP

	bl GCD

    str R3, [R2]
    str R9, [R7]
L: b L

GCD:
	push {lr}
	mov R9, SP
	sub R9, R8, R9

	# if(a == 0)
	cmp R0, #0
	# return b
	mov R3, R1
	beq return

	# if(b == 0)
	cmp R1, #0
	# return a
	mov R3, R0
	beq return

	# if(a % 2 == 0 && b % 2 == 0)
	and R4, R0, #1
	eor R4, R4, #1
	and R5, R1, #1
	eor R5, R5, #1
	and R6, R4, R5
	cmp R6, #1
	bne p1

	# return 2 * GCD(a >> 1, b >> 1)
	lsr R0, #1
	lsr R1, #1
	bl GCD
	lsl R3, #1
	b return

p1:
	# if(a % 2 == 0)
	cmp R4, #1
	bne p2

	# return GCD(a >> 1, b)
	lsr R0, #1
	bl GCD
	b return

p2:
	# if(b%2 == 0)
	cmp R5, #1
	bne p3

	# return GCD(a, b >> 1)
	lsr R1, #1
	bl GCD
	b return

p3:
	# return GCD(abs(a - b), min(a, b))
	sub R4, R0, R1
	cmp R4, 0
	IT LT
	neglt R4, R4
	IT LT
	movlt R5, R0
	IT GE
	movge R5, R1

	movs R0, R4
	movs R1, R5
	bl GCD
	b return
return:
	pop {lr}
    bx lr
