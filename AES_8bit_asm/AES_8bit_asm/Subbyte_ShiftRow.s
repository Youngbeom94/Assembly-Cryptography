
/*
 * Subbyte_ShiftRow.s
 *
 * Created: 2020-04-08 오전 9:32:29
 *  Author: 김영범
 */ 

 #include "AVR_macro.s"
 /*
	state in from r24 : r25 --> to r28 : r29 Y
	sbox in r30 : r31
 */

 .global Subbyte_ShiftRows_asm

 Subbyte_ShiftRows_asm:

	regBackupAdd2
	movw	r28,	r24 ;Y : state
	movw	r26,	r24 ;X : state
	ldi	r30,	lo8(sbox)
	ldi	r31,	hi8(sbox)
	
	.irp i,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
		ld r30,		Y+
		lpm	r\i,	Z
	.endr

	.irp i,0,5,10,15,4,9,14,3,8,13,2,7,12,1,6,11
		st X+,	r\i
	.endr


	regRetriveveAdd2
	ret