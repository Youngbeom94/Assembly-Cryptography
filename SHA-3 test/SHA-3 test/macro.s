
/*
 * mecro.s
 *
 * Created: 2020-07-13 오후 3:33:03
 *  Author: 김영범
 */ 
 .nolist
#include <avr/io.h>
.list
/*******************************************************************************
*  MACRO SECTION                                                               *
*******************************************************************************/
.macro push_range from:req, to:req
	push \from
.if     \to-\from
	push_range "(\from+1)",\to
.endif
.endm

.macro pop_range from:req, to:req
	pop \to
.if     \to-\from
	pop_range \from,"(\to-1)"
.endif
.endm

.macro load_from_state_to_Y
		ld	r8,		Y+
		ld	r9,		Y+
		ld	r10,	Y+
		ld	r11,	Y+
		ld	r12,	Y+
		ld	r13,	Y+
		ld	r14,	Y+
		ld	r15,	Y+
.endm

.macro load_from_temp_to_Y
		ld	r16,	Y+
		ld	r17,	Y+
		ld	r18,	Y+
		ld	r19,	Y+
		ld	r20,	Y+
		ld	r21,	Y+
		ld	r22,	Y+
		ld	r23,	Y+
.endm


.macro store_from_Y_to_state
		st	Y+,		r8
		st	Y+,		r9
		st	Y+,		r10
		st	Y+,		r11
		st	Y+,		r12
		st	Y+,		r13
		st	Y+,		r14
		st	Y+,		r15
.endm

.macro store_from_Y_to_temp
		st	Y+,		r16
		st	Y+,		r17
		st	Y+,		r18
		st	Y+,		r19
		st	Y+,		r20
		st	Y+,		r21
		st	Y+,		r22
		st	Y+,		r23
.endm

.macro load_from_state_to_X
		ld	r8,		X+
		ld	r9,		X+
		ld	r10,	X+
		ld	r11,	X+
		ld	r12,	X+
		ld	r13,	X+
		ld	r14,	X+
		ld	r15,	X+
.endm

.macro load_from_temp_to_X
		ld	r16,	X+
		ld	r17,	X+
		ld	r18,	X+
		ld	r19,	X+
		ld	r20,	X+
		ld	r21,	X+
		ld	r22,	X+
		ld	r23,	X+
.endm

.macro store_from_X_to_state
		st	X+,		r8
		st	X+,		r9
		st	X+,		r10
		st	X+,		r11
		st	X+,		r12
		st	X+,		r13
		st	X+,		r14
		st	X+,		r15
.endm

.macro store_from_X_to_temp
		st	X+,		r16
		st	X+,		r17
		st	X+,		r18
		st	X+,		r19
		st	X+,		r20
		st	X+,		r21
		st	X+,		r22
		st	X+,		r23
.endm

.macro initial_theta_rotate_state
		lsl     	r8 ;2 로테이트
    	rol     	r9
    	rol     	r10
    	rol     	r11
    	rol     	r12
   		rol     	r13
    	rol     	r14
    	rol     	r15
    	adc     	r8, r1
.endm

.macro initial_theta_rotate_temp
		lsl     	r16 ;2 로테이트
    	rol     	r17
    	rol     	r18
    	rol     	r19
    	rol     	r20
   		rol     	r21
    	rol     	r22
    	rol     	r23
    	adc     	r16, r1
.endm

.macro initial_theta_eor_form_temp_to_state
		eor		r8,		r16
		eor		r9,		r17
		eor		r10,	 r18
		eor		r11,	r19
		eor		r12,	r20
		eor		r13,	r21
		eor		r14,	r22
		eor		r15,	r23
.endm

.macro initial_theta_eor_form_state_to_temp
		eor		r16,	r8
		eor		r17,	r9
		eor		r18,	r10
		eor		r19,	r11
		eor		r20,	r12
		eor		r21,	r13
		eor		r22,	r14
		eor		r23,	r15
.endm



.macro theta_initial_help
		adiw	r26,	32
		adc		r27, r1						; state[x+5]
   		ld		r0,	X+
		eor		r16,	r0
		ld		r0,	X+
		eor		r17,	r0
		ld		r0,	X+
		eor		r18,	r0
		ld		r0,	X+
		eor		r19,	r0
		ld		r0,	X+
		eor		r20,	r0
		ld		r0,	X+
		eor		r21,	r0
		ld		r0,	X+
		eor		r22,	r0
		ld		r0,	X+
		eor		r23,	r0
