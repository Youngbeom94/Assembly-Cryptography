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
	;LOAD DATA END
	
	;KEY ADD
	MOV r10, #0
	LDRB r10, [r1]
	EOR r5, r10
	LDRB r10, [r1, #1]
	EOR r4, r10
	LDRB r10, [r1, #2]
	EOR r3, r10
	LDRB r10, [r1, #3]
	EOR r2, r10
	LDRB r10, [r1, #4]
	EOR r9, r10
	LDRB r10, [r1, #5]
	EOR r8, r10
	LDRB r10, [r1, #6]
	EOR r7, r10
	LDRB r10, [r1, #7]
	EOR r6, r10
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
	AND r11, r8, #0x01 ;left rotation : 7 
	AND r8, r8, #0xFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F ;left rotation : 4
	AND r7, r7, #0xF0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F ;left rotation : 3
	AND r6, r6, #0xE0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03 ;left rotation : 6
	AND r5, r5, #0xfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07 ;left rotation : 5
	AND r4, r4, #0xF8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F ;left rotation : 1
	AND r3, r3, #0x80
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F ;left rotation : 2
	AND r2, r2, #0xC0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	LDRB r10, [r1, #8]
	EOR r5, r10
	LDRB r10, [r1, #9]
	EOR r4, r10
	LDRB r10, [r1, #10]
	EOR r3, r10
	LDRB r10, [r1, #11]
	EOR r2, r10
	LDRB r10, [r1, #12]
	EOR r9, r10
	LDRB r10, [r1, #13]
	EOR r8, r10
	LDRB r10, [r1, #14]
	EOR r7, r10
	LDRB r10, [r1, #15]
	EOR r6, r10
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
	AND r11, r8, #0x01 ;left rotation : 7 
	AND r8, r8, #0xFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F ;left rotation : 4
	AND r7, r7, #0xF0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F ;left rotation : 3
	AND r6, r6, #0xE0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03 ;left rotation : 6
	AND r5, r5, #0xfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07 ;left rotation : 5
	AND r4, r4, #0xF8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F ;left rotation : 1
	AND r3, r3, #0x80
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F ;left rotation : 2
	AND r2, r2, #0xC0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	LDRB r10, [r1, #16]
	EOR r5, r10
	LDRB r10, [r1, #17]
	EOR r4, r10
	LDRB r10, [r1, #18]
	EOR r3, r10
	LDRB r10, [r1, #19]
	EOR r2, r10
	LDRB r10, [r1, #20]
	EOR r9, r10
	LDRB r10, [r1, #21]
	EOR r8, r10
	LDRB r10, [r1, #22]
	EOR r7, r10
	LDRB r10, [r1, #23]
	EOR r6, r10
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
	AND r11, r8, #0x01 ;left rotation : 7 
	AND r8, r8, #0xFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F ;left rotation : 4
	AND r7, r7, #0xF0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F ;left rotation : 3
	AND r6, r6, #0xE0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03 ;left rotation : 6
	AND r5, r5, #0xfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07 ;left rotation : 5
	AND r4, r4, #0xF8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F ;left rotation : 1
	AND r3, r3, #0x80
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F ;left rotation : 2
	AND r2, r2, #0xC0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	LDRB r10, [r1, #24]
	EOR r5, r10
	LDRB r10, [r1, #25]
	EOR r4, r10
	LDRB r10, [r1, #26]
	EOR r3, r10
	LDRB r10, [r1, #27]
	EOR r2, r10
	LDRB r10, [r1, #28]
	EOR r9, r10
	LDRB r10, [r1, #29]
	EOR r8, r10
	LDRB r10, [r1, #30]
	EOR r7, r10
	LDRB r10, [r1, #31]
	EOR r6, r10
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
	AND r11, r8, #0x01 ;left rotation : 7 
	AND r8, r8, #0xFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F ;left rotation : 4
	AND r7, r7, #0xF0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F ;left rotation : 3
	AND r6, r6, #0xE0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03 ;left rotation : 6
	AND r5, r5, #0xfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07 ;left rotation : 5
	AND r4, r4, #0xF8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F ;left rotation : 1
	AND r3, r3, #0x80
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F ;left rotation : 2
	AND r2, r2, #0xC0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	LDRB r10, [r1, #32]
	EOR r5, r10
	LDRB r10, [r1, #33]
	EOR r4, r10
	LDRB r10, [r1, #34]
	EOR r3, r10
	LDRB r10, [r1, #35]
	EOR r2, r10
	LDRB r10, [r1, #36]
	EOR r9, r10
	LDRB r10, [r1, #37]
	EOR r8, r10
	LDRB r10, [r1, #38]
	EOR r7, r10
	LDRB r10, [r1, #39]
	EOR r6, r10
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
	AND r11, r8, #0x01 ;left rotation : 7 
	AND r8, r8, #0xFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F ;left rotation : 4
	AND r7, r7, #0xF0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F ;left rotation : 3
	AND r6, r6, #0xE0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03 ;left rotation : 6
	AND r5, r5, #0xfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07 ;left rotation : 5
	AND r4, r4, #0xF8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F ;left rotation : 1
	AND r3, r3, #0x80
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F ;left rotation : 2
	AND r2, r2, #0xC0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	LDRB r10, [r1, #40]
	EOR r5, r10
	LDRB r10, [r1, #41]
	EOR r4, r10
	LDRB r10, [r1, #42]
	EOR r3, r10
	LDRB r10, [r1, #43]
	EOR r2, r10
	LDRB r10, [r1, #44]
	EOR r9, r10
	LDRB r10, [r1, #45]
	EOR r8, r10
	LDRB r10, [r1, #46]
	EOR r7, r10
	LDRB r10, [r1, #47]
	EOR r6, r10
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
	AND r11, r8, #0x01 ;left rotation : 7 
	AND r8, r8, #0xFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F ;left rotation : 4
	AND r7, r7, #0xF0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F ;left rotation : 3
	AND r6, r6, #0xE0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03 ;left rotation : 6
	AND r5, r5, #0xfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07 ;left rotation : 5
	AND r4, r4, #0xF8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F ;left rotation : 1
	AND r3, r3, #0x80
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F ;left rotation : 2
	AND r2, r2, #0xC0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	LDRB r10, [r1, #48]
	EOR r5, r10
	LDRB r10, [r1, #49]
	EOR r4, r10
	LDRB r10, [r1, #50]
	EOR r3, r10
	LDRB r10, [r1, #51]
	EOR r2, r10
	LDRB r10, [r1, #52]
	EOR r9, r10
	LDRB r10, [r1, #53]
	EOR r8, r10
	LDRB r10, [r1, #54]
	EOR r7, r10
	LDRB r10, [r1, #55]
	EOR r6, r10
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
	AND r11, r8, #0x01 ;left rotation : 7 
	AND r8, r8, #0xFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F ;left rotation : 4
	AND r7, r7, #0xF0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F ;left rotation : 3
	AND r6, r6, #0xE0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03 ;left rotation : 6
	AND r5, r5, #0xfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07 ;left rotation : 5
	AND r4, r4, #0xF8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F ;left rotation : 1
	AND r3, r3, #0x80
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F ;left rotation : 2
	AND r2, r2, #0xC0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	LDRB r10, [r1, #56]
	EOR r5, r10
	LDRB r10, [r1, #57]
	EOR r4, r10
	LDRB r10, [r1, #58]
	EOR r3, r10
	LDRB r10, [r1, #59]
	EOR r2, r10
	LDRB r10, [r1, #60]
	EOR r9, r10
	LDRB r10, [r1, #61]
	EOR r8, r10
	LDRB r10, [r1, #62]
	EOR r7, r10
	LDRB r10, [r1, #63]
	EOR r6, r10
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
	AND r11, r8, #0x01 ;left rotation : 7 
	AND r8, r8, #0xFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F ;left rotation : 4
	AND r7, r7, #0xF0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F ;left rotation : 3
	AND r6, r6, #0xE0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03 ;left rotation : 6
	AND r5, r5, #0xfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07 ;left rotation : 5
	AND r4, r4, #0xF8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F ;left rotation : 1
	AND r3, r3, #0x80
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F ;left rotation : 2
	AND r2, r2, #0xC0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	LDRB r10, [r1, #64]
	EOR r5, r10
	LDRB r10, [r1, #65]
	EOR r4, r10
	LDRB r10, [r1, #66]
	EOR r3, r10
	LDRB r10, [r1, #67]
	EOR r2, r10
	LDRB r10, [r1, #68]
	EOR r9, r10
	LDRB r10, [r1, #69]
	EOR r8, r10
	LDRB r10, [r1, #70]
	EOR r7, r10
	LDRB r10, [r1, #71]
	EOR r6, r10
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
	AND r11, r8, #0x01 ;left rotation : 7 
	AND r8, r8, #0xFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F ;left rotation : 4
	AND r7, r7, #0xF0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F ;left rotation : 3
	AND r6, r6, #0xE0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03 ;left rotation : 6
	AND r5, r5, #0xfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07 ;left rotation : 5
	AND r4, r4, #0xF8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F ;left rotation : 1
	AND r3, r3, #0x80
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F ;left rotation : 2
	AND r2, r2, #0xC0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	LDRB r10, [r1, #72]
	EOR r5, r10
	LDRB r10, [r1, #73]
	EOR r4, r10
	LDRB r10, [r1, #74]
	EOR r3, r10
	LDRB r10, [r1, #75]
	EOR r2, r10
	LDRB r10, [r1, #76]
	EOR r9, r10
	LDRB r10, [r1, #77]
	EOR r8, r10
	LDRB r10, [r1, #78]
	EOR r7, r10
	LDRB r10, [r1, #79]
	EOR r6, r10
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
	AND r11, r8, #0x01 ;left rotation : 7 
	AND r8, r8, #0xFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F ;left rotation : 4
	AND r7, r7, #0xF0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F ;left rotation : 3
	AND r6, r6, #0xE0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03 ;left rotation : 6
	AND r5, r5, #0xfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07 ;left rotation : 5
	AND r4, r4, #0xF8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F ;left rotation : 1
	AND r3, r3, #0x80
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F ;left rotation : 2
	AND r2, r2, #0xC0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	LDRB r10, [r1, #80]
	EOR r5, r10
	LDRB r10, [r1, #81]
	EOR r4, r10
	LDRB r10, [r1, #82]
	EOR r3, r10
	LDRB r10, [r1, #83]
	EOR r2, r10
	LDRB r10, [r1, #84]
	EOR r9, r10
	LDRB r10, [r1, #85]
	EOR r8, r10
	LDRB r10, [r1, #86]
	EOR r7, r10
	LDRB r10, [r1, #87]
	EOR r6, r10
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
	AND r11, r8, #0x01 ;left rotation : 7 
	AND r8, r8, #0xFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F ;left rotation : 4
	AND r7, r7, #0xF0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F ;left rotation : 3
	AND r6, r6, #0xE0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03 ;left rotation : 6
	AND r5, r5, #0xfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07 ;left rotation : 5
	AND r4, r4, #0xF8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F ;left rotation : 1
	AND r3, r3, #0x80
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F ;left rotation : 2
	AND r2, r2, #0xC0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	LDRB r10, [r1, #88]
	EOR r5, r10
	LDRB r10, [r1, #89]
	EOR r4, r10
	LDRB r10, [r1, #90]
	EOR r3, r10
	LDRB r10, [r1, #91]
	EOR r2, r10
	LDRB r10, [r1, #92]
	EOR r9, r10
	LDRB r10, [r1, #93]
	EOR r8, r10
	LDRB r10, [r1, #94]
	EOR r7, r10
	LDRB r10, [r1, #95]
	EOR r6, r10
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
	AND r11, r8, #0x01 ;left rotation : 7 
	AND r8, r8, #0xFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F ;left rotation : 4
	AND r7, r7, #0xF0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F ;left rotation : 3
	AND r6, r6, #0xE0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03 ;left rotation : 6
	AND r5, r5, #0xfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07 ;left rotation : 5
	AND r4, r4, #0xF8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F ;left rotation : 1
	AND r3, r3, #0x80
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F ;left rotation : 2
	AND r2, r2, #0xC0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	LDRB r10, [r1, #96]
	EOR r5, r10
	LDRB r10, [r1, #97]
	EOR r4, r10
	LDRB r10, [r1, #98]
	EOR r3, r10
	LDRB r10, [r1, #99]
	EOR r2, r10
	LDRB r10, [r1, #100]
	EOR r9, r10
	LDRB r10, [r1, #101]
	EOR r8, r10
	LDRB r10, [r1, #102]
	EOR r7, r10
	LDRB r10, [r1, #103]
	EOR r6, r10
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
	AND r11, r8, #0x01 ;left rotation : 7 
	AND r8, r8, #0xFE
	LSR r8, r8, #1
	ORR r8, r8, r11, LSL #7
	
	AND r11, r7, #0x0F ;left rotation : 4
	AND r7, r7, #0xF0
	LSR r7, r7, #4
	ORR r7, r7, r11, LSL #4
	
	AND r11, r6, #0x1F ;left rotation : 3
	AND r6, r6, #0xE0
	LSR r6, r6, #5
	ORR r6, r6, r11, LSL #3
	
	AND r11, r5, #0x03 ;left rotation : 6
	AND r5, r5, #0xfc
	LSR r5, r5, #2
	ORR r5, r5, r11, LSL #6
	
	AND r11, r4, #0x07 ;left rotation : 5
	AND r4, r4, #0xF8
	LSR r4, r4, #3
	ORR r4, r4, r11, LSL #5
	
	AND r11, r3, #0x7F ;left rotation : 1
	AND r3, r3, #0x80
	LSR r3, r3, #7
	ORR r3, r3, r11, LSL #1
	
	AND r11, r2, #0x3F ;left rotation : 2
	AND r2, r2, #0xC0
	LSR r2, r2, #6
	ORR r2, r2, r11, LSL #2	
	;PLAYER END
	
	;KEY ADD
	MOV r10, #0
	LDRB r10, [r1, #104]
	EOR r5, r10
	LDRB r10, [r1, #105]
	EOR r4, r10
	LDRB r10, [r1, #106]
	EOR r3, r10
	LDRB r10, [r1, #107]
	EOR r2, r10
	LDRB r10, [r1, #108]
	EOR r9, r10
	LDRB r10, [r1, #109]
	EOR r8, r10
	LDRB r10, [r1, #110]
	EOR r7, r10
	LDRB r10, [r1, #111]
	EOR r6, r10
	;KEY ADD END

	;POP
	LDR r0, [sp]
	LDR r1, [sp, #4]
	;ADD sp, sp, #8

	;STORE DATA 
	STRB r2, [r0] 	;store PT0
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
	
	