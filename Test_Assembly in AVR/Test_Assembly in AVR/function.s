
/*
 * function.s
 *
 * Created: 2020-04-07 오후 5:59:39
 *  Author: 김영범
 */ 


 
/*
 */ 


 .macro regBackupAdd
	.irp i,0,3,4,5,6,7,8,16,17,28,29,30,31,
		push	\i
	.endr
 .endm

 .macro regRetriveveAdd
	.irp i,31,30,29,28,17,16,8,7,6,5,4,3,0
		pop	\i
	.endr
 .endm

 .global MixColumns_asm_Progm
MixColumns_asm_Progm:

	regBackupAdd
	movw r26,	r24 ; X
	movw r28,	r24 ; Y
	ldi	 r16,	4
	ldi  r17,	0x1b

	ldi	r30,	lo8(sbox2);!!!!!!!!!!!!!!!!
	ldi	r31,	hi8(sbox2);!!!!!!!!!!!!!!!!

loop:
	;2 3 1 1 
	ld r2,		Y+	;3
	ld r4,		Y+	;1
	ld r5,		Y+	;1
	ld r6,		Y+	;2

	mov r0,		r2
	eor r0,		r4
	mov r30,	r0
	lpm r0,		Z
	eor	r0,		r4
	eor	r0,		r5
	eor r0,		r6
	st X+,		r0 ; -------------------[0]

	; 1 2 3 1 
	mov r0,		r4
	eor r0,		r5
	mov r30,	r0
	lpm r0,		Z
	eor	r0,		r2
	eor	r0,		r5
	eor r0,		r6
	st X+,		r0  ; -------------------[1]


	; 1 1 2 3 
	mov r0,		r5
	eor r0,		r6
	mov r30,	r0
	lpm r0,		Z
	eor	r0,		r2
	eor	r0,		r4
	eor r0,		r6
	st X+,		r0  ; -------------------[2]

	; 3 1 1 2 
	mov r0,		r6
	eor r0,		r2
	mov r30,	r0
	lpm r0,		Z
	eor	r0,		r2
	eor	r0,		r4
	eor r0,		r5
	st X+,		r0 ; -------------------[3]
	dec		r16
	brne loop

	regRetriveveAdd

	ret



	
/*
 * MixColumns.s
 *
 * Created: 2020-03-25 오후 2:11:23
 *  Author: 김영범
 */ 

