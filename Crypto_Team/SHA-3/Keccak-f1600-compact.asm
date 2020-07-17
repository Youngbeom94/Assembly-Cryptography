; The Keccak sponge function, designed by Guido Bertoni, Joan Daemen,
; Michaël Peeters and Gilles Van Assche. For more information, feedback or
; questions, please refer to our website: http://keccak.noekeon.org/
;
; Implementation by Ronny Van Keer, hereby denoted as "the implementer".
;
; To the extent possible under law, the implementer has waived all copyright
; and related or neighboring rights to the source code in this file.
; http://creativecommons.org/publicdomain/zero/1.0/
;
; Description: Keccak-f[1600] permutation, compact version.
; Version 1 - June 2012.

#define ROT_BIT(a)	 ((a) & 7)
#define ROT_BYTE(a)	 (((a)/8 + !!(((a)%8) > 4)) & 7)

KeccakF_RhoPiConstants:
	.db		ROT_BIT( 1), ROT_BYTE( 3),	10 * 8, \
			ROT_BIT( 3), ROT_BYTE( 6),	 7 * 8, \
			ROT_BIT( 6), ROT_BYTE(10),	11 * 8, \
			ROT_BIT(10), ROT_BYTE(15),	17 * 8, \
			ROT_BIT(15), ROT_BYTE(21),	18 * 8, \
			ROT_BIT(21), ROT_BYTE(28),	 3 * 8, \
			ROT_BIT(28), ROT_BYTE(36),	 5 * 8, \
			ROT_BIT(36), ROT_BYTE(45),	16 * 8, \
			ROT_BIT(45), ROT_BYTE(55),	 8 * 8, \
			ROT_BIT(55), ROT_BYTE( 2),	21 * 8, \
			ROT_BIT( 2), ROT_BYTE(14),	24 * 8, \
			ROT_BIT(14), ROT_BYTE(27),	 4 * 8, \
			ROT_BIT(27), ROT_BYTE(41),	15 * 8, \
			ROT_BIT(41), ROT_BYTE(56),	23 * 8, \
			ROT_BIT(56), ROT_BYTE( 8),	19 * 8, \
			ROT_BIT( 8), ROT_BYTE(25),	13 * 8, \
			ROT_BIT(25), ROT_BYTE(43),	12 * 8, \
			ROT_BIT(43), ROT_BYTE(62),	 2 * 8, \
			ROT_BIT(62), ROT_BYTE(18),	20 * 8, \
			ROT_BIT(18), ROT_BYTE(39),	14 * 8, \
			ROT_BIT(39), ROT_BYTE(61),	22 * 8, \
			ROT_BIT(61), ROT_BYTE(20),	 9 * 8, \
			ROT_BIT(20), ROT_BYTE(44),	 6 * 8, \
			ROT_BIT(44), ROT_BYTE( 1),	 1 * 8

KeccakF_RoundConstants:
	.db		0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
			0x82, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
			0x8a, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, \
			0x00, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80, \
			0x8b, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
			0x01, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, \
			0x81, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80, \
			0x09, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, \
			0x8a, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
			0x88, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
			0x09, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, \
			0x0a, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, \
			0x8b, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, \
			0x8b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, \
			0x89, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, \
			0x03, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, \
			0x02, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, \
			0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, \
			0x0a, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
			0x0a, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80, \
			0x81, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80, \
			0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, \
			0x01, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, \
			0x08, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80, \
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
	ldi		TCIPx, 5*8
KeccakInitialPrepTheta_Loop:
	ld		r0, Y
	adiw	rY, 40
	ld		rTemp, Y
	adiw	rY, 40
	eor		r0, rTemp
	ld		rTemp, Y
	adiw	rY, 40
	eor		r0, rTemp
	ld		rTemp, Y
	eor		r0, rTemp
	ldd		rTemp, Y+40
	eor		r0, rTemp
	st		Z+, r0
	subi	rY, 119
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

	ldi		TCminus, low(SRAM_ADD_MEM+4*8)
	ldi		TCminus1, high(SRAM_ADD_MEM+4*8)
	ldi		TCplus, low(SRAM_ADD_MEM+1*8)
	ldi		TCplus1, high(SRAM_ADD_MEM+1*8)
	ldi		rY, low(SRAM_STATE)
	ldi		rY1, high(SRAM_STATE)

	ldi		TCcoordX, 0x16
