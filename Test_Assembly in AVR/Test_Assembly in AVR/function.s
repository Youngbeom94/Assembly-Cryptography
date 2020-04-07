
/*
 * function.s
 *
 * Created: 2020-04-07 오후 5:59:39
 *  Author: 김영범
 */ 


 
/*
 * MixColumns.s
 *
 * Created: 2020-03-25 오후 2:11:23
 *  Author: 김영범
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



	.global test


	test:
	regBackupAdd


	
	LDi r30, sbox
	ldi r31, hi8(sbox)
	lpm r20, Z+
	lpm r21, Z+

	movw r28, r24
	
	ld r17, Z+
	ld r18, Z+
	ld r19, Z+
	ld r13, Y+
	ld r14, Y+
	ld r15, Y+

	
	

	regRetriveveAdd
		ret