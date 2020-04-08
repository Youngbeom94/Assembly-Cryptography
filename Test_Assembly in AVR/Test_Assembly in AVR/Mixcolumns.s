#include "AVR_macro.s"
 
 .global MixColumns_asm
MixColumns_asm:

	regBackupAdd
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