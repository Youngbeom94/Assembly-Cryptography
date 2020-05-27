/*
* ctr_drbg_func.c
*
* Created: 2020-05-27 오후 3:44:57
*  Author: 김영범
*/
#include "ctr_drbg.h"

void XoR(u8 *drc, u8 *src, int len)
{
	for (int cnt_i = 0; cnt_i < len; cnt_i++)
	{
		drc[cnt_i] ^= src[cnt_i];
	}
}
void set_state(u8 *drc, u8 *src, int start)
{
	for (int cnt_i = 0; cnt_i < BLOCK_SIZE; cnt_i++)
	{
		drc[cnt_i] = src[start + cnt_i];
	}
}
void copy_state(u8 drc[LEN_SEED][BLOCK_SIZE], u8 *src, int len)
{
	for (int cnt_i = 0; cnt_i < BLOCK_SIZE; cnt_i++)
	{
		drc[len][cnt_i] = src[cnt_i];
	}
}
void copy(u8 *drc, u8 *src)
{
	for (int cnt_i = 0; cnt_i < BLOCK_SIZE; cnt_i++)
	{
		drc[cnt_i] = src[cnt_i];
	}
}
void clear(u8 *src, int len)
{
	for (int cnt_i = 0; cnt_i < len; cnt_i++)
	{
		src[cnt_i] = 0x00;
	}
}
void derived_function(u8 *input_data, u8 *seed, u8 *input_len)
{
	volatile char cnt_i, cnt_j, cnt_k = 0;
	u8 len = 25 + *input_len;
	u8 temp = len % BLOCK_SIZE;
	u8 CBC_KEY[16] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f};
	u8 chain_value[16] = {0x00};
	u8 seed_temp[SEED_LEN] = {0x00};
	u8 KEYandV[LEN_SEED][BLOCK_SIZE] = {0x00};
#if KEY_BIT == 128
	aes128_ctx_t aes_test;
	aes128_init(CBC_KEY, &aes_test);
#elif KEY_BIT == 192
	aes192_ctx_t aes_test;
	aes192_init(CBC_KEY, &aes_test);

#else //KEY_BIT ==256
	aes256_ctx_t aes_test;
	aes256_init(CBC_KEY, &aes_test);
#endif

	if (temp != 0)
	len += BLOCK_SIZE - temp;

	u8 *in = (u8 *)calloc(len, sizeof(u8));
	in[19] = *input_len;
	in[23] = N_DF;
	for (cnt_i = 24; cnt_i < 24 + *input_len; cnt_i++)
		{in[cnt_i] = input_data[cnt_i - 24];}
	in[cnt_i] = 0x80;

	u8 state[16] = {0x00};
	for (cnt_j = 0; cnt_j < LEN_SEED; cnt_j++)
	{
		for (cnt_i = 0; cnt_i < len / 16; cnt_i++)
		{
			set_state(state, in, 16 * cnt_i);
			XoR(state, chain_value, BLOCK_SIZE);
#if KEY_BIT == 128
			aes128_enc_CBC_asm(state, &aes_test);
#elif KEY_BIT == 192
			aes192_enc_CBC_asm(state, &aes_test);
#else //KEY_BIT ==256
			aes256_enc_CBC_asm(state, &aes_test);
#endif
			copy(chain_value, state);
		}
		copy_state(KEYandV, chain_value, cnt_j);
		clear(chain_value, BLOCK_SIZE);
		in[3]++;
	}

	//! step2
	u8 key[16] = {0x00};
	for (cnt_i = 0; cnt_i < KEY_BIT/8 ; cnt_i++)
	{
		key[cnt_i] = *(KEYandV+cnt_i);
	}
	for (cnt_j = cnt_i; cnt_j < BLOCK_SIZE; cnt_j++)
	{
		state[cnt_j] = *(KEYandV+cnt_i+cnt_j);
	}		
	
#if KEY_BIT == 128
	aes128_init(key, &aes_test);
#elif KEY_BIT == 192
	aes192_init(key, &aes_test);
#else //KEY_BIT ==256
	aes256_init(key, &aes_test);