.endm

.macro first_load_state

			add			r26,		r24 ;count			
			adc			r27,		r1

			ld			r8,			X+
    		ld     		r9,			X+
    		ld     		r10,		X+
    		ld     		r11,		X+
    		ld     		r12,		X+
    		ld     		r13,		X+
    		ld     		r14,		X+
    		ld     		r15,		X+

			add			r24,		r7
			sub			r26,		r24
			sbc			r27,		r1


			add			r28,		r25 ;count2			
			adc			r29,		r1

			ld			r0,			Y+
			eor			r8,			r0
			ld			r0,			Y+
			eor			r9,			r0
			ld			r0,			Y+
			eor			r10,		r0
			ld			r0,			Y+
			eor			r11,		r0
			ld			r0,			Y+
			eor			r12,		r0
			ld			r0,			Y+
			eor			r13,		r0
			ld			r0,			Y+
			eor			r14,		r0
			ld			r0,			Y+
			eor			r15,		r0

			add			r25,		r7
			sub			r28,		r25
			sbc			r29,		r1

.endm

.macro first_load_temp

			
			add			r26,		r24 ;count			
			adc			r27,		r1

			ld			r16,		X+
    		ld     		r17,		X+
    		ld     		r18,		X+
    		ld     		r19,		X+
    		ld     		r20,		X+
    		ld     		r21,		X+
    		ld     		r22,		X+
    		ld     		r23,		X+

			add			r24,		r7
			sub			r26,		r24
			sbc			r27,		r1


			add			r28,		r25 ;count2			
			adc			r29,		r1

			ld			r0,			Y+
			eor			r16,		r0
			ld			r0,			Y+
			eor			r17,		r0
			ld			r0,			Y+
			eor			r18,		r0
			ld			r0,			Y+
			eor			r19,		r0
			ld			r0,			Y+
			eor			r20,		r0
			ld			r0,			Y+
			eor			r21,		r0
			ld			r0,			Y+
			eor			r22,		r0
			ld			r0,			Y+
			eor			r23,		r0
	
			
			add			r25,		r7
			sub			r28,		r25
			sbc			r29,		r1
.endm
//--------------------------------------------------------------------------------------------------------------------------------------state rotate------------------------------------------
.macro rotate64_4bit_left_state

    		lsl		    r8
    		rol     	r9
    		rol     	r10
    		rol     	r11
    		rol     	r12
    		rol     	r13
    		rol     	r14
    		rol     	r15
    		adc     	r8, r1

			lsl		    r8
    		rol     	r9
    		rol     	r10
    		rol     	r11
    		rol     	r12
    		rol     	r13
    		rol     	r14
    		rol     	r15
    		adc     	r8, r1
			
			lsl		    r8
    		rol     	r9
    		rol     	r10
    		rol     	r11
    		rol     	r12
    		rol     	r13
    		rol     	r14
    		rol     	r15
    		adc     	r8, r1

			lsl		    r8
    		rol     	r9
    		rol     	r10
    		rol     	r11
    		rol     	r12
    		rol     	r13
    		rol     	r14
    		rol     	r15
    		adc     	r8, r1		
.endm

.macro rotate64_3bit_left_state

    		lsl		    r8
    		rol     	r9
    		rol     	r10
    		rol     	r11
    		rol     	r12
    		rol     	r13
    		rol     	r14
    		rol     	r15
    		adc     	r8, r1

			lsl		    r8
    		rol     	r9
    		rol     	r10
    		rol     	r11
    		rol     	r12
    		rol     	r13
    		rol     	r14
    		rol     	r15
    		adc     	r8, r1
			
			lsl		    r8
    		rol     	r9
    		rol     	r10
    		rol     	r11
    		rol     	r12
    		rol     	r13
    		rol     	r14
    		rol     	r15
    		adc     	r8, r1
	
.endm

.macro rotate64_2bit_left_state

			lsl		    r8
    		rol     	r9
    		rol     	r10
    		rol     	r11
    		rol     	r12
    		rol     	r13
    		rol     	r14
    		rol     	r15
    		adc     	r8, r1

			lsl		    r8
    		rol     	r9
    		rol     	r10
    		rol     	r11
    		rol     	r12
    		rol     	r13
    		rol     	r14
    		rol     	r15
    		adc     	r8, r1		
