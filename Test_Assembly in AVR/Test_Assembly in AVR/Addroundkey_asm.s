
/*
 * Addroundkey.s
 *
 * Created: 2020-04-08 오전 10:44:01
 *  Author: 김영범
 */ 

 #include "AVR_macro.s"

 .global AddRoundKey_asm

 AddRoundKey_asm:
	push r2
	push r3
	push r17
	push r26
	push r27
	push r28
	push r29
	push r30
	push r31
	/*
		state from r24 : r25  --> r26 : r27 ; X
		urkey from r22 : r23 -- > r28 : r29 ; Y 
	*/
	movw	r26,	r24 ;Y : state
	movw	r30,	r24 ;Z : state
	movw	r28,	r22 ;X : usrkey
	ldi		r17,	16	
	
loop:
	ld	r2,		Y+
	ld	r3,		X+
	eor	r2,		r3
	st	Z+,		r2
	dec	r17
	brne loop

	pop r31
	pop r30
	pop r29
	pop r28
	pop r27
	pop r26
	pop r17
	pop r3
	pop r2
	ret

