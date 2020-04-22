
/*
 * aes_keyschedule_asm.s
 *
 * Created: 2020-04-22 오후 5:23:32
 *  Author: 김영범
 */ 
 #include "avr-asm-macros.S"

.global aes256_init
aes256_init:
	movw r20, r22
	ldi r23, hi8(256)
	ldi r22, lo8(256)
	rjmp aes_init
	
.global aes192_init
aes192_init:
	movw r20, r22
	ldi r23, hi8(192)
	ldi r22, lo8(192)
	rjmp aes_init
	
.global aes128_init
aes128_init:
	movw r20, r22
	clr r23
	ldi r22, 128

SBOX_SAVE0 = 14
SBOX_SAVE1 = 15
XRC = 17
NK = 22
C1 = 18
NEXT_NK = 19
HI = 23
T0 = 20
T1 = 21
T2 = 24
T3 = 25
/*
 * param key:       r24:r25
 * param keysize_b: r22:r23
 * param ctx:       r20:r21
 */
.global aes_init
aes_init:
	push_range 14, 17
	push r28
	push r29
	movw r30, r20
	movw r28, r20
	movw r26, r24
	lsr r23
	ror r22
	lsr r22
	lsr r22 /* r22 contains keysize_b/8 */
	mov C1, r22

1:	/* copy key to ctx */ 
	ld r0, X+
	st Z+, r0
	dec C1
	brne 1b
	
	lsr NK
	lsr NK
	bst NK,3 /* set T if NK==8 */
	mov NEXT_NK, NK
	mov HI, NK
	subi HI, -7
	lsl HI
	lsl HI
	movw r26, r30
	sbiw r26, 4
	mov C1, NK
	ldi r31, hi8(aes_sbox)
	movw SBOX_SAVE0, r30
	ldi XRC, 1
1:	
	ld T0, X+
	ld T1, X+
	ld T2, X+
	ld T3, X+
	cp NEXT_NK, C1
	breq 2f 
	brtc 5f
	mov r16, C1
	andi r16, 0x07
	cpi r16, 0x04
	brne 5f
	movw r30, SBOX_SAVE0
	mov r30, T0
	lpm T0, Z

	mov r30, T1
	lpm T1, Z

	mov r30, T2
	lpm T2, Z

	mov r30, T3
	lpm T3, Z

	rjmp 5f
2:
	add NEXT_NK, NK
	movw r30, SBOX_SAVE0
	mov r30, T0
	lpm r16, Z

	mov r30, T1
	lpm T0, Z

	mov r30, T2
	lpm T1, Z

	mov r30, T3
	lpm T2, Z

	mov T3, r16
	eor T0, XRC
	lsl XRC
	brcc 3f
	ldi XRC, 0x1b
3:
5:	
	movw r30, r26

	ld r0, Y+
	eor r0, T0
	st Z+, r0 
	ld r0, Y+
	eor r0 ,T1
	st Z+, r0
	ld r0, Y+
	eor r0, T2
	st Z+, r0
	ld r0, Y+
	eor r0, T3
	st Z+, r0
	
	inc C1
	cp C1, HI
	breq 6f
	rjmp 1b
6:	
	clt
	pop r29
	pop r28
	pop_range 14, 17
	ret