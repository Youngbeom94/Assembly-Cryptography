/*
 * SHA_256.asm
 *
 *  Created: 2020-07-09 ?? 12:31:51
 *   Author: ???
 */ 
 /*
 * SHA_256.s
 *
 *  Created: 2020-07-09 ?? 12:27:22
 *   Author: ???
 */ 
 ;
; Copyright ? Tim G?neysu, 2012
; e-mail:  <tim.gueneysu@rub.de>
;
; This program is a free software: you can redistribute it
; and/or modify it under the terms of the GNU General Public
; License as published by the Free Software Foundation.
;
; It is distributed without any warranty of correctness nor
; fintess for any particular purpose. See the GNU General
; Public License for more details.
;
; <http://www.gnu.org/licenses/>.
;
; Description: SHA256 hash function (fast version)
; Version 1 - July 2012.
;
; IMPORTANT NOTES
;
; (1) THIS CODE HAS BEEN OPTIMIZED FOR 
; MEMORY AND REGISTER ALLOCATION. PLEASE MAKE SURE THAT
; THE ALLOCATION FITS YOUR DEVICE BY CHOOSING THE 
; CORRECT BASE MEMORY LAYOUT. PLEASE CHECK OUT THE
; OPTIONS [1A] AND [1B] TO SELECT ATXMEGA, ATMEGA OR ATTINY
; DEVICES APPROPRIATELY
;
; 
;
;
;   ----------------------------------------------------
;  |    User interface:                                 |
;  |----------------------------------------------------|
;  |(1) Data to hash must be in SRAM with the first byte|
;  |    at the location pointed by SRAM_DATA. The data  |
;  |    has to be udated before each update or final    |
;  |    call and the number of bytes needed in SRAM by  |
;  |    each update call is equal to DATA_NUM_BYTE      |
;  |                                                    |
;  |    If final routine is called, r24 must contain    |
;  |    the number of bytes of data passed to the       |
;  |    function.                                       |
;  |----------------------------------------------------|
;  |(2) Call init, update or final routine              |
;  |----------------------------------------------------|
;  |(3) After each call, the intermediate (or final)    |
;  |    hash function state is at location pointed by   |
;  |    SRAM_STATE. Lenght of hash intermediate states  |
;  |    is given by STATE_NUM_BYTE constant.            |
;  |    Lenght of final hash value is given by          |
;  |    HASH_NUM_BYTE.                                  |
;   ----------------------------------------------------
;

.device Ainy45
.include "tn45def.inc"
;
; Constants
;
.EQU    DATA_NUM_BYTE = 64 ;Number of bytes that will be processed by the update function ;
.EQU    STATE_NUM_BYTE = 32 ;Memory needed for hash function intermediate state (in bytes) ;
.EQU    ADD_MEM_NUM_BYTE = 41 ;Optional additional memory for internal computation (in bytes) ;
.EQU    HASH_NUM_BYTE = 32 ;Size of output hash (in bytes) ;
.EQU	CNT_NUM_BYTE=8


.EQU 	DATA_LENGTH=32
.EQU 	RC_LENGTH=256
.EQU    WREG_CNT=8
.EQU	INPUT_CNT=32
.EQU 	ROUND_CNT=64

.EQU	CNT_START=DATA_LENGTH
	

; [1A] UNCOMMENT THE FOLLOWING FOR ATXMEGA DEVICES
;.EQU	SREG=CPU_SREG
;.EQU	HASH_MEM_LAYOUT=INTERNAL_SRAM_START

; [1B] OTHERWISE (E.G. FOR ATMEGA and ATTINY DEVICE) USE THIS HERE
.EQU	HASH_MEM_LAYOUT=0x80

;
; Registers declarations

.DEF 	TEMP_REG = R16
.DEF	BYTES_REMAINING = R24
.DEF	INDEX = R25

; 32-bit register definition (5 regs named A-E)
.DEF	WR_A0=R0
.DEF	WR_A1=R1
.DEF	WR_A2=R2
.DEF	WR_A3=R3
.DEF	WR_B0=R4
.DEF	WR_B1=R5
.DEF	WR_B2=R6
.DEF	WR_B3=R7
.DEF	WR_C0=R8
.DEF	WR_C1=R9
.DEF	WR_C2=R10
.DEF	WR_C3=R11
.DEF	WR_D0=R12
.DEF	WR_D1=R13
.DEF	WR_D2=R14
.DEF	WR_D3=R15
.DEF	WR_E0=R20
.DEF	WR_E1=R21
.DEF	WR_E2=R22
.DEF	WR_E3=R23

; RAM declarations

.DSEG

.ORG HASH_MEM_LAYOUT

	SRAM_DATA:		.BYTE DATA_NUM_BYTE
	SRAM_ADD_MEM :	.BYTE ADD_MEM_NUM_BYTE
	SRAM_STATE:		.BYTE STATE_NUM_BYTE
.CSEG

; ##### MACROS #####


