
/*
 * test.s
 *
 * Created: 2020-07-13 오후 3:18:31
 *  Author: 김영범
 */

.balign 256
PHI_TABLE_12:

.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
	  0x00, 0x06, 0x0c, 0x12, 0x18, 0x03, 0x09, 0x0a, 0x10, 0x16, 0x01, 0x07, 0x0d, 0x13, 0x14, 0x04, 0x05, 0x0b, 0x11, 0x17, 0x02, 0x08, 0x0e, 0x0f, 0x15, \
	  0x00, 0x09, 0x0d, 0x11, 0x15, 0x12, 0x16, 0x01, 0x05, 0x0e, 0x06, 0x0a, 0x13, 0x17, 0x02, 0x18, 0x03, 0x07, 0x0b, 0x0f, 0x0c, 0x10, 0x14, 0x04, 0x08, \
	  0x00, 0x16, 0x13, 0x0b, 0x08, 0x11, 0x0e, 0x06, 0x03, 0x14, 0x09, 0x01, 0x17, 0x0f, 0x0c, 0x15, 0x12, 0x0a, 0x07, 0x04, 0x0d, 0x05, 0x02, 0x18, 0x10, \
	  0x00, 0x0e, 0x17, 0x07, 0x10, 0x0b, 0x14, 0x09, 0x12, 0x02, 0x16, 0x06, 0x0f, 0x04, 0x0d, 0x08, 0x11, 0x01, 0x0a, 0x18, 0x13, 0x03, 0x0c, 0x15, 0x05, \
	  0x00, 0x14, 0x0f, 0x0a, 0x05, 0x07, 0x02, 0x16, 0x11, 0x0c, 0x0e, 0x09, 0x04, 0x18, 0x13, 0x10, 0x0b, 0x06, 0x01, 0x15, 0x17, 0x12, 0x0d, 0x08, 0x03, \
	  0x00, 0x02, 0x04, 0x01, 0x03, 0x0a, 0x0c, 0x0e, 0x0b, 0x0d, 0x14, 0x16, 0x18, 0x15, 0x17, 0x05, 0x07, 0x09, 0x06, 0x08, 0x0f, 0x11, 0x13, 0x10, 0x12, \
	  0x00, 0x0c, 0x18, 0x06, 0x12, 0x01, 0x0d, 0x14, 0x07, 0x13, 0x02, 0x0e, 0x15, 0x08, 0x0f, 0x03, 0x0a, 0x16, 0x09, 0x10, 0x04, 0x0b, 0x17, 0x05, 0x11, \
	  0x00, 0x0d, 0x15, 0x09, 0x11, 0x06, 0x13, 0x02, 0x0a, 0x17, 0x0c, 0x14, 0x08, 0x10, 0x04, 0x12, 0x01, 0x0e, 0x16, 0x05, 0x18, 0x07, 0x0f, 0x03, 0x0b, \
	  0x00, 0x13, 0x08, 0x16, 0x0b, 0x09, 0x17, 0x0c, 0x01, 0x0f, 0x0d, 0x02, 0x10, 0x05, 0x18, 0x11, 0x06, 0x14, 0x0e, 0x03, 0x15, 0x0a, 0x04, 0x12, 0x07, \
	  0x00, 0x17, 0x10, 0x0e, 0x07, 0x16, 0x0f, 0x0d, 0x06, 0x04, 0x13, 0x0c, 0x05, 0x03, 0x15, 0x0b, 0x09, 0x02, 0x14, 0x12, 0x08, 0x01, 0x18, 0x11, 0x0a, \
	  0x00, 0x0f, 0x05, 0x14, 0x0a, 0x0e, 0x04, 0x13, 0x09, 0x18, 0x17, 0x0d, 0x03, 0x12, 0x08, 0x07, 0x16, 0x0c, 0x02, 0x11, 0x10, 0x06, 0x15, 0x0b, 0x01, \
	  0x00, 0x04, 0x03, 0x02, 0x01, 0x14, 0x18, 0x17, 0x16, 0x15, 0x0f, 0x13, 0x12, 0x11, 0x10, 0x0a, 0x0e, 0x0d, 0x0c, 0x0b, 0x05, 0x09, 0x08, 0x07, 0x06

