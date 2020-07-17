; The Keccak sponge function, designed by Guido Bertoni, Joan Daemen,
; Michaël Peeters and Gilles Van Assche. For more information, feedback or
; questions, please refer to our website: http://keccak.noekeon.org/
;
; Implementation by Ronny Van Keer and Gilles Van Assche, hereby denoted as "the implementer".
;
; To the extent possible under law, the implementer has waived all copyright
; and related or neighboring rights to the source code in this file.
; http://creativecommons.org/publicdomain/zero/1.0/
;
; Description: Keccak-f[400] permutation, derived from the Keccak-f[1600] implementation, compact version.
; Version 1 - June 2012.

#define ROT_BIT(a)	 ((a) & 7)
#define ROT_BYTE(a)	 (((a)/8 + !!(((a)%8) > 4)) & 1)
#define PI(a)		 ((a) * 2)

KeccakF_RhoPiConstants:
	.db		ROT_BIT( 1), ROT_BYTE( 3),	PI(10), \
			ROT_BIT( 3), ROT_BYTE( 6),	PI( 7), \
			ROT_BIT( 6), ROT_BYTE(10),	PI(11), \
			ROT_BIT(10), ROT_BYTE(15),	PI(17), \
			ROT_BIT(15), ROT_BYTE(21),	PI(18), \
			ROT_BIT(21), ROT_BYTE(28),	PI( 3), \
			ROT_BIT(28), ROT_BYTE(36),	PI( 5), \
			ROT_BIT(36), ROT_BYTE(45),	PI(16), \
			ROT_BIT(45), ROT_BYTE(55),	PI( 8), \
			ROT_BIT(55), ROT_BYTE( 2),	PI(21), \
			ROT_BIT( 2), ROT_BYTE(14),	PI(24), \
			ROT_BIT(14), ROT_BYTE(27),	PI( 4), \
			ROT_BIT(27), ROT_BYTE(41),	PI(15), \
			ROT_BIT(41), ROT_BYTE(56),	PI(23), \
			ROT_BIT(56), ROT_BYTE( 8),	PI(19), \
			ROT_BIT( 8), ROT_BYTE(25),	PI(13), \
			ROT_BIT(25), ROT_BYTE(43),	PI(12), \
			ROT_BIT(43), ROT_BYTE(62),	PI( 2), \
			ROT_BIT(62), ROT_BYTE(18),	PI(20), \
			ROT_BIT(18), ROT_BYTE(39),	PI(14), \
			ROT_BIT(39), ROT_BYTE(61),	PI(22), \
			ROT_BIT(61), ROT_BYTE(20),	PI( 9), \
			ROT_BIT(20), ROT_BYTE(44),	PI( 6), \
			ROT_BIT(44), ROT_BYTE( 1),	PI( 1)

KeccakF_RoundConstants:
	.db		0x01, 0x00, \
			0x82, 0x80, \
			0x8a, 0x80, \
			0x00, 0x80, \
			0x8b, 0x80, \
			0x01, 0x00, \
			0x81, 0x80, \
			0x09, 0x80, \
			0x8a, 0x00, \
			0x88, 0x00, \
			0x09, 0x80, \
			0x0a, 0x00, \
			0x8b, 0x80, \
			0x8b, 0x00, \
			0x89, 0x80, \
			0x03, 0x80, \
			0x02, 0x80, \
			0x80, 0x00, \
			0x0a, 0x80, \
			0x0a, 0x00, \
			0xFF, 0		//terminator

//	Registers used in all routines
#define	zero			r1
#define	rX				r26
#define	rX1				r27
#define	rY				r28
#define rY1				r29
#define	rZ				r30
#define rZ1				r31

KeccakF:
	//	Variables used in multiple operations
	#define	rTemp		r2		// 8 regs (2-9)
	#define	rTemp0		r2
	#define	rTemp1		r3
	#define	rTemp2		r4
	#define	rTemp3		r5
	#define	rTemp4		r6
	#define	rTemp5		r7
	#define	rTemp6		r8
	#define	rTemp7		r9
	#define	rTempBis	r10		// 8 regs (10-17)
	#define	rTempBis0	r10
	#define	rTempBis1	r11
	#define	rTempBis2	r12
	#define	rTempBis3	r13
	#define	rTempBis4	r14
	#define	rTempBis5	r15
	#define	rTempBis6	r16
	#define	rTempBis7	r17
	#define	rTempTer	r18		// 2 regs (18-19)
	#define	rTempTer0	r18
	#define rTempTer1	r19
	#define	pRound		r20		// 2 regs (20-21)
	#define pRound1		r21

	//	Initial Prepare Theta
	#define	TCIPx				rTempTer
	
	clr		zero
	ldi		rZ, low(SRAM_ADD_MEM)
	ldi		rZ1, high(SRAM_ADD_MEM)		// Z points to 5 C lanes
	ldi		rY, low(SRAM_STATE)
	ldi		rY1, high(SRAM_STATE)		// Y points to the state
	ldi		TCIPx, 5*2
