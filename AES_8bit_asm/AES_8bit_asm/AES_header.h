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

void SubByte(u8 *state,u8 *sbox);
void ShiftRow(u8 *state);
void MixColumns(u8 *state);
void AddRoundKey(u8 *state, u8* rdkey);
void AES_encrypt(u8* inp, u8* out, u8* usrkey,u8* sbox, u8* rcon);
void keyScheduling(u8* roundkey,u8* Rcon, u8* sbox,u8 *round);

void ShiftRow_asm(u8 *state);
void MixColumns_asm(u8 *state);
void AES_encrypt_asm(u8* inp, u8* out, u8* usrkey,u8* sbox, u8* rcon);

#endif /* AES_HEADER_H_ */