
/*
 * test.s
 *
 * Created: 2020-07-13 오후 3:18:31
 *  Author: 김영범
 */

.balign 256
PHI_TABLE:

.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

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

#define load     0
#define zero     1
#define therz	 2
#define therz2	 3
#define	therx	 4
#define	therx2	 5
#define	count3	 6
#define	main_count	 7
#define rState0  8
#define rState1  9
#define rState2  10
#define rState3  11
#define rState4  12
#define rState5  13
#define rState6  14
#define rState7  15
#define rTemp0   16
#define rTemp1   17
#define rTemp2   18
#define rTemp3   19
#define rTemp4   20
#define rTemp5   21
#define rTemp6   22
#define rTemp7   23
#define count    24
#define	count2	 25
#define rX       26
#define rY       28
#define rZ       30

.global keccack
keccack:
		push_range 0, 31
		push r23
		push r22;  state --> stack

		movw 		rX,	r24 ; in   --> X
		movw 		rY,	r20 ; temp --> Y
		ldi			count,		24
		mov 		main_count,		 count

		ldi		r31,	hi8(RoundConstants_24)
		ldi		r30,	lo8(RoundConstants_24)
		push		r30
		push		r31

		movw		therz,	rZ
		eor		zero,	zero

start:
		ldi		count2,	5		;//main count:o : count:x, count2:o, count3:x
		movw		rZ,	therz
		movw		therx,	X

		ldi		count,	160		;//main count:o : count:160, count2:5, count3:32


Theta_init_Loop:

		load_from_temp_to_X	; state[x]

		theta_initial_help	; state[x+5]
		theta_initial_help	; state[x+10]
		theta_initial_help	; state[x+15]
		theta_initial_help	; state[x+20]

		store_from_Y_to_temp
		sub		rX,		count
		sbc		rX+1,	zero	;//main count:o : count:160, count2:5, count3:32
		dec		count2
		breq		END_Theta
		rjmp		Theta_init_Loop		

END_Theta:						;//main count:o : count:x, count2:x, count3:x			
		sbiw		rY,	 40
		sbc			rY+1,	zero
		movw		X,	 therx ; X inital 

Theta_update_1:					;//main count:o : count:o, count2:x, count3:x

			ld       	rTemp0, Y   ;0 저장
    		ldd      	rTemp1, Y+1
    		ldd      	rTemp2, Y+2
    		ldd      	rTemp3, Y+3
    		ldd      	rTemp4, Y+4
    		ldd     	rTemp5, Y+5
    		ldd      	rTemp6, Y+6
    		ldd      	rTemp7, Y+7

			ldd      	rState0, Y+16   ; 2저장
    		ldd      	rState1, Y+17
    		ldd      	rState2, Y+18
    		ldd      	rState3, Y+19
    		ldd      	rState4, Y+20
    		ldd      	rState5, Y+21
    		ldd     	rState6, Y+22
    		ldd      	rState7, Y+23

		initial_theta_rotate_state ;2 -rotate
		initial_theta_eor_form_temp_to_state;저장값 1 만들기
	
		ldi		count,	48
		add		rY,		count
		adc		rY+1,	zero
		store_from_Y_to_state	;-------------------------------------------------02 ->1
		sub		rY,	count
		sbc		rY+1,zero
		sbiw		Y,	8
		sbc		rY+1,zero


Theta_update_2:
							 ;rTemp <-- 0저장
		ldd      	rState0, Y+24   ; 3저장
		ldd      	rState1, Y+25
		ldd      	rState2, Y+26
		ldd      	rState3, Y+27
		ldd      	rState4, Y+28
		ldd      	rState5, Y+29
		ldd      	rState6, Y+30
		ldd      	rState7, Y+31

		initial_theta_rotate_temp ;0 -rotate
		initial_theta_eor_form_state_to_temp;저장값 4 만들기

	
		ldi		count,	72
		add		rY,	count
		adc		rY+1,	zero
		store_from_Y_to_temp	;-------------------------------------------------30 ->4
		sub		rY,	count
		sbc		rY+1,zero
		sbiw		Y,	8
		sbc		rY+1,zero

