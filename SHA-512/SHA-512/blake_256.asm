/*
 * blake_256.asm
 *
 *  Created: 2020-07-09 ?? 12:31:18
 *   Author: ???
 */ 
 ;
; Copyright ? I. von Maurich
; e-mail: <ingo.vonmaurich@rub.de>.
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
; Description: Blake256 hash function.
; Version 1 - June 2012.
;
;
;   ----------------------------------------------------
;  |    User interface:                                 |
;  |----------------------------------------------------|
;  |(1) Data to hash must be in SRAM with the first byte|
;  |    at the location pointed by SRAM_DATA. The data  |
;  |    has to be updated before each update or final   |
;  |    call and the number of bytes needed in SRAM by  |
;  |    each update call is equal to DATA_NUM_BYTE.     |
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

.include "tn45def.inc"

;
; Constants
;
.EQU    DATA_NUM_BYTE = 64 ;Number of bytes that will be processed by the update function
.EQU    STATE_NUM_BYTE = 64 ;Memory needed for hash function intermediate state (in bytes)
.EQU    ADD_MEM_NUM_BYTE = 56 ;Optional additional memory for internal computation (in bytes)
.EQU    HASH_NUM_BYTE = 32 ;Size of output hash (in bytes)

.DSEG
	SRAM_DATA:		.BYTE DATA_NUM_BYTE
	SRAM_STATE:		.BYTE STATE_NUM_BYTE
	SRAM_ADD_MEM :	.BYTE ADD_MEM_NUM_BYTE

.CSEG
;
; Registers declarations
;
.NOLIST

.def a_hi			= r0
.def a_mh			= r1
.def a_ml			= r2
.def a_lo			= r3
.def b_hi			= r4
.def b_mh			= r5
.def b_ml			= r6
.def b_lo			= r7
.def c_hi			= r8
.def c_mh			= r9
.def c_ml			= r10
.def c_lo			= r11
.def d_hi			= r12
.def d_mh 			= r13
.def d_ml 			= r14
.def d_lo			= r15
.def temp1 			= r16
.def temp2 			= r17
.def temp3 			= r18
.def i 				= r19
.def v_round		= r20
.def sigr1 			= r21
.def sigr2 			= r22
.def eormc_hi 		= r23
.def eormc_mh 		= r24
.def eormc_ml 		= r25

; offsets in SRAM_ADD_MEM for chain value (32 byte), salt (16 byte) and counter (8 byte)
.equ offset_chain	= 0
.equ offset_salt	= 32	;32-47
.equ offset_counter = 48	;48-55

.LIST

; Initialization
; Init resets the counter and salt to zero, if a different salt is desired it should be set here
; In addition, Init loads the initialization vectors as first chain value

init:	
;initialze the chain value by loading the initialization vector to it, h^0 <- IV
	ldi zh, high(IV<<1)
	ldi zl, low (IV<<1)
	ldi xh, high(SRAM_ADD_MEM)
	ldi xl, low (SRAM_ADD_MEM)

	ldi temp2, 32
loop_load_iv:
	lpm temp1, Z+
	st X+, temp1
	dec temp2
	brne loop_load_iv

; set counter and salt to zero (if a different salt is required, it can be changed here)
	clr temp1
	ldi temp2, 16
; reset salt
loop_load_salt:
	st X+,temp1
	dec temp2
	brne loop_load_salt

	ldi temp2,8
; reset counter
loop_reset_counter:
	st X+,temp1
	dec temp2
	brne loop_reset_counter

; clear T flag
	clt
	ret

; Update Hash
update:
;chain value is already present in the first 32 bytes of the state
; X points to the state
; Y points to the additional RAM
; Z points to the constants in flash memory
	ldi xh, high(SRAM_STATE)
	ldi xl, low (SRAM_STATE)
	ldi yh, high(SRAM_ADD_MEM)
	ldi yl, low (SRAM_ADD_MEM)
	ldi zh, high(CONSTANTS<<1)
	ldi zl, low(CONSTANTS<<1)

;load chain value to state
; v(0)..v(7) <- h(0)..h(7)
	ldi temp3, 32
load_chain:
	ld temp1, Y+
	st X+, temp1
	dec temp3
	brne load_chain