; MACRO: ROTATE A 32 BIT WORD TO RIGHT BY ONE BIT
; INPUT: @0-@3
; DESTROYS: TEMP_REG
; OUTPUT: @0-@3
.MACRO ROTATE_BIT_TO_RIGHT_32

	MOV TEMP_REG, @0
	ROR TEMP_REG
	ROR @3
	ROR @2
	ROR @1
	ROR @0

.ENDMACRO

; MACRO: ROTATE A 32 BIT WORD TO LEFT BY ONE BIT
; INPUT: @0-@3
; DESTROYS: TEMP_REG
; OUTPUT: @0-@3
.MACRO ROTATE_BIT_TO_LEFT_32

	MOV TEMP_REG, @3
	ROL TEMP_REG
	ROL @0
	ROL @1
	ROL @2
	ROL @3

.ENDMACRO

; MACRO FOR PREPROCESSING STEP #1: ROTATE AND XOR WORD in WR_A0-WR_A3 by 7, 18 and 3 bits to right
; INPUT: WR_A
; DESTROYS: TEMP_REG, WR_B
; OUTPUT: WR_A0
.MACRO XOR_ROTATE_RIGHT_7_18_3
	
	; copy word since we need to shift both right and left
	MOVW WR_B0, WR_A0
	MOVW WR_B2, WR_A2

	; rotate 1 left and reassign bytes (results in shift by 7 to right)
	ROTATE_BIT_TO_LEFT_32 WR_B0, WR_B1, WR_B2, WR_B3

	; rotate 2 bits right and shift by two bytes (shift by 18 to right), xor to first word
	ROTATE_BIT_TO_RIGHT_32 WR_A0, WR_A1, WR_A2, WR_A3
	ROTATE_BIT_TO_RIGHT_32 WR_A0, WR_A1, WR_A2, WR_A3

	EOR WR_B1, WR_A2 
	EOR WR_B2, WR_A3
	EOR WR_B3, WR_A0
	EOR WR_B0, WR_A1

	; rotate another bit right and use original order (shift by 3 to right) while xoring with first word
	ROTATE_BIT_TO_RIGHT_32 WR_A0, WR_A1, WR_A2, WR_A3
	LDI TEMP_REG, 0x1F
	AND WR_A3, TEMP_REG

	EOR WR_A0, WR_B1
	EOR WR_A1, WR_B2
	EOR WR_A2, WR_B3
	EOR WR_A3, WR_B0

.ENDMACRO


; MACRO FOR PREPROCESSING STEP #1: ROTATE AND XOR WORD in WR_A0-WR_A3 by 17, 19 and 10 bits to right
; INPUT: WR_A
; DESTROYS: TEMP_REG, WR_B
; OUTPUT: WR_B
.MACRO XOR_ROTATE_RIGHT_17_19_10

	; rotate 1 right and shift by two bytes (results in rotate by 17 to right)
	ROTATE_BIT_TO_RIGHT_32 WR_A0, WR_A1, WR_A2, WR_A3

	MOVW WR_B2, WR_A0
	MOVW WR_B0, WR_A2

	; rotate another bit right and mask it to make it a shift by 10, xor result to first word

	ROTATE_BIT_TO_RIGHT_32 WR_A0, WR_A1, WR_A2, WR_A3
	MOV TEMP_REG, WR_A3
	ANDI TEMP_REG, 0x3F
	EOR WR_B0, WR_A1
	EOR WR_B1, WR_A2
	EOR WR_B2, TEMP_REG

	; rotate another bit right and use original order (rotate by 3 to right), xor to first word

	ROTATE_BIT_TO_RIGHT_32 WR_A0, WR_A1, WR_A2, WR_A3

	EOR WR_B0, WR_A2
	EOR WR_B1, WR_A3
	EOR WR_B2, WR_A0
	EOR WR_B3, WR_A1

.ENDMACRO

; MACRO FOR COMPRESSION FNCT: ROTATE AND XOR WORD in WR_A0-WR_A3 by 2, 13 and 22 bits to right
; INPUT: WR_A
; DESTROYS: TEMP_REG, WR_B
; OUTPUT: WR_A0
.MACRO XOR_ROTATE_RIGHT_2_13_22

	; rotate 2 right
	ROTATE_BIT_TO_RIGHT_32 WR_A0, WR_A1, WR_A2, WR_A3
	ROTATE_BIT_TO_RIGHT_32 WR_A0, WR_A1, WR_A2, WR_A3

	MOVW WR_B0, WR_A0
	MOVW WR_B2, WR_A2

	; rotate 3 bits right
	ROTATE_BIT_TO_RIGHT_32 WR_B0, WR_B1, WR_B2, WR_B3
	ROTATE_BIT_TO_RIGHT_32 WR_B0, WR_B1, WR_B2, WR_B3
	ROTATE_BIT_TO_RIGHT_32 WR_B0, WR_B1, WR_B2, WR_B3

	EOR WR_A0, WR_B1
	EOR WR_A1, WR_B2
	EOR WR_A2, WR_B3
	EOR WR_A3, WR_B0

	; rotate another bit right and use original order (shift by 3 to right), xor to first word

	ROTATE_BIT_TO_RIGHT_32 WR_B0, WR_B1, WR_B2, WR_B3

	EOR WR_A0, WR_B2
	EOR WR_A1, WR_B3
	EOR WR_A2, WR_B0
	EOR WR_A3, WR_B1