Theta_update_3:
						  ; rstate 3 저장
		ldd      	rTemp0, Y+8  ;1 저장
		ldd      	rTemp1, Y+9
		ldd      	rTemp2, Y+10
		ldd      	rTemp3, Y+11
		ldd      	rTemp4, Y+12
		ldd      	rTemp5, Y+13
		ldd      	rTemp6, Y+14
		ldd      	rTemp7, Y+15

		initial_theta_rotate_state ; 3-rotate
		initial_theta_eor_form_temp_to_state;저장값 2 만들기

		ldi		count,	56
		add		rY,	count
		adc		rY+1,	zero
		store_from_Y_to_state;-------------------------------------------------13 ->2
		sub		rY,		count
		sbc		rY+1,zero
		sbiw		Y,	8
		sbc		rY+1,zero

Theta_update_4:
						;rTemp <-- 1저장	 
		ldd      	rState0, Y+32   ; 4저장
    		ldd      	rState1, Y+33
    		ldd      	rState2, Y+34
    		ldd      	rState3, Y+35
    		ldd      	rState4, Y+36
    		ldd      	rState5, Y+37
    		ldd      	rState6, Y+38
    		ldd      	rState7, Y+39

		initial_theta_rotate_temp ;0 -rotate
		initial_theta_eor_form_state_to_temp;저장값 0 만들기

		ldi		count,	40
		add		rY,	count
		adc		rY+1,	zero
		store_from_Y_to_temp	;-------------------------------------------------31 ->0
		sub		rY,	count
		sbc		rY+1,zero
		sbiw		Y,	8
		sbc		rY+1,zero		;Y 저장값에 주소 fix


Theta_update_5:
						  ; rstate 4 저장
			ldd      	rTemp0, Y+16  ;2 저장
    		ldd      	rTemp1, Y+17
    		ldd      	rTemp2, Y+18
    		ldd      	rTemp3, Y+19
    		ldd      	rTemp4, Y+20
    		ldd      	rTemp5, Y+21
    		ldd      	rTemp6, Y+22
    		ldd      	rTemp7, Y+23

		initial_theta_rotate_state ; 4-rotate
		initial_theta_eor_form_temp_to_state;저장값 3 만들기
					
		ldi		count,	64
		add		rY,	count
		adc		rY+1,	zero
		store_from_Y_to_state;-------------------------------------------------24 ->3
		sbiw	Y,	32
		sbc		rY+1,zero	

		ldi		count,	8	;//main count:o : ld:count:x, ld:count2:x, count3:8
		mov		count3,	count
		

