;
; Copyright © S. Kerckhof, 2011, G. Van Assche, 2012, R. Van Keer, 2012
; e-mail: <stephanie.kerckhof@uclouvain.be>, <gilles.vanassche@st.com>, <ronny.vankeer@st.com>
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
;  |    SRAM_STATE. Length of hash intermediate states  |
;  |    is given by STATE_NUM_BYTE constant.            |
;  |    Lenght of final hash value is given by          |
;  |    HASH_NUM_BYTE.                                  |
;   ----------------------------------------------------
;

;
; Constants
;
.EQU    DATA_NUM_BYTE = rate/8 ;Number of bytes that will be processed by the update function
.EQU    STATE_NUM_BYTE = (rate+capacity)/8 ;Memory needed for hash function intermediate state (in bytes)
#if (output_size <= rate)
.EQU    ADD_MEM_NUM_BYTE = ((rate+capacity) > 200) ? (rate+capacity)/40 : 0 ;Optional additional memory for internal computation (in bytes)
#else
.EQU    ADD_MEM_NUM_BYTE = (((rate+capacity) > 200) ? (rate+capacity)/40 : 0) + output_size/8 ;Optional additional memory for internal computation (in bytes)
#endif
.EQU    HASH_NUM_BYTE = output_size/8 ;Size of output hash (in bytes)

.DSEG
	SRAM_STATE:		.BYTE STATE_NUM_BYTE
	SRAM_ADD_MEM :	.BYTE ADD_MEM_NUM_BYTE
#if (output_size > rate)
.EQU    SRAM_OUTPUT_BUFFER = SRAM_ADD_MEM + ADD_MEM_NUM_BYTE - output_size/8
#endif
	SRAM_DATA:		.BYTE DATA_NUM_BYTE ;This memory area belongs to the caller and is not modified here

.CSEG

;******************** FUNCTIONS ***********************************
; This function XOR bytes from SRAM location pointed by ZH:ZL into
; SRAM location pointed by XH:XL
;	Z must contain source address
;	X must contain destination address
;	r24 must contain the number of bytes to XOR
;	r22, r23 are used for internal computation
XOR_bytes:
	tst		r24
	breq	XOR_bytes_end
XOR_bytes_loop:
	ld		r23, Z+
	ld		r22, X
	eor		r23, r22
	st 		X+,r23
	dec		r24
	brbc	1, XOR_bytes_loop
XOR_bytes_end:
	ret

; This function copies bytes from SRAM location pointed by ZH:ZL into
; SRAM location pointed by XH:XL
;	Z must contain source address
;	X must contain destination address
;	r24 must contain the number of bytes to copy
;	r23 is used for internal computation
copy_bytes:
	tst		r24
	breq	copy_bytes_end
copy_bytes_loop:
	ld		r23, Z+
	st 		X+,r23
	dec		r24
	brbc	1, copy_bytes_loop
copy_bytes_end:
	ret

; This function clear bytes in RAM
;	X must contain destination address
;	r24 must contain the number of bytes to clear
;	r22 is used for internal computation
clear_bytes:
	clr		r23
clear_bytes_loop:
	st 		X+,r23
	dec		r24
	brbc	1, clear_bytes_loop
	ret

; Initialisation
; This function sets the initial state to zero
init:
	ldi		r24, STATE_NUM_BYTE
	ldi 	XH, high(SRAM_STATE)
	ldi 	XL, low(SRAM_STATE)
	rcall	clear_bytes
	ret

; Update Hash
; This function updates the state by XORing the input into the state 
; and then calling Keccak-f
update:
	ldi		r24, rate/8
	ldi 	ZH, high(SRAM_DATA)
	ldi 	ZL, low(SRAM_DATA)
	ldi 	XH, high(SRAM_STATE)
	ldi 	XL, low(SRAM_STATE)
	rcall	XOR_bytes
	rcall	KeccakF
	ret


; Final
; This function updates the state by XORing the input into the state,
; applying the padding and then calling Keccak-f
; r24 contains the number of bytes passed to the final function.
; r24 is assumed to be less than rate/8
final:
	ldi 	ZH, high(SRAM_DATA)
	ldi 	ZL, low(SRAM_DATA)
	ldi 	XH, high(SRAM_STATE)
	ldi 	XL, low(SRAM_STATE)
	rcall	XOR_bytes
	ld		r23, X
	ldi		r22, 0x01
	eor		r23, r22
	st 		X, r23
	lds		r23, SRAM_STATE + rate/8 - 1
	ldi		r22, 0x80
	eor		r23, r22
	sts		SRAM_STATE + rate/8 - 1, r23
	rcall	KeccakF
#if (output_size > rate)
	ldi 	ZH, high(SRAM_STATE)
	ldi 	ZL, low(SRAM_STATE)
	ldi 	XH, high(SRAM_OUTPUT_BUFFER)
	ldi 	XL, low(SRAM_OUTPUT_BUFFER)
	ldi		r24, rate/8
	rcall	copy_bytes
	rcall	KeccakF
	ldi 	ZH, high(SRAM_STATE)
	ldi 	ZL, low(SRAM_STATE)
	ldi 	XH, high(SRAM_OUTPUT_BUFFER+rate/8)
	ldi 	XL, low(SRAM_OUTPUT_BUFFER+rate/8)
	ldi		r24, ((output_size - rate) > rate) ? rate/8 : (output_size - rate)/8
	rcall	copy_bytes
#if (output_size > 2*rate)
	rcall	KeccakF
	ldi 	ZH, high(SRAM_STATE)
	ldi 	ZL, low(SRAM_STATE)
	ldi 	XH, high(SRAM_OUTPUT_BUFFER+2*rate/8)
	ldi 	XL, low(SRAM_OUTPUT_BUFFER+2*rate/8)
	ldi		r24, ((output_size - 2*rate) > rate) ? rate/8 : (output_size - 2*rate)/8
	rcall	copy_bytes
#if (output_size > 3*rate)
	rcall	KeccakF
	ldi 	ZH, high(SRAM_STATE)
	ldi 	ZL, low(SRAM_STATE)
	ldi 	XH, high(SRAM_OUTPUT_BUFFER+3*rate/8)
	ldi 	XL, low(SRAM_OUTPUT_BUFFER+3*rate/8)
	ldi		r24, ((output_size - 3*rate) > rate) ? rate/8 : (output_size - 3*rate)/8
	rcall	copy_bytes
#endif
#endif
	ldi 	ZH, high(SRAM_OUTPUT_BUFFER)
	ldi 	ZL, low(SRAM_OUTPUT_BUFFER)
	ldi 	XH, high(SRAM_STATE)
	ldi 	XL, low(SRAM_STATE)
	ldi		r24, output_size/8
	rcall	copy_bytes
#endif
	ret


