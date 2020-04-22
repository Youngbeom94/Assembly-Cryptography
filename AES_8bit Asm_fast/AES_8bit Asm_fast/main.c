/*
 * AES_8bit Asm_fast.c
 *
 * Created: 2020-04-22 오후 5:21:35
 * Author : 김영범
 */ 

#include <avr/io.h>
#include "aes_types.h"

int main(void)
{
    /* Replace with your application code */
    while (1) 
    {
		u8 key[16] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
		u8 IV[16] = {0,};
		aes128_ctx_t aes_test;
		aes128_init(key, &aes_test);
		aes128_enc(IV,&aes_test);
    }
}