.balign 256
PHI_TABLE_24:

.byte 0x00, 0x18, 0x12, 0x0c, 0x06, 0x02, 0x15, 0x0f, 0x0e, 0x08, 0x04, 0x17, 0x11, 0x0b, 0x05, 0x01, 0x14, 0x13, 0x0d, 0x07, 0x03, 0x16, 0x10, 0x0a, 0x09, \
	  0x00, 0x15, 0x11, 0x0d, 0x09, 0x0c, 0x08, 0x04, 0x14, 0x10, 0x18, 0x0f, 0x0b, 0x07, 0x03, 0x06, 0x02, 0x17, 0x13, 0x0a, 0x12, 0x0e, 0x05, 0x01, 0x16, \
	  0x00, 0x08, 0x0b, 0x13, 0x16, 0x0d, 0x10, 0x18, 0x02, 0x05, 0x15, 0x04, 0x07, 0x0a, 0x12, 0x09, 0x0c, 0x0f, 0x17, 0x01, 0x11, 0x14, 0x03, 0x06, 0x0e, \
	  0x00, 0x10, 0x07, 0x17, 0x0e, 0x13, 0x05, 0x15, 0x0c, 0x03, 0x08, 0x18, 0x0a, 0x01, 0x11, 0x16, 0x0d, 0x04, 0x0f, 0x06, 0x0b, 0x02, 0x12, 0x09, 0x14, \
	  0x00, 0x05, 0x0a, 0x0f, 0x14, 0x17, 0x03, 0x08, 0x0d, 0x12, 0x10, 0x15, 0x01, 0x06, 0x0b, 0x0e, 0x13, 0x18, 0x04, 0x09, 0x07, 0x0c, 0x11, 0x16, 0x02, \
	  0x00, 0x03, 0x01, 0x04, 0x02, 0x0f, 0x12, 0x10, 0x13, 0x11, 0x05, 0x08, 0x06, 0x09, 0x07, 0x14, 0x17, 0x15, 0x18, 0x16, 0x0a, 0x0d, 0x0b, 0x0e, 0x0c, \
	  0x00, 0x12, 0x06, 0x18, 0x0c, 0x04, 0x11, 0x05, 0x17, 0x0b, 0x03, 0x10, 0x09, 0x16, 0x0a, 0x02, 0x0f, 0x08, 0x15, 0x0e, 0x01, 0x13, 0x07, 0x14, 0x0d, \
	  0x00, 0x11, 0x09, 0x15, 0x0d, 0x18, 0x0b, 0x03, 0x0f, 0x07, 0x12, 0x05, 0x16, 0x0e, 0x01, 0x0c, 0x04, 0x10, 0x08, 0x14, 0x06, 0x17, 0x0a, 0x02, 0x13, \
	  0x00, 0x0b, 0x16, 0x08, 0x13, 0x15, 0x07, 0x12, 0x04, 0x0a, 0x11, 0x03, 0x0e, 0x14, 0x06, 0x0d, 0x18, 0x05, 0x10, 0x02, 0x09, 0x0f, 0x01, 0x0c, 0x17, \
	  0x00, 0x07, 0x0e, 0x10, 0x17, 0x08, 0x0a, 0x11, 0x18, 0x01, 0x0b, 0x12, 0x14, 0x02, 0x09, 0x13, 0x15, 0x03, 0x05, 0x0c, 0x16, 0x04, 0x06, 0x0d, 0x0f, \
	  0x00, 0x0a, 0x14, 0x05, 0x0f, 0x10, 0x01, 0x0b, 0x15, 0x06, 0x07, 0x11, 0x02, 0x0c, 0x16, 0x17, 0x08, 0x12, 0x03, 0x0d, 0x0e, 0x18, 0x09, 0x13, 0x04, \
	  0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18


