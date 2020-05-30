/*
* ctr_drbg.h
*
* Created: 2020-05-27 오후 3:44:43
*  암호최적화 연구실
*  Author: 김영범
*/
#ifndef __PLUS__
#define __PLUS__

//! header file
#include <stdio.h>
#include <time.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>


#define KEY_BIT 192
#define BLOCK_BIT 128
#define BLOCK_SIZE 16
#define SEED_LEN (KEY_BIT + BLOCK_BIT)/8
#define N_DF (KEY_BIT + BLOCK_BIT)/8
#define INSIZE 16
#define TRUE  1
#define FALSE  0
#if KEY_BIT	== 128
	#define LEN_SEED 2
# elif KEY_BIT == 192
	#define LEN_SEED 3
# else
	#define LEN_SEED 3
#endif

typedef struct{
	uint8_t ks[16];
} aes_roundkey_t;
typedef struct{
	aes_roundkey_t key[10+1];
} aes128_ctx_t;
typedef struct{
	aes_roundkey_t key[12+1];
} aes192_ctx_t;
typedef struct{
	aes_roundkey_t key[14+1];
} aes256_ctx_t;
typedef struct{
	aes_roundkey_t key[1]; /* just to avoid the warning */
} aes_genctx_t;


typedef unsigned char u8;
typedef int8_t  s8;
typedef uint32_t k8;
typedef struct _IN_state {
	u8 key[SEED_LEN - BLOCK_SIZE];
	u8 V[BLOCK_SIZE];
	u8 Reseed_counter;
	u8 prediction_flag;
} st_state;

typedef struct LEN {
	u8 add_data_len;
	u8 re_adddata;
	u8 re_Entrophy;
	u8 seed;
	u8 general_len;
	u8 input_len;
} st_len;

void XoR(u8* drc, u8* src, char len);
void set_state(u8* drc, u8* src , char start);
void copy_state(u8 drc[LEN_SEED][BLOCK_SIZE], u8 * src, char len);
void copy(u8 *drc, u8 * src);
void clear(u8 *src, char len);

void derived_function(u8 *input_data,u8* seed, u8 *input_len);
void update(st_state* state,u8* seed);
void generate_Random(st_state *state, u8 *random, u8 *add_data, u8 *re_Entrophy, u8 *re_add_data,st_len* LEN);
void Reseed_Function(st_state* state,u8 *re_Entrophy,u8 *re_add_data,st_len* LEN);
void CTR_DRBG(st_state* in_state, st_len* len,u8* in, u8* seed,u8* random,u8* re_add_data,u8 *re_Entrophy,u8 *add_data);

//! AES
#if KEY_BIT	== 128
void aes128_init(const void *key, aes128_ctx_t *ctx);
void aes128_enc_CBC_asm(void *buffer, aes128_ctx_t *ctx);
void aes128_enc_CTR_asm(void *buffer, aes128_ctx_t *ctx,u8* temp);

# elif KEY_BIT == 192
void aes192_init(const void *key, aes192_ctx_t *ctx);
void aes192_enc_CBC_asm(void *buffer, aes192_ctx_t *ctx);
void aes192_enc_CTR_asm(void *buffer, aes192_ctx_t *ctx,u8* temp);
# else
void aes256_init(const void *key, aes256_ctx_t *ctx);
void aes256_enc_CBC_asm(void *buffer, aes256_ctx_t *ctx);
void aes256_enc_CTR_asm(void *buffer, aes256_ctx_t *ctx,u8* temp);
#endif



//test

#define ALIGN_ZH __attribute__ ((aligned (256)))
#define _CRT_SECURE_NO_WARNINGS
#define xtime(x) ((x << 1) ^ (((x >> 7) & 1) * 0x1b))
#define Nb 4
#define Nk 4 //Number of 32-bit words comprising the Cipher Key
#if KEY_BIT == 128
#define AES_MAXNR 10 //10 round
#define AES_KEY_BIT 128 // 128 bit
#elif KEY_BIT ==192 
#define AES_MAXNR 12 //10 round
#define AES_KEY_BIT 192 // 128 bit
#else
#define AES_MAXNR 14 //10 round
#define AES_KEY_BIT 256 // 128 bit
#endif
#define BLOCKSIZE 1

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
#endif