
/*
 * test.s
 *
 * Created: 2020-07-10 오전 11:49:22
 *  Author: 김영범
 */ 

#define zero    1
#define rpState 24
#define rX      26
#define rY      28
#define rZ      30

 .global test
 test:
    movw    r26, r24
	movw	r28, r22
	movw	r30, r20
	ld		r6, Z
	ld		r7,	Y
	ld		r7,	X
	adc		rZ,	r7
	adc		rZ+1,r7

    ldi     r23, 5*5   

	ret