.ENDMACRO

; MACRO FOR COMPRESSION FNCT: ROTATE AND XOR WORD in WR_A0-WR_A3 by 6, 11 and 25 bits to right
; INPUT: WR_A
; DESTROYS: TEMP_REG, WR_B
; OUTPUT: WR_B
.MACRO XOR_ROTATE_RIGHT_6_11_25

	; rotate 1 right (shift by 25, start with reg 3)

	ROTATE_BIT_TO_RIGHT_32 WR_A0, WR_A1, WR_A2, WR_A3
	
	MOVW WR_B0, WR_A0
	MOVW WR_B2, WR_A2

	; rotate another 2 bits right (shift by 11, start with reg 1) 
	ROTATE_BIT_TO_RIGHT_32 WR_B0, WR_B1, WR_B2, WR_B3
	ROTATE_BIT_TO_RIGHT_32 WR_B0, WR_B1, WR_B2, WR_B3
	
	EOR WR_A3, WR_B1
	EOR WR_A0, WR_B2
	EOR WR_A1, WR_B3
	EOR WR_A2, WR_B0

	; rotate another 3 bits right and use original order (shift by 3 to right), xor to first word

	ROTATE_BIT_TO_RIGHT_32 WR_B0, WR_B1, WR_B2, WR_B3
	ROTATE_BIT_TO_RIGHT_32 WR_B0, WR_B1, WR_B2, WR_B3
	ROTATE_BIT_TO_RIGHT_32 WR_B0, WR_B1, WR_B2, WR_B3
	
	EOR WR_B0, WR_A3
	EOR WR_B1, WR_A0
	EOR WR_B2, WR_A1
	EOR WR_B3, WR_A2


.ENDMACRO

; MACRO FOR COMPRESSION FNCT: CIRCULAR PROCESSING OF WORKING REGISTERS - ¢¥check bounds
.MACRO CHECK_WSTATE_BOUNDS

	ANDI YL, 0x1F
	ORI YL, LOW(SRAM_ADD_MEM)

.ENDMACRO

; MACRO FOR COMPRESSION FNCT: CIRCULAR PROCESSING OF WORKING REGISTERS  - ¢¥check bounds
.MACRO CHECK_INPUT_BOUNDS

	ANDI XL, 0x3F
	ORI XL, LOW(SRAM_DATA)

.ENDMACRO

; MACRO FOR COMPRESSION FNCT: ADVANCE Y POINTER TO NEXT WORKING REGISTER (CIRCULARY)
.MACRO SKIP_WSTATE_WORD

	ADIW Y, @0*4
	CHECK_WSTATE_BOUNDS

.ENDMACRO

; MACRO FOR COMPRESSION FNCT: ADVANCE Y POINTER BY 3 WORKING REGISTER (CIRCULARY)
;.MACRO SKIP_2_WORKING_REGS

;	ADIW Y, 8
;	CHECK_WSTATE_BOUNDS

;.ENDMACRO

; MACRO FOR COMPRESSION FNCT: READ CURRENT WORKSTATE TO REGISTERS @0-@3 (via Y-Pointer)
; INPUT: Y pointing to current working register
; DESTROYS: -
; OUTPUT: @0-@3
.MACRO READ_WSTATE_WORD

	LD  @3, Y
	LDD @2, Y+1
	LDD @1, Y+2
	LDD @0, Y+3

.ENDMACRO

; MACRO FOR COMPRESSION FNCT: READ CURRENT WORKING REGISTER TO REGISTERS @0-@3 (via Y-Pointer)
; INPUT: Y pointing to current working register
; DESTROYS: -
; OUTPUT: @0-@3
.MACRO READ_WSTATE_WORD_INC

	LD @3, Y+
	LD @2, Y+
	LD @1, Y+
	LD @0, Y+

.ENDMACRO

; MACRO FOR COMPRESSION FNCT: WRITE CURRENT WORD TO REGISTERS @0-@3 (via Y-Pointer)
; INPUT: Y pointing to current working register, @0-@3
; DESTROYS: -
; OUTPUT: 4 bytes written at RAM location
.MACRO WRITE_WSTATE_WORD

	ST Y+, @3
	ST Y+, @2 
	ST Y+, @1
	ST Y+, @0

.ENDMACRO

; MACRO FOR COMPRESSION FNCT: READ INPUT TO WORKING REGISTERS (via X-Pointer)
; INPUT: X pointing to current working register
; DESTROYS: -
; OUTPUT: @0-@3
.MACRO READ_INPUT_WORD

	LD  @3, X++
	LD  @2, X++
	LD  @1, X++
	LD  @0, X++

