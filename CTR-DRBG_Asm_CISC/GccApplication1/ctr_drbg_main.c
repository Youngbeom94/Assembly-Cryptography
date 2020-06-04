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
	st_state INSTATE = {0x00};
	st_state *in_state = &INSTATE;
	st_len st_LEN = {0x00};
	st_len *len = &st_LEN;

	u8 in[45] = {0x00};
	u8 seed[SEED_LEN] = {0x00};
	u8 *re_add_data = NULL;
	u8 *add_data = NULL;
	u8 random[16] = {0x00};
	u8 re_Entrophy[16] = {0x00};

	in_state->prediction_flag = FALSE;
	len->add_data_len = 0;
	len->general_len = 16;
	len->re_adddata = 16;
	len->re_Entrophy = 16;
	len->input_len = 45;

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

