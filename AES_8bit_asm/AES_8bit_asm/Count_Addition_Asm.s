
/*
 * Count_Addition_Asm.s
 *
 * Created: 2020-04-08 오전 11:37:19
 *  Author: 김영범
 */ 
 #include "AVR_macro.s"
 /*
	count in from r24 :r25 --> to r28 : r29 Y
 */
 .global Count_Addition_Asm

 Count_Addition_Asm:
	push r29
	push r28
	push r20
	push r19
	push r18
	push r17
	push r16

	movw	r28,	r24 ;Y : state
	ldi		r20,	0x01
	clc

	ldd		r19,	Y+15
	adc		r19,	r20
	ldd		r18,	Y+14
	adc		r18,	r1
	ldd		r17,	Y+13
	adc		r17,	r1
	ldd		r16,	Y+12
	adc		r16,	r1

	std		Y+15,	r19
	std		Y+14,	r18
	std		Y+13,	r17
	std		Y+12,	r16
	
	pop r16
	pop r17
	pop r18
	pop r19
	pop r20
	pop r28
	pop r29
	ret