;load salt and constants, xor their sum and store them to the state
; v(8)  <- s(0) xor c(0)
; v(9)  <- s(1) xor c(1)
; v(10) <- s(2) xor c(2)
; v(11) <- s(3) xor c(3)

	ldi temp3, 16
loop_xor_salt_constant:	
	ld temp1, Y+	;load salt
	lpm temp2, Z+	;load constant
	eor temp1,temp2	;xor salt and constant
	st X+,temp1		;store sum to state
	dec temp3
	brne loop_xor_salt_constant

; increase counter by 512 except for when the T flag is set which indicates a call to update from final
; if T flag is set => do not increase counter
	brts no_counter
; else add 512=0x200 to the counter
	adiw Y, 1
	ldi temp1, 0x02
	ld temp2, Y
	add temp2, temp1
	st Y+, temp2
; add possible carrys
	clr temp1
	ldi temp2, 6
loop_inc_counter:
	ld temp3, Y
	adc temp3, temp1
	st Y+, temp3
	dec temp2
	brne loop_inc_counter
	sbiw Y,8

; fill the last part of the state by xoring counter (t) and constants
; v(12) <- t(0) xor c(4)
; v(13) <- t(0) xor c(5)
; v(14) <- t(1) xor c(6)
; v(15) <- t(1) xor c(7)
no_counter:
	adiw Y, 4
	ldi temp3, 2
counter_xor_constant_loop0:	
	ldi v_round, 2
counter_xor_constant_loop1:
	ldi i, 4
counter_xor_constant_loop2:
	lpm temp1, Z+
	ld temp2, -Y
	eor temp1, temp2
	st X+, temp1
	dec i
	brne counter_xor_constant_loop2
	adiw Y, 4
	dec v_round
	brne counter_xor_constant_loop1
	adiw Y, 4
	dec temp3
	brne counter_xor_constant_loop0

	sbiw Y, 8

; after initialization the compression function is iterated 14 times

	in temp1, SREG
	push temp1

	ldi v_round,-0x8
	clt

do_round:
	clr i
	ldi temp1,0x8
	add v_round, temp1
	cpi v_round, 0x50 ; do we have reached 10 iterations? if so reset v_round because sigma table is read again from the top
	brne check_end
	set
	clr v_round

check_end:
	brtc start_round
	cpi v_round,0x20 ; after another 4 rounds we have reached the required 14 iterations and have to continue with the round-finalization step
	brne start_round
	clt
	rjmp finalize

start_round:
	
;call round function gi(a,b,c,d)
;set a,b,c,d according to:
;G0(v0 , v4 , v8 , v12) G1(v1 , v5 , v9 , v13) 
;G2(v2 , v6 , v10, v14) G3(v3 , v7 , v11, v15)
;G4(v0 , v5 , v10, v15) G5(v1 , v6 , v11, v12) 
;G6(v2 , v7 , v8 , v13) G7(v3 , v4 , v9 , v14)