KeccakInitialPrepTheta_Loop:
	ld		r0, Y
	adiw	rY, 10
	ld		rTemp, Y
	adiw	rY, 10
	eor		r0, rTemp
	ld		rTemp, Y
	adiw	rY, 10
	eor		r0, rTemp
	ld		rTemp, Y
	eor		r0, rTemp
	ldd		rTemp, Y+10
	eor		r0, rTemp
	st		Z+, r0
	subi	rY, 29
	sbc		rY1, zero
	dec		TCIPx
	brne	KeccakInitialPrepTheta_Loop
	#undef	TCIPx

	ldi		pRound, low(KeccakF_RoundConstants<<1)
	ldi		pRound1, high(KeccakF_RoundConstants<<1)
Keccak_RoundLoop:

	//	Theta
	#define	TCplus			rX
	#define	TCplus1			rX1
	#define	TCminus			rZ
	#define	TCminus1		rZ1
	#define	TCcoordX		rTempTer
	#define	TCcoordY		rTempTer1

	ldi		TCminus, low(SRAM_ADD_MEM+4*2)
	ldi		TCminus1, high(SRAM_ADD_MEM+4*2)
	ldi		TCplus, low(SRAM_ADD_MEM+1*2)
	ldi		TCplus1, high(SRAM_ADD_MEM+1*2)
	ldi		rY, low(SRAM_STATE)
	ldi		rY1, high(SRAM_STATE)

	ldi		TCcoordX, 0x16
KeccakTheta_Loop1:
	ld		rTemp0, X+	
	ld		rTemp1, X+	

	lsl		rTemp0
	rol		rTemp1
	adc		rTemp0, zero

	ld		r0, Z+	
	eor		rTemp0, r0
	ld		r0, Z+	
	eor		rTemp1, r0

	ldi		TCcoordY, 5
KeccakTheta_Loop2:
	ld		r0, Y
	eor		r0, rTemp0
	st		Y+, r0
	ld		r0, Y
	eor		r0, rTemp1
	st		Y+, r0
	adiw	rY, 8

	dec		TCcoordY
	brne	KeccakTheta_Loop2

	subi	rY, 50-2
	sbc		rY1, zero

	lsr		TCcoordX
	brcc	local1
	breq	KeccakTheta_End
	rjmp	KeccakTheta_Loop1
local1:
	cpi		TCcoordX, 0x0B
	brne	local2
	sbiw	TCminus, 10
	rjmp	KeccakTheta_Loop1
local2:
	sbiw	TCplus, 10
	rjmp	KeccakTheta_Loop1

KeccakTheta_End:	
	#undef	TCplus
	#undef	TCminus
	#undef	TCcoordX
	#undef	TCcoordY


	//	Rho Pi
	#define	RPindex			rTempTer0
	#define	RPTemp			rTempTer1

	sbiw	rY, 8

	ld		rTemp0, Y+	
	ld		rTemp1, Y+	
	
	ldi		rZ, low(KeccakF_RhoPiConstants<<1)
	ldi		rZ1, high(KeccakF_RhoPiConstants<<1)

KeccakRhoPi_Loop:
	;	do bit rotation
	lpm		RPTemp, Z+		;get nuber of bits to rotate
	cpi		RPTemp, 5
	brcs	rotate16_nbit_leftOrNot
	neg		RPTemp
	andi	RPTemp, 3

rotate16_nbit_right:
	bst		rTemp0, 0
	ror		rTemp1
	ror		rTemp
	bld		rTemp1, 7
	dec		RPTemp
	brne	rotate16_nbit_right
	rjmp	KeccakRhoPi_RhoBitRotateDone

rotate16_nbit_leftOrNot:
	tst		RPTemp
	breq	KeccakRhoPi_RhoBitRotateDone
rotate16_nbit_left:
	lsl		rTemp0
	rol		rTemp1
	adc		rTemp, r1
	dec		RPTemp
	brne	rotate16_nbit_left

KeccakRhoPi_RhoBitRotateDone:
	lpm		r0, Z+		;get number of bytes to rotate
	lpm		RPindex, Z+		;get index in state
	ldi		rY, low(SRAM_STATE)
	ldi		rY1, high(SRAM_STATE)
	add		rY, RPindex
	adc		rY1, zero
	
	tst		r0
	brne	KeccakRhoPi_LoadSwapped
	ld		rTempBis0, Y+
	ld		rTempBis1, Y+
	rjmp	KeccakRhoPi_LoadDone
