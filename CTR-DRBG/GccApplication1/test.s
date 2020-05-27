
/*
 * test.s
 *
 * Created: 2020-05-27 오후 4:43:00
 *  Author: 김영범
 */ 

 
#include "avr-asm-macros.S"
#include "ctr_drbg.h"
/*
 * param a: r24
 * param b: r22
 * param reducer: r0
 */

.global test
 test:


 ret