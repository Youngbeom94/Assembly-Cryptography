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


#define KEY_BIT 128
#define BLOCK_BIT 128
#define LEN_SEED (KEY_BIT + BLOCK_BIT)/BLOCK_BIT
#define BLOCK_SIZE 16
#define SEED_LEN (KEY_BIT + BLOCK_BIT)/8
#define N_DF (KEY_BIT + BLOCK_BIT)/8
#define TRUE  1
#define FALSE  0

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
typedef struct _IN_state {
	u8 key[SEED_LEN - BLOCK_SIZE];
	u8 V[BLOCK_SIZE];
	u8 Reseed_counter;
	u8 prediction_flag;
} st_state;

typedef struct LEN {
	u8 add_data;
	u8 re_adddata;
	u8 re_Entrophy;
	u8 seed;
	u8 general_len;
	u8 input_len;
} st_len;

void XoR(u8* drc, u8* src, int len);
void set_state(u8* drc, u8* src , int start);
void copy_state(u8 drc[LEN_SEED][BLOCK_SIZE], u8 * src, int len);
void copy(u8 *drc, u8 * src);
void clear(u8 *src, int len);

void derived_function(u8 *input_data,u8* seed, u8 *input_len);
void update(st_state* state,u8* seed);
void generate_Random(st_state *state, u8 *random, u8 *add_data, u8 *re_Entrophy, u8 *re_add_data,st_len* LEN);
void Reseed_Function(st_state* state,u8 *re_Entrophy,u8 *re_add_data,st_len* LEN);
void CTR_DRBG(st_state* in_state, st_len* len,u8* in, u8* seed,u8* random,u8* re_add_data,u8 *re_Entrophy,u8 *add_data);

//! AES

void aes128_init(const void *key, aes128_ctx_t *ctx);
void aes128_enc_CBC_asm(void *buffer, aes128_ctx_t *ctx);
void aes128_enc_CTR_asm(void *buffer, aes128_ctx_t *ctx,u8* temp);
//
void aes192_init(const void *key, aes192_ctx_t *ctx);
void aes192_enc_CBC_asm(void *buffer, aes128_ctx_t *ctx);
void aes192_enc_CTR_asm(void *buffer, aes128_ctx_t *ctx,u8* temp);
//
void aes256_init(const void *key, aes128_ctx_t *ctx);
void aes256_enc_CBC_asm(void *buffer, aes128_ctx_t *ctx);
void aes256_enc_CTR_asm(void *buffer, aes128_ctx_t *ctx,u8* temp);
//






#endif