#endif
	for (cnt_i = 0; cnt_i < LEN_SEED; cnt_i++)
	{
#if KEY_BIT == 128
		aes128_enc_CBC_asm(state, &aes_test);
#elif KEY_BIT == 192
		aes192_enc_CBC_asm(state, &aes_test);
#else //KEY_BIT ==256
		aes256_enc_CBC_asm(state, &aes_test);
#endif
		for (cnt_j = 0; cnt_j < BLOCK_SIZE; cnt_j++)
		{
			seed[cnt_i * 16 + cnt_j] = state[cnt_j];
			if((KEY_BIT == 192) && (cnt_i == 2) && (cnt_j == 7))
				break;
		}
	}
	free(in);
}

void update(st_state *state, u8 *seed)
{
	volatile char cnt_i, cnt_j, cnt_k = 0;
	u8 key[KEY_BIT /8] = {0x00};
	u8 temp[SEED_LEN] = {0x00};
	u8 temp2[12] = {0x00};
		
	for(cnt_i = 0 ; cnt_i < KEY_BIT /8 ; cnt_i ++)
	{
		key[cnt_i] = state->key[cnt_i];
	}
	copy(temp,state->V);
	for (cnt_i = 0; cnt_i < BLOCK_SIZE; cnt_i++)
	{
		temp[cnt_i] =  state->V[cnt_i];
	}

#if key_bit == 128
	aes128_ctx_t aes_test;
	aes128_init(state->key, &aes_test);
	aes128_enc_CTR_asm(temp, &aes_test,temp2);
	
#elif key_bit == 192
	aes192_ctx_t aes_test;
	aes192_init(state->key, &aes_test);
	aes128_enc_CTR_asm(temp, &aes_test,temp2);

#else //key_bit ==256
	aes256_ctx_t aes_test;
	aes256_init(state->key, &aes_test);
	aes128_enc_CTR_asm(temp, &aes_test,temp2);

#endif

	for (cnt_i = 0; cnt_i < SEED_LEN - BLOCK_SIZE; cnt_i++)
	{
		state->key[cnt_i] = temp[cnt_i] ^ seed[cnt_i];
	}
	for (cnt_i = 0; cnt_i < BLOCK_SIZE; cnt_i++)
	{
		state->V[cnt_i] = temp[SEED_LEN - BLOCK_SIZE + cnt_i] ^ seed[SEED_LEN - BLOCK_SIZE + cnt_i];
	}
}