Thetha_Rho_loop:
		
		eor		count,		count
		eor		count2,		count2
		first_load_state; s[0]
		//no rotate
		ldi		count,		32 ; s[0] ->s[4]
		ldi		count2,		32 ; 4번째 Temp
		first_load_temp; s[4]
		ldi		count,		32 ; s[0] ->s[4]
		rotate64_1byte_right_state ; s[0] ->s[4] clear

		rotate64_1bit_right_temp
		ldi		count,		72; s[4]->s[9]
		ldi		count2,		32;
		first_load_state;	s[9]
		ldi		count,		72; s[4]->s[9]
		rotate64_3byte_right_temp ; s[4] ->s[9] clear

		rotate64_3bit_right_state 
		ldi		count,		24; s[9]->s[3]
		ldi		count2,		24;
		first_load_temp;	s[3]
		ldi		count,		24; s[9]->s[3]
		rotate64_5byte_right_state ; s[9] ->s[3] clear

		rotate64_2bit_left_temp
		ldi		count,		192; s[3]->s[24]
		ldi		count2,		32;
		first_load_state;	s[24]
		ldi		count,		192; s[3]->s[24]
		rotate64_0byte_right_temp ; s[3] ->s[24] clear

		rotate64_2bit_right_state 
		ldi		count,		160; s[24]->s[20]
		eor		count2,		count2;
		first_load_temp;	s[20]
		ldi		count,		160; s[24]->s[20]
		rotate64_1byte_right_state ; s[24] ->s[20] clear

		rotate64_1bit_left_temp
		ldi		count,		80; s[20]->s[10]
		eor		count2,		count2;
		first_load_state;	s[10]
		ldi		count,		80; s[20]->s[10]
		rotate64_2byte_right_temp ; s[20] ->s[10] clear

		rotate64_3bit_left_state 
		ldi		count,		56; s[10]->s[7]
		ldi		count2,		16;
		first_load_temp;	s[7]
		ldi		count,		56; s[10]->s[7]
		rotate64_3byte_right_state ; s[10] ->s[7] clear

		rotate64_4bit_left_temp
		ldi		count,		184; s[7]->s[23]
		ldi		count2,		24;
		first_load_state;	s[23]
		ldi		count,		184; s[7]->s[23]
		rotate64_4byte_right_temp ; s[7] ->s[23] clear

		rotate64_4bit_left_state 
		ldi		count,		40; s[23]->s[5]
		eor		count2,		count2;
		first_load_temp;	s[5]
		ldi		count,		40; s[23]->s[5]
		rotate64_4byte_right_state ; s[23] ->s[5] clear

		rotate64_3bit_left_temp
		ldi		count,		144; s[5]->s[18]
		ldi		count2,		24;
		first_load_state;	s[5]
		ldi		count,		144; s[5]->s[18]
		rotate64_6byte_right_temp ; s[5] ->s[18] clear

		rotate64_1bit_left_state 
		ldi		count,		128; s[18]->s[16]
		ldi		count2,		8;
		first_load_temp;	s[16]
		ldi		count,		128; s[18]->s[16]
		rotate64_7byte_right_state ; s[18] ->s[16] clear

		
		rotate64_2bit_right_temp
		ldi		count,		88; s[16]->s[11]
		ldi		count2,		8;
		first_load_state;	s[11]
		ldi		count,		88; s[16]->s[11]
		rotate64_0byte_right_temp ; s[16] ->s[11] clear

		rotate64_2bit_left_state 
		ldi		count,		176; s[11]->s[22]
		ldi		count2,		16;
		first_load_temp;	s[22]
		ldi		count,		176; s[11]->s[22]
		rotate64_2byte_right_state ; s[11] ->s[22] clear

		rotate64_3bit_right_temp 
		ldi		count,		120; s[22]->s[15]
		eor		count2,		count2;
		first_load_state;	s[15]
		ldi		count,		120; s[22]->s[15]
		rotate64_3byte_right_temp ; s[22] ->s[15] clear

		rotate64_1bit_right_state 
		ldi		count,		168; s[15]->s[21]
		ldi		count2,		8;
		first_load_temp;	s[21]
		ldi		count,		168; s[15]->s[21]
		rotate64_5byte_right_state ; s[15] ->s[21] clear

		rotate64_1bit_right_temp   ;  s[21] -> s[0] ;-> s[0] is already Empty
		rotate64_3byte_right_temp  ;  s[21] -> s[0] clear////////-new start---------------------------------------


		ldi		count,		8
		ldi		count2,		8
		first_load_state; s[1]

		rotate64_2bit_right_state
		ldi		count,		152; s[1] ->s[19]
		ldi		count2,		32 ;
		first_load_temp; 
		ldi		count,		152 ; s[1] ->s[19]
		rotate64_2byte_right_state ; s[1] ->s[19] clear

		rotate64_1bit_left_temp 
		ldi		count,		18; s[19]->s[6]
		ldi		count2,		8 ;
		first_load_state;	s[6]
		ldi		count,		8; s[19]->s[6]
		rotate64_5byte_right_temp ; s[19] ->s[6] clear

		rotate64_3bit_left_state
		ldi		count,		64; s[6] ->s[8]
		ldi		count2,		24 ;
		first_load_temp; s[8]
		ldi		count,		64 ; s[6] ->s[8]
		rotate64_0byte_right_state ; s[6] ->s[8] clear

		rotate64_4bit_left_temp 
		ldi		count,		104; s[8]->s[13]
		ldi		count2,		24 ;
		first_load_state;	s[13]
		ldi		count,		104; s[8]->s[13]
		rotate64_3byte_right_temp ; s[8] ->s[13] clear

		rotate64_4bit_left_state
		ldi		count,		16; s[13] ->s[2]
		ldi		count2,		16 ;
		first_load_temp; s[2]
		ldi		count,		16 ; s[13] ->s[2]
		rotate64_6byte_right_state ; s[13] ->s[2] clear

		rotate64_1bit_right_temp 
		ldi		count,		112   ; s[2]->s[14]
		ldi		count2,		32  ;
		first_load_state;	s[14]
		ldi		count,		112   ; s[2]->s[14]
		rotate64_0byte_right_temp ; s[2] ->s[14] clear

		rcall last_Rho_Process



		//--------Chi setting
		movw		rX,		therx
		movw		therx,	rY
		movw		rY,		rX
		movw		rX,		therx


		ldi		count2,	5