.balign 256
RoundConstants_24:
    .BYTE   0x8b, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00
    .BYTE   0x8b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80
    .BYTE   0x89, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80
    .BYTE   0x03, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80
    .BYTE   0x02, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80
    .BYTE   0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80
    .BYTE   0x0a, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .BYTE   0x0a, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80
    .BYTE   0x81, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80
    .BYTE   0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80
    .BYTE   0x01, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00
    .BYTE   0x08, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80
	.BYTE   0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .BYTE   0x82, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .BYTE   0x8a, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80
    .BYTE   0x00, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80
    .BYTE   0x8b, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .BYTE   0x01, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00
    .BYTE   0x81, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80
    .BYTE   0x09, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80
    .BYTE   0x8a, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .BYTE   0x88, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .BYTE   0x09, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00
    .BYTE   0x0a, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00


.text


 #include "macro.s"

#define load   0
#define zero    1
#define therz	2
#define therz2	3
#define	therx	4
#define	therx2	5
#define	count2	6
#define	count3	7
#define rState0  8
#define rState1  9
#define rState2  10
#define rState3  11
#define rState4  12
#define rState5  13
#define rState6  14
#define rState7  15
#define rTemp0  16
#define rTemp1  17
#define rTemp2  18
#define rTemp3  19
#define rTemp4  20
#define rTemp5  21
#define rTemp6  22
#define rTemp7  23
#define count   24
#define	main_count 25
#define rX      26
#define rY      28
#define rZ      30




/*.global test
test:
	ldi r31, hi8(SBOX_TABLE) // Z : r31:r30
	eor r30, r30	lpm r24, Z+
	lpm r25, Z+	lpm r26, Z+
	ret*/


 /*		param 'in'    <- r24:r25
 *			  'state' <- r22:r23
 *			  'temp'  <- r20:r21
 */			  
.global keccack
keccack:
		push_range 0, 31
		push r23
		push r22;  state --> stack

		movw rX,	r24 ; in   --> X
		movw rY,	r20 ; temp --> Y
		ldi main_count,		 24

		ldi		r31,	hi8(RoundConstants_24)
		ldi		r30,	lo8(RoundConstants_24)
		push	r30
		push	r31

		ldi		r31,	hi8(PHI_TABLE_12)
		ldi		r30,	lo8(PHI_TABLE_12)
		movw	therz,	rZ

start:
		ldi		count,	5
		mov		count2,	count
		movw	rZ,		therz
		movw	therx,	X

		ldi		count,	12
		cp		count,	main_count
		brge	startafter
		rjmp	Theta_init_Loop

startafter:
		ldi		r31,	hi8(PHI_TABLE_24)
		ldi		r30,	lo8(PHI_TABLE_24)
		movw	therz,	rZ



Theta_init_Loop:

	lpm		rX,		Z
    ld      rTemp0, X+     ; state[x]
    ld      rTemp1, X+
    ld      rTemp2, X+
    ld      rTemp3, X+
    ld      rTemp4, X+
    ld      rTemp5, X+
    ld      rTemp6, X+
    ld      rTemp7, X+

	adiw	Z,		5    ; state[x+5]
	lpm		rX,		Z
    ld		load,	X+
	eor		rTemp0,	load
	ld		load,	X+
	eor		rTemp1,	load
	ld		load,	X+
	eor		rTemp2,	load
	ld		load,	X+
	eor		rTemp3,	load
	ld		load,	X+
	eor		rTemp4,	load
	ld		load,	X+
	eor		rTemp5,	load
	ld		load,	X+
	eor		rTemp6,	load
	ld		load,	X+
	eor		rTemp7,	load

	adiw	Z,		5    ; state[x+10]
	lpm		rX,		Z
    ld		load,	X+
	eor		rTemp0,	load
	ld		load,	X+
	eor		rTemp1,	load
	ld		load,	X+
	eor		rTemp2,	load
	ld		load,	X+
	eor		rTemp3,	load
	ld		load,	X+
	eor		rTemp4,	load
	ld		load,	X+
	eor		rTemp5,	load
	ld		load,	X+
	eor		rTemp6,	load
	ld		load,	X+
	eor		rTemp7,	load

	adiw	Z,		5    ; state[x+15]
	lpm		rX,		Z
    ld		load,	X+
	eor		rTemp0,	load
	ld		load,	X+
	eor		rTemp1,	load
	ld		load,	X+
	eor		rTemp2,	load
	ld		load,	X+
	eor		rTemp3,	load
	ld		load,	X+
	eor		rTemp4,	load
	ld		load,	X+
	eor		rTemp5,	load
	ld		load,	X+
	eor		rTemp6,	load
	ld		load,	X+
	eor		rTemp7,	load

	adiw	Z,		5    ; state[x+20]
	lpm		rX,		Z+
    ld		load,	X+
	eor		rTemp0,	load
	ld		load,	X+
	eor		rTemp1,	load
	ld		load,	X+
	eor		rTemp2,	load
	ld		load,	X+
	eor		rTemp3,	load
	ld		load,	X+
	eor		rTemp4,	load
	ld		load,	X+
	eor		rTemp5,	load
	ld		load,	X+
	eor		rTemp6,	load
	ld		load,	X+
	eor		rTemp7,	load

	st      Y+, rTemp0
    st      Y+, rTemp1
    st      Y+, rTemp2
    st      Y+, rTemp3
    st      Y+, rTemp4
    st      Y+, rTemp5
    st      Y+, rTemp6
    st      Y+, rTemp7
	dec		count2
	breq	END_Theta
	sbiw	Z,	 20
	rjmp	Theta_init_Loop

