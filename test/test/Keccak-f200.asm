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
; Description: Keccak-f[200] permutation
; Version 1 - June 2012.

//	Registers used
#define	zero			r1

#define	c0				r14
#define	c1				r15
#define	c2				r16
#define	c3				r17
#define	c4				r18

#define	a0				r19
#define	a1				r20
#define	a2				r21
#define	a3				r22
#define	a4				r23

#define i				r24

#define	rX				r26
#define	rX1				r27
#define	rY				r28
#define	rY1				r29
#define	rZ				r30
#define	rZ1				r31

#define ROT_BIT(a)	 ((a) & 7)

.MACRO		RhoPi
.IF			@0==1
	lsl		@2
	adc		@2, zero
.ENDIF
.IF			@0==2
	lsl		@2
	adc		@2, zero
	lsl		@2
	adc		@2, zero
.ENDIF
.IF			@0==3
	swap	@2
	bst		@2, 0
	lsr		@2
	bld		@2, 7
.ENDIF
.IF			@0==4
	swap	@2
.ENDIF
.IF			@0==5
	lsl		@2
	adc		@2, zero
	swap	@2
.ENDIF
.IF			@0==6
	lsl		@2
	adc		@2, zero
	lsl		@2
	adc		@2, zero
	swap	@2
.ENDIF
.IF			@0==7
	bst		@2, 0
	lsr		@2
	bld		@2, 7
.ENDIF

	ldi		rY, low(SRAM_STATE+@1)
	ldi		rY1, high(SRAM_STATE+@1)
	ld		@3, Y
	st		Y, 	@2
.ENDMACRO

.MACRO		ChiPTheta
	mov		r0, @1
	com		r0
	and		r0, @2
	eor		r0, @0
	eor		@3, r0
	st		Y+, r0
.ENDMACRO

.MACRO		ChiPThetaS
	com		@1
	and		@1, @2
	eor		@1, @0
	eor		@3, @1
	st		Y+, @1
.ENDMACRO

KeccakF_RoundConstants:
	.db		0x01, \
			0x82, \
			0x8a, \
			0x00, \
			0x8b, \
			0x01, \
			0x81, \
			0x09, \
			0x8a, \
			0x88, \
			0x09, \
			0x0a, \
			0x8b, \
			0x8b, \
			0x89, \
			0x03, \
			0x02, \
			0x80

KeccakF:
	//	Initial Prepare Theta
	ldi		rY, low(SRAM_STATE)
	ldi		rY1, high(SRAM_STATE)		// Y points to the state

	ld		c0, Y+	;C0 = state[0+x]
	ld		c1, Y+	;C1 = state[1+x]
	ld		c2, Y+	;C2 = state[2+x]
	ld		c3, Y+	;C3 = state[3+x]
	ld		c4, Y+	;C4 = state[4+x]

	ldi		i, 4
KeccakF_initialThetaLoop:
	ld		r0, Y+	;C0 ^= state[5*(5-i)+0+x]
	eor		c0, r0
	ld		r0, Y+	;C1 ^= state[5*(5-i)+1+x]
	eor		c1, r0
	ld		r0, Y+	;C2 ^= state[5*(5-i)+2+x]
	eor		c2, r0
	ld		r0, Y+	;C3 ^= state[5*(5-i)+3+x]
	eor		c3, r0
	ld		r0, Y+	;C4 ^= state[5*(5-i)+4+x]
	eor		c4, r0
	dec		i
	brne	KeccakF_initialThetaLoop

	ldi		rY, low(SRAM_STATE)
	ldi		rY1, high(SRAM_STATE)
	ldi		rZ, low(KeccakF_RoundConstants<<1)
	ldi		rZ1, high(KeccakF_RoundConstants<<1)
