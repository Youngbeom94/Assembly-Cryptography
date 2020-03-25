/*
 * AES_header.h
 *
 * Created: 2020-03-25 오전 11:22:13
 *  Author: 김영범
 */ 

#ifndef AES_HEADER_H_
#define AES_HEADER_H_
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define _CRT_SECURE_NO_WARNINGS
#define xtime(x) ((x << 1) ^ (((x >> 7) & 1) * 0x1b))
#define Nb 4
#define Nk 4 //Number of 32-bit words comprising the Cipher Key

#if Nk == 4
#define AES_MAXNR 10 //10 round
#define AES_KEY_BIT 128 // 128 bit
#elif Nk == 6
#define AES_MAXNR 12 // 12 round
#define AES_KEY_BIT 192 // 192 bit
#else Nk == 8
#define AES_MAXNR 14 // 14 round
#define AES_KEY_BIT 256 // 256bit
#endif

typedef uint8_t u8;
typedef int8_t  s8;
typedef uint32_t k8;

typedef struct aes_key_st
{
	k8 rd_key[4 * (AES_MAXNR + 1)];
	k8 rounds;
} AES_KEY;

void SubByte(u8 *state);
void ShiftRow(u8 *state);
void ShiftRow_asm(u8 *state);
void MixColumns(u8 *state);
void MixColumns_asm(u8 *state);




#endif /* AES_HEADER_H_ */