.ENDMACRO

; MACRO FOR COMPRESSION FNCT: WRITE INPUT FROM REGISTERS @0-@3 TO DATA RAM (via X-Pointer)
; INPUT: X pointing to current working register
; DESTROYS: 32 bit word at X-pointer RAM location
; OUTPUT: @0-@3
.MACRO WRITE_INPUT_WORD

	ST X+, @3
	ST X+, @2
	ST X+, @1
	ST X+, @0

.ENDMACRO

; MACRO FOR COMPRESSION FNCT: ADVANCE Y POINTER TO NEXT WORKING REGISTER (CIRCULARY)
.MACRO SKIP_INPUT_WORD

	ADIW X, @0*4
	CHECK_INPUT_BOUNDS

.ENDMACRO

; MACRO FOR COMPRESSION FNCT: ADD TWO 32 BIT VALUES MOD 32
; INPUT: @0, @1
; DESTROYS: -
; OUTPUT: @0-@3
.MACRO ADD_MOD_32

	ADD @0, @4
	ADC @1, @5
	ADC @2, @6
	ADC @3, @7

.ENDMACRO

; MACRO FOR COMPRESSION FNCT: GET NEXT WORD FROM HASH BLOCK (via X-Pointer)
; INPUT: X-Pointer
; DESTROYS: WR_B, WR_E
; OUTPUT: WR_B
.MACRO GET_NEXT_INPUT_WORD

	CPI INDEX, 16
	BRGE EXTEND_NEXT_WORD
		; just read plain input word 
		READ_INPUT_WORD WR_B0, WR_B1, WR_B2, WR_B3
		RJMP END_NEXT_INPUT
	
	EXTEND_NEXT_WORD:

		; load W[i-16] in temp registers
		CHECK_INPUT_BOUNDS
		READ_INPUT_WORD WR_E0, WR_E1, WR_E2, WR_E3

		; load W[i-15] into WR_A0-WR_A3
		CHECK_INPUT_BOUNDS		
		READ_INPUT_WORD WR_A0, WR_A1, WR_A2, WR_A3

		; compute rotation on W[i-15] and store result in WR_A0-WR_A3
		XOR_ROTATE_RIGHT_7_18_3

		; add result to temp registers
		ADD_MOD_32 WR_E0, WR_E1, WR_E2, WR_E3, WR_A0, WR_A1, WR_A2, WR_A3

		; skip next 7 words and load W[i-7]
		SKIP_INPUT_WORD 7	
		READ_INPUT_WORD WR_A0, WR_A1, WR_A2, WR_A3

		; add W[i-7] to temp results
		ADD_MOD_32 WR_E0, WR_E1, WR_E2, WR_E3, WR_A0, WR_A1, WR_A2, WR_A3

		; skip next 4 words and load W[i-2]
		SKIP_INPUT_WORD 4	
		READ_INPUT_WORD WR_A0, WR_A1, WR_A2, WR_A3

		; compute rotation on W[i-2]
		XOR_ROTATE_RIGHT_17_19_10

		; add temp results to rotation result
		ADD_MOD_32 WR_B0, WR_B1, WR_B2, WR_B3, WR_E0, WR_E1, WR_E2, WR_E3

		; skip next word and overwrite W[i-16]
		SKIP_INPUT_WORD 1	
		WRITE_INPUT_WORD WR_B0, WR_B1, WR_B2, WR_B3

	END_NEXT_INPUT: 

.ENDMACRO

; MACRO FOR COMPRESSION FNCT: GET NEXT CONSTANT FROM FLASH (Z-Pointer)
; INPUT: Z-Pointer
; DESTROYS: -
; RESULT: @0-@3
.MACRO GET_NEXT_CONSTANT

	LPM @0, Z+
	LPM @1, Z+
	LPM @2, Z+
	LPM @3, Z+

.ENDMACRO

; MACRO FOR COMPRESSION FNCT: COMPUTE MAJORITY FUNCTION ON INPUTS A, B, C
; INPUT: A, B, C
; DESTROYS: WR_B, WR_C, WR_D
; OUTPUT: WR_C, A in WR_A
.MACRO MAJORITY_FNC

	; load register A and duplicate it
	READ_WSTATE_WORD_INC WR_A0, WR_A1, WR_A2, WR_A3
	CHECK_WSTATE_BOUNDS
	MOVW WR_B0, WR_A0
	MOVW WR_B2, WR_A2

	; load register B
	READ_WSTATE_WORD_INC WR_C0, WR_C1, WR_C2, WR_C3
	CHECK_WSTATE_BOUNDS

	; load register C
	READ_WSTATE_WORD_INC WR_D0, WR_D1, WR_D2, WR_D3
	CHECK_WSTATE_BOUNDS

	AND WR_B0, WR_C0	; compute P=(A AND B)
	AND WR_B1, WR_C1
	AND WR_B2, WR_C2
	AND WR_B3, WR_C3

	AND WR_C0, WR_D0	; compute R=(B AND C)
	AND WR_C1, WR_D1
	AND WR_C2, WR_D2
	AND WR_C3, WR_D3

	AND WR_D0, WR_A0	; compute Q=(A AND C)
	AND WR_D1, WR_A1
	AND WR_D2, WR_A2
	AND WR_D3, WR_A3 

	EOR WR_C0, WR_B0	; compute (P xor R)
	EOR WR_C1, WR_B1
	EOR WR_C2, WR_B2
	EOR WR_C3, WR_B3

	EOR WR_C0, WR_D0	; compute (P xor R xor Q)
	EOR WR_C1, WR_D1
	EOR WR_C2, WR_D2
	EOR WR_C3, WR_D3