KeccakRhoPi_LoadSwapped:
	ld		rTempBis1, Y+
	ld		rTempBis0, Y+
KeccakRhoPi_LoadDone:
	sbiw	rY, 2
	st		Y+, rTemp0
	st		Y+, rTemp1

	movw	rTemp0, rTempBis0

KeccakRhoPi_RhoDone:
	subi	RPindex, 2
	brne	KeccakRhoPi_Loop

	#undef	RPindex			
	#undef	RPTemp


	//	Chi Iota prepare Theta
	#define	CIPTa0			rTemp
	#define	CIPTa1			rTemp1
	#define	CIPTa2			rTemp2
	#define	CIPTa3			rTemp3
	#define	CIPTa4			rTemp4
	#define	CIPTc0			rTempBis
	#define	CIPTc1			rTempBis1
	#define	CIPTc2			rTempBis2
	#define	CIPTc3			rTempBis3
	#define	CIPTc4			rTempBis4
	#define	CIPTz			rTempBis6
	#define	CIPTy			rTempBis7

	ldi		rY, low(SRAM_STATE)
	ldi		rY1, high(SRAM_STATE)
	ldi		rX, low(SRAM_ADD_MEM)
	ldi		rX1, high(SRAM_ADD_MEM)

	movw	rZ, pRound

	ldi		CIPTz, 2
KeccakChiIotaPrepareTheta_zLoop:
	mov		CIPTc0, zero
	mov		CIPTc1, zero
	movw	CIPTc2, CIPTc0
	mov		CIPTc4, zero

	ldi		CIPTy, 5
KeccakChiIotaPrepareTheta_yLoop:
	ld		CIPTa0, Y
	ldd		CIPTa1, Y+2
	ldd		CIPTa2, Y+4
	ldd		CIPTa3, Y+6
	ldd		CIPTa4, Y+8
	
	;*p      = t = a0 ^ ((~a1) & a2); c0 ^= t;
	mov		r0, CIPTa1
	com		r0      			
	and		r0, CIPTa2
	eor		r0, CIPTa0
	eor		CIPTc0, r0
	st		Y, r0
	
	;*(p+8)	 = t = a1 ^ ((~a2) & a3); c1 ^= t;
	mov		r0, CIPTa2
	com		r0      			
	and		r0, CIPTa3
	eor		r0, CIPTa1
	eor		CIPTc1, r0
	std		Y+2, r0

	;*(p+16) = a2 ^= ((~a3) & a4); c2 ^= a2;
	mov		r0, CIPTa3
	com		r0      			
	and		r0, CIPTa4
	eor		r0, CIPTa2
	eor		CIPTc2, r0
	std		Y+4, r0

	;*(p+24) = a3 ^= ((~a4) & a0); c3 ^= a3;
	mov		r0, CIPTa4
	com		r0      			
	and		r0, CIPTa0
	eor		r0, CIPTa3
	eor		CIPTc3, r0
	std		Y+6, r0

	;*(p+32) = a4 ^= ((~a0) & a1); c4 ^= a4;
	com		CIPTa0
	and		CIPTa0, CIPTa1
	eor		CIPTa0, CIPTa4
	eor		CIPTc4, CIPTa0
	std		Y+8, CIPTa0
	
	adiw	rY, 10	
	dec		CIPTy
	brne	KeccakChiIotaPrepareTheta_yLoop

	subi	rY, 50
	sbc		rY1, zero	

	lpm		r0, Z+		;Round Constant
	ld		CIPTa0, Y
	eor		CIPTa0, r0
	st		Y+, CIPTa0
                			
	movw	pRound, rZ
	movw	rZ, rX
	eor		CIPTc0, r0
	st		Z+,   CIPTc0	
	std		Z+1,  CIPTc1
	std		Z+3, CIPTc2
	std		Z+5, CIPTc3
	std		Z+7, CIPTc4
	movw	rX, rZ
	movw	rZ, pRound

	dec		CIPTz
	brne	KeccakChiIotaPrepareTheta_zLoop

	#undef	CIPTa0
	#undef	CIPTa1
	#undef	CIPTa2
	#undef	CIPTa3
	#undef	CIPTa4
	#undef	CIPTc0
	#undef	CIPTc1
	#undef	CIPTc2
	#undef	CIPTc3
	#undef	CIPTc4
	#undef	CIPTz
	#undef	CIPTy


	;Check for terminator
	lpm		r0, Z
	inc		r0					
	breq	Keccak_Done
	rjmp	Keccak_RoundLoop
Keccak_Done:
	ret

	#undef	rTemp			
	#undef	rTempBis	
	#undef	rTempTer
	#undef	pRound		

	#undef	zero			
	#undef	rX				
	#undef	rY				
	#undef	rZ				
