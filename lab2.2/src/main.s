	.syntax unified
	.cpu cortex-m4
	.thumb

.data
	infix_expr: .asciz "{-99+ [ 10 + 20-0] }"
	user_stack_bottom: .zero 128

.text
	.global main
	#infix_expr: .asciz "{-99+ [ 10 + 20-0] }"
	#.align

main:
	bl stack_init
	ldr R1, =infix_expr
	bl pare_check

L: b L

stack_init:
	ldr R0, =user_stack_bottom
	add R0, R0, #127
	msr msp, R0
	bx lr

pare_check:
	mov R3, #0
loop:
	ldrb R2, [R1, R3]
	cmp R2, #0
	beq out

	# [
	cmp R2, #91
	IT EQ
	pusheq {R2}
	beq continue

	# {
	cmp R2, #123
	IT EQ
	pusheq {R2}
	beq continue

	# ]
	cmp R2, #93
	bne next
	cmp sp, R0
	beq error
	pop {R4}
	cmp R4, #91
	bne error

next:
	# }
	cmp R2, #125
	bne continue
	cmp sp, R0
	beq error
	pop {R4}
	cmp R4, #123
	bne error

continue:
	add R3, R3, #1
	b loop

error:
	mov R0, #-1
out:
	cmp sp, R0
	IT NE
	movne R0, #-1
	IT EQ
	moveq R0, #0
	bx lr