.ENDMACRO

; MACRO FOR COMPRESSION FNCT: COMPUTE CHECK FUNCTION ON INPUTS E, F, G
; INPUT: E,F,G
; DESTROYS: WR_B, WR_D
; OUTPUT: WR_D, E in WR_A
.MACRO CHECK_FNC

	; load register E
	READ_WSTATE_WORD_INC WR_A0, WR_A1, WR_A2, WR_A3
	CHECK_WSTATE_BOUNDS

	; load register F
	READ_WSTATE_WORD_INC WR_B0, WR_B1, WR_B2, WR_B3
	CHECK_WSTATE_BOUNDS

	; load register G
	READ_WSTATE_WORD_INC WR_D0, WR_D1, WR_D2, WR_D3
	CHECK_WSTATE_BOUNDS

	AND WR_B0, WR_A0	; compute P=(E AND F)
	AND WR_B1, WR_A1
	AND WR_B2, WR_A2
	AND WR_B3, WR_A3

	COM WR_A0			; compute NOT E
	COM WR_A1
	COM WR_A2
	COM WR_A3

	AND WR_D0, WR_A0	; compute Q=(NOT E AND G)
	AND WR_D1, WR_A1
	AND WR_D2, WR_A2
	AND WR_D3, WR_A3

	EOR WR_D0, WR_B0	; compute (E AND F) xor (NOT E AND G)
	EOR WR_D1, WR_B1
	EOR WR_D2, WR_B2
	EOR WR_D3, WR_B3

	COM WR_A0			; revert original E
	COM WR_A1
	COM WR_A2
	COM WR_A3

.ENDMACRO

; MACRO FOR UPDATE FNCT: COPY STATE INTO 32-BIT WORKING REGISTERS A-H
; INPUT: -
; DESTROYS: Y and Z pointer, TEMP_REG, INDEX
; OUTPUT: state in working registers
.MACRO COPY_STATE_TO_WORKING_REGISTERS

	; load address of target state in RAM
	LDI XH, HIGH(SRAM_STATE)
	LDI XL, LOW(SRAM_STATE)
	
	;load base address of working registers
	LDI YL, LOW(SRAM_ADD_MEM)
	LDI YH, HIGH(SRAM_ADD_MEM)

	; load number of words to transfer
	LDI INDEX, DATA_LENGTH

	; transfer state from last block into working registers in RAM  
	COPY_STATE_INTO_WORKING_REG_LOOP:

	LD TEMP_REG, X+
	ST Y+, TEMP_REG
	DEC INDEX
	BRNE COPY_STATE_INTO_WORKING_REG_LOOP

.ENDMACRO

; MACRO FOR UPDATE FNCT: UPDAET STATE INFORMATION BY ADDING 32-BIT WORKING REGISTERS A-H MOD 32
; INPUT: -
; DESTROYS: X pointer, WR_A, WR_B, INDEX
; OUTPUT: state in RAM
.MACRO UPDATE_STATE_USING_WORKING_REGISTERS

	; reload address of target state in RAM
	LDI XH, HIGH(SRAM_STATE)
	LDI XL, LOW(SRAM_STATE)

	; load number of words to transfer
	LDI INDEX, WREG_CNT

	; transfer state from last block into working registers in RAM  
	ADD_WORKING_REGS_TO_STATE_LOOP:
	
		; read current 32 bit word from state
		READ_INPUT_WORD WR_A0, WR_A1, WR_A2, WR_A3

		; read current 32 bit working register
		READ_WSTATE_WORD_INC WR_B0, WR_B1, WR_B2, WR_B3

		; add state and working register
		ADD_MOD_32 WR_A0, WR_A1, WR_A2, WR_A3, WR_B0, WR_B1, WR_B2, WR_B3

		; rewind and write state
		SBIW X, 4
		WRITE_INPUT_WORD WR_A0, WR_A1, WR_A2, WR_A3

		DEC INDEX
		BRNE ADD_WORKING_REGS_TO_STATE_LOOP

.ENDMACRO

