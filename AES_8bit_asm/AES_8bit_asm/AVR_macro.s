
/*
 * AVR_macro.s
 *
 * Created: 2020-04-08 오전 11:24:14
 *  Author: 김영범
 */ 
#ifndef AVR_macro
#define AVR_Amacro
.nolist
#include <avr/io.h>

.list
/*******************************************************************************
*  MACRO SECTION                                                               *
*******************************************************************************/
 .macro regBackupAdd
	.irp i,0,3,4,5,6,7,8,16,17,28,29,30,31,
		push	\i
	.endr
 .endm

 .macro regRetriveveAdd
	.irp i,31,30,29,28,17,16,8,7,6,5,4,3,0
		pop	\i
	.endr
 .endm

  .macro regBackupAdd2
	.irp i,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,28,29,30,31,
		push	\i
	.endr
 .endm

 .macro regRetriveveAdd2
	.irp i,31,30,29,28,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0
		pop	\i
	.endr
 .endm


 
 #endif