.endm

.macro rotate64_1bit_left_state

			lsl		    r8
    		rol     	r9
    		rol     	r10
    		rol     	r11
    		rol     	r12
    		rol     	r13
    		rol     	r14
    		rol     	r15
    		adc     	r8, r1
.endm
 

.macro rotate64_3bit_right_state

    		bst     	r8, 0
    		ror     	r15
    		ror     	r14
    		ror     	r13
    		ror     	r12
    		ror     	r11
    		ror     	r10
    		ror     	r9
    		ror     	r8
   	 		bld     	r15, 7


    		bst     	r8, 0
    		ror     	r15
    		ror     	r14
    		ror     	r13
    		ror     	r12
    		ror     	r11
    		ror     	r10
    		ror     	r9
    		ror     	r8
   	 		bld     	r15, 7


    		bst     	r8, 0
    		ror     	r15
    		ror     	r14
    		ror     	r13
    		ror     	r12
    		ror     	r11
    		ror     	r10
    		ror     	r9
    		ror     	r8
   	 		bld     	r15, 7

.endm

.macro rotate64_2bit_right_state

    		bst     	r8, 0
    		ror     	r15
    		ror     	r14
    		ror     	r13
    		ror     	r12
    		ror     	r11
    		ror     	r10
    		ror     	r9
    		ror     	r8
   	 		bld     	r15, 7


    		bst     	r8, 0
    		ror     	r15
    		ror     	r14
    		ror     	r13
    		ror     	r12
    		ror     	r11
    		ror     	r10
    		ror     	r9
    		ror     	r8
   	 		bld     	r15, 7

.endm

.macro rotate64_1bit_right_state

    		bst     	r8, 0
    		ror     	r15
    		ror     	r14
    		ror     	r13
    		ror     	r12
    		ror     	r11
    		ror     	r10
    		ror     	r9
    		ror     	r8
   	 		bld     	r15, 7

.endm



.macro rotate64_0byte_right_state
		
		add			r26,		r24 ;count			
		adc			r27,		r1

    	st      	X+,	r8
    	st      	X+,	r9
    	st      	X+,	r10
		st      	X+,	r11
		st      	X+,	r12
		st      	X+,	r13
		st      	X+,	r14
		st      	X+,	r15

		add			r24,		r7
		sub			r26,		r24
		sbc			r27,		r1

.endm


.macro rotate64_1byte_right_state
		
		add			r26,		r24 ;count			
		adc			r27,		r1

    	st      	X+,	r15
    	st      	X+,	r8
    	st      	X+,	r9
		st      	X+,	r10
		st      	X+,	r11
		st      	X+,	r12
		st      	X+,	r13
		st      	X+,	r14

		add			r24,		r7
		sub			r26,		r24
		sbc			r27,		r1

.endm


.macro rotate64_2byte_right_state
		
		add			r26,		r24 ;count			
		adc			r27,		r1

    	st      	X+,	r14
    	st      	X+,	r15
    	st      	X+,	r8
		st      	X+,	r9
		st      	X+,	r10
		st      	X+,	r11
		st      	X+,	r12
		st      	X+,	r13

		add			r24,		r7
		sub			r26,		r24
		sbc			r27,		r1

.endm


.macro rotate64_3byte_right_state
		
		add			r26,		r24 ;count			
		adc			r27,		r1

    	st      	X+,	r13
    	st      	X+,	r14
    	st      	X+,	r15
		st      	X+,	r8
		st      	X+,	r9
		st      	X+,	r10
		st      	X+,	r11
		st      	X+,	r12

		add			r24,		r7
		sub			r26,		r24
		sbc			r27,		r1

.endm

.macro rotate64_4byte_right_state
		
		add			r26,		r24 ;count			
		adc			r27,		r1

    	st      	X+,	r12
    	st      	X+,	r13
    	st      	X+,	r14
		st      	X+,	r15
		st      	X+,	r8
		st      	X+,	r9
		st      	X+,	r10
		st      	X+,	r11

		add			r24,		r7
		sub			r26,		r24
		sbc			r27,		r1

.endm