Chi_Lota_Setting:
	
		ldi		count,	8	

Chi_Lota:

		ld      	rTemp0, Y
		ldd     	rTemp1, Y+8
		ldd     	rTemp2, Y+16
		ldd     	rTemp3, Y+24
		ldd     	rTemp4, Y+32
	
;*p = t = a0 ^ ((~a1) & a2); c0 ^= t;

		mov     	load, rTemp1
    		com     	load
    		and     	load, rTemp2
   		eor    		load, rTemp0
    		eor     	rTemp0, load
    		st      	Y, load

;*(p+8) = t = a1 ^ ((~a2) & a3); c1 ^= t;

		 mov     	load, rTemp2
		 com     	load
		 and     	load, rTemp3
		 eor     	load, rTemp1
		 eor     	rTemp1, load
		 std     	Y+8, r0

;*(p+16) = a2 ^= ((~a3) & a4); c2 ^= a2;

    		mov     	load, rTemp3
    		com     	load
    		and     	load, rTemp4
    		eor     	load, rTemp2
    		eor     	rTemp2, load
    		std     	Y+16, load

;*(p+24) = a3 ^= ((~a4) & a0); c3 ^= a3;

    		mov     	load, rTemp4
    		com     	load
    		and     	load, rTemp0
    		eor     	load, rTemp3
    		eor     	rTemp3, load
    		std     	Y+24, load

;*(p+32) = a4 ^= ((~a0) & a1); c4 ^= a4;

    		com     	rTemp0
    		and     	rTemp0, rTemp1
    		eor     	rTemp0, rTemp4
    		eor     	rTemp4, rTemp0
    		std     	Y+32, rTemp0

Chi_Condition:

		adiw   		rY, 8
		adc		rY+1,	zero
    		dec     	count
    		brne    	Chi_Lota

		adiw		rY,32
		adc		rY+1,	zero
		dec		count2
		brne		Chi_Lota_Setting

		movw		rX,	rY
		movw		rY,	therx

		movw		therx,	rZ

Lota:

		pop		r31
		pop		r30

		ldi		count,	96
		adiw		rY,	count
		adc		rY,	zero

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

		initial_theta_eor_form_temp_to_state

		st		Y,			rState0
		std		Y+1,		rState1
		std		Y+2,		rState2
		std		Y+3,		rState3
		std		Y+4,		rState4
		std		Y+5,		rState5
		std		Y+6,		rState6
		std		Y+7,		rState7

		sbiw		rY,		count
		sbc		rY+1,		zero
		push		r30
		push		r31

		movw		rZ,		therx
		movw		therx,		rX
	
END_Condtion:
		dec		main_count
		breq 		Keccack_END
		rjmp 		start

Keccack_END:
		pop		r31
		pop		r30
		pop 		r22
		pop 		r23
		pop_range 0, 31
		
		ret


last_Rho_Process:

		rotate64_1bit_right_state
		ldi		count,		136; s[14] ->s[17]
		ldi		count2,		16 ;
		first_load_temp; s[17]
		ldi		count,		136 ; s[14] ->s[17]
		rotate64_0byte_right_state ; s[14] ->s[17] clear

		rotate64_2bit_left_temp
		ldi		count,	8;	s[17]->S[1]
		rotate64_0byte_right_temp; s[17]->S[1] clear


		ldi		count,	96; S[12]
		first_load_temp
		ldi		count,	96; S[12]
		rotate64_0byte_right_temp ; S[12] clear
		
		ret