/*
 * Asm.s
 *
 * Created: 2021-03-08 오전 11:13:35
 * Author: YoungBeom Kim
 */ 

.global PIPO_enc
.type PIPO_enc, @function

#define P0  R0
#define P1  R1
#define P2  R2
#define P3  R3
#define P4  R4
#define P5  R5
#define P6  R6
#define P7  R7

#define RK0  R8
#define RK1  R9
#define RK2  R10
#define RK3  R11
#define RK4  R12
#define RK5  R13
#define RK6  R14
#define RK7  R15
#define RK8  R16
#define RK9  R17
#define RK10 R18
#define RK11 R19
#define RK12 R20
#define RK13 R21
#define RK14 R22
#define RK15 R23

#define CNT R24
#define	RC  R25
#define T0	R26
#define T1	R27
#define T2	R28
#define T3	R29

.macro PUSH_REGS 
	PUSH R0
	PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11
    PUSH R12
    PUSH R13
    PUSH R14
    PUSH R15
    PUSH R16
    PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	PUSH R21
    PUSH R28
    PUSH R29
.endm

.macro POP_REGS
	POP R29
	POP R28
	POP R21
	POP R20
	POP R19
	POP R18
	POP R17
	POP R16
	POP R15
	POP R14
	POP R13
	POP R12
	POP R11
	POP R10
	POP R9
	POP R8
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP	R1
	POP R0
.endm

.macro LOAD_8 pointer
	LDD P0,  \pointer+7
	LDD P1,  \pointer+6
	LDD P2,  \pointer+5
	LDD P3,  \pointer+4
	LDD P4,  \pointer+3
	LDD P5,  \pointer+2
	LDD P6,  \pointer+1
	LDD P7,  \pointer+0
.endm

.macro LOAD_16 pointer
	LDD RK0,   \pointer+15
	LDD RK1,   \pointer+14
	LDD RK2,   \pointer+13
	LDD RK3,   \pointer+12
	LDD RK4,   \pointer+11
	LDD RK5,   \pointer+10
	LDD RK6,   \pointer+9
	LDD RK7,   \pointer+8
	LDD RK8,   \pointer+7
	LDD RK9,   \pointer+6
	LDD RK10,  \pointer+5
	LDD RK11,  \pointer+4
	LDD RK12,  \pointer+3
	LDD RK13,  \pointer+2
	LDD RK14,  \pointer+1
	LDD RK15,  \pointer+0
.endm

.macro STORE_8 pointer
	STD \pointer+0,  P0
	STD \pointer+1,  P1
	STD \pointer+2,  P2
	STD \pointer+3,  P3
	STD \pointer+4,  P4
	STD \pointer+5,  P5
	STD \pointer+6,  P6
	STD \pointer+7,  P7
.endm

.macro S_LAYER_BITSLICING X0, X1, X2, X3, X4, X5, X6, X7, TM0, TM1, TM2, TM3

	// S5_1
	MOV		\TM0,	\X6 ; TM0 = X[6]
	AND		\TM0,	\X7 ; TM0 = (X[7] & X[6])
	EOR		\X5,	\TM0 ; X[5] = (X[7] & X[6])

	MOV		\TM0,	\X3 ; TM0 = X[3]
	AND		\TM0,	\X5 ; T369M0 = (X[3] & X[5])
	EOR		\X4,	\TM0 ; X[5] = (X[7] & X[6])

	EOR		\X7,	\X4 ; X[7] ^= X[4]
	EOR		\X6,	\X3 ; X[6] ^= X[3]

	MOV		\TM0,	\X4 ; TM0 = X[4]
	OR		\TM0,	\X5 ; TM0 = (X[4] | X[5])
	EOR		\X3,	\TM0 ; X[3] ^= (X[4] | X[5])

	EOR		\X5,	\X7 ; X[5] = X[7]

	MOV		\TM0,	\X6 ; TM0 = X[6]
	AND		\TM0,	\X5 ; TM0 = (X[6] & X[5])
	EOR		\X4,	\TM0 ; X[4] ^= (X[6] & X[5])

	// S3
	MOV		\TM0,	\X0 ; TM0 = X[0] 
	AND		\TM0,	\X1 ; TM0 = (X[0] & X[1])
	EOR		\X2,	\TM0 ; X2 ^= (X[0] & X[1])

	MOV		\TM0,	\X1 ; TM0 = X[1] 
	OR		\TM0,	\X2 ; TM0 = (X[1] | X[2])
	EOR		\X0,	\TM0 ; X0 ^= (X[1] & X[2])

	MOV		\TM0,	\X0 ; TM0 = X[0] 
	OR		\TM0,	\X2 ; TM0 = (X[0] | X[2])
	EOR		\X1,	\TM0 ; X1 ^= (X[0] | X[2])

	COM		\X2

	// Extend XOR
	EOR		\X7,	\X1
	EOR		\X3,	\X2
	EOR		\X4,	\X0


	// S5_2
	MOV		\TM0,	\X7 ; t[0] = x[7]
	MOV		\TM1,	\X3 ; t[1] = x[3]
	MOV		\TM2,	\X4 ; t[2] = x[4]

	MOV		\TM3,	\TM0 ; TM3 = t[0]
	AND		\TM3,	\X5 ; TM3 = (t[0] & x[5])
	EOR		\X6,	\TM3 ; X6 ^= (t[0] & x[5])

	EOR		\TM0,	\X6 ; t[0] ^= x[6]

	MOV		\TM3,	\TM1 ; TM3 = t[1]
	OR		\TM3,	\TM2 ; TM3 = (t[1] | t[2])
	EOR		\X6,	\TM3 ; X6 ^= (t[1] | t[2])

	EOR		\TM1,	\X5 ; t[1] ^= x[5]

	MOV		\TM3,	\TM2 ; TM3 = t[2]
	OR		\TM3,	\X6 ; TM3 = (x[6] | t[2])
	EOR		\X5,	\TM3 ; X6 ^= (x[6] | t[2])

	MOV		\TM3,	\TM0 ; TM3 = t[0]
	AND		\TM3,	\TM1 ; TM3 = (t[1] & t[0])
	EOR		\TM2,	\TM3 ; t[2] ^= (t[1] & t[0])

	// Truncate XOR and SWAP
	EOR		\X2,	\TM0 ; x[2] ^= t[0]

	MOV		\TM0,	\TM2 ; TM0 = t[2]
	EOR		\TM0,	\X1 ;  t[0] = TM0 = (x[1] ^ t[2])

	MOV		\X1,	\TM1 ; x[1] = t[1]
	EOR		\X1,	\X0 ; x[1] =  x[0] ^ t[1]

	MOV		\X0,	\X7 ; x[0] = x[7]
	MOV		\X7,	\TM0 ; x[7] = t[0]

	MOV		\TM1,	\X3 ; t[1] = x[3]
	MOV		\X3,	\X6 ; x[3] = x[6]
	MOV		\X6,	\TM1 ; x[6] = t[1]
	
	MOV		\TM2,	\X4 ; t[2] = x[4]
	MOV		\X4,	\X5 ; x[4] = x[5]
	MOV		\X5,	\TM2 ; x[5] = t[2]	
.endm


.macro R_LAYER zero, X1, X2, X3, X4, X5, X6, X7 
	
	//X0 left-rotate shift offset : 0
	EOR		\zero,	\zero
	//X1 left-rotate shift offset : 7
	BST		\X1,	0
	LSR		\X1
	BLD		\X1,	7

	//X2 left-rotate shift offset : 4
	SWAP	\X2

	//X3 left-rotate shift offset : 3
	SWAP	\X3
	BST		\X3,	0
	LSR		\X3
	BLD		\X3,	7

	//X4 left-rotate shift offset : 6
	SWAP	\X4
	LSL		\X4
	ADC		\X4,	\zero
	LSL		\X4
	ADC		\X4,	\zero

	//X5 left-rotate shift offset : 5
	SWAP	\X5
	LSL		\X5
	ADC		\X5,	\zero

	//X6 left-rotate shift offset : 1
	LSL		\X6
	ADC		\X6,	\zero

	//X7 left-rotate shift offset : 2
	LSL		\X7
	ADC		\X7,	\zero
	LSL		\X7
	ADC		\X7,	\zero
.endm

.macro S_LAYER_LUT X0, X1, X2, X3, X4, X5, X6, X7 
	MOV		R30,	\X0
	LPM		\X0,	Z
	MOV		R30,	\X1
	LPM		\X1,	Z
	MOV		R30,	\X2
	LPM		\X2,	Z
	MOV		R30,	\X3
	LPM		\X3,	Z
	MOV		R30,	\X4
	LPM		\X4,	Z
	MOV		R30,	\X5
	LPM		\X5,	Z
	MOV		R30,	\X6
	LPM		\X6,	Z
	MOV		R30,	\X7
	LPM		\X7,	Z
.endm

.macro KEYADD X0, X1, X2, X3, X4, X5, X6, X7, K0, K1, K2, K3, K4, K5, K6, K7, RCON
	EOR		\X0,	\RCON
	INC		\RCON
	EOR		\X0,	\K0
	EOR		\X1,	\K1
	EOR		\X2,	\K2
	EOR		\X3,	\K3
	EOR		\X4,	\K4
	EOR		\X5,	\K5
	EOR		\X6,	\K6
	EOR		\X7,	\K7
.endm

PIPO_enc:

	PUSH_REGS

	MOVW	R30, R24		//PLAIN TEXT
	MOVW	R28, R22		//MASTER KEY
	EOR		RC,	 RC			//RCON = 0	
	LDI		CNT, 6

	LOAD_8 Z
	LOAD_16 Y

	KEYADD P0, P1, P2, P3, P4, P5, P6, P7, RK0, RK1, RK2, RK3, RK4, RK5, RK6, RK7, RC

LOOP:
	// ODD Round
	S_LAYER_BITSLICING P0, P1, P2, P3, P4, P5, P6, P7, T0, T1, T2, T3
	R_LAYER T0, P1, P2, P3, P4, P5, P6, P7
	KEYADD P0, P1, P2, P3, P4, P5, P6, P7, RK8, RK9, RK10, RK11, RK12, RK13, RK14, RK15, RC


	// EVEN Round
	S_LAYER_BITSLICING P0, P1, P2, P3, P4, P5, P6, P7, T0, T1, T2, T3
	R_LAYER T0, P1, P2, P3, P4, P5, P6, P7
	KEYADD P0, P1, P2, P3, P4, P5, P6, P7, RK0, RK1, RK2, RK3, RK4, RK5, RK6, RK7, RC

	DEC		CNT
	CPSE	CNT, T0
	RJMP	LOOP

	// 13 Round
	S_LAYER_BITSLICING P0, P1, P2, P3, P4, P5, P6, P7, T0, T1, T2, T3
	R_LAYER T0, P1, P2, P3, P4, P5, P6, P7
	KEYADD P0, P1, P2, P3, P4, P5, P6, P7, RK8, RK9, RK10, RK11, RK12, RK13, RK14, RK15, RC

	STORE_8 Z
	POP_REGS

RET