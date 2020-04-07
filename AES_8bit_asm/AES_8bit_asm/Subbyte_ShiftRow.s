
/*
 * Subbyte_ShiftRow.s
 *
 * Created: 2020-04-07 오후 8:00:05
 *  Author: 김영범
 */ 
 
/*
 * MixColumns.s
 *
 * Created: 2020-03-25 오후 2:11:23
 *  Author: 김영범
 */ 
 .include "m8515def.inc"


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

 .global Subbyte_ShiftRows_asm


Subbyte_ShiftRows_asm:

	regBackupAdd

	;void Subbyte_ShiftRows_asm(u8 *state,u8 * sbox);
	/*
		state -> r24 : r25
		sbox ->  r22 : r23
	*/

	movw r30,	r24 ; Z
	movw r28,	r24 ; Y
	ldi	 r16,	4
	ldi  r17,	0x1b

loop:
	;2 3 1 1 
	ld r2,		Y+	;2
	ld r4,		Y+	;3
	ld r5,		Y+	;1
	ld r6,		Y+	;1
	
	mov r3,		r2
	eor r3,		r4
	mov r7,		r3 ; r7 = r3
	add r7,		r7 ; <<1
	mov r8,		r3 ; r8 = r3
	add	r8,		r8
	eor r8,		r8
	adc	r8,		r8 ; >>7 & 0x01 
	mul	r8,		r17 ; (x>>7)&1 * 0x1b
	eor	r0,		r7 
	eor r0,		r4 
	eor r0,		r5
	eor r0,		r6
	st Z+,		r0 ; -------------------[0]

	; 1 2 3 1 
	mov r3,		r4
	eor r3,		r5
	mov r7,		r3 ; r7 = r3
	add r7,		r7 ; <<1
	mov r8,		r3 ; r8 = r3
	add	r8,		r8
	eor r8,		r8
	adc	r8,		r8 ; >>7 & 0x01 
	mul	r8,		r17 ; (x>>7)&1 * 0x1b
	eor	r0,		r7 
	eor r0,		r2
	eor r0,		r5
	eor r0,		r6
	st Z+,		r0 ; -------------------[1]


	; 1 1 2 3 
	mov r3,		r5
	eor r3,		r6
	mov r7,		r3 ; r7 = r3
	add r7,		r7 ; <<1
	mov r8,		r3 ; r8 = r3
	add	r8,		r8
	eor r8,		r8
	adc	r8,		r8 ; >>7 & 0x01 
	mul	r8,		r17 ; (x>>7)&1 * 0x1b
	eor	r0,		r7 
	eor r0,		r2
	eor r0,		r4
	eor r0,		r6
	st Z+,		r0 ; -------------------[2]

	; 3 1 1 2 
	mov r3,		r6
	eor r3,		r2
	mov r7,		r3 ; r7 = r3
	add r7,		r7 ; <<1
	mov r8,		r3 ; r8 = r3
	add	r8,		r8
	eor r8,		r8
	adc	r8,		r8 ; >>7 & 0x01 
	mul	r8,		r17 ; (x>>7)&1 * 0x1b
	eor	r0,		r7 
	eor r0,		r2
	eor r0,		r4
	eor r0,		r5
	st Z+,		r0 ; -------------------[3]
	dec		r16
	brne loop

	regRetriveveAdd

	ret