; #################### Initialization
;	; stores the SHA256 initialization vector in state (RAM)
INIT:
	; load address of target state in RAM
	LDI XH, HIGH(SRAM_STATE)
	LDI XL, LOW(SRAM_STATE)

	;load address of counter in flash
	LDI YH, HIGH(SRAM_ADD_MEM+CNT_START)
	LDI YL, LOW(SRAM_ADD_MEM+CNT_START)

	;load address of initialization vector in flash
	LDI ZH, HIGH(IV<<1)
	LDI ZL, LOW(IV<<1)

	; load number of words to transfer
	LDI INDEX, DATA_LENGTH

	; transfer IV from flash to RAM
INIT_TRANSFER_LOOP:

	LPM TEMP_REG, Z+
	ST X+, TEMP_REG
	DEC INDEX
	BRNE INIT_TRANSFER_LOOP

	; invalidate counter by clearing valid flag
	CLR TEMP_REG
	STD Y+CNT_NUM_BYTE, TEMP_REG

	ret

; ##################### Update Hash
;	performs compression of a 512 bit block using SHA256
UPDATE:
	
; ### update message counter if necessary (performed only once at the beginning)
	RCALL UPDATE_BIT_COUNTER


; ### copy current state into working registers ###
	COPY_STATE_TO_WORKING_REGISTERS


	; initialize the round counter and static values
	CLR INDEX

	; set address pointer X to begin of input data
	LDI XH, HIGH(SRAM_DATA)
	LDI XL, LOW(SRAM_DATA)

	; reset address pointer Y to begin of working register
	LDI YL, LOW(SRAM_ADD_MEM)
	LDI YH, HIGH(SRAM_ADD_MEM)

	;load base address of constant table in Z pointer
	LDI ZL, LOW(RC<<1)
	LDI ZH, HIGH(RC<<1)

	; ### perform compression operation

	MAIN_LOOP: 

		; majority function on inputs A, B, C -> result R1 in WR_Cand A in WR_A
		MAJORITY_FNC

		; shift A by 2, 13 and 22  -> result R2 in WR_A
		XOR_ROTATE_RIGHT_2_13_22

		; add R1+R2 -> result T2 in WR_C
		ADD_MOD_32 WR_C0, WR_C1, WR_C2, WR_C3, WR_A0, WR_A1, WR_A2, WR_A3

		; skip register D
		SKIP_WSTATE_WORD 1

		; check function on inputs E, F, G -> result R1 in WR_D and E in WR_A
		CHECK_FNC

		; shift E by 6, 11 and 25 bits -> result R2 in WR_B
		XOR_ROTATE_RIGHT_6_11_25

		; add R1+R2 -> result R3 in WR_B
		ADD_MOD_32  WR_B0, WR_B1, WR_B2, WR_B3, WR_D0, WR_D1, WR_D2, WR_D3

		; get current round constant and load it to WR_D
		GET_NEXT_CONSTANT WR_D0, WR_D1, WR_D2, WR_D3

		; add RC+R3 -> result R4 in WR_D
		ADD_MOD_32 WR_D0, WR_D1, WR_D2, WR_D3, WR_B0, WR_B1, WR_B2, WR_B3

		; get word to mix in current round and load it to WR_B
		GET_NEXT_INPUT_WORD

		; add W+R4 -> result T1 in WR_B
		ADD_MOD_32 WR_B0, WR_B1, WR_B2, WR_B3, WR_D0, WR_D1, WR_D2, WR_D3

		; load H register
		READ_WSTATE_WORD WR_A0, WR_A1, WR_A2, WR_A3

		; add T1+H -> result T1 in WR_B
		ADD_MOD_32 WR_B0, WR_B1, WR_B2, WR_B3, WR_A0, WR_A1, WR_A2, WR_A3

		; add T2+T1 -> result T2 in WR_C
		ADD_MOD_32 WR_C0, WR_C1, WR_C2, WR_C3, WR_B0, WR_B1, WR_B2, WR_B3

		; now store A=T1+T2 in RAM
		WRITE_WSTATE_WORD WR_C0, WR_C1, WR_C2, WR_C3

		; jump over A,B and C registers
		SKIP_WSTATE_WORD 3

		; load D register
		READ_WSTATE_WORD WR_A0, WR_A1, WR_A2, WR_A3

		; add D+T1 -> result T2 in WR_B
		ADD_MOD_32 WR_B0, WR_B1, WR_B2, WR_B3, WR_A0, WR_A1, WR_A2, WR_A3

		; write register WR_B back to RAM
		WRITE_WSTATE_WORD WR_B0, WR_B1, WR_B2, WR_B3

		; jump over E,F and G registers --> new base register is H (now defined as A)
		SKIP_WSTATE_WORD 3

		; check loop condition (if all rounds are processed and INDEX=64)
		INC INDEX

		CPI INDEX, ROUND_CNT 
		IN TEMP_REG, SREG			; implement conditional long range jump (not available on ATTiny devices)
		SBRS TEMP_REG, 1
		RJMP MAIN_LOOP

	; #### final step, now add result to state
	UPDATE_STATE_USING_WORKING_REGISTERS
	
	RET