END_Theta:
	adiw	Z,	 20
	sbiw	Y,	 25
	movw	X,	 therx ; X inital 
	movw	therz,	Z  ; thetha Z -----> r2, r3

Theta_update_1:

	ld       rTemp0, Y   ;0 저장
    ldd      rTemp1, Y+1
    ldd      rTemp2, Y+2
    ldd      rTemp3, Y+3
    ldd      rTemp4, Y+4
    ldd      rTemp5, Y+5
    ldd      rTemp6, Y+6
    ldd      rTemp7, Y+7

	ldd      rState0, Y+16   ; 2저장
    ldd      rState1, Y+17
    ldd      rState2, Y+18
    ldd      rState3, Y+19
    ldd      rState4, Y+20
    ldd      rState5, Y+21
    ldd      rState6, Y+22
    ldd      rState7, Y+23

	lsl     rState0 ;2 로테이트
    rol     rState1
    rol     rState2
    rol     rState3
    rol     rState4
    rol     rState5
    rol     rState6
    rol     rState7
    adc     rState0, zero

	eor		rState0, rTemp0 ;저장값 1 만들기
	eor		rState1, rTemp1
	eor		rState2, rTemp2
	eor		rState3, rTemp3
	eor		rState4, rTemp4
	eor		rState5, rTemp5
	eor		rState6, rTemp6
	eor		rState7, rTemp7
	
	ldi		count,	48
	add		rY,		count
	st		Y+,	rState0
	st		Y+,	rState1
	st		Y+,	rState2
	st		Y+,	rState3
	st		Y+,	rState4
	st		Y+,	rState5
	st		Y+,	rState6
	st		Y+,	rState7;-------------------------------------------------02 ->1
	sub		rY,		count
	sbiw	Y,		8

Theta_update_2:
							 ;rTemp <-- 0저장
	ldd      rState0, Y+24   ; 3저장
    ldd      rState1, Y+25
    ldd      rState2, Y+26
    ldd      rState3, Y+27
    ldd      rState4, Y+28
    ldd      rState5, Y+29
    ldd      rState6, Y+30
    ldd      rState7, Y+31

	lsl     rTemp0 ;0 로테이트
    rol     rTemp1
    rol     rTemp2
    rol     rTemp3
    rol     rTemp4
    rol     rTemp5
    rol     rTemp6
    rol     rTemp7
    adc     rTemp0, zero

	eor		rTemp0,	rState0 ;저장값 4 만들기
	eor		rTemp1,	rState1
	eor		rTemp2,	rState2
	eor		rTemp3,	rState3
	eor		rTemp4,	rState4
	eor		rTemp5,	rState5
	eor		rTemp6,	rState6
	eor		rTemp7,	rState7
	
	ldi		count,	72
	add		rY,		count
	st		Y+,	rTemp0
	st		Y+,	rTemp1
	st		Y+,	rTemp2
	st		Y+,	rTemp3
	st		Y+,	rTemp4
	st		Y+,	rTemp5
	st		Y+,	rTemp6
	st		Y+,	rTemp7	;-------------------------------------------------30 ->4
	sub		rY,		count
	sbiw	Y,		8

