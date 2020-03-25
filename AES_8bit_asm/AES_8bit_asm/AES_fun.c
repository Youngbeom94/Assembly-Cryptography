/*
* AES_fun.c
*
* Created: 2020-03-25 오전 11:22:41
*  Author: 김영범
*/
#include "AES_header.h"
 
 void SubByte(u8 *state, u8* sbox)
 {
	 u8 cnt_i;
	 for (cnt_i = 0; cnt_i < 16; cnt_i++)
	 {
		 *(state + cnt_i) = sbox[state[cnt_i]]; //sbox를 이용해 치환하기
	 }
 }

void ShiftRow(u8 *state)
{
	u8 temp, temp2;
	temp = state[13]; //2번째 행 1칸 Left shift
	state[13] = state[1];
	state[1] = state[5];
	state[5] = state[9];
	state[9] = temp;

	temp = state[10]; //3번째 행 2칸 Left shift
	temp2 = state[14];
	state[10] = state[2];
	state[14] = state[6];
	state[2] = temp;
	state[6] = temp2;

	temp = state[7]; // 4번째 행 3칸 Left shift
	state[7] = state[3];
	state[3] = state[15];
	state[15] = state[11];
	state[11] = temp;
}

void MixColumns(u8 *state)
{
	u8 temp[4];
	u8 src[4];
	for (int cnt_i = 0; cnt_i < 4; cnt_i++)
	{
		//? 02 03 01 01
		temp[0] = state[4 * cnt_i] ^ state[4 * cnt_i + 1]; // 02 03 에해당하는 xtime
		temp[0] = xtime(temp[0]);
		temp[1] = state[4 * cnt_i + 1] ^ state[4 * cnt_i + 2] ^ state[4 * cnt_i + 3]; // 1 에 해당하는 plain_txt
		src[0] = temp[0] ^ temp[1];                                                   // 최종 src
		//? 01 02 03 01
		temp[0] = state[4 * cnt_i + 1] ^ state[4 * cnt_i + 2]; // 02 03 에해당하는 xtime
		temp[0] = xtime(temp[0]);
		temp[1] = state[4 * cnt_i] ^ state[4 * cnt_i + 2] ^ state[4 * cnt_i + 3]; // 1 에 해당하는 plain_txt
		src[1] = temp[0] ^ temp[1];                                               // 최종 src
		//? 01 01 02 03
		temp[0] = state[4 * cnt_i + 2] ^ state[4 * cnt_i + 3]; // 02 03 에해당하는 xtime
		temp[0] = xtime(temp[0]);
		temp[1] = state[4 * cnt_i] ^ state[4 * cnt_i + 1] ^ state[4 * cnt_i + 3]; // 1 에 해당하는 plain_txt
		src[2] = temp[0] ^ temp[1];                                               // 최종 src
		//? 03 01 01 03
		temp[0] = state[4 * cnt_i] ^ state[4 * cnt_i + 3]; // 02 03 에해당하는 xtime
		temp[0] = xtime(temp[0]);
		temp[1] = state[4 * cnt_i] ^ state[4 * cnt_i + 1] ^ state[4 * cnt_i + 2];
		src[3] = temp[0] ^ temp[1]; // 최종 src

		for (int cnt_j = 0; cnt_j < 4; cnt_j++)
		{
			state[4 * cnt_i + cnt_j] = src[cnt_j];
		}
	}
}

void RotWord(uint32_t *Word) // int 기준으로 값을 받고 1byte left Rotation
{
	uint32_t temp;
	temp = *Word << 8;
	*Word = *Word >> 24;
	*Word &= 0x000000ff;
	*Word ^= temp;
}
void SubWord(uint32_t *Word,u8* sbox) // int 기준으로 값을 받고 int를 4개의 byte로 쪼개서 byte를 sbox의 값으로 치환
{
	u8 cnt_i = 0;
	u8 temp[4] = {0x00};
	uint32_t temp2;
	for (cnt_i = 0; cnt_i < 4; cnt_i++) // 값 쪼개서 sbox로 치환해서 temp배열에 저장
	{
		temp2 = (*Word >> (24 - (8 * cnt_i)));
		temp2 &= 0x000000ff;
		temp[cnt_i] = sbox[temp2];
	}
	*Word = 0;
	for (cnt_i = 0; cnt_i < 4; cnt_i++)
	{
		*Word += (temp[cnt_i] << (24 - (8 * cnt_i))); // 다시 쪼개고 치환한 값들을 다시 합쳐주기
	}
}

