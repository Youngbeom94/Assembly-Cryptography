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
#define AES_MAXNR 10 //10 round
#define AES_KEY_BIT 128 // 128 bit

typedef uint8_t u8;
typedef int8_t  s8;
typedef uint32_t k8;

typedef struct aes_key_st
{
	k8 rd_key[4 * (AES_MAXNR + 1)];
	k8 rounds;
} AES_KEY;

void SubByte(u8 *state,u8 *sbox);
void ShiftRow(u8 *state);
void MixColumns(u8 *state);
void RotWord(uint32_t *Word); // int 기준으로 값을 받고 1byte left Rotation
void SubWord(uint32_t *Word,u8* sbox); // int 기준으로 값을 받고 int를 4개의 byte로 쪼개서 byte를 sbox의 값으로 치환

void AddRoundKey(u8 *state, u8* rdkey);
void AES_set_encrypt_key(u8 *inp, uint8_t bits, u8* usrkey,u8* Rcon,u8* sbox); //키생성 함수
void keyScheduling(u8* roundkey,u8* Rcon, u8* sbox,u8 round);


void ShiftRow_asm(u8 *state);
void MixColumns_asm(u8 *state);









#endif /* AES_HEADER_H_ */