KeccakTheta_Loop1:
	ld		rTemp0, X+	
	ld		rTemp1, X+	
	ld		rTemp2, X+	
	ld		rTemp3, X+	
	ld		rTemp4, X+	
	ld		rTemp5, X+	
	ld		rTemp6, X+	
	ld		rTemp7, X+	

	lsl		rTemp0
	rol		rTemp1
	rol		rTemp2
	rol		rTemp3
	rol		rTemp4
	rol		rTemp5
	rol		rTemp6
	rol		rTemp7
	adc		rTemp0, zero

	ld		r0, Z+	
	eor		rTemp0, r0
	ld		r0, Z+	
	eor		rTemp1, r0
	ld		r0, Z+	
	eor		rTemp2, r0
	ld		r0, Z+	
	eor		rTemp3, r0
	ld		r0, Z+	
	eor		rTemp4, r0
	ld		r0, Z+	
	eor		rTemp5, r0
	ld		r0, Z+	
	eor		rTemp6, r0
	ld		r0, Z+	
	eor		rTemp7, r0

	ldi		TCcoordY, 5
KeccakTheta_Loop2:
	ld		r0, Y
	eor		r0, rTemp0
	st		Y+, r0
	ld		r0, Y
	eor		r0, rTemp1
	st		Y+, r0
	ld		r0, Y
	eor		r0, rTemp2
	st		Y+, r0
	ld		r0, Y
	eor		r0, rTemp3
	st		Y+, r0
	ld		r0, Y
	eor		r0, rTemp4
	st		Y+, r0
	ld		r0, Y
	eor		r0, rTemp5
	st		Y+, r0
	ld		r0, Y
	eor		r0, rTemp6
	st		Y+, r0
	ld		r0, Y
	eor		r0, rTemp7
	st		Y+, r0
	adiw	rY, 32

	dec		TCcoordY
	brne	KeccakTheta_Loop2

	subi	rY, 200-8
	sbc		rY1, zero

	lsr		TCcoordX
	brcc	local1
	breq	KeccakTheta_End
	rjmp	KeccakTheta_Loop1
local1:
	cpi		TCcoordX, 0x0B
	brne	local2
	sbiw	TCminus, 40
	rjmp	KeccakTheta_Loop1
local2:
	sbiw	TCplus, 40
	rjmp	KeccakTheta_Loop1

KeccakTheta_End:	
	#undef	TCplus
	#undef	TCminus
	#undef	TCcoordX
	#undef	TCcoordY


	//	Rho Pi
	#define	RPindex			rTempTer0
	#define	RPTemp			rTempTer1

	sbiw	rY, 32

	ld		rTemp0, Y+	
	ld		rTemp1, Y+	
	ld		rTemp2, Y+	
	ld		rTemp3, Y+	
	ld		rTemp4, Y+	
	ld		rTemp5, Y+	
	ld		rTemp6, Y+	
	ld		rTemp7, Y+	
	
	ldi		rZ, low(KeccakF_RhoPiConstants<<1)
	ldi		rZ1, high(KeccakF_RhoPiConstants<<1)

KeccakRhoPi_Loop:
	;	do bit rotation
	lpm		RPTemp, Z+		;get nuber of bits to rotate
	cpi		RPTemp, 5
	brcs	rotate64_nbit_leftOrNot
	neg		RPTemp
	andi	RPTemp, 3

rotate64_nbit_right:
	bst		rTemp0, 0
	ror		rTemp7
	ror		rTemp6
	ror		rTemp5
	ror		rTemp4
	ror		rTemp3
	ror		rTemp2
	ror		rTemp1
	ror		rTemp
	bld		rTemp7, 7
	dec		RPTemp
	brne	rotate64_nbit_right
	rjmp	KeccakRhoPi_RhoBitRotateDone