Keccak_RoundLoop:

	//	Theta
	mov		a0, c1
	lsl		a0
	adc		a0, zero
	eor		a0, c4
	
	mov		a1, c2
	lsl		a1
	adc		a1, zero
	eor		a1, c0

	mov		a2, c3
	lsl		a2
	adc		a2, zero
	eor		a2, c1

	mov		a3, c4
	lsl		a3
	adc		a3, zero
	eor		a3, c2

	mov		a4, c0
	lsl		a4
	adc		a4, zero
	eor		a4, c3

	ldi		i, 5
KeccakF_ThetaLoop:
	ld		r0, Y
	eor		r0, a0
	st		Y+, r0
	ld		r0, Y
	eor		r0, a1
	st		Y+, r0
	ld		r0, Y
	eor		r0, a2
	st		Y+, r0
	ld		r0, Y
	eor		r0, a3
	st		Y+, r0
	ld		r0, Y
	eor		r0, a4
	st		Y+, r0
	dec i
	brne KeccakF_ThetaLoop


	//	Rho Pi
	ldi		rY, low(SRAM_STATE)
	ldi		rY1, high(SRAM_STATE)
	ldd		a0, Y+1
	RhoPi	ROT_BIT( 1), 10, a0, a1
	RhoPi	ROT_BIT( 3),  7, a1, a0
	RhoPi	ROT_BIT( 6), 11, a0, a1
	RhoPi	ROT_BIT(10), 17, a1, a0
	RhoPi	ROT_BIT(15), 18, a0, a1
	RhoPi	ROT_BIT(21),  3, a1, a0
	RhoPi	ROT_BIT(28),  5, a0, a1
	RhoPi	ROT_BIT(36), 16, a1, a0
	RhoPi	ROT_BIT(45),  8, a0, a1
	RhoPi	ROT_BIT(55), 21, a1, a0
	RhoPi	ROT_BIT( 2), 24, a0, a1
	RhoPi	ROT_BIT(14),  4, a1, a0
	RhoPi	ROT_BIT(27), 15, a0, a1
	RhoPi	ROT_BIT(41), 23, a1, a0
	RhoPi	ROT_BIT(56), 19, a0, a1
	RhoPi	ROT_BIT( 8), 13, a1, a0
	RhoPi	ROT_BIT(25), 12, a0, a1
	RhoPi	ROT_BIT(43),  2, a1, a0
	RhoPi	ROT_BIT(62), 20, a0, a1
	RhoPi	ROT_BIT(18), 14, a1, a0
	RhoPi	ROT_BIT(39), 22, a0, a1
	RhoPi	ROT_BIT(61),  9, a1, a0
	RhoPi	ROT_BIT(20),  6, a0, a1
	RhoPi	ROT_BIT(44),  1, a1, a0

	//	Chi Iota prepare Theta
	ldi		rY, low(SRAM_STATE)
	ldi		rY1, high(SRAM_STATE)
	movw	rX, rY
	mov		c0, zero
	mov		c1, zero
	movw	c2, c0
	mov		c4, zero


	ldi		i, 5
KeccakF_ChiIotaPrepareThetaLoop:
	ld		a0, X+
	ld		a1, X+
	ld		a2, X+
	ld		a3, X+
	ld		a4, X+
	ChiPTheta  a0, a1, a2, c0
	ChiPTheta  a1, a2, a3, c1
	ChiPTheta  a2, a3, a4, c2
	ChiPTheta  a3, a4, a0, c3
	ChiPThetaS a4, a0, a1, c4
	dec		i
	brne	KeccakF_ChiIotaPrepareThetaLoop

	//	Iota prepare Theta
	ldi		rY, low(SRAM_STATE)
	ldi		rY1, high(SRAM_STATE)
	lpm		rX, Z+		;Round Constant

	ld		a0, Y
	eor		a0, rX
	st		Y, a0
	eor		c0, rX

	;Check for last round constant
	cpi		rX, 0x80
	breq	Keccak_Done
	
	rjmp	Keccak_RoundLoop

Keccak_Done:
	ret
