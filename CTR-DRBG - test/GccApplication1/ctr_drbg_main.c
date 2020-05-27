/*
 * ctr_drbg_mainc.c
 *
 * Created: 2020-05-27 오후 3:45:07
 *  Author: 김영범
 */ 
#include "ctr_drbg.h"

int main(void)
{
	
	/* Replace with your application code */
	volatile st_state INSTATE = {0x00};
	volatile st_state *in_state = &INSTATE;
	st_len st_LEN = {0x00};
	st_len *len = &st_LEN;

	u8 in[24] = {0x3D, 0xA9, 0x3E, 0xDD, 0x17, 0x94, 0x4F, 0x79, 0x1E, 0x33, 0x99, 0x67, 0x2C, 0xC6, 0xEA, 0x93, 0x8A, 0x3F, 0xFF, 0x14, 0x09, 0x02, 0x3D, 0x0C};
	u8 seed[SEED_LEN] = {0x00};
	u8 *re_add_data = NULL;
	u8 *add_data = NULL;
	u8 random[16] = {0x00};
	u8 re_Entrophy[16] = {0x4E, 0xE9, 0xA2, 0xCF, 0x6E, 0x8B, 0xFA, 0x48, 0xBB, 0xBE, 0x56, 0x99, 0xDD, 0x5A, 0xBA, 0x02};

	in_state->prediction_flag = FALSE;
	len->add_data = 16;
	len->general_len = 16;
	len->re_adddata = 16;
	len->re_Entrophy = 16;
	len->seed = 32;
	len->input_len = 24;

	#if KEY_BIT == 128
aes128_ctx_t aes_test;
	#elif KEY_BIT == 192
aes192_ctx_t aes_test;
	#else //KEY_BIT ==256
aes256_ctx_t aes_test;
	#endif

	CTR_DRBG(in_state, len, in, seed, random, re_add_data, re_Entrophy, add_data);

	return 0;
}