Theta_update_3:
						  ; rstate 3 저장
	ldd      rTemp0, Y+8  ;1 저장
    ldd      rTemp1, Y+9
    ldd      rTemp2, Y+10
    ldd      rTemp3, Y+11
    ldd      rTemp4, Y+12
    ldd      rTemp5, Y+13
    ldd      rTemp6, Y+14
    ldd      rTemp7, Y+15
					
	lsl     rState0 ;3 로테이트
    rol     rState1
    rol     rState2
    rol     rState3
    rol     rState4
    rol     rState5
    rol     rState6
    rol     rState7
    adc     rState0, zero

	eor		rState0, rTemp0 ;저장값 1 만들기
	eor		rState1, rTemp1
	eor		rState2, rTemp2
	eor		rState3, rTemp3
	eor		rState4, rTemp4
	eor		rState5, rTemp5
	eor		rState6, rTemp6
	eor		rState7, rTemp7
	
	ldi		count,	56
	add		rY,		count
	st		Y+,	rState0
	st		Y+,	rState1
	st		Y+,	rState2
	st		Y+,	rState3
	st		Y+,	rState4
	st		Y+,	rState5
	st		Y+,	rState6
	st		Y+,	rState7;-------------------------------------------------13 ->2
	sub		rY,		count
	sbiw	Y,		8

	Theta_update_4:
							 ;rTemp <-- 1저장
	ldd      rState0, Y+32   ; 4저장
    ldd      rState1, Y+33
    ldd      rState2, Y+34
    ldd      rState3, Y+35
    ldd      rState4, Y+36
    ldd      rState5, Y+37
    ldd      rState6, Y+38
    ldd      rState7, Y+39

	lsl     rTemp0 ;0 로테이트
    rol     rTemp1
    rol     rTemp2
    rol     rTemp3
    rol     rTemp4
    rol     rTemp5
    rol     rTemp6
    rol     rTemp7
    adc     rTemp0, zero

	eor		rTemp0,	rState0 ;저장값 4 만들기
	eor		rTemp1,	rState1
	eor		rTemp2,	rState2
	eor		rTemp3,	rState3
	eor		rTemp4,	rState4
	eor		rTemp5,	rState5
	eor		rTemp6,	rState6
	eor		rTemp7,	rState7
	
	ldi		count,	40
	add		rY,		count
	st		Y+,	rTemp0
	st		Y+,	rTemp1
	st		Y+,	rTemp2
	st		Y+,	rTemp3
	st		Y+,	rTemp4
	st		Y+,	rTemp5
	st		Y+,	rTemp6
	st		Y+,	rTemp7;-------------------------------------------------41 ->0
	sub		rY,		count
	sbiw	Y,		8


Theta_update_5:
						  ; rstate 4 저장
	ldd      rTemp0, Y+16  ;2 저장
    ldd      rTemp1, Y+17
    ldd      rTemp2, Y+18
    ldd      rTemp3, Y+19
    ldd      rTemp4, Y+20
    ldd      rTemp5, Y+21
    ldd      rTemp6, Y+22
    ldd      rTemp7, Y+23
					
	lsl     rState0 ;4 로테이트
    rol     rState1
    rol     rState2
    rol     rState3
    rol     rState4
    rol     rState5
    rol     rState6
    rol     rState7
    adc     rState0, zero

	eor		rState0, rTemp0 ;저장값 3 만들기
	eor		rState1, rTemp1
	eor		rState2, rTemp2
	eor		rState3, rTemp3
	eor		rState4, rTemp4
	eor		rState5, rTemp5
	eor		rState6, rTemp6
	eor		rState7, rTemp7
	
	ldi		count,	64
	add		rY,		count
	st		Y+,	rState0
	st		Y+,	rState1
	st		Y+,	rState2
	st		Y+,	rState3
	st		Y+,	rState4
	st		Y+,	rState5
	st		Y+,	rState6
	st		Y+,	rState7;-------------------------------------------------24 ->3
	sbiw	Y,	28	
	
	ldi		count,	25
	mov		count2,	count
	ldi		count,	8
	mov		count3,	count
	eor		zero,	zero

