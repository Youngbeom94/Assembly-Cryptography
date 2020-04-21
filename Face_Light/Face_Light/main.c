/*
 * Face_Light.c
 *
 * Created: 2020-04-21 오후 6:08:25
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


int main(void)
{
    /* Replace with your application code */
    while (1) 
    {
		u8 key[16] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
		u8 IV[16] = {0,};
		u8 buffer[16] = {0,};

		aes128_ctx_t aes_test;
		aes128_init(key, &aes_test);
		aes128_enc(IV,&aes_test);
    }
}



