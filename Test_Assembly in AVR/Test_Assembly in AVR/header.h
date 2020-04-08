/*
 * header.h
 *
 * Created: 2020-04-07 오후 5:59:11
 *  Author: 김영범
 */

#ifndef AES_HEADER_H_
#define AES_HEADER_H_
#define ALIGN_ZH __attribute__ ((aligned (256)))

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <avr/pgmspace.h>
#include <avr/io.h>
#include <avr/eeprom.h>

#define _CRT_SECURE_NO_WARNINGS
#define xtime(x) ((x << 1) ^ (((x >> 7) & 1) * 0x1b))
#define Nb 4
#define Nk 4 //Number of 32-bit words comprising the Cipher Key
#define AES_MAXNR 10 //10 round
#define AES_KEY_BIT 128 // 128 bit
#define BLOCKSIZE 5

typedef uint8_t u8;
typedef int8_t  s8;
typedef uint32_t k8;

void SubByte(u8 *state);
void ShiftRow(u8 *state);
void MixColumns(u8 *state);
void AddRoundKey(u8 *state, u8* rdkey);
void AES_encrypt(u8* inp, u8* out, u8* usrkey);
void keyScheduling(u8* roundkey,u8 *round);


void Subbyte_ShiftRows_asm(u8 *state);
void AddRoundKey_asm(u8* state, u8* rdkey);
void MixColumns_asm(u8 *state);
void MixColumns_asm_Progm(u8 *state);
void AES_encrypt_asm(u8* inp, u8* out, u8* usrkey);
void AES_encrypt_asm_Progm(u8* inp, u8* out, u8* usrkey);


// AES-CTR(FACE_LIGHT)
void reset_count(u8* count);
void state_copy(u8* dst, u8* src);
void Count_Add_for_LUT(u8* count, u8* cnt_k);
void Count_Add_for_FACE_LIGHT(u8* count);
void Make_LUT_Face_Light(u8 LUT_FL[4][4][256],u8* userkey, u8* count);//! LUK Table of FACE_Light
void AES_encrypt_FACE_Light(u8 *inp,u8 LUT_FL[4][4][256], u8 *out, u8 *userkey);//AES encryption of FACE mode
void CRYPTO_ctr128_encrypt_FACE_Light(u8* inp, u8* out, u8 LUT_FL[4][4][256], u8 len, u8* usrkey, u8* count); //AES CTR Mode of FACE_Light

// AES-CTR (Origin)
void Count_Addition(u8 *count); //Count 배열에서 값을 1증가시키는 함수
void CRYPTO_ctr128_encrypt(u8* inp, u8* out, u8 len, u8* usrkey, u8* count); //AES CTR Mode of origin


#endif /* AES_HEADER_H_ */