Thetha_Rho_loop:

	ldi		count,	40

	rcall	first_load_EOR
	rcall	rotate64_1bit_right
	rcall	rotate64_4byte_left

	rcall	first_load_EOR
	rcall	rotate64_1bit_left
	rcall	rotate64_3byte_left

	rcall	first_load_EOR
	rcall	rotate64_3bit_right
	rcall	rotate64_0byte_left

	rcall	first_load_EOR
	rcall	rotate64_2bit_right
	rcall	rotate64_7byte_left

	rcall	first_load_EOR
	rcall	rotate64_3bit_right
	rcall	rotate64_3byte_left ; fist Row

	sub		rY,		count
;-------------------------------------------
	rcall	first_load_EOR
	rcall	rotate64_1bit_left
	rcall	rotate64_1byte_left

	rcall	first_load_EOR
	rcall	rotate64_4bit_left
	rcall	rotate64_4byte_left

	rcall	first_load_EOR
	rcall	rotate64_4bit_left
	rcall	rotate64_3byte_left

	rcall	first_load_EOR
	rcall	rotate64_4bit_left
	rcall	rotate64_2byte_left

	rcall	first_load_EOR
	rcall	rotate64_1bit_left
	rcall	rotate64_0byte_left  ; fist Row

	sub		rY,		count	
;-------------------------------------------

	rcall	first_load_EOR
	rcall	rotate64_4bit_left
	rcall	rotate64_3byte_left

	rcall	first_load_EOR
	rcall	rotate64_3bit_left
	rcall	rotate64_4byte_left

	rcall	first_load_EOR
	rcall	rotate64_0byte_left

	rcall	first_load_EOR
	rcall	rotate64_1bit_right
	rcall	rotate64_0byte_left

	rcall	first_load_EOR
	rcall	rotate64_2bit_left
	rcall	rotate64_0byte_left	;Third Row

	sub		rY,		count	
;-------------------------------------------

	rcall	first_load_EOR
	rcall	rotate64_1byte_left

	rcall	first_load_EOR
	rcall	rotate64_2bit_left
	rcall	rotate64_6byte_left

	rcall	first_load_EOR
	rcall	rotate64_2bit_right
	rcall	rotate64_6byte_left

	rcall	first_load_EOR
	rcall	rotate64_2bit_right
	rcall	rotate64_0byte_left

	rcall	first_load_EOR
	rcall	rotate64_3bit_left
	rcall	rotate64_0byte_left	 ;Firth Row
	
	sub		rY,		count

;-------------------------------------------

	rcall	first_load_EOR
	rcall	rotate64_3bit_left
	rcall	rotate64_5byte_left

	rcall	first_load_EOR
	rcall	rotate64_7byte_left

	rcall	first_load_EOR
	rcall	rotate64_1bit_right
	rcall	rotate64_3byte_left

	rcall	first_load_EOR
	rcall	rotate64_3bit_left
	rcall	rotate64_2byte_left

	rcall	first_load_EOR
	rcall	rotate64_1bit_left
	rcall	rotate64_6byte_left	 ;Fifth Row
	
	sub		rY,		count

	movw	rX,		therx
	movw	therx,	rY
	movw	rY,		rX
	movw	rX,		therx


	ldi		count,	5
	mov		count2,	count
	eor		zero,	zero

Chi_Lota_Setting:
	ldi		count,	8	

