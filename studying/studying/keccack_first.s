
/*
 * keccack_first.s
 *
 * Created: 2020-07-14 오후 4:34:23
 *  Author: 김영범
 */ 
 
/*
 * test.s
 *
 * Created: 2020-07-13 오후 3:18:31
 *  Author: 김영범
 */ 
.section .data

PHI_TABLE_12:
.byte 0x00, 0x06, 0x0c, 0x12, 0x18, 0x03, 0x09, 0x0a, 0x10, 0x16, 0x01, 0x07, 0x0d, 0x13, 0x14, 0x04, 0x05, 0x0b, 0x11, 0x17, 0x02, 0x08, 0x0e, 0x0f, 0x15, \
	  

.section .text

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


;push_range 2, 22
;pop_range 2, 22

 /*		param 'in'    <- r24:r25
 *			  'state' <- r22:r23
 *			  'temp'  <- r20:r21
 */
 
 

.global keccack_first
keccack_first:
	push_range 0, 17

	ldi r31, hi8(PHI_TABLE_12)
	ldi r30, lo8(PHI_TABLE_12)	ld r17, Z
	ld r18, Z

	pop_range 0, 17

	ret


    ; Initial Prepare Theta
  ;  ldi     TCIPx, 5
    movw    rY, rpState
Theta_Loop:
    ld      rTemp0, Y+     ; state[x]
    ld      rTemp1, Y+
    ld      rTemp2, Y+
    ld      rTemp3, Y+
    ld      rTemp4, Y+
    ld      rTemp5, Y+
    ld      rTemp6, Y+
    ld      rTemp7, Y+

    adiw    rY, 32
    ld      r0, Y+          ; state[5+x]
    eor     rTemp0, r0
    ld      r0, Y+
    eor     rTemp1, r0
    ld      r0, Y+
    eor     rTemp2, r0
    ld      r0, Y+
    eor     rTemp3, r0
    ld      r0, Y+
    eor     rTemp4, r0
    ld      r0, Y+
    eor     rTemp5, r0
    ld      r0, Y+
    eor     rTemp6, r0
    ld      r0, Y+
    eor     rTemp7, r0

    adiw    rY, 32
    ld      r0, Y+          ; state[10+x]
    eor     rTemp0, r0
    ld      r0, Y+
    eor     rTemp1, r0
    ld      r0, Y+
    eor     rTemp2, r0
    ld      r0, Y+
    eor     rTemp3, r0
    ld      r0, Y+
    eor     rTemp4, r0
    ld      r0, Y+
    eor     rTemp5, r0
    ld      r0, Y+
    eor     rTemp6, r0
    ld      r0, Y+
    eor     rTemp7, r0

    adiw    rY, 32
    ld      r0, Y+          ; state[15+x]
    eor     rTemp0, r0
    ld      r0, Y+
    eor     rTemp1, r0
    ld      r0, Y+
    eor     rTemp2, r0
    ld      r0, Y+
    eor     rTemp3, r0
    ld      r0, Y+
    eor     rTemp4, r0
    ld      r0, Y+
    eor     rTemp5, r0
    ld      r0, Y+
    eor     rTemp6, r0
    ld      r0, Y+
    eor     rTemp7, r0

    adiw    rY, 32
    ld      r0, Y+          ; state[20+x]
    eor     rTemp0, r0
    ld      r0, Y+
    eor     rTemp1, r0
    ld      r0, Y+
    eor     rTemp2, r0
    ld      r0, Y+
    eor     rTemp3, r0
    ld      r0, Y+
    eor     rTemp4, r0
    ld      r0, Y+
    eor     rTemp5, r0
    ld      r0, Y+
    eor     rTemp6, r0
    ld      r0, Y+
    eor     rTemp7, r0

    st      Z+, rTemp0
    st      Z+, rTemp1
    st      Z+, rTemp2
    st      Z+, rTemp3
    st      Z+, rTemp4
    st      Z+, rTemp5
    st      Z+, rTemp6
    st      Z+, rTemp7

    subi    rY, 160
    sbc     rY+1, zero

   ; subi    TCIPx,                 1
   ; breq    KeccakInitialPrepTheta_Done
   ; rjmp    KeccakInitialPrepTheta_Loop