rotate64_nbit_leftOrNot:
	tst		RPTemp
	breq	KeccakRhoPi_RhoBitRotateDone
rotate64_nbit_left:
	lsl		rTemp0
	rol		rTemp1
	rol		rTemp2
	rol		rTemp3
	rol 	rTemp4
	rol		rTemp5
	rol		rTemp6
	rol		rTemp7
	adc		rTemp, r1
	dec		RPTemp
	brne	rotate64_nbit_left

KeccakRhoPi_RhoBitRotateDone:
	lpm		r0, Z+		;get number of bytes to rotate
	lpm		RPindex, Z+		;get index in state
	ldi		rY, low(SRAM_STATE)
	ldi		rY1, high(SRAM_STATE)
	add		rY, RPindex
	adc		rY1, zero
	
	ldi		rX, 10 ;rTempBis
	add		rX, r0
	mov		rX1, zero
	ldi		RPTemp, 8
KeccakRhoPi_PiByteRotLoop:
	ld		r0, Y+
	st		X+, r0
	cpi		rX, 18 ;rTempBis+8
	brne	KeccakRhoPi_PiByteRotFirst
	ldi		rX, 10 ;rTempBis
KeccakRhoPi_PiByteRotFirst:
	dec		RPTemp
	brne	KeccakRhoPi_PiByteRotLoop

	sbiw	rY, 8
	st		Y+, rTemp0
	st		Y+, rTemp1
	st		Y+, rTemp2
	st		Y+, rTemp3
	st		Y+, rTemp4
	st		Y+, rTemp5
	st		Y+, rTemp6
	st		Y+, rTemp7

	movw	rTemp0, rTempBis0
	movw	rTemp2, rTempBis2
	movw	rTemp4, rTempBis4
	movw	rTemp6, rTempBis6

KeccakRhoPi_RhoDone:
	subi	RPindex, 			8
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

	ldi		CIPTz, 8
KeccakChiIotaPrepareTheta_zLoop:
	mov		CIPTc0, zero
	mov		CIPTc1, zero
	movw	CIPTc2, CIPTc0
	mov		CIPTc4, zero

	ldi		CIPTy, 5
KeccakChiIotaPrepareTheta_yLoop:
	ld		CIPTa0, Y
	ldd		CIPTa1, Y+8
	ldd		CIPTa2, Y+16
	ldd		CIPTa3, Y+24
	ldd		CIPTa4, Y+32
	
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
	std		Y+8, r0

	;*(p+16) = a2 ^= ((~a3) & a4); c2 ^= a2;
	mov		r0, CIPTa3
	com		r0      			
	and		r0, CIPTa4
	eor		r0, CIPTa2
	eor		CIPTc2, r0
	std		Y+16, r0

	;*(p+24) = a3 ^= ((~a4) & a0); c3 ^= a3;
	mov		r0, CIPTa4
	com		r0      			
	and		r0, CIPTa0
	eor		r0, CIPTa3
	eor		CIPTc3, r0
	std		Y+24, r0

	;*(p+32) = a4 ^= ((~a0) & a1); c4 ^= a4;
	com		CIPTa0
	and		CIPTa0, CIPTa1
	eor		CIPTa0, CIPTa4
	eor		CIPTc4, CIPTa0
	std		Y+32, CIPTa0
	
	adiw	rY, 40	
	dec		CIPTy
	brne	KeccakChiIotaPrepareTheta_yLoop

	subi	rY, 200
	sbc		rY1, zero	

	lpm		r0, Z+		;Round Constant
	ld		CIPTa0, Y
	eor		CIPTa0, r0
	st		Y+, CIPTa0
                			
	movw	pRound, rZ
	movw	rZ, rX
	eor		CIPTc0, r0
	st		Z+,   CIPTc0	
	std		Z+7,  CIPTc1
	std		Z+15, CIPTc2
	std		Z+23, CIPTc3
	std		Z+31, CIPTc4
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
