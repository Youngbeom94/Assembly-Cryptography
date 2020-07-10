;
; SHA-512.asm
;
; Created: 2020-07-09 오후 12:26:55
; Author : 김영범
;


; Replace with your application code Copyright 짤 L. Van Oldeneel tot Oldenzeel, S. Kerckhof, 2012.
; e-mail:  <loic.vanoldeneel@uclouvain.be>, <stephanie.kerckhof@uclouvain.be>.
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
; Description: Main test program for hash functions
; Version 1 - March 2012.

.include "tn45def.inc"

#define blake ;TO_UPD specify which hash function will be included
.equ msg_size = 1	;TO_UPD specify lenght of message to hash

.ORG 0x0000
; global interrupt disable
	cli
; initialize stack
	ldi		r31,HIGH(RAMEND)
	out		SPH,r31
	ldi		r31,LOW(RAMEND)
	out		SPL,r31

; initialize trigger B1
  	ldi		r16, 0b11	; portB,1 = output (triggers)
  	out		DDRB, r16

	rjmp	main


;******************* INCLUDE FILES *******************************
; include hash function ;TO_UPD add a condition for the new hash function
#ifdef shrimpton
	.include	"shrimpton_stam_rijndael256.asm"
#elif DM_rijndael
	.include	"DM_rijndael_hash.asm"
#elif blake
	.include	"blake_256.asm"
#else
	#error "Undefined or unsupported hash function type. Add #define <hash_name> at the begining of main file"
#endif


.cseg


;******************** MAIN (START) *******************************
main:
	; initialisation
	ldi		XH, high(to_hash_size)
	ldi		XL, low(to_hash_size)
	ldi		r25, high(msg_size)		; Number of bytes to hash is DATA_NUM_BYTE at initialisation
	ldi		r24, low(msg_size)
	st		X+, r25
	st		X, r24

	rcall	init


main_hash_loop:
	;Load remaining bytes to hash (to_hash_size) from SRAM
	ldi		XH, high(to_hash_size)
	ldi		XL, low(to_hash_size)
	ld		r25, X+					;r25:24 = Number of remaining bytes to hash before update
	ld		r24, X

	movw	Y, r25:r24
	subi	YL, low(DATA_NUM_BYTE)
	sbci	YH, high(DATA_NUM_BYTE)
	brsh	main_upd_call		; If remaining bytes to hash >= DATA_NUM_BYTE,
								; we call update again.
	rjmp	main_final_call		; Otherwise we call the final routine.

	main_upd_call:
		;Store updated 2hash_size in SRAM
		ldi		XH, high(to_hash_size)
		ldi		XL, low(to_hash_size)
		st		X+, YH
		st		X, YL
		;Store ith message block into SRAM
		clr		r17
		ldi 	XH, high(SRAM_DATA)
		ldi 	XL, low(SRAM_DATA)
		ldi		r18, DATA_NUM_BYTE
		store_msg_loop:
			st		X+, r17
			inc		r17
			dec		r18
			brne	store_msg_loop		
		
		rcall	update
		rjmp	main_hash_loop

	main_final_call:
		;Store ith message block into SRAM
		clr		r17
		ldi 	XH, high(SRAM_DATA)
		ldi 	XL, low(SRAM_DATA)
		mov		r18, r24
		cpi		r18,0
		brbs	1, final_empty_block

		store_end_msg_loop:
			st		X+, r17
			inc		r17
			dec		r18
			brne	store_end_msg_loop	
			
	final_empty_block:
		rcall	final
		rjmp	main



.dseg
	to_hash_size: .byte 2

;******************** MAIN (END) *********************************