void generate_Random(st_state *state, u8 *random, u8 *add_data, u8 *re_Entrophy, u8 *re_add_data, st_len *LEN)
{

	int cnt_i, cnt_j, cnt_k = 0;
	u8 round_key[16 * 17] = {0x00};
	u8 result[16] = {0x00};
	u8 a_data[16] = {0x00};
	u8 seed[32] = {0x00};
	u8 temp[32] = {0x00};

	if (state->prediction_flag == TRUE)
	{
		Reseed_Function(state, re_Entrophy, re_add_data, LEN);
		add_data = NULL;
		derived_function(a_data, seed, &(LEN->general_len));
		for (cnt_i = 0; cnt_i < LEN_SEED; cnt_i++)
		{
			state->V[15]++;
			//Crypt(state->V, EncKeySetup(state->key, round_key, 128), round_key, result);
			for (cnt_j = 0; cnt_j < BLOCK_SIZE; cnt_j++)
			{
				random[cnt_i * 16 + cnt_j] = result[cnt_j];
			}
		}
		for (cnt_i = 0; cnt_i < LEN_SEED; cnt_i++)
		{
			state->V[15]++;
			//Crypt(state->V, EncKeySetup(state->key, round_key, 128), round_key, result);
			for (cnt_j = 0; cnt_j < BLOCK_SIZE; cnt_j++)
			{
				temp[cnt_i * 16 + cnt_j] = result[cnt_j];
			}
		}
		for (cnt_i = 0; cnt_i < 32; cnt_i++)
		{
			temp[cnt_i] ^= seed[cnt_i];
		}
		for (cnt_i = 0; cnt_i < 16; cnt_i++)
		{
			state->key[cnt_i] = temp[cnt_i] ^ seed[cnt_i];
			state->V[cnt_i] = temp[16 + cnt_i] ^ seed[16 + cnt_i];
		}
	}

	else if (add_data != NULL)
	{
		derived_function(add_data, seed, &(LEN->general_len));
		update(state, seed);
		for (cnt_i = 0; cnt_i < LEN_SEED; cnt_i++)
		{
			state->V[15]++;
			//Crypt(state->V, EncKeySetup(state->key, round_key, 128), round_key, result);
			for (cnt_j = 0; cnt_j < BLOCK_SIZE; cnt_j++)
			{
				random[cnt_i * 16 + cnt_j] = result[cnt_j];
			}
		}
		for (cnt_i = 0; cnt_i < LEN_SEED; cnt_i++)
		{
			state->V[15]++;
			//Crypt(state->V, EncKeySetup(state->key, round_key, 128), round_key, result);
			for (cnt_j = 0; cnt_j < BLOCK_SIZE; cnt_j++)
			{
				temp[cnt_i * 16 + cnt_j] = result[cnt_j];
			}
		}
		for (cnt_i = 0; cnt_i < 32; cnt_i++)
		{
			temp[cnt_i] ^= seed[cnt_i];
		}
		for (cnt_i = 0; cnt_i < 16; cnt_i++)
		{
			state->key[cnt_i] = temp[cnt_i] ^ seed[cnt_i];
			state->V[cnt_i] = temp[16 + cnt_i] ^ seed[16 + cnt_i];
		}
	}

	else
	{
		derived_function(a_data, seed, &(LEN->general_len));
		for (cnt_i = 0; cnt_i < LEN_SEED; cnt_i++)
		{
			state->V[15]++;
			//Crypt(state->V, EncKeySetup(state->key, round_key, 128), round_key, result);
			for (cnt_j = 0; cnt_j < BLOCK_SIZE; cnt_j++)
			{
				random[cnt_i * 16 + cnt_j] = result[cnt_j];
			}
		}

		for (cnt_i = 0; cnt_i < LEN_SEED; cnt_i++)
		{
			state->V[15]++;
			//Crypt(state->V, EncKeySetup(state->key, round_key, 128), round_key, result);
			for (cnt_j = 0; cnt_j < BLOCK_SIZE; cnt_j++)
			{
				temp[cnt_i * 16 + cnt_j] = result[cnt_j];
			}
		}
		for (cnt_i = 0; cnt_i < 32; cnt_i++)
		{
			temp[cnt_i] ^= seed[cnt_i];
		}
		for (cnt_i = 0; cnt_i < 16; cnt_i++)
		{
			state->key[cnt_i] = temp[cnt_i] ^ seed[cnt_i];
			state->V[cnt_i] = temp[16 + cnt_i] ^ seed[16 + cnt_i];
		}
	}
	state->Reseed_counter++;
}

void Reseed_Function(st_state *state, u8 *re_Entrophy, u8 *re_add_data, st_len *len)
{
	int cnt_i = 0;
	u8 len2 = len->re_adddata + len->re_Entrophy;
	u8 *input_data = (u8 *)calloc(len2, sizeof(u8));
	u8 seed[32] = {0x00};
	for (cnt_i = 0; cnt_i < len->re_Entrophy; cnt_i++)
	{
		input_data[cnt_i] = re_Entrophy[cnt_i];
	}
	for (cnt_i = len->re_Entrophy; cnt_i < len2; cnt_i++)
	{
		input_data[cnt_i] = re_Entrophy[cnt_i - len->re_Entrophy];
	}
	derived_function(input_data, seed, &len2);
	update(state, seed);
	free(input_data);
}

void CTR_DRBG(st_state *in_state, st_len *len, u8 *in, u8 *seed, u8 *random, u8 *re_add_data, u8 *re_Entrophy, u8 *add_data)
{
	derived_function(in, seed, &len->input_len);
	update(in_state, seed);
	generate_Random(in_state, random, add_data, re_Entrophy, re_add_data, len);
}