Chi_Lota:

	ld      rTemp0, Y
    ldd     rTemp1, Y+8
    ldd     rTemp2, Y+16
    ldd     rTemp3, Y+24
    ldd     rTemp4, Y+32
	
	;*p = t = a0 ^ ((~a1) & a2); c0 ^= t;

	mov     load, rTemp1
    com     load
    and     load, rTemp2
    eor     load, rTemp0
    eor     rTemp0, load
    st      Y, load

    ;*(p+8) = t = a1 ^ ((~a2) & a3); c1 ^= t;

    mov     load, rTemp2
    com     load
    and     load, rTemp3
    eor     load, rTemp1
    eor     rTemp1, load
    std     Y+8, r0

    ;*(p+16) = a2 ^= ((~a3) & a4); c2 ^= a2;

    mov     load, rTemp3
    com     load
    and     load, rTemp4
    eor     load, rTemp2
    eor     rTemp2, load
    std     Y+16, load

    ;*(p+24) = a3 ^= ((~a4) & a0); c3 ^= a3;

    mov     load, rTemp4
    com     load
    and     load, rTemp0
    eor     load, rTemp3
    eor     rTemp3, load
    std     Y+24, load

    ;*(p+32) = a4 ^= ((~a0) & a1); c4 ^= a4;

    com     rTemp0
    and     rTemp0, rTemp1
    eor     rTemp0, rTemp4
    eor     rTemp4, rTemp0
    std     Y+32, rTemp0

Chi_Condition:

	adiw    rY, 8
	adc		rY+1,	zero
    dec     count
    brne    Chi_Lota

	adiw	rY,32
	adc		rY+1,	zero
	dec		count2
	brne	Chi_Lota_Setting

	movw	rX,		rY
	movw	rY,		therx

	movw	therx,	rZ

Lota:

	pop		r31
	pop		r30
	
	ldi		count,	96
	adiw	rY,		count
	adc		rY,		zero

	ld		rState0,	Y
	ldd		rState1,	Y+1
	ldd		rState2,	Y+2
	ldd		rState3,	Y+3
	ldd		rState4,	Y+4
	ldd		rState5,	Y+5
	ldd		rState6,	Y+6
	ldd		rState7,	Y+7

	lpm		rTemp0,		Z+
	lpm		rTemp1,		Z+
	lpm		rTemp2,		Z+
	lpm		rTemp3,		Z+
	lpm		rTemp4,		Z+
	lpm		rTemp5,		Z+
	lpm		rTemp6,		Z+
	lpm		rTemp7,		Z+

	eor		rState0,	rTemp0
	eor		rState1,	rTemp1
	eor		rState2,	rTemp2
	eor		rState3,	rTemp3
	eor		rState4,	rTemp4
	eor		rState5,	rTemp5
	eor		rState6,	rTemp6
	eor		rState7,	rTemp7

	st		Y,			rState0
	std		Y+1,		rState1
	std		Y+2,		rState2
	std		Y+3,		rState3
	std		Y+4,		rState4
	std		Y+5,		rState5
	std		Y+6,		rState6
	std		Y+7,		rState7

	sbiw	rY,		count
	sbc		rY+1,	zero
	push	r30
	push	r31

	movw	rZ,		therx
	movw	therx,	rX
	
END_Condtion:
	dec	main_count
	breq Keccack_END
	rjmp start

Keccack_END:
	pop	r31
	pop	r30
	pop r22
	pop r23
	pop_range 0, 31
	ret

first_load_EOR:

	ld	   rState0,		X+
    ld     rState1,		X+
    ld     rState2,		X+
    ld     rState3,		X+
    ld     rState4,		X+
    ld     rState5,		X+
    ld     rState6,		X+
    ld     rState7,		X+
	sub		rX,		count3

	ld	   rTemp0,		Y+
    ld     rTemp1,		Y+
    ld     rTemp2,		Y+
    ld     rTemp3,		Y+
    ld     rTemp4,		Y+
    ld     rTemp5,		Y+
    ld     rTemp6,		Y+
    ld     rTemp7,		Y+

	eor	  rState0,	rTemp0
	eor	  rState1,	rTemp1
	eor	  rState2,	rTemp2
	eor	  rState3,	rTemp3
	eor	  rState4,	rTemp4
	eor	  rState5,	rTemp5
	eor	  rState6,	rTemp6
	eor	  rState7,	rTemp7

	
	ret

 rotate64_4bit_left:

    lsl		rState0
    rol     rState1
    rol     rState2
    rol     rState3
    rol     rState4
    rol     rState5
    rol     rState6
    rol     rState7
    adc     rState0, zero

