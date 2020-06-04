
/*
 * avr_asm_macros.S
 *
 * Created: 2020-05-27 오후 3:57:26
 *  Author: 김영범
 */ 
 .nolist
#include <avr/io.h>
.list
/*******************************************************************************
*  MACRO SECTION                                                               *
*******************************************************************************/

.macro push_ p1:req, p2:vararg
	push \p1
.ifnb \p2
	push_ \p2
.endif
.endm

.macro pop_ p1:req, p2:vararg
	pop \p1
.ifnb \p2
	pop_ \p2
.endif
.endm

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

.macro stack_alloc size:req, reg1=r30, reg2=r31
	in r0, _SFR_IO_ADDR(SREG)
	in \reg1, _SFR_IO_ADDR(SPL)
	in \reg2, _SFR_IO_ADDR(SPH)
	sbiw \reg1, \size
	cli
	out _SFR_IO_ADDR(SPH), \reg2
	out _SFR_IO_ADDR(SREG), r0
	out _SFR_IO_ADDR(SPL), \reg1
.endm

.macro stack_free size:req, reg1=r30, reg2=r31
	in r0, _SFR_IO_ADDR(SREG)
	in \reg1, _SFR_IO_ADDR(SPL)
	in \reg2, _SFR_IO_ADDR(SPH)
	adiw \reg1, \size
	cli
	out _SFR_IO_ADDR(SPH), \reg2
	out _SFR_IO_ADDR(SREG), r0
	out _SFR_IO_ADDR(SPL), \reg1
.endm


.macro stack_alloc_large size:req, reg1=r30, reg2=r31
	in r0, _SFR_IO_ADDR(SREG)
	in \reg1, _SFR_IO_ADDR(SPL)
	in \reg2, _SFR_IO_ADDR(SPH)
	subi \reg1, lo8(\size)
	sbci \reg2, hi8(\size)
	cli
	out _SFR_IO_ADDR(SPH), \reg2
	out _SFR_IO_ADDR(SREG), r0
	out _SFR_IO_ADDR(SPL), \reg1
.endm

.macro stack_free_large size:req, reg1=r30, reg2=r31
	in r0, _SFR_IO_ADDR(SREG)
	in \reg1, _SFR_IO_ADDR(SPL)
	in \reg2, _SFR_IO_ADDR(SPH)
	adiw \reg1, 63
	adiw \reg1, (\size-63)
	cli
	out _SFR_IO_ADDR(SPH), \reg2
	out _SFR_IO_ADDR(SREG), r0
	out _SFR_IO_ADDR(SPL), \reg1
.endm

.macro stack_free_large2 size:req, reg1=r30, reg2=r31
	in r0, _SFR_IO_ADDR(SREG)
	in \reg1, _SFR_IO_ADDR(SPL)
	in \reg2, _SFR_IO_ADDR(SPH)
	adiw \reg1, 63
	adiw \reg1, 63
	adiw \reg1, (\size-63*2)
	cli
	out _SFR_IO_ADDR(SPH), \reg2
	out _SFR_IO_ADDR(SREG), r0
	out _SFR_IO_ADDR(SPL), \reg1
.endm

.macro stack_free_large3 size:req, reg1=r30, reg2=r31
	in r0, _SFR_IO_ADDR(SREG)
	in \reg1, _SFR_IO_ADDR(SPL)
	in \reg2, _SFR_IO_ADDR(SPH)
	push r16
	push r17
	ldi r16, lo8(\size)
	ldi r17, hi8(\size)
	add \reg1, r16
	adc \reg2, r17
	pop r17
	pop r16
	cli
	out _SFR_IO_ADDR(SPH), \reg2
	out _SFR_IO_ADDR(SREG), r0
	out _SFR_IO_ADDR(SPL), \reg1
.endm