; the parameters a,b,c,d for gi are loaded using the proposed method by Dag Arne Osvik (http://eprint.iacr.org/2012/156.pdf)
	ldi xh, high(SRAM_STATE)
	ldi xl, low (SRAM_STATE)

	ldi temp3, 4
g0_to_g3:
; G0, G1, G2, G3
	rcall lc
	rcall gi
	rcall sc
	dec temp3
	brne g0_to_g3

; G4
	adiw X, 24
	rcall ld10
	rcall gi
	adiw X, 56
	rcall st15

; G5
	adiw X, 40
	rcall ld10
	adiw X, 40
	rcall ld11
	rcall gi
	sbiw X, 8
	rcall st10
	adiw X, 40
	rcall st11

; G6
	sbiw X, 24
	rcall ld5
	adiw X, 20
	rcall ld6
	rcall gi
	sbiw X, 28
	rcall st5
	adiw X, 20
	rcall st6

; G7
	sbiw X, 44
	rcall ld0
	rcall ld1
	rcall gi
	sbiw X, 48
	rcall st0
	rcall st1

	rjmp do_round

finalize:
;finalization of current state
;h'0 = h0 eor s0 eor v0 eor v8
;h'1 = h1 eor s1 eor v1 eor v9
;h'2 = h2 eor s2 eor v2 eor v10
;h'3 = h3 eor s3 eor v3 eor v11
;h'4 = h4 eor s0 eor v4 eor v12
;h'5 = h5 eor s1 eor v5 eor v13
;h'6 = h6 eor s2 eor v6 eor v14
;h'7 = h7 eor s3 eor v7 eor v15

; X points to the state
; Y points to the salt
; Z points to the old chain value

	ldi XH, high(SRAM_STATE)
	ldi XL, low(SRAM_STATE)
	ldi YH, high(SRAM_ADD_MEM+offset_salt)
	ldi YL, low(SRAM_ADD_MEM+offset_salt)
	ldi ZH, high(SRAM_ADD_MEM)
	ldi ZL, low(SRAM_ADD_MEM)

	ldi v_round, 2
loop_final1:
	ldi i, 16
loop_final2:
	ld temp1, Z ; h(i)	
	ld temp2, Y+ ; s(i)
	ld temp3, X+ ; v(i)
	adiw X, 31
	ld a_hi, X+ ; v(i+8)
	sbiw X, 32
	eor temp1, temp2
	eor temp3, a_hi
	eor temp1, temp3
	st Z+, temp1
	dec i
	brne loop_final2
	sbiw Y, 16
	dec v_round
	brne loop_final1

return:
	pop temp1
	out SREG, temp1

	ret

; Final
;	r24 contains the number of bytes passed to the final function.
final:
; X points to the data block which need padding
; Y points to the counter
	ldi xh, high(SRAM_DATA)
	ldi xl, low (SRAM_DATA)
	ldi yh, high(SRAM_ADD_MEM+offset_counter)
	ldi yl, low (SRAM_ADD_MEM+offset_counter)

; if size is zero last block was a full block and now an additional block is required that just contains out of padding 0x80...01<counter>
	cpi r24, 0
	breq full_padding

; if size is >= 56 the padding cannot be done in place and an additional block is required
	cpi r24, 56
	brsh padd_and_new_block
; else the padding fits into the current message block	
	rjmp in_place_padding

full_padding:
; set T flag (indicates to not increase the counter) since no message bytes are present
	set
	rjmp in_place_padding

padd_and_new_block:
; go to the byte just after the last message byte and append 0x80
	clr temp1
	mov i, r24
	add xl, i
	adc xh, temp1

	ldi temp2, 0b10000000
	st X+, temp2
	inc i
; if message block is now full we are done, else padd with zeros until message block is full
	cpi i, 64
	breq done_padd_00

padd_00:
	st X+, temp1
	inc i
	cpi i, 64
	brne padd_00

done_padd_00:
; increase the counter by the remaining message bytes
	rcall load_counter_add_r24
; store the counter back to RAM
	rcall store_counter
; call the update function
	set
	rcall update
; now no message bytes are remaining, but a new block with only the padding is hashed
	ldi r24, 0
	ldi xh, high(SRAM_DATA)
	ldi xl, low (SRAM_DATA)
	ldi yh, high(SRAM_ADD_MEM+offset_counter)
	ldi yl, low (SRAM_ADD_MEM+offset_counter)

	mov i, r24
	clr temp1
	st X+, temp1
	set
	rjmp padd_0

in_place_padding:
; in this case the padding fits into the current block write 0x80 just after the last message byte,
; or 0x81 if only one block is left before the counter has to be appended
	mov i, r24
	
	clr temp1
	add xl, r24
	adc xh, temp1

	cpi i,55
	brne padd_usual

	ldi temp1,0b10000001
	st X, temp1
	rjmp padd_counter
	
padd_usual:
	ldi temp1,0b10000000
	st X+, temp1

	clr temp1	
padd_0:
; padd with zeros until we have reached the position where the counter has to be appended
	st X+, temp1
	inc i
	cpi i, 55
	brne padd_0
	
	ldi temp1, 0b00000001
	st -X, temp1

padd_counter:
; now append the counter
	rcall load_counter_add_r24

	adiw X, 1
	st X+,b_hi
	st X+,b_mh
	st X+,b_ml
	st X+,b_lo
	st X+,a_hi
	st X+,a_mh
	st X+,a_ml
	st X+,a_lo
; if T flag is clear call update
; else set counter to zero and then call update
	brtc final_call
	clr a_lo
	clr a_ml
	clr a_mh
	clr a_hi
	clr b_lo
	clr b_ml
	clr b_mh
	clr b_hi
	
final_call:
	rcall store_counter
	set
	rcall update

; now copy the hash value to the state where it has to be placed according to the interface
copy_hash_value:
	ldi xh, high(SRAM_STATE)
	ldi xl, low (SRAM_STATE)
	ldi yh, high(SRAM_ADD_MEM)
	ldi yl, low (SRAM_ADD_MEM)

	ldi temp1, 32
loop_copy_hash_value:
	ld temp2, Y+
	st X+, temp2
	dec temp1
	brne loop_copy_hash_value

	ret

; ****************
; Helper functions
; ****************

;roundfunction gi
;gi(a,b,c,d)
;a =  a + b + (m_sigr(2i) XOR c_sigr(2i+1))
;d =  (d XOR a) >> 16
;c =  c + d
;b =  (b XOR c) >> 12
;a =  a + b + (m sigr(2i+1) XOR c sigr(2i))
;d =  (d XOR a) >> 8
;c =  c + d
;b =  (b XOR c) >> 7

gi:
	ldi yh, high(SRAM_DATA)
	ldi yl, low(SRAM_DATA)
	ldi zh, high(SIGMA<<1)
	ldi zl, low(SIGMA<<1)	

;calculate offset in sigma table
	mov temp1, i
	;lsl temp1
	add temp1,v_round
;add offset to sigma pointer
	add zl, temp1
	clr temp1
	adc zh, temp1
;read sigma_r(2i)
	lpm sigr2,Z
	mov sigr1, sigr2
	andi sigr2, 0x0F
	swap sigr1
	andi sigr1, 0x0F
;read sigma_r(2i+1)
	;lpm sigr2,Z
;i=i+1 for the next round
	inc i

; set Z pointer to CONSTANTS
	ldi zh, high(CONSTANTS<<1)
	ldi zl, low(CONSTANTS<<1)

;calculate a =  a + b + (m_sigr(2i) XOR c_sigr(2i+1))

;load constant c_sigr(2i+1) and xor with m_sigr(2i)
	lsl sigr2
	lsl sigr2
	lsl sigr1
	lsl sigr1

	add zl,sigr2
	adc zh,temp1

	add yl,sigr1
	adc yh,temp1

	rcall a_b_msg_const

; d = (d xor a) >> 16
; 32 bit xor of d and a, result is stored in d
	eor d_lo,a_lo
	eor d_ml,a_ml
	eor d_mh,a_mh
	eor d_hi,a_hi
; 16 bit rotation is done by swapping
	movw temp1,d_hi
	movw d_hi,d_ml
	movw d_ml,temp1

; c = c+d
; 32 bit add of c and d, result is stored in c
	add c_lo,d_lo
	adc c_ml,d_ml
	adc c_mh,d_mh
	adc c_hi,d_hi

; b = (b xor c) >> 12
; 32 bit xor of b and c, result is stored in b
	eor b_lo,c_lo
	eor b_ml,c_ml
	eor b_mh,c_mh
	eor b_hi,c_hi

; >>>>16 + <<<<4 = >>>>12
;	>>>>16
	movw temp1,b_hi
	movw b_hi,b_ml
	movw b_ml,temp1
;	<<<<4
	ldi temp1, 4
	clr temp2
loop_shift_4:
	lsl b_lo
	rol b_ml
	rol b_mh
	rol b_hi
	adc b_lo,temp2
	dec temp1
	brne loop_shift_4

;insert a =  a + b + (m sigr(2i+1) XOR c sigr(2i))
	ldi yh, high(SRAM_DATA)
	ldi yl, low(SRAM_DATA)
	ldi zh, high(CONSTANTS<<1)
	ldi zl, low(CONSTANTS<<1)

	add zl, sigr1
	adc zh, temp2

	add yl, sigr2
	adc yh, temp2

	rcall a_b_msg_const

; d = (d xor a) >> 8
; 32 bit xor of d and a, result is stored in d
	eor d_lo,a_lo
	eor d_ml,a_ml
	eor d_mh,a_mh
	eor d_hi,a_hi

; 8 bit rotation is done by swapping
	mov temp2,d_mh
	mov d_mh,d_hi
	mov d_hi,d_lo
	mov d_lo,d_ml
	mov d_ml,temp2

; 32 bit add of c and d, result is stored in c
	add c_lo,d_lo
	adc c_ml,d_ml
	adc c_mh,d_mh
	adc c_hi,d_hi

; b = (b xor c) >> 7
; 32 bit xor of b and c, result is stored in b
	eor b_lo,c_lo
	eor b_ml,c_ml
	eor b_mh,c_mh
	eor b_hi,c_hi
; >>>>7 = >>>>8 + <<<<1
	mov temp2,b_mh
	mov b_mh,b_hi
	mov b_hi,b_lo
	mov b_lo,b_ml
	mov b_ml,temp2
; plus <<<<1
	lsl b_lo
	rol b_ml
	rol b_mh
	rol b_hi
	clr temp1
	adc b_lo,temp1

ret

; load and store functions to load the parameters a,b,c,d - see http://eprint.iacr.org/2012/156.pdf by Dag Arne Osvik
lc:
	ld a_hi,X+
	ld a_mh,X+
	ld a_ml,X+
	ld a_lo,X+
	adiw xl,12
	ld b_hi,X+
	ld b_mh,X+
	ld b_ml,X+
	ld b_lo,X+
	adiw xl,12
	ld c_hi,X+
	ld c_mh,X+
	ld c_ml,X+
	ld c_lo,X+
	adiw xl,12
	ld d_hi,X+
	ld d_mh,X+
	ld d_ml,X+
	ld d_lo,X+
	ret

ld15:
	ld d_hi,X+
	ld d_mh,X+
	ld d_ml,X+
	ld d_lo,X+
	sbiw X, 24

ld10:	
	ld c_hi,X+
	ld c_mh,X+
	ld c_ml,X+
	ld c_lo,X+ 
	sbiw X, 24

ld5: 
	ld b_hi,X+
	ld b_mh,X+
	ld b_ml,X+
	ld b_lo,X+
	sbiw X, 24

ld0:
	ld a_hi,X+
	ld a_mh,X+
	ld a_ml,X+
	ld a_lo,X+
	ret

ld1:
	ld b_hi,X+
	ld b_mh,X+
	ld b_ml,X+
	ld b_lo,X+
	adiw X, 16

ld6:
	ld c_hi,X+
	ld c_mh,X+
	ld c_ml,X+
	ld c_lo,X+ 
	adiw X, 16

ld11:
	ld d_hi,X+
	ld d_mh,X+
	ld d_ml,X+
	ld d_lo,X+
	ret

sc:
	st -X,d_lo
	st -X,d_ml
	st -X,d_mh
	st -X,d_hi
	sbiw xl,12
	st -X,c_lo
	st -X,c_ml
	st -X,c_mh
	st -X,c_hi
	sbiw xl,12
	st -X,b_lo
	st -X,b_ml
	st -X,b_mh
	st -X,b_hi
	sbiw xl,16
	st X+,a_hi
	st X+,a_mh
	st X+,a_ml
	st X+,a_lo
	ret

st15:
	st X+, d_hi
	st X+, d_mh
	st X+, d_ml
	st X+, d_lo
	sbiw X, 24

st10:
	st X+, c_hi
	st X+, c_mh
	st X+, c_ml
	st X+, c_lo
	sbiw X, 24

st5:
	st X+, b_hi
	st X+, b_mh
	st X+, b_ml
	st X+, b_lo
	sbiw X, 24

st0:
	st X+, a_hi
	st X+, a_mh
	st X+, a_ml
	st X+, a_lo
	ret

st1:
	st X+, b_hi
	st X+, b_mh
	st X+, b_ml
	st X+, b_lo
	adiw X, 16

st6:
	st X+, c_hi
	st X+, c_mh
	st X+, c_ml
	st X+, c_lo
	adiw X, 16

st11:
	st X+, d_hi
	st X+, d_mh
	st X+, d_ml
	st X+, d_lo
	ret

ld_a:
;	ld a_hi,X+
;	ld a_mh,X+
;	ld a_ml,X+
;	ld a_lo,X+

ld_b:
;	ld b_hi,X+
;	ld b_mh,X+
;	ld b_ml,X+
;	ld b_lo,X+

; this function loads the counter and adds the content of r24 to it
load_counter_add_r24:
	ld a_lo,Y+
	ld a_ml,Y+
	ld a_mh,Y+
	ld a_hi,Y+
	ld b_lo,Y+
	ld b_ml,Y+
	ld b_mh,Y+
	ld b_hi,Y+

	clr temp2
	mov temp1, r24
	lsl temp1
	rol temp2
	lsl temp1
	rol temp2
	lsl temp1
	rol temp2
	
	clr temp3
	add a_lo, temp1
	adc a_ml,temp2
	adc a_mh,temp3
	adc a_hi,temp3
	adc b_lo,temp3
	adc b_ml,temp3
	adc b_mh,temp3
	adc b_hi,temp3
	ret

; this function stores the counter back to RAM
store_counter:
	st -Y,b_hi
	st -Y,b_mh
	st -Y,b_ml
	st -Y,b_lo
	st -Y,a_hi
	st -Y,a_mh
	st -Y,a_ml
	st -Y,a_lo	
	ret

; this function is part of the computation a = a+b+m+c in gi
a_b_msg_const:
	lpm eormc_hi,Z+
	ld temp1,Y+
	eor eormc_hi,temp1
		
	lpm eormc_mh,Z+
	ld temp1,Y+
	eor eormc_mh,temp1
	
	lpm eormc_ml,Z+
	ld temp1,Y+
	eor eormc_ml,temp1
	
	lpm temp1,Z+
	ld temp2,Y+
	eor temp1,temp2

	add a_lo,temp1
	adc a_ml,eormc_ml
	adc a_mh,eormc_mh
	adc a_hi,eormc_hi	

; 32 bit add of a and b, result is stored in a
	add a_lo,b_lo
	adc a_ml,b_ml
	adc a_mh,b_mh
	adc a_hi,b_hi
	ret

; IV's needed for initialization require 8x32Bit = 256Bit = 8x4Byte = 32 Byte
IV:
	.db 0x6A,0x09,0xE6,0x67
	.db 0xBB,0x67,0xAE,0x85
	.db 0x3C,0x6E,0xF3,0x72
	.db 0xA5,0x4F,0xF5,0x3A
	.db 0x51,0x0E,0x52,0x7F
	.db 0x9B,0x05,0x68,0x8C
	.db 0x1F,0x83,0xD9,0xAB
	.db 0x5B,0xE0,0xCD,0x19


;Constants that are used in every round 16x32 Bit = 512Bit = 16x4Byte = 64 Byte
CONSTANTS:
	.db 0x24,0x3F,0x6A,0x88
	.db 0x85,0xA3,0x08,0xD3
	.db 0x13,0x19,0x8A,0x2E
	.db 0x03,0x70,0x73,0x44
	.db 0xA4,0x09,0x38,0x22
	.db 0x29,0x9F,0x31,0xD0
	.db 0x08,0x2E,0xFA,0x98
	.db 0xEC,0x4E,0x6C,0x89
	.db 0x45,0x28,0x21,0xE6
	.db 0x38,0xD0,0x13,0x77
	.db 0xBE,0x54,0x66,0xCF
	.db 0x34,0xE9,0x0C,0x6C
	.db 0xC0,0xAC,0x29,0xB7
	.db 0xC9,0x7C,0x50,0xDD
	.db 0x3F,0x84,0xD5,0xB5
	.db 0xB5,0x47,0x09,0x17

; Sigma round-dependend: 
; when stored with one sigma value per byte 10x16x8 Bit = 1280 Bit = 160x1 Byte = 160 Byte
; here merged to fit two sigma values in one byte -> reduced to 10x16x4 Bit = 640 Bit = 80x1 Byte = 80 Byte
SIGMA:
	.db 0x01,0x23,0x45,0x67,0x89,0xab,0xcd,0xef
	.db 0xea,0x48,0x9f,0xd6,0x1c,0x02,0xb7,0x53
	.db 0xb8,0xc0,0x52,0xfd,0xae,0x36,0x71,0x94
	.db 0x79,0x31,0xdc,0xbe,0x26,0x5a,0x40,0xf8
	.db 0x90,0x57,0x24,0xaf,0xe1,0xbc,0x68,0x3d
	.db 0x2c,0x6a,0x0b,0x83,0x4d,0x75,0xfe,0x19
	.db 0xc5,0x1f,0xed,0x4a,0x07,0x63,0x92,0x8b
	.db 0xdb,0x7e,0xc1,0x39,0x50,0xf4,0x86,0x2a
	.db 0x6f,0xe9,0xb3,0x08,0xc2,0xd7,0x14,0xa5
	.db 0xa2,0x84,0x76,0x15,0xfb,0x9e,0x3c,0xd0