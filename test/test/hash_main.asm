;
; Copyright © L. Van Oldeneel tot Oldenzeel, S. Kerckhof, 2012.
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
;.include "tn85def.inc"


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

	ldi		ZH, high(main)
	ldi		ZL, low(main)
	ijmp


;******************* INCLUDE FILES *******************************
; include hash function
;SELECT
; *** Instances with 256-bit flat security (c=512)
.include "Keccakr1088c512.asm"
;.include "Keccakr288c512.asm"
; *** Instances with 128-bit flat security (c=256)
;.include "Keccakr1344c256.asm"
;.include "Keccakr544c256.asm"
;.include "Keccakr144c256.asm"
; *** Instances with 80-bit flat security (c=160)
;.include "Keccakr1440c160.asm"
;.include "Keccakr640c160.asm"
;.include "Keccakr240c160.asm"
;.include "Keccakr40c160.asm"



;******************** FUNCTIONS ***********************************
; This function copy bytes from ROM location pointed by ZH:ZL to
; SRAM location pointed by XH:XL
;	Z must contain source address
;	X must contain destination address
;	r24 must contain the number of bytes to copy
;	r23 is used for internal computation
copy_word:
	lpm		r23, Z+
	st 		X+,r23
	dec		r24
	brbc	1, copy_word
	ret
;*******************************************************************

;******************** MAIN (START) *******************************
main:
	ldi		XH, high(hashed_size)
	ldi		XL, low(hashed_size)
	clr		r16			; Number of hashed bytes is 0 at initialisation
	st		X, r16

	rcall	init

main_hash_loop:
	;Load hashed_size from SRAM
	ldi		XH, high(hashed_size)
	ldi		XL, low(hashed_size)
	ld		r16, X

	;Update hashed_size and store back in SRAM
	mov		r18, r16
	ldi		r24, DATA_NUM_BYTE
	add		r18, r24
	st		X, r18

	;Prepare registers for copy_word function
	ldi		ZH, high(msg2hash<<1)
	ldi		ZL, low(msg2hash<<1)
	clr		r17
	add		ZL, r16					; Adds hashed_size in order to point on next block of data
	adc		ZH, r17
	ldi 	XH, high(SRAM_DATA)
	ldi 	XL, low(SRAM_DATA)

	;Copy the data to hash from the db below to SRAM
	rcall	copy_word

	;Check the number of remaining bytes in message
	ldi		r18, msg_size
	sub		r18, r16
	mov		r24, r18			;r24 contains the number of remaining bytes if needed by final function
	subi	r18, DATA_NUM_BYTE
	brsh	main_upd_call		; If remaining bytes to hash >= DATA_NUM_BYTE,
								; we call update again.
	rjmp	main_final_call		; Otherwise we call the final routine.

	main_upd_call:
		rcall	update
		rjmp	main_hash_loop

	main_final_call:
		rcall	final
		rjmp	main




msg2hash: ;TO_UPD Put your test vector here
.db $A8,$73,$E0,$C6,$7C,$A6,$39,$02,$6B,$66,$83,$00,$8F,$7A,$A6,$32,$4D,$49,$79,$55,$0E,$9B,$CE,$06,$4C,$A1,$E1,$FB,$97,$A3,$0B,$14,$7A,$24,$F3,$F6,$66,$C0,$A7,$2D,$71,$34,$8E,$DE,$70,$1C,$F2,$D1,$7E,$22,$53,$C3,$4D,$1E,$C3,$B6,$47,$DB,$CE,$F2,$F8,$79,$F4,$EB,$88,$1C,$48,$30,$B7,$91,$37,$8C,$90,$1E,$B7,$25,$EA,$5C,$17,$23,$16,$C6,$D6,$06,$E0,$AF,$7D,$F4,$DF,$7F,$76,$E4,$90,$CD,$30,$B2,$BA,$DF,$45,$68,$5F

.equ msg_size = 101 ;TO_UPD Put your test vector size here (in bytes)

.dseg
	hashed_size: .byte 1

;******************** MAIN (END) *********************************


