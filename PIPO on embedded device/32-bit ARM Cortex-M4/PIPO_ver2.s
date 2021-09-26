;PIPO in cortex M4
;Parallel Plaintext : r2-r9
;return address : r0(text), r1(master key)
;temp : r0, r10, r11, r12

	AREA myCode, CODE
		ENTRY
		EXPORT __PIPO

__PIPO

	;PUSH
	SUB sp, sp, #52
	STR r0, [sp]
	STR r1, [sp, #4]
	STR r2, [sp, #8]
	STR r3, [sp, #12]
	STR r4, [sp, #16]
	STR r5, [sp, #20]
	STR r6, [sp, #24]
	STR r7, [sp, #28]
	STR r8, [sp, #32]
	STR r9, [sp, #36]
	STR r10, [sp, #40]
	STR r11, [sp, #44]
	STR r12, [sp, #48]

	;LOAD DATA
	LDRB r2, [r0] 	;load PT0
	LDRB r3, [r0, #1]
	LDRB r4, [r0, #2]
	LDRB r5, [r0, #3]
	LDRB r6, [r0, #4]
	LDRB r7, [r0, #5]
	LDRB r8, [r0, #6]
	LDRB r9, [r0, #7]
	LSL r2, r2, #8
	LSL r3, r3, #8
	LSL r4, r4, #8
	LSL r5, r5, #8
	LSL r6, r6, #8
	LSL r7, r7, #8
	LSL r8, r8, #8
	LSL r9, r9, #8
	LDRB r10, [r0, #8]	;load pT1
	ORR r2, r2, r10 
	LDRB r10, [r0, #9]
	ORR r3, r3, r10
	LDRB r10, [r0, #10]
	ORR r4, r4, r10
	LDRB r10, [r0, #11]
	ORR r5, r5, r10		
	LDRB r10, [r0, #12]
	ORR r6, r6, r10 
	LDRB r10, [r0, #13]
	ORR r7, r7, r10
	LDRB r10, [r0, #14]
	ORR r8, r8, r10
	LDRB r10, [r0, #15]
	ORR r9, r9, r10		
	LSL r2, r2, #8
	LSL r3, r3, #8
	LSL r4, r4, #8
	LSL r5, r5, #8
	LSL r6, r6, #8
	LSL r7, r7, #8
	LSL r8, r8, #8
	LSL r9, r9, #8
	LDRB r10, [r0, #16]	;load PT2
	ORR r2, r2, r10 
	LDRB r10, [r0, #17]
	ORR r3, r3, r10
	LDRB r10, [r0, #18]
	ORR r4, r4, r10
	LDRB r10, [r0, #19]
	ORR r5, r5, r10		
	LDRB r10, [r0, #20]
	ORR r6, r6, r10 
	LDRB r10, [r0, #21]
	ORR r7, r7, r10
	LDRB r10, [r0, #22]
	ORR r8, r8, r10
	LDRB r10, [r0, #23]
	ORR r9, r9, r10		
	LSL r2, r2, #8
	LSL r3, r3, #8
	LSL r4, r4, #8
	LSL r5, r5, #8
	LSL r6, r6, #8
	LSL r7, r7, #8
	LSL r8, r8, #8
	LSL r9, r9, #8
	LDRB r10, [r0, #24]	;load PT3
	ORR r2, r2, r10 
	LDRB r10, [r0, #25]
	ORR r3, r3, r10
	LDRB r10, [r0, #26]
	ORR r4, r4, r10
	LDRB r10, [r0, #27]
	ORR r5, r5, r10		
	LDRB r10, [r0, #28]
	ORR r6, r6, r10 
	LDRB r10, [r0, #29]
	ORR r7, r7, r10
	LDRB r10, [r0, #30]
	ORR r8, r8, r10
	LDRB r10, [r0, #31]
	ORR r9, r9, r10		
	;LOAD DATA END
	
	;KEY ADD
	MOV r10, #0
	MOV r11, #0
	LDRB r10, [r1]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r5, r11
	
	MOV r11, #0
	LDRB r10, [r1, #1]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r4, r11
	
	MOV r11, #0
	LDRB r10, [r1, #2]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r3, r11
	
	MOV r11, #0
	LDRB r10, [r1, #3]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r2, r11
	
	MOV r11, #0
	LDRB r10, [r1, #4]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r9, r11
	
	MOV r11, #0
	LDRB r10, [r1, #5]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r8, r11
	
	MOV r11, #0
	LDRB r10, [r1, #6]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r7, r11
	
	MOV r11, #0
	LDRB r10, [r1, #7]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r6, r11
	;KEY ADD END
	
	;ROUND 1	
	;SLAYER
	and r12, r2, r3
	eor r4, r4, r12
	and r12, r6, r4
	eor r5, r5, r12
	eor r2, r2, r5
	eor r3, r3, r6
	orr r12, r5, r4
	eor r6, r6, r12
	eor r4, r4, r2
	and r12, r4, r3
	eor r5, r5, r12 ;OK
	
	and r12, r8, r9
	eor r7, r7, r12
	orr r12, r7, r8
	eor r9, r9, r12
	orr r12, r7, r9
	eor r8, r8, r12	  
	mvn r7, r7
	  
	eor r2, r2, r8
	eor r6, r6, r7
	eor r5, r5, r9
	
	mov r0, r2
	mov r10, r6
	mov r11, r5
	and r12, r0, r4
	eor r3, r3, r12
	eor r0, r0, r3	
	orr r12, r10, r11
	eor r3, r3, r12
	eor r10, r10, r4
	orr r12, r3, r11
	eor r4, r4, r12
	and r12, r0, r10
	eor r11, r11, r12
		
	eor r7, r7, r0
	eor r0, r8, r11
	eor r8, r9, r10
	mov r9, r2
	mov r2, r0
		
	mov r10, r6
	mov r6, r3
	mov r3, r10
	mov r11, r5
	mov r5, r4
	mov r4, r11
	;SLAYER END

	;PLAYER
	AND r11, r8, #0x01010101 ;left rotation : 7 
	AND r8, r8, #0xFEFEFEFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F0F0F0F ;left rotation : 4
	AND r7, r7, #0xF0F0F0F0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F1F1F1F ;left rotation : 3
	AND r6, r6, #0xE0E0E0E0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03030303 ;left rotation : 6
	AND r5, r5, #0xfcfcfcfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07070707 ;left rotation : 5
	AND r4, r4, #0xF8F8F8F8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F7F7F7F ;left rotation : 1
	AND r3, r3, #0x80808080
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F3F3F3F ;left rotation : 2
	AND r2, r2, #0xC0C0C0C0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	MOV r11, #0
	LDRB r10, [r1, #8]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r5, r11
	
	MOV r11, #0
	LDRB r10, [r1, #9]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r4, r11
	
	MOV r11, #0
	LDRB r10, [r1, #10]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r3, r11
	
	MOV r11, #0
	LDRB r10, [r1, #11]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r2, r11
	
	MOV r11, #0
	LDRB r10, [r1, #12]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r9, r11
	
	MOV r11, #0
	LDRB r10, [r1, #13]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r8, r11
	
	MOV r11, #0
	LDRB r10, [r1, #14]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r7, r11
	
	MOV r11, #0
	LDRB r10, [r1, #15]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r6, r11
	;KEY ADD END
	
	;ROUND 2	
	;SLAYER
	and r12, r2, r3
	eor r4, r4, r12
	and r12, r6, r4
	eor r5, r5, r12
	eor r2, r2, r5
	eor r3, r3, r6
	orr r12, r5, r4
	eor r6, r6, r12
	eor r4, r4, r2
	and r12, r4, r3
	eor r5, r5, r12 ;OK
	
	and r12, r8, r9
	eor r7, r7, r12
	orr r12, r7, r8
	eor r9, r9, r12
	orr r12, r7, r9
	eor r8, r8, r12	  
	mvn r7, r7
	  
	eor r2, r2, r8
	eor r6, r6, r7
	eor r5, r5, r9
	
	mov r0, r2
	mov r10, r6
	mov r11, r5
	and r12, r0, r4
	eor r3, r3, r12
	eor r0, r0, r3	
	orr r12, r10, r11
	eor r3, r3, r12
	eor r10, r10, r4
	orr r12, r3, r11
	eor r4, r4, r12
	and r12, r0, r10
	eor r11, r11, r12
		
	eor r7, r7, r0
	eor r0, r8, r11
	eor r8, r9, r10
	mov r9, r2
	mov r2, r0
		
	mov r10, r6
	mov r6, r3
	mov r3, r10
	mov r11, r5
	mov r5, r4
	mov r4, r11
	;SLAYER END

	;PLAYER
	AND r11, r8, #0x01010101 ;left rotation : 7 
	AND r8, r8, #0xFEFEFEFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F0F0F0F ;left rotation : 4
	AND r7, r7, #0xF0F0F0F0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F1F1F1F ;left rotation : 3
	AND r6, r6, #0xE0E0E0E0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03030303 ;left rotation : 6
	AND r5, r5, #0xfcfcfcfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07070707 ;left rotation : 5
	AND r4, r4, #0xF8F8F8F8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F7F7F7F ;left rotation : 1
	AND r3, r3, #0x80808080
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F3F3F3F ;left rotation : 2
	AND r2, r2, #0xC0C0C0C0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	MOV r11, #0
	LDRB r10, [r1, #16]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r5, r11
	
	MOV r11, #0
	LDRB r10, [r1, #17]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r4, r11
	
	MOV r11, #0
	LDRB r10, [r1, #18]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r3, r11
	
	MOV r11, #0
	LDRB r10, [r1, #19]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r2, r11
	
	MOV r11, #0
	LDRB r10, [r1, #20]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r9, r11
	
	MOV r11, #0
	LDRB r10, [r1, #21]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r8, r11
	
	MOV r11, #0
	LDRB r10, [r1, #22]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r7, r11
	
	MOV r11, #0
	LDRB r10, [r1, #23]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r6, r11
	;KEY ADD END
	
	;ROUND 3
	;SLAYER
	and r12, r2, r3
	eor r4, r4, r12
	and r12, r6, r4
	eor r5, r5, r12
	eor r2, r2, r5
	eor r3, r3, r6
	orr r12, r5, r4
	eor r6, r6, r12
	eor r4, r4, r2
	and r12, r4, r3
	eor r5, r5, r12 ;OK
	
	and r12, r8, r9
	eor r7, r7, r12
	orr r12, r7, r8
	eor r9, r9, r12
	orr r12, r7, r9
	eor r8, r8, r12	  
	mvn r7, r7
	  
	eor r2, r2, r8
	eor r6, r6, r7
	eor r5, r5, r9
	
	mov r0, r2
	mov r10, r6
	mov r11, r5
	and r12, r0, r4
	eor r3, r3, r12
	eor r0, r0, r3	
	orr r12, r10, r11
	eor r3, r3, r12
	eor r10, r10, r4
	orr r12, r3, r11
	eor r4, r4, r12
	and r12, r0, r10
	eor r11, r11, r12
		
	eor r7, r7, r0
	eor r0, r8, r11
	eor r8, r9, r10
	mov r9, r2
	mov r2, r0
		
	mov r10, r6
	mov r6, r3
	mov r3, r10
	mov r11, r5
	mov r5, r4
	mov r4, r11
	;SLAYER END

	;PLAYER
	AND r11, r8, #0x01010101 ;left rotation : 7 
	AND r8, r8, #0xFEFEFEFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F0F0F0F ;left rotation : 4
	AND r7, r7, #0xF0F0F0F0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F1F1F1F ;left rotation : 3
	AND r6, r6, #0xE0E0E0E0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03030303 ;left rotation : 6
	AND r5, r5, #0xfcfcfcfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07070707 ;left rotation : 5
	AND r4, r4, #0xF8F8F8F8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F7F7F7F ;left rotation : 1
	AND r3, r3, #0x80808080
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F3F3F3F ;left rotation : 2
	AND r2, r2, #0xC0C0C0C0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	MOV r11, #0
	LDRB r10, [r1, #24]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r5, r11
	
	MOV r11, #0
	LDRB r10, [r1, #25]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r4, r11
	
	MOV r11, #0
	LDRB r10, [r1, #26]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r3, r11
	
	MOV r11, #0
	LDRB r10, [r1, #27]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r2, r11
	
	MOV r11, #0
	LDRB r10, [r1, #28]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r9, r11
	
	MOV r11, #0
	LDRB r10, [r1, #29]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r8, r11
	
	MOV r11, #0
	LDRB r10, [r1, #30]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r7, r11
	
	MOV r11, #0
	LDRB r10, [r1, #31]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r6, r11
	;KEY ADD END
	
	;ROUND 4
	;SLAYER
	and r12, r2, r3
	eor r4, r4, r12
	and r12, r6, r4
	eor r5, r5, r12
	eor r2, r2, r5
	eor r3, r3, r6
	orr r12, r5, r4
	eor r6, r6, r12
	eor r4, r4, r2
	and r12, r4, r3
	eor r5, r5, r12 ;OK
	
	and r12, r8, r9
	eor r7, r7, r12
	orr r12, r7, r8
	eor r9, r9, r12
	orr r12, r7, r9
	eor r8, r8, r12	  
	mvn r7, r7
	  
	eor r2, r2, r8
	eor r6, r6, r7
	eor r5, r5, r9
	
	mov r0, r2
	mov r10, r6
	mov r11, r5
	and r12, r0, r4
	eor r3, r3, r12
	eor r0, r0, r3	
	orr r12, r10, r11
	eor r3, r3, r12
	eor r10, r10, r4
	orr r12, r3, r11
	eor r4, r4, r12
	and r12, r0, r10
	eor r11, r11, r12
		
	eor r7, r7, r0
	eor r0, r8, r11
	eor r8, r9, r10
	mov r9, r2
	mov r2, r0
		
	mov r10, r6
	mov r6, r3
	mov r3, r10
	mov r11, r5
	mov r5, r4
	mov r4, r11
	;SLAYER END

	;PLAYER
	AND r11, r8, #0x01010101 ;left rotation : 7 
	AND r8, r8, #0xFEFEFEFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F0F0F0F ;left rotation : 4
	AND r7, r7, #0xF0F0F0F0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F1F1F1F ;left rotation : 3
	AND r6, r6, #0xE0E0E0E0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03030303 ;left rotation : 6
	AND r5, r5, #0xfcfcfcfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07070707 ;left rotation : 5
	AND r4, r4, #0xF8F8F8F8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F7F7F7F ;left rotation : 1
	AND r3, r3, #0x80808080
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F3F3F3F ;left rotation : 2
	AND r2, r2, #0xC0C0C0C0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	MOV r11, #0
	LDRB r10, [r1, #32]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r5, r11
	
	MOV r11, #0
	LDRB r10, [r1, #33]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r4, r11
	
	MOV r11, #0
	LDRB r10, [r1, #34]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r3, r11
	
	MOV r11, #0
	LDRB r10, [r1, #35]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r2, r11
	
	MOV r11, #0
	LDRB r10, [r1, #36]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r9, r11
	
	MOV r11, #0
	LDRB r10, [r1, #37]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r8, r11
	
	MOV r11, #0
	LDRB r10, [r1, #38]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r7, r11
	
	MOV r11, #0
	LDRB r10, [r1, #39]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r6, r11
	;KEY ADD END
	
	;ROUND 5
	;SLAYER
	and r12, r2, r3
	eor r4, r4, r12
	and r12, r6, r4
	eor r5, r5, r12
	eor r2, r2, r5
	eor r3, r3, r6
	orr r12, r5, r4
	eor r6, r6, r12
	eor r4, r4, r2
	and r12, r4, r3
	eor r5, r5, r12 ;OK
	
	and r12, r8, r9
	eor r7, r7, r12
	orr r12, r7, r8
	eor r9, r9, r12
	orr r12, r7, r9
	eor r8, r8, r12	  
	mvn r7, r7
	  
	eor r2, r2, r8
	eor r6, r6, r7
	eor r5, r5, r9
	
	mov r0, r2
	mov r10, r6
	mov r11, r5
	and r12, r0, r4
	eor r3, r3, r12
	eor r0, r0, r3	
	orr r12, r10, r11
	eor r3, r3, r12
	eor r10, r10, r4
	orr r12, r3, r11
	eor r4, r4, r12
	and r12, r0, r10
	eor r11, r11, r12
		
	eor r7, r7, r0
	eor r0, r8, r11
	eor r8, r9, r10
	mov r9, r2
	mov r2, r0
		
	mov r10, r6
	mov r6, r3
	mov r3, r10
	mov r11, r5
	mov r5, r4
	mov r4, r11
	;SLAYER END

	;PLAYER
	AND r11, r8, #0x01010101 ;left rotation : 7 
	AND r8, r8, #0xFEFEFEFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F0F0F0F ;left rotation : 4
	AND r7, r7, #0xF0F0F0F0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F1F1F1F ;left rotation : 3
	AND r6, r6, #0xE0E0E0E0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03030303 ;left rotation : 6
	AND r5, r5, #0xfcfcfcfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07070707 ;left rotation : 5
	AND r4, r4, #0xF8F8F8F8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F7F7F7F ;left rotation : 1
	AND r3, r3, #0x80808080
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F3F3F3F ;left rotation : 2
	AND r2, r2, #0xC0C0C0C0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	MOV r11, #0
	LDRB r10, [r1, #40]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r5, r11
	
	MOV r11, #0
	LDRB r10, [r1, #41]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r4, r11
	
	MOV r11, #0
	LDRB r10, [r1, #42]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r3, r11
	
	MOV r11, #0
	LDRB r10, [r1, #43]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r2, r11
	
	MOV r11, #0
	LDRB r10, [r1, #44]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r9, r11
	
	MOV r11, #0
	LDRB r10, [r1, #45]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r8, r11
	
	MOV r11, #0
	LDRB r10, [r1, #46]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r7, r11
	
	MOV r11, #0
	LDRB r10, [r1, #47]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r6, r11
	;KEY ADD END
	
	;ROUND 6
	;SLAYER
	and r12, r2, r3
	eor r4, r4, r12
	and r12, r6, r4
	eor r5, r5, r12
	eor r2, r2, r5
	eor r3, r3, r6
	orr r12, r5, r4
	eor r6, r6, r12
	eor r4, r4, r2
	and r12, r4, r3
	eor r5, r5, r12 ;OK
	
	and r12, r8, r9
	eor r7, r7, r12
	orr r12, r7, r8
	eor r9, r9, r12
	orr r12, r7, r9
	eor r8, r8, r12	  
	mvn r7, r7
	  
	eor r2, r2, r8
	eor r6, r6, r7
	eor r5, r5, r9
	
	mov r0, r2
	mov r10, r6
	mov r11, r5
	and r12, r0, r4
	eor r3, r3, r12
	eor r0, r0, r3	
	orr r12, r10, r11
	eor r3, r3, r12
	eor r10, r10, r4
	orr r12, r3, r11
	eor r4, r4, r12
	and r12, r0, r10
	eor r11, r11, r12
		
	eor r7, r7, r0
	eor r0, r8, r11
	eor r8, r9, r10
	mov r9, r2
	mov r2, r0
		
	mov r10, r6
	mov r6, r3
	mov r3, r10
	mov r11, r5
	mov r5, r4
	mov r4, r11
	;SLAYER END

	;PLAYER
	AND r11, r8, #0x01010101 ;left rotation : 7 
	AND r8, r8, #0xFEFEFEFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F0F0F0F ;left rotation : 4
	AND r7, r7, #0xF0F0F0F0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F1F1F1F ;left rotation : 3
	AND r6, r6, #0xE0E0E0E0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03030303 ;left rotation : 6
	AND r5, r5, #0xfcfcfcfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07070707 ;left rotation : 5
	AND r4, r4, #0xF8F8F8F8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F7F7F7F ;left rotation : 1
	AND r3, r3, #0x80808080
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F3F3F3F ;left rotation : 2
	AND r2, r2, #0xC0C0C0C0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	MOV r11, #0
	LDRB r10, [r1, #48]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r5, r11
	
	MOV r11, #0
	LDRB r10, [r1, #49]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r4, r11
	
	MOV r11, #0
	LDRB r10, [r1, #50]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r3, r11
	
	MOV r11, #0
	LDRB r10, [r1, #51]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r2, r11
	
	MOV r11, #0
	LDRB r10, [r1, #52]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r9, r11
	
	MOV r11, #0
	LDRB r10, [r1, #53]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r8, r11
	
	MOV r11, #0
	LDRB r10, [r1, #54]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r7, r11
	
	MOV r11, #0
	LDRB r10, [r1, #55]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r6, r11
	;KEY ADD END
	
	;ROUND 7
	;SLAYER
	and r12, r2, r3
	eor r4, r4, r12
	and r12, r6, r4
	eor r5, r5, r12
	eor r2, r2, r5
	eor r3, r3, r6
	orr r12, r5, r4
	eor r6, r6, r12
	eor r4, r4, r2
	and r12, r4, r3
	eor r5, r5, r12 ;OK
	
	and r12, r8, r9
	eor r7, r7, r12
	orr r12, r7, r8
	eor r9, r9, r12
	orr r12, r7, r9
	eor r8, r8, r12	  
	mvn r7, r7
	  
	eor r2, r2, r8
	eor r6, r6, r7
	eor r5, r5, r9
	
	mov r0, r2
	mov r10, r6
	mov r11, r5
	and r12, r0, r4
	eor r3, r3, r12
	eor r0, r0, r3	
	orr r12, r10, r11
	eor r3, r3, r12
	eor r10, r10, r4
	orr r12, r3, r11
	eor r4, r4, r12
	and r12, r0, r10
	eor r11, r11, r12
		
	eor r7, r7, r0
	eor r0, r8, r11
	eor r8, r9, r10
	mov r9, r2
	mov r2, r0
		
	mov r10, r6
	mov r6, r3
	mov r3, r10
	mov r11, r5
	mov r5, r4
	mov r4, r11
	;SLAYER END

	;PLAYER
	AND r11, r8, #0x01010101 ;left rotation : 7 
	AND r8, r8, #0xFEFEFEFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F0F0F0F ;left rotation : 4
	AND r7, r7, #0xF0F0F0F0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F1F1F1F ;left rotation : 3
	AND r6, r6, #0xE0E0E0E0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03030303 ;left rotation : 6
	AND r5, r5, #0xfcfcfcfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07070707 ;left rotation : 5
	AND r4, r4, #0xF8F8F8F8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F7F7F7F ;left rotation : 1
	AND r3, r3, #0x80808080
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F3F3F3F ;left rotation : 2
	AND r2, r2, #0xC0C0C0C0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	MOV r11, #0
	LDRB r10, [r1, #56]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r5, r11
	
	MOV r11, #0
	LDRB r10, [r1, #57]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r4, r11
	
	MOV r11, #0
	LDRB r10, [r1, #58]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r3, r11
	
	MOV r11, #0
	LDRB r10, [r1, #59]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r2, r11
	
	MOV r11, #0
	LDRB r10, [r1, #60]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r9, r11
	
	MOV r11, #0
	LDRB r10, [r1, #61]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r8, r11
	
	MOV r11, #0
	LDRB r10, [r1, #62]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r7, r11
	
	MOV r11, #0
	LDRB r10, [r1, #63]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r6, r11
	;KEY ADD END
	
	;ROUND 8
	;SLAYER
	and r12, r2, r3
	eor r4, r4, r12
	and r12, r6, r4
	eor r5, r5, r12
	eor r2, r2, r5
	eor r3, r3, r6
	orr r12, r5, r4
	eor r6, r6, r12
	eor r4, r4, r2
	and r12, r4, r3
	eor r5, r5, r12 ;OK
	
	and r12, r8, r9
	eor r7, r7, r12
	orr r12, r7, r8
	eor r9, r9, r12
	orr r12, r7, r9
	eor r8, r8, r12	  
	mvn r7, r7
	  
	eor r2, r2, r8
	eor r6, r6, r7
	eor r5, r5, r9
	
	mov r0, r2
	mov r10, r6
	mov r11, r5
	and r12, r0, r4
	eor r3, r3, r12
	eor r0, r0, r3	
	orr r12, r10, r11
	eor r3, r3, r12
	eor r10, r10, r4
	orr r12, r3, r11
	eor r4, r4, r12
	and r12, r0, r10
	eor r11, r11, r12
		
	eor r7, r7, r0
	eor r0, r8, r11
	eor r8, r9, r10
	mov r9, r2
	mov r2, r0
		
	mov r10, r6
	mov r6, r3
	mov r3, r10
	mov r11, r5
	mov r5, r4
	mov r4, r11
	;SLAYER END

	;PLAYER
	AND r11, r8, #0x01010101 ;left rotation : 7 
	AND r8, r8, #0xFEFEFEFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F0F0F0F ;left rotation : 4
	AND r7, r7, #0xF0F0F0F0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F1F1F1F ;left rotation : 3
	AND r6, r6, #0xE0E0E0E0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03030303 ;left rotation : 6
	AND r5, r5, #0xfcfcfcfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07070707 ;left rotation : 5
	AND r4, r4, #0xF8F8F8F8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F7F7F7F ;left rotation : 1
	AND r3, r3, #0x80808080
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F3F3F3F ;left rotation : 2
	AND r2, r2, #0xC0C0C0C0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	MOV r11, #0
	LDRB r10, [r1, #64]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r5, r11
	
	MOV r11, #0
	LDRB r10, [r1, #65]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r4, r11
	
	MOV r11, #0
	LDRB r10, [r1, #66]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r3, r11
	
	MOV r11, #0
	LDRB r10, [r1, #67]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r2, r11
	
	MOV r11, #0
	LDRB r10, [r1, #68]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r9, r11
	
	MOV r11, #0
	LDRB r10, [r1, #69]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r8, r11
	
	MOV r11, #0
	LDRB r10, [r1, #70]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r7, r11
	
	MOV r11, #0
	LDRB r10, [r1, #71]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r6, r11
	;KEY ADD END
	
	;ROUND 9
	;SLAYER
	and r12, r2, r3
	eor r4, r4, r12
	and r12, r6, r4
	eor r5, r5, r12
	eor r2, r2, r5
	eor r3, r3, r6
	orr r12, r5, r4
	eor r6, r6, r12
	eor r4, r4, r2
	and r12, r4, r3
	eor r5, r5, r12 ;OK
	
	and r12, r8, r9
	eor r7, r7, r12
	orr r12, r7, r8
	eor r9, r9, r12
	orr r12, r7, r9
	eor r8, r8, r12	  
	mvn r7, r7
	  
	eor r2, r2, r8
	eor r6, r6, r7
	eor r5, r5, r9
	
	mov r0, r2
	mov r10, r6
	mov r11, r5
	and r12, r0, r4
	eor r3, r3, r12
	eor r0, r0, r3	
	orr r12, r10, r11
	eor r3, r3, r12
	eor r10, r10, r4
	orr r12, r3, r11
	eor r4, r4, r12
	and r12, r0, r10
	eor r11, r11, r12
		
	eor r7, r7, r0
	eor r0, r8, r11
	eor r8, r9, r10
	mov r9, r2
	mov r2, r0
		
	mov r10, r6
	mov r6, r3
	mov r3, r10
	mov r11, r5
	mov r5, r4
	mov r4, r11
	;SLAYER END

	;PLAYER
	AND r11, r8, #0x01010101 ;left rotation : 7 
	AND r8, r8, #0xFEFEFEFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F0F0F0F ;left rotation : 4
	AND r7, r7, #0xF0F0F0F0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F1F1F1F ;left rotation : 3
	AND r6, r6, #0xE0E0E0E0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03030303 ;left rotation : 6
	AND r5, r5, #0xfcfcfcfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07070707 ;left rotation : 5
	AND r4, r4, #0xF8F8F8F8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F7F7F7F ;left rotation : 1
	AND r3, r3, #0x80808080
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F3F3F3F ;left rotation : 2
	AND r2, r2, #0xC0C0C0C0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	MOV r11, #0
	LDRB r10, [r1, #72]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r5, r11
	
	MOV r11, #0
	LDRB r10, [r1, #73]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r4, r11
	
	MOV r11, #0
	LDRB r10, [r1, #74]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r3, r11
	
	MOV r11, #0
	LDRB r10, [r1, #75]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r2, r11
	
	MOV r11, #0
	LDRB r10, [r1, #76]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r9, r11
	
	MOV r11, #0
	LDRB r10, [r1, #77]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r8, r11
	
	MOV r11, #0
	LDRB r10, [r1, #78]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r7, r11
	
	MOV r11, #0
	LDRB r10, [r1, #79]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r6, r11
	;KEY ADD END
	
	;ROUND 10
	;SLAYER
	and r12, r2, r3
	eor r4, r4, r12
	and r12, r6, r4
	eor r5, r5, r12
	eor r2, r2, r5
	eor r3, r3, r6
	orr r12, r5, r4
	eor r6, r6, r12
	eor r4, r4, r2
	and r12, r4, r3
	eor r5, r5, r12 ;OK
	
	and r12, r8, r9
	eor r7, r7, r12
	orr r12, r7, r8
	eor r9, r9, r12
	orr r12, r7, r9
	eor r8, r8, r12	  
	mvn r7, r7
	  
	eor r2, r2, r8
	eor r6, r6, r7
	eor r5, r5, r9
	
	mov r0, r2
	mov r10, r6
	mov r11, r5
	and r12, r0, r4
	eor r3, r3, r12
	eor r0, r0, r3	
	orr r12, r10, r11
	eor r3, r3, r12
	eor r10, r10, r4
	orr r12, r3, r11
	eor r4, r4, r12
	and r12, r0, r10
	eor r11, r11, r12
		
	eor r7, r7, r0
	eor r0, r8, r11
	eor r8, r9, r10
	mov r9, r2
	mov r2, r0
		
	mov r10, r6
	mov r6, r3
	mov r3, r10
	mov r11, r5
	mov r5, r4
	mov r4, r11
	;SLAYER END

	;PLAYER
	AND r11, r8, #0x01010101 ;left rotation : 7 
	AND r8, r8, #0xFEFEFEFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F0F0F0F ;left rotation : 4
	AND r7, r7, #0xF0F0F0F0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F1F1F1F ;left rotation : 3
	AND r6, r6, #0xE0E0E0E0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03030303 ;left rotation : 6
	AND r5, r5, #0xfcfcfcfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07070707 ;left rotation : 5
	AND r4, r4, #0xF8F8F8F8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F7F7F7F ;left rotation : 1
	AND r3, r3, #0x80808080
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F3F3F3F ;left rotation : 2
	AND r2, r2, #0xC0C0C0C0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	MOV r11, #0
	LDRB r10, [r1, #80]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r5, r11
	
	MOV r11, #0
	LDRB r10, [r1, #81]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r4, r11
	
	MOV r11, #0
	LDRB r10, [r1, #82]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r3, r11
	
	MOV r11, #0
	LDRB r10, [r1, #83]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r2, r11
	
	MOV r11, #0
	LDRB r10, [r1, #84]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r9, r11
	
	MOV r11, #0
	LDRB r10, [r1, #85]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r8, r11
	
	MOV r11, #0
	LDRB r10, [r1, #86]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r7, r11
	
	MOV r11, #0
	LDRB r10, [r1, #87]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r6, r11
	;KEY ADD END
	
	;ROUND 11
	;SLAYER
	and r12, r2, r3
	eor r4, r4, r12
	and r12, r6, r4
	eor r5, r5, r12
	eor r2, r2, r5
	eor r3, r3, r6
	orr r12, r5, r4
	eor r6, r6, r12
	eor r4, r4, r2
	and r12, r4, r3
	eor r5, r5, r12 ;OK
	
	and r12, r8, r9
	eor r7, r7, r12
	orr r12, r7, r8
	eor r9, r9, r12
	orr r12, r7, r9
	eor r8, r8, r12	  
	mvn r7, r7
	  
	eor r2, r2, r8
	eor r6, r6, r7
	eor r5, r5, r9
	
	mov r0, r2
	mov r10, r6
	mov r11, r5
	and r12, r0, r4
	eor r3, r3, r12
	eor r0, r0, r3	
	orr r12, r10, r11
	eor r3, r3, r12
	eor r10, r10, r4
	orr r12, r3, r11
	eor r4, r4, r12
	and r12, r0, r10
	eor r11, r11, r12
		
	eor r7, r7, r0
	eor r0, r8, r11
	eor r8, r9, r10
	mov r9, r2
	mov r2, r0
		
	mov r10, r6
	mov r6, r3
	mov r3, r10
	mov r11, r5
	mov r5, r4
	mov r4, r11
	;SLAYER END

	;PLAYER
	AND r11, r8, #0x01010101 ;left rotation : 7 
	AND r8, r8, #0xFEFEFEFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F0F0F0F ;left rotation : 4
	AND r7, r7, #0xF0F0F0F0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F1F1F1F ;left rotation : 3
	AND r6, r6, #0xE0E0E0E0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03030303 ;left rotation : 6
	AND r5, r5, #0xfcfcfcfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07070707 ;left rotation : 5
	AND r4, r4, #0xF8F8F8F8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F7F7F7F ;left rotation : 1
	AND r3, r3, #0x80808080
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F3F3F3F ;left rotation : 2
	AND r2, r2, #0xC0C0C0C0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	MOV r11, #0
	LDRB r10, [r1, #88]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r5, r11
	
	MOV r11, #0
	LDRB r10, [r1, #89]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r4, r11
	
	MOV r11, #0
	LDRB r10, [r1, #90]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r3, r11
	
	MOV r11, #0
	LDRB r10, [r1, #91]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r2, r11
	
	MOV r11, #0
	LDRB r10, [r1, #92]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r9, r11
	
	MOV r11, #0
	LDRB r10, [r1, #93]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r8, r11
	
	MOV r11, #0
	LDRB r10, [r1, #94]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r7, r11
	
	MOV r11, #0
	LDRB r10, [r1, #95]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r6, r11
	;KEY ADD END
	
	;ROUND 12
	;SLAYER
	and r12, r2, r3
	eor r4, r4, r12
	and r12, r6, r4
	eor r5, r5, r12
	eor r2, r2, r5
	eor r3, r3, r6
	orr r12, r5, r4
	eor r6, r6, r12
	eor r4, r4, r2
	and r12, r4, r3
	eor r5, r5, r12 ;OK
	
	and r12, r8, r9
	eor r7, r7, r12
	orr r12, r7, r8
	eor r9, r9, r12
	orr r12, r7, r9
	eor r8, r8, r12	  
	mvn r7, r7
	  
	eor r2, r2, r8
	eor r6, r6, r7
	eor r5, r5, r9
	
	mov r0, r2
	mov r10, r6
	mov r11, r5
	and r12, r0, r4
	eor r3, r3, r12
	eor r0, r0, r3	
	orr r12, r10, r11
	eor r3, r3, r12
	eor r10, r10, r4
	orr r12, r3, r11
	eor r4, r4, r12
	and r12, r0, r10
	eor r11, r11, r12
		
	eor r7, r7, r0
	eor r0, r8, r11
	eor r8, r9, r10
	mov r9, r2
	mov r2, r0
		
	mov r10, r6
	mov r6, r3
	mov r3, r10
	mov r11, r5
	mov r5, r4
	mov r4, r11
	;SLAYER END

	;PLAYER
	AND r11, r8, #0x01010101 ;left rotation : 7 
	AND r8, r8, #0xFEFEFEFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F0F0F0F ;left rotation : 4
	AND r7, r7, #0xF0F0F0F0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F1F1F1F ;left rotation : 3
	AND r6, r6, #0xE0E0E0E0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03030303 ;left rotation : 6
	AND r5, r5, #0xfcfcfcfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07070707 ;left rotation : 5
	AND r4, r4, #0xF8F8F8F8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F7F7F7F ;left rotation : 1
	AND r3, r3, #0x80808080
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F3F3F3F ;left rotation : 2
	AND r2, r2, #0xC0C0C0C0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	MOV r11, #0
	LDRB r10, [r1, #96]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r5, r11
	
	MOV r11, #0
	LDRB r10, [r1, #97]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r4, r11
	
	MOV r11, #0
	LDRB r10, [r1, #98]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r3, r11
	
	MOV r11, #0
	LDRB r10, [r1, #99]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r2, r11
	
	MOV r11, #0
	LDRB r10, [r1, #100]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r9, r11
	
	MOV r11, #0
	LDRB r10, [r1, #101]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r8, r11
	
	MOV r11, #0
	LDRB r10, [r1, #102]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r7, r11
	
	MOV r11, #0
	LDRB r10, [r1, #103]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r6, r11
	;KEY ADD END
	
	;ROUND 13
	;SLAYER
	and r12, r2, r3
	eor r4, r4, r12
	and r12, r6, r4
	eor r5, r5, r12
	eor r2, r2, r5
	eor r3, r3, r6
	orr r12, r5, r4
	eor r6, r6, r12
	eor r4, r4, r2
	and r12, r4, r3
	eor r5, r5, r12 ;OK
	
	and r12, r8, r9
	eor r7, r7, r12
	orr r12, r7, r8
	eor r9, r9, r12
	orr r12, r7, r9
	eor r8, r8, r12	  
	mvn r7, r7
	  
	eor r2, r2, r8
	eor r6, r6, r7
	eor r5, r5, r9
	
	mov r0, r2
	mov r10, r6
	mov r11, r5
	and r12, r0, r4
	eor r3, r3, r12
	eor r0, r0, r3	
	orr r12, r10, r11
	eor r3, r3, r12
	eor r10, r10, r4
	orr r12, r3, r11
	eor r4, r4, r12
	and r12, r0, r10
	eor r11, r11, r12
		
	eor r7, r7, r0
	eor r0, r8, r11
	eor r8, r9, r10
	mov r9, r2
	mov r2, r0
		
	mov r10, r6
	mov r6, r3
	mov r3, r10
	mov r11, r5
	mov r5, r4
	mov r4, r11
	;SLAYER END

	;PLAYER
	AND r11, r8, #0x01010101 ;left rotation : 7 
	AND r8, r8, #0xFEFEFEFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F0F0F0F ;left rotation : 4
	AND r7, r7, #0xF0F0F0F0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F1F1F1F ;left rotation : 3
	AND r6, r6, #0xE0E0E0E0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03030303 ;left rotation : 6
	AND r5, r5, #0xfcfcfcfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07070707 ;left rotation : 5
	AND r4, r4, #0xF8F8F8F8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F7F7F7F ;left rotation : 1
	AND r3, r3, #0x80808080
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F3F3F3F ;left rotation : 2
	AND r2, r2, #0xC0C0C0C0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	MOV r11, #0
	LDRB r10, [r1, #104]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r5, r11
	
	MOV r11, #0
	LDRB r10, [r1, #105]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r4, r11
	
	MOV r11, #0
	LDRB r10, [r1, #106]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r3, r11
	
	MOV r11, #0
	LDRB r10, [r1, #107]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r2, r11
	
	MOV r11, #0
	LDRB r10, [r1, #108]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r9, r11
	
	MOV r11, #0
	LDRB r10, [r1, #109]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r8, r11
	
	MOV r11, #0
	LDRB r10, [r1, #110]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r7, r11
	
	MOV r11, #0
	LDRB r10, [r1, #111]
	ORR r11, r11, r10
	ORR r11, r11, r10, LSL #8
	ORR r11, r11, r10, LSL #16
	ORR r11, r11, r10, LSL #24
	EOR r6, r11
	;KEY ADD END

	;POP
	LDR r0, [sp]
	LDR r1, [sp, #4]
	;ADD sp, sp, #8

	;STORE DATA ~ing
	STRB r2, [r0, #24] 	;store PT0
	STRB r3, [r0, #25]
	STRB r4, [r0, #26]
	STRB r5, [r0, #27]	
	STRB r6, [r0, #28]
	STRB r7, [r0, #29]
	STRB r8, [r0, #30]
	STRB r9, [r0, #31]		
	LSR r2, r2, #8
	LSR r3, r3, #8
	LSR r4, r4, #8
	LSR r5, r5, #8
	LSR r6, r6, #8
	LSR r7, r7, #8
	LSR r8, r8, #8
	LSR r9, r9, #8
	STRB r2, [r0, #16] 	;store PT1
	STRB r3, [r0, #17]
	STRB r4, [r0, #18]
	STRB r5, [r0, #19]	
	STRB r6, [r0, #20]
	STRB r7, [r0, #21]
	STRB r8, [r0, #22]
	STRB r9, [r0, #23]	
	LSR r2, r2, #8
	LSR r3, r3, #8
	LSR r4, r4, #8
	LSR r5, r5, #8
	LSR r6, r6, #8
	LSR r7, r7, #8
	LSR r8, r8, #8
	LSR r9, r9, #8
	STRB r2, [r0, #8] 	;store PT2
	STRB r3, [r0, #9]
	STRB r4, [r0, #10]
	STRB r5, [r0, #11]	
	STRB r6, [r0, #12]
	STRB r7, [r0, #13]
	STRB r8, [r0, #14]
	STRB r9, [r0, #15]	
	LSR r2, r2, #8
	LSR r3, r3, #8
	LSR r4, r4, #8
	LSR r5, r5, #8
	LSR r6, r6, #8
	LSR r7, r7, #8
	LSR r8, r8, #8
	LSR r9, r9, #8
	STRB r2, [r0] 	;store PT3
	STRB r3, [r0, #1]
	STRB r4, [r0, #2]
	STRB r5, [r0, #3]	
	STRB r6, [r0, #4]
	STRB r7, [r0, #5]
	STRB r8, [r0, #6]
	STRB r9, [r0, #7]	
	;STORE DATA END

	LDR r2, [sp, #8]
	LDR r3, [sp, #12]
	LDR r4, [sp, #16]
	LDR r5, [sp, #20]
	LDR r6, [sp, #24]
	LDR r7, [sp, #28]
	LDR r8, [sp, #32]
	LDR r9, [sp, #36]
	LDR r10, [sp, #40]
	LDR r11, [sp, #44]
	LDR r12, [sp, #48]
	ADD sp, sp, #52
	
	MOV PC, LR
	
	END
	
	