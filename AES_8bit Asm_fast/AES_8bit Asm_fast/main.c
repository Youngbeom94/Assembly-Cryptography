/*
* AES_8bit Asm_fast.c
*
* Created: 2020-04-22 오후 5:21:35
* Author : 김영범
*/

#include <avr/io.h>
#include "aes_types.h"

void aes128_init(const void *key, aes128_ctx_t *ctx);
void aes128_enc(void *buffer, aes128_ctx_t *ctx);
void aes192_init(const void *key, aes192_ctx_t *ctx);
void aes192_enc(void *buffer, aes192_ctx_t *ctx);
void aes256_init(const void *key, aes128_ctx_t *ctx);
void aes256_enc(void *buffer, aes128_ctx_t *ctx);


void aes128_enc_origin(void *buffer, aes128_ctx_t *ctx);
void aes192_enc_origin(void *buffer, aes192_ctx_t *ctx);
void aes256_enc_origin(void *buffer, aes128_ctx_t *ctx);

int main(void)
{
	/* Replace with your application code */

	u8 key[16] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
	u8 IV[16] = {0,};
	//u8 key[16] = {0x2b,0x7e,0x15,0x16,0x28,0xae,0xd2,0xa6,0xab,0xf7,0x15,0x88,0x09,0xcf,0x4f,0x3c};
	//u8 IV[16] = {0x32,0x43,0xf6,0xa8,0x88,0x5a,0x30,0x8d,0x31,0x31,0x98,0xa2,0xe0,0x37,0x07,0x34};
	aes128_ctx_t aes_test;
	aes128_init(key, &aes_test);
	aes128_enc(IV,&aes_test);
	//aes128_enc_origin(IV,&aes_test);

	
}