rotate64_3bit_left:

    lsl		rState0
    rol     rState1
    rol     rState2
    rol     rState3
    rol     rState4
    rol     rState5
    rol     rState6
    rol     rState7
    adc     rState0, zero

rotate64_2bit_left:

    lsl		rState0
    rol     rState1
    rol     rState2
    rol     rState3
    rol     rState4
    rol     rState5
    rol     rState6
    rol     rState7
    adc     rState0, zero

rotate64_1bit_left:

    lsl		rState0
    rol     rState1
    rol     rState2
    rol     rState3
    rol     rState4
    rol     rState5
    rol     rState6
    rol     rState7
    adc     rState0, zero

	ret

;----------------------------------------------------------------------------------------------------

rotate64_3bit_right:

    bst     rState0, 0
    ror     rState7
    ror     rState6
    ror     rState5
    ror     rState4
    ror     rState3
    ror     rState2
    ror     rState1
    ror     rState0
    bld     rState7, 7

rotate64_2bit_right:

    bst     rState0, 0
    ror     rState7
    ror     rState6
    ror     rState5
    ror     rState4
    ror     rState3
    ror     rState2
    ror     rState1
    ror     rState0
    bld     rState7, 7

rotate64_1bit_right:

    bst     rState0, 0
    ror     rState7
    ror     rState6
    ror     rState5
    ror     rState4
    ror     rState3
    ror     rState2
    ror     rState1
    ror     rState0
    bld     rState7, 7

	ret

;----------------------------------------------------------------------------------------------------

rotate64_0byte_left:

    st      X+,	rState0
    st      X+,	rState1
    st      X+,	rState2
	st      X+,	rState3
	st      X+,	rState4
	st      X+,	rState5
	st      X+,	rState6
	st      X+,	rState7

    ret

rotate64_1byte_left:
	
	st      X+,	rState1
    st      X+,	rState2
    st      X+,	rState3
	st      X+,	rState4
	st      X+,	rState5
	st      X+,	rState6
	st      X+,	rState7
	st      X+,	rState0

    ret   

rotate64_2byte_left:

	st      X+,	rState2
    st      X+,	rState3
    st      X+,	rState4
	st      X+,	rState5
	st      X+,	rState6
	st      X+,	rState7
	st      X+,	rState0
	st      X+,	rState1

    ret   

rotate64_3byte_left:

	st      X+,	rState3
    st      X+,	rState4
    st      X+,	rState5
	st      X+,	rState6
	st      X+,	rState7
	st      X+,	rState0
	st      X+,	rState1
	st      X+,	rState2

    ret    

rotate64_4byte_left:

	st      X+,	rState4
    st      X+,	rState5
    st      X+,	rState6
	st      X+,	rState7
	st      X+,	rState0
	st      X+,	rState1
	st      X+,	rState2
	st      X+,	rState3

    ret    

rotate64_5byte_left:

	st      X+,	rState5
    st      X+,	rState6
    st      X+,	rState7
	st      X+,	rState0
	st      X+,	rState1
	st      X+,	rState2
	st      X+,	rState3
	st      X+,	rState4

    ret    

rotate64_6byte_left:

	st      X+,	rState6
    st      X+,	rState7
    st      X+,	rState0
	st      X+,	rState1
	st      X+,	rState2
	st      X+,	rState3
	st      X+,	rState4
	st      X+,	rState5

    ret    

rotate64_7byte_left:

	st      X+,	rState7
    st      X+,	rState0
    st      X+,	rState1
	st      X+,	rState2
	st      X+,	rState3
	st      X+,	rState4
	st      X+,	rState5
	st      X+,	rState6

    ret    