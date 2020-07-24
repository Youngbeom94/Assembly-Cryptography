/*
 * CTR_DRBG TEST.c
 *
 * Created: 2020-07-19 오후 3:33:51
 * Author : 김영범
 */ 

#include "header.h"

int main()
{
	st_state INSTATE = {0x00};
	st_state *in_state = &INSTATE;
	in_state->prediction_flag = FALSE;
	

	u8 in[INSTANCE_INPUT] = {0x3D, 0xA9, 0x3E, 0xDD, 0x17, 0x94, 0x4F, 0x79, 0x1E, 0x33, 0x99, 0x67, 0x2C, 0xC6, 0xEA, 0x93, 0x8A, 0x3F, 0xFF, 0x14, 0x09, 0x02, 0x3D, 0x0C};
	u8 seed[SEED_LEN] = {0x00};
	u8 re_add_data[RESEED_ADD_DATA_LEN] = {0x00};
	u8 random[RANDOM_LEN] = {0x00};

	u8 LUK_Table[BLOCK_SIZE + SEED_LEN] = {0x00};

	//update_first_call(in_state, seed);

	//CTR_DRBG(in_state, in, seed, random, re_add_data);
	//Optimize_CTR_DRBG(in_state, in, seed, random, re_add_data, LUK_Table);

	 Output(in_state, random);
	 copy_state_seed(seed, in_state);
	 update_first_call(in_state, seed);


	//Show_Random_number(random);


	return 0;
}