; Final
;	performs padding and compression of the last block
;	r24 contains the number of bytes passed to the final function.
FINAL:
	
; ### update message counter if necessary (performed only once at the beginning)
	RCALL UPDATE_BIT_COUNTER

	; set address pointer X to begin of input data 
	LDI XH, HIGH(SRAM_DATA)
	LDI XL, LOW(SRAM_DATA)

	LDI	YH, HIGH(SRAM_ADD_MEM+CNT_START)
	LDI	YL, LOW(SRAM_ADD_MEM+CNT_START)

	; preload constant according to padding scheme (100000,,,)
	LDI TEMP_REG, 0x80

	; if size is >= 56 the padding cannot be done in place and an additional block is required
	CPI BYTES_REMAINING, 56
	BRSH PADD_AND_ADD_FULL_BLOCK


; pad the last block accordingly with zeroes and the counter	
PAD_BLOCK: 

	; jump to the beginning of the padding area
	ADD XL, BYTES_REMAINING

	; store initial magic byte
	ST X+, TEMP_REG

	; padd zeros until counter is reached
	CLR TEMP_REG

	PAD_ZEROS_1:
		CPI XL, LOW(SRAM_DATA+DATA_NUM_BYTE-CNT_NUM_BYTE)
		BRGE ADD_PAD_CNT
		ST X+, TEMP_REG
		RJMP PAD_ZEROS_1

	; now load and append the bit counter value to the block
	ADD_PAD_CNT:
		
		LDI INDEX, CNT_NUM_BYTE

		STORE_CNT_BYTES:
			LD TEMP_REG, Y+
			ST X+, TEMP_REG
			DEC INDEX
			BRNE STORE_CNT_BYTES

	; now call update on final block
	RCALL update
	RJMP END_OF_FINAL	


PADD_AND_ADD_FULL_BLOCK:

	ADD XL, BYTES_REMAINING

	; store initial magic byte
	ST X+, TEMP_REG

	; padd zeros until counter is reached
	CLR TEMP_REG
	PAD_ZEROS_2:
		CPI XL, LOW(SRAM_DATA+DATA_NUM_BYTE)
		BRGE HASH_BLOCK
		ST X+, TEMP_REG
		RJMP PAD_ZEROS_2
	
	HASH_BLOCK:
		RCALL update

		; reset address pointer X to begin of input data 
		LDI XH, HIGH(SRAM_DATA)
		LDI XL, LOW(SRAM_DATA)

		; reset Y-pointer to RAM counter
		LDI	YH, HIGH(SRAM_ADD_MEM+CNT_START)
		LDI	YL, LOW(SRAM_ADD_MEM+CNT_START)

		; clear temp_reg to make sure that only zeros to additional blocks are written (no leading one anymore!)
		CLR TEMP_REG
		CLR BYTES_REMAINING

		RJMP PAD_BLOCK

END_OF_FINAL:

	RET

; ADDITIONAL SUBFUNCTIONS

; SUBFUNCTION FOR UPDATE AND FINAL: STORE THE NUMBER OF MESSAGE BITS FOR PADDING FORMAT
; INPUT: BYTES_REMAINING
; DESTROYS: TEMP_REG, Y-Pointer
; OUTPUT: COUNTER BITS in RAM
UPDATE_BIT_COUNTER:

	; load pointer to bit counter
	LDI YH, HIGH(SRAM_ADD_MEM+CNT_START)
	LDI YL, LOW(SRAM_ADD_MEM+CNT_START)

	; check if bit counter was initialized already
	LDD TEMP_REG, Y+CNT_NUM_BYTE
	CPI TEMP_REG, 0 
	BRNE NO_UPDATE_NEEEDED

	; convert message length (64 bit value) from bytes to bits (multiply by 8 => shift length value by 3 bits to left)
	MOV WR_A0, BYTES_REMAINING
	CLR WR_A1 	; we currently use only a single byte to determine the message size --> adapt as necessary
	CLR WR_A2	; we currently use only a single byte to determine the message size --> adapt as necessary
	CLR WR_A3	; we currently use only a single byte to determine the message size --> adapt as necessary
	CLR WR_B0 	; we currently use only a single byte to determine the message size --> adapt as necessary
	CLR WR_B1	; we currently use only a single byte to determine the message size --> adapt as necessary
	CLR WR_B2	; we currently use only a single byte to determine the message size --> adapt as necessary
	CLR WR_B3	; we currently use only a single byte to determine the message size --> adapt as necessary

	; multiply by 8 (shift by 3 bits to left)
	RCALL SHIFT_BIT_TO_LEFT_64
	RCALL SHIFT_BIT_TO_LEFT_64
	RCALL SHIFT_BIT_TO_LEFT_64

	; store 64-bit bit counter value at Y pointer
	WRITE_WSTATE_WORD WR_B0, WR_B1, WR_B2, WR_B3		
	WRITE_WSTATE_WORD WR_A0, WR_A1, WR_A2, WR_A3		
	
	; set valid flag in last byte of counter value
	LDI TEMP_REG, 0x01
	ST  Y, TEMP_REG

	NO_UPDATE_NEEEDED:

