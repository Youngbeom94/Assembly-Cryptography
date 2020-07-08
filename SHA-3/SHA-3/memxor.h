/*
 * memxor.h
 *
 * Created: 2020-07-08 오후 3:01:23
 *  Author: 김영범
 */ 


#ifndef MEMXOR_H_
#define MEMXOR_H_
#include <stdint.h>

void memxor(void* dest, const void* src, uint16_t n);

#endif