void Byte_Int_Set(u8 *userKey, AES_KEY *key, u8 start) // byte 16개 배열을 int함수에 저장시키는 함수
{
	uint32_t temp = 0;
	u8 cnt_i,cnt_j;
	for (cnt_i = 0; cnt_i < 4; cnt_i++) // 저장할 공간을 먼저 초기화 시키기
	{
		key->rd_key[start + cnt_i] = 0;
	}

	for (cnt_i = 0; cnt_i < 4; cnt_i++) // byte 16개를 int 4개 배열에 저장시키기
	{
		for (cnt_j = 0; cnt_j < 4; cnt_j++)
		{
			temp = userKey[cnt_j + (cnt_i * 4)] << ((3 - cnt_j) * 8);
			key->rd_key[start + cnt_i] += temp;
			temp = 0;
		}
	}
}

void AddRoundKey(u8 *state, u8* rdkey)
{
	int cnt_i;
	for (cnt_i = 0; cnt_i < 4; cnt_i++)
	{
		state[cnt_i] ^= rdkey[cnt_i];
	}
}


void keyScheduling(u8* roundkey,u8* Rcon, u8* sbox,u8 round)
{
	u8 cnt_i = 0x00;
	u8 temp2[16] = {0x00};
	cnt_i = roundkey[12];
	roundkey[12] = sbox[roundkey[13]];
	roundkey[13] = sbox[roundkey[14]];
	roundkey[14] = sbox[roundkey[15]];
	roundkey[15] = sbox[cnt_i];
	
	temp2[0] = roundkey[12]^Rcon[round]^roundkey[0];
	temp2[1] = roundkey[13]^roundkey[0];
	temp2[2] = roundkey[14]^roundkey[0];
	temp2[3] = roundkey[15]^roundkey[0];
	
	temp2[4] = temp2[0]^roundkey[4];
	temp2[5] = temp2[1]^roundkey[5];
	temp2[6] = temp2[2]^roundkey[6];
	temp2[7] = temp2[3]^roundkey[7];
	
	temp2[8] = temp2[4]^roundkey[8];
	temp2[9] = temp2[5]^roundkey[9];
	temp2[10] = temp2[6]^roundkey[10];
	temp2[11] = temp2[7]^roundkey[11];
	
	temp2[12] = temp2[8]^roundkey[12];
	temp2[13] = temp2[9]^roundkey[13];
	temp2[14] = temp2[10]^roundkey[14];
	temp2[15] = temp2[11]^roundkey[15];
	
	for(cnt_i = 0 ; cnt_i <16; cnt_i++)
	{
		roundkey[cnt_i] = temp2[cnt_i];
	}	
	
}

void AES_encrypt(u8* inp, u8* out, u8* usrkey,u8* sbox, u8* rcon)
{
	u8 state[16];
	u8 cnt_i;
	u8 round = 0;
	u8 roundkey[16] = {0x00};

	
	for (cnt_i = 0; cnt_i < 16; cnt_i++)
	{
		state[cnt_i] = inp[cnt_i];
		roundkey[cnt_i] = usrkey[cnt_i];
	}

	AddRoundKey(state, roundkey);
	keyScheduling(roundkey,rcon, sbox,round);


	for (cnt_i = 1; cnt_i < AES_MAXNR; cnt_i++)
	{
		SubByte(state,sbox);
		ShiftRow(state);
		MixColumns(state);
		AddRoundKey(state, roundkey);
		keyScheduling(roundkey,rcon, sbox,round);

	}
	
	SubByte(state,sbox);
	ShiftRow(state);
	AddRoundKey(state, roundkey);

	for (cnt_i = 0; cnt_i < 4 * Nb; cnt_i++)
	{
		out[cnt_i] = state[cnt_i];
	}
}