RET

; SUBFUNCTION FOR UPDATE FUNCTION: SHIFT A 64 BIT WORD TO LEFT BY ONE BIT
; INPUT: WR_A, WR_B
; DESTROYS: -
; OUTPUT: WR_A, WR_B
SHIFT_BIT_TO_LEFT_64:

	LSL WR_A0
	ROL WR_A1
	ROL WR_A2
	ROL WR_A3
	ROL WR_B0
	ROL WR_B1
	ROL WR_B2
	ROL WR_B3

RET


; CONSTANTS

IV: .DB  0x6A, 0x09, 0xE6, 0x67, 0xBB, 0x67, 0xAE, 0x85, 0x3C, 0x6E, 0xF3, 0x72, 0xA5, 0x4F, 0xF5, 0x3A, 0x51, 0x0E, 0x52, 0x7F, 0x9B, 0x05, 0x68, 0x8C, 0x1F, 0x83, 0xD9, 0xAB, 0x5B, 0xE0, 0xCD, 0x19 ; big endian order
RC: .DB 0x98, 0x2F, 0x8A, 0x42, 0x91, 0x44, 0x37, 0x71, 0xCF, 0xFB, 0xC0, 0xB5, 0xA5, 0xDB, 0xB5, 0xE9, 0x5B, 0xC2, 0x56, 0x39, 0xF1, 0x11, 0xF1, 0x59, 0xA4, 0x82, 0x3F, 0x92, 0xD5, 0x5E, 0x1C, 0xAB, 0x98, 0xAA, 0x07, 0xD8, 0x01, 0x5B, 0x83, 0x12, 0xBE, 0x85, 0x31, 0x24, 0xC3, 0x7D, 0x0C, 0x55, 0x74, 0x5D, 0xBE, 0x72, 0xFE, 0xB1, 0xDE, 0x80, 0xA7, 0x06, 0xDC, 0x9B, 0x74, 0xF1, 0x9B, 0xC1, 0xC1, 0x69, 0x9B, 0xE4, 0x86, 0x47, 0xBE, 0xEF, 0xC6, 0x9D, 0xC1, 0x0F, 0xCC, 0xA1, 0x0C, 0x24, 0x6F, 0x2C, 0xE9, 0x2D, 0xAA, 0x84, 0x74, 0x4A, 0xDC, 0xA9, 0xB0, 0x5C, 0xDA, 0x88, 0xF9, 0x76, 0x52, 0x51, 0x3E, 0x98, 0x6D, 0xC6, 0x31, 0xA8, 0xC8, 0x27, 0x03, 0xB0, 0xC7, 0x7F, 0x59, 0xBF, 0xF3, 0x0B, 0xE0, 0xC6, 0x47, 0x91, 0xA7, 0xD5, 0x51, 0x63, 0xCA, 0x06, 0x67, 0x29, 0x29, 0x14, 0x85, 0x0A, 0xB7, 0x27, 0x38, 0x21, 0x1B, 0x2E, 0xFC, 0x6D, 0x2C, 0x4D, 0x13, 0x0D, 0x38, 0x53, 0x54, 0x73, 0x0A, 0x65, 0xBB, 0x0A, 0x6A, 0x76, 0x2E, 0xC9, 0xC2, 0x81, 0x85, 0x2C, 0x72, 0x92, 0xA1, 0xE8, 0xBF, 0xA2, 0x4B, 0x66, 0x1A, 0xA8, 0x70, 0x8B, 0x4B, 0xC2, 0xA3, 0x51, 0x6C, 0xC7, 0x19, 0xE8, 0x92, 0xD1, 0x24, 0x06, 0x99, 0xD6, 0x85, 0x35, 0x0E, 0xF4, 0x70, 0xA0, 0x6A, 0x10, 0x16, 0xC1, 0xA4, 0x19, 0x08, 0x6C, 0x37, 0x1E, 0x4C, 0x77, 0x48, 0x27, 0xB5, 0xBC, 0xB0, 0x34, 0xB3, 0x0C, 0x1C, 0x39, 0x4A, 0xAA, 0xD8, 0x4E, 0x4F, 0xCA, 0x9C, 0x5B, 0xF3, 0x6F, 0x2E, 0x68, 0xEE, 0x82, 0x8F, 0x74, 0x6F, 0x63, 0xA5, 0x78, 0x14, 0x78, 0xC8, 0x84, 0x08, 0x02, 0xC7, 0x8C, 0xFA, 0xFF, 0xBE, 0x90, 0xEB, 0x6C, 0x50, 0xA4, 0xF7, 0xA3, 0xF9, 0xBE, 0xF2, 0x78, 0x71, 0xC6