.macro rotate64_5byte_right_state
		
		add			r26,		r24 ;count			
		adc			r27,		r1

    	st      	X+,	r11
    	st      	X+,	r12
    	st      	X+,	r13
		st      	X+,	r14
		st      	X+,	r15
		st      	X+,	r8
		st      	X+,	r9
		st      	X+,	r10

		add			r24,		r7
		sub			r26,		r24
		sbc			r27,		r1

.endm

.macro rotate64_6byte_right_state
		
		add			r26,		r24 ;count			
		adc			r27,		r1

    	st      	X+,	r10
    	st      	X+,	r11
    	st      	X+,	r12
		st      	X+,	r13
		st      	X+,	r14
		st      	X+,	r15
		st      	X+,	r8
		st      	X+,	r9

		add			r24,		r7
		sub			r26,		r24
		sbc			r27,		r1

.endm

.macro rotate64_7byte_right_state
		
		add			r26,		r24 ;count			
		adc			r27,		r1

    	st      	X+,	r9
    	st      	X+,	r10
    	st      	X+,	r11
		st      	X+,	r12
		st      	X+,	r13
		st      	X+,	r14
		st      	X+,	r15
		st      	X+,	r8

		
		add			r24,		r7
		sub			r26,		r24
		sbc			r27,		r1

.endm

//--------------------------------------------------------------------------------------------------------------------------------------Temp rotate------------------------------------------
.macro rotate64_4bit_left_temp
		
    		lsl		    r16
    		rol     	r17
    		rol     	r18
    		rol     	r19
    		rol     	r20
    		rol     	r21
    		rol     	r22
    		rol     	r23
    		adc     	r16, r1

			lsl		    r16
    		rol     	r17
    		rol     	r18
    		rol     	r19
    		rol     	r20
    		rol     	r21
    		rol     	r22
    		rol     	r23
    		adc     	r16, r1
			
			lsl		    r16
    		rol     	r17
    		rol     	r18
    		rol     	r19
    		rol     	r20
    		rol     	r21
    		rol     	r22
    		rol     	r23
    		adc     	r16, r1

			lsl		    r16
    		rol     	r17
    		rol     	r18
    		rol     	r19
    		rol     	r20
    		rol     	r21
    		rol     	r22
    		rol     	r23
    		adc     	r16, r1
.endm

.macro rotate64_3bit_left_temp

    		lsl		    r16
    		rol     	r17
    		rol     	r18
    		rol     	r19
    		rol     	r20
    		rol     	r21
    		rol     	r22
    		rol     	r23
    		adc     	r16, r1

			lsl		    r16
    		rol     	r17
    		rol     	r18
    		rol     	r19
    		rol     	r20
    		rol     	r21
    		rol     	r22
    		rol     	r23
    		adc     	r16, r1
			
			lsl		    r16
    		rol     	r17
    		rol     	r18
    		rol     	r19
    		rol     	r20
    		rol     	r21
    		rol     	r22
    		rol     	r23
    		adc     	r16, r1
	
.endm

.macro rotate64_2bit_left_temp

			lsl		    r16
    		rol     	r17
    		rol     	r18
    		rol     	r19
    		rol     	r20
    		rol     	r21
    		rol     	r22
    		rol     	r23
    		adc     	r16, r1

			lsl		    r16
    		rol     	r17
    		rol     	r18
    		rol     	r19
    		rol     	r20
    		rol     	r21
    		rol     	r22
    		rol     	r23
    		adc     	r16, r1
.endm

.macro rotate64_1bit_left_temp

			lsl		    r16
    		rol     	r17
    		rol     	r18
    		rol     	r19
    		rol     	r20
    		rol     	r21
    		rol     	r22
    		rol     	r23
    		adc     	r16, r1
.endm
 

.macro rotate64_3bit_right_temp

    		bst     	r16, 0
    		ror     	r23
    		ror     	r22
    		ror     	r21
    		ror     	r20
    		ror     	r19
    		ror     	r18
    		ror     	r17
    		ror     	r16
   	 		bld     	r23, 7


    		bst     	r16, 0
    		ror     	r23
    		ror     	r22
    		ror     	r21
    		ror     	r20
    		ror     	r19
    		ror     	r18
    		ror     	r17
    		ror     	r16
   	 		bld     	r23, 7


    		bst     	r16, 0
    		ror     	r23
    		ror     	r22
    		ror     	r21
    		ror     	r20
    		ror     	r19
    		ror     	r18
    		ror     	r17
    		ror     	r16
   	 		bld     	r23, 7

