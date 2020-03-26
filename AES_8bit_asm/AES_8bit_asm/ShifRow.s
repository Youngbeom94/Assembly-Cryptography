
/*
 * ShifRow.s
 *
 * Created: 2020-03-25 오전 11:38:18
 *  Author: 김영범
 */ 
 .macro regBackupAdd
	.irp i,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14, 28, 29
		push	\i
	.endr
 .endm

 .macro regRetriveveAdd
	.irp i, 29, 28,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0
		pop	\i
	.endr
 .endm
 .global ShiftRow_asm

ShiftRow_asm:

	regBackupAdd

	movw	r30,	r24
	
	ldd		r17,	Z+1
	ldd		r16,	Z+5
	ldd		r15,	Z+9
	ldd		r14,	z+13

	std		Z+1,	r16
	std		Z+5,	r15
	std		Z+9,	r14
	std		Z+13,	r17
	;2번째 Shift Row

	ldd		r17,	Z+2
	ldd		r16,	Z+6
	ldd		r15,	Z+10
	ldd		r14,	z+14

	std		Z+2,	r15
	std		Z+6,	r14
	std		Z+10,	r17
	std		Z+14,	r16
	;3번째 Shift Row

	ldd		r17,	Z+3
	ldd		r16,	Z+7
	ldd		r15,	Z+11
	ldd		r14,	z+15

	std		Z+3,	r14
	std		Z+7,	r17
	std		Z+11,	r16
	std		Z+15,	r15
	;4번째 Shift Row

	regRetriveveAdd

	ret