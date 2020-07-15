
/*
 * init.s
 *
 * Created: 2020-07-14 오후 2:24:26
 *  Author: 김영범
 */ 
 

 .text
 #include "macro.s"

#define zero    1
#define rpState 24
#define rX      26
#define rY      28
#define rZ      30
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



 /*		param 'in'    <- r24:r25
 *			  'state' <- r22:r23
 *			  'temp'  <- r20:r21
 */			  
 .global init
	init:
		push r17
		push r18
		push r0

		movw rZ,	r24
		movw rY,	r22
		movw rX,	r20
		
		eor  r0,	r0		;r0 초기화
		ldi  r17,	136		
		add  rZ,	r17
		adc  r31,	r0
	    ldi  r17,	2

	1:
		ld	r18,	Z+
		st	Y+,		r18
		st	Z+,		r0
		dec	r17
		brne 1b

		ldi r17,	0x06
		st	Y+,		r17
		ldi r17,	132
		add	rY,		r17
		adc	r29,	r0
		ldi r18,	0x80
		st	Y,		r18

		pop r0
		pop r18
		pop r17

		ret

		