.endm

.macro rotate64_2bit_right_temp

    		bst     	r16, 0
    		ror     	r23
    		ror     	r22
    		ror     	r21
    		ror     	r20
    		ror     	r19
    		ror     	r18
    		ror     	r17
    		ror     	r16
   	 		bld     	r23, 7


    		bst     	r16, 0
    		ror     	r23
    		ror     	r22
    		ror     	r21
    		ror     	r20
    		ror     	r19
    		ror     	r18
    		ror     	r17
    		ror     	r16
   	 		bld     	r23, 7

.endm

.macro rotate64_1bit_right_temp

    		bst     	r16, 0
    		ror     	r23
    		ror     	r22
    		ror     	r21
    		ror     	r20
    		ror     	r19
    		ror     	r18
    		ror     	r17
    		ror     	r16
   	 		bld     	r23, 7

.endm



.macro rotate64_0byte_right_temp

		add			r26,		r24 ;count			
		adc			r27,		r1
			
    	st      	X+,	r16
    	st      	X+,	r17
    	st      	X+,	r18
		st      	X+,	r19
		st      	X+,	r20
		st      	X+,	r21
		st      	X+,	r22
		st      	X+,	r23

		add			r24,		r7
		sub			r26,		r24
		sbc			r27,		r1
.endm


.macro rotate64_1byte_right_temp
		
		add			r26,		r24 ;count			
		adc			r27,		r1

    	st      	X+,	r23
    	st      	X+,	r16
    	st      	X+,	r17
		st      	X+,	r18
		st      	X+,	r19
		st      	X+,	r20
		st      	X+,	r21
		st      	X+,	r22

		add			r24,		r7
		sub			r26,		r24
		sbc			r27,		r1

.endm


.macro rotate64_2byte_right_temp

		add			r26,		r24 ;count			
		adc			r27,		r1

    	st      	X+,	r22
    	st      	X+,	r23
    	st      	X+,	r16
		st      	X+,	r17
		st      	X+,	r18
		st      	X+,	r19
		st      	X+,	r20
		st      	X+,	r21

		add			r24,		r7
		sub			r26,		r24
		sbc			r27,		r1

.endm


.macro rotate64_3byte_right_temp
		
		add			r26,		r24 ;count			
		adc			r27,		r1

    	st      	X+,	r21
    	st      	X+,	r22
    	st      	X+,	r23
		st      	X+,	r16
		st      	X+,	r17
		st      	X+,	r18
		st      	X+,	r19
		st      	X+,	r20

		add			r24,		r7
		sub			r26,		r24
		sbc			r27,		r1

.endm

.macro rotate64_4byte_right_temp
		
		add			r26,		r24 ;count			
		adc			r27,		r1

    	st      	X+,	r20
    	st      	X+,	r21
    	st      	X+,	r22
		st      	X+,	r23
		st      	X+,	r16
		st      	X+,	r17
		st      	X+,	r18
		st      	X+,	r19

		add			r24,		r7
		sub			r26,		r24
		sbc			r27,		r1

.endm

.macro rotate64_5byte_right_temp
		
		add			r26,		r24 ;count			
		adc			r27,		r1

    	st      	X+,	r19
    	st      	X+,	r20
    	st      	X+,	r21
		st      	X+,	r22
		st      	X+,	r23
		st      	X+,	r16
		st      	X+,	r17
		st      	X+,	r18

		add			r24,		r7
		sub			r26,		r24
		sbc			r27,		r1

.endm

.macro rotate64_6byte_right_temp
		
		add			r26,		r24 ;count			
		adc			r27,		r1

    	st      	X+,	r18
    	st      	X+,	r19
    	st      	X+,	r20
		st      	X+,	r21
		st      	X+,	r22
		st      	X+,	r23
		st      	X+,	r16
		st      	X+,	r17

		add			r24,		r7
		sub			r26,		r24
		sbc			r27,		r1

.endm

.macro rotate64_7byte_right_temp
		
		add			r26,		r24 ;count			
		adc			r27,		r1

    	st      	X+,	r17
    	st      	X+,	r18
    	st      	X+,	r19
		st      	X+,	r20
		st      	X+,	r21
		st      	X+,	r22
		st      	X+,	r23
		st      	X+,	r16

		add			r24,		r7
		sub			r26,		r24
		sbc			r27,		r1

.endm

			