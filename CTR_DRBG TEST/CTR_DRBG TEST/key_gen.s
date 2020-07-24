#define MK0		R0
#define MK1		R1
#define MK2		R2
#define MK3		R3
#define MK4		R4
#define MK5		R5
#define MK6		R6
#define MK7		R7
#define MK8		R8
#define MK9		R9
#define MK10	R10
#define MK11	R11

#define CON		R19

#define MK12	R20
#define MK13	R21

#define IN_CNT	R22
#define OUT_CNT	R23

#define TMP		R24

#define MK14	R26
#define MK15	R27

.global HIGHT_key_gen
.type HIGHT_key_gen, @function

	HIGHT_key_gen:

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
		
	MOVW R30,	R24	
	
	LD MK7,		Z+

	LD MK0,		Z+
	LD MK1,		Z+
	LD MK2,		Z+
	LD MK3,		Z+
	LD MK4,		Z+
	LD MK5,		Z+
	LD MK6,		Z+
	
	LD MK15,	Z+

	LD MK8,		Z+
	LD MK9,		Z+
	LD MK10,	Z+
	LD MK11,	Z+
	LD MK12,	Z+
	LD MK13,	Z+
	LD MK14,	Z+
	
	MOVW R30,	R22
	ST Z+,		MK11
	ST Z+,		MK12
	ST Z+,		MK13
	ST Z+,		MK14
	ST Z+,		MK7
	ST Z+,		MK0
	ST Z+,		MK1
	ST Z+,		MK2

	LDI CON,	90		// 0b 1011010

	LDI OUT_CNT, 15		// ( 2 * 8 ) TIMES

	OUT_LOOP:

	LDI IN_CNT, 7		// 8 TIMES

	//
	MOV TMP,	MK7
	MOV MK7,	MK6
	MOV MK6,	MK5
	MOV MK5,	MK4
	MOV MK4,	MK3

	MOV MK3,	MK2
	MOV MK2,	MK1
	MOV MK1,	MK0
	MOV MK0,	TMP
	//

	IN_LOOP:
	//SUBKEY
	MOV TMP,	CON
	ADD TMP,	MK0
	ST Z+,		TMP

	MOV TMP,	MK0
	MOV MK0,	MK1
	MOV MK1,	MK2
	MOV MK2,	MK3
	MOV MK3,	MK4

	MOV MK4,	MK5
	MOV MK5,	MK6
	MOV MK6,	MK7
	MOV MK7,	TMP

	//CONSTANT
	//FOR i = 1 TO 127
	// S_i+6 = S_i+2 + S_i-1
	CLR TMP
	BST CON,	0
	BLD CON,	7

	BST CON,	3
	BLD TMP,	7

	EOR CON,	TMP
	LSR CON

	SUBI IN_CNT, 1
	BRGE IN_LOOP

	MOVW TMP,	MK0
	MOVW MK0,	MK8
	MOVW MK8,	TMP

	MOVW TMP,	MK2
	MOVW MK2,	MK10
	MOVW MK10,	TMP

	MOVW TMP,	MK4
	MOVW MK4,	MK12
	MOVW MK12,	TMP

	MOVW TMP,	MK6
	MOVW MK6,	MK14
	MOVW MK14,	TMP

	SUBI OUT_CNT, 1
	BRGE OUT_LOOP
	//OUT_LOOP

	CLR R1
	
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
	
	RET
