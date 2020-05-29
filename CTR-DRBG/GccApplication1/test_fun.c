/*
 * test_fun.c
 *
 * Created: 2020-05-29 오후 8:05:45
 *  Author: 김영범
 */ 
/*
* AES_fun.c
*
* Created: 2020-03-25 오전 11:22:41
*  Author: 김영범
*/
#include "ctr_drbg.h"

const u8 Rcon[13] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab};
const u8 sbox[256]={
	//0     1    2      3     4    5     6     7      8    9     A      B    C     D     E     F
	0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
	0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
	0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
	0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
	0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
	0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
	0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
	0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
	0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
	0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
	0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
	0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
	0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
	0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
	0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16};


void SubByte(u8 *state)
{
	u8 cnt_i;
	u8 temp = 0;
	for (cnt_i = 0; cnt_i < 16; cnt_i++)
	{
		state[cnt_i] = sbox[cnt_i]; //sbox를 이용해 치환하기
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

void AddRoundKey(u8 *state, u8* rdkey)
{
	int cnt_i;
	for (cnt_i = 0; cnt_i < 16; cnt_i++)
	{
		state[cnt_i] ^= rdkey[cnt_i];
	}
}


void keyScheduling(u8* roundkey,u8* round)
{
	volatile u8 cnt_i = 0x00;
	volatile u8 temp2[16] = {0x00};
	volatile u8 a = 0x00,b = 0x00,c = 0x00;
	
	cnt_i = roundkey[12];
	a = roundkey[13];
	b = roundkey[14];
	c = roundkey[15];
	
	temp2[12] = sbox(a);
	temp2[13] = sbox(b);
	temp2[14] =sbox(c);
	temp2[15] = sbox(cnt_i);
	
	a = *round;
	cnt_i = Rcon[a];
	temp2[0] = temp2[12]^cnt_i^roundkey[0];
	temp2[1] = temp2[13]^roundkey[1];
	temp2[2] = temp2[14]^roundkey[2];
	temp2[3] = temp2[15]^roundkey[3];
	
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
	
	*round = *round + 1;
	for(cnt_i = 0 ; cnt_i <16; cnt_i++)
	{
		roundkey[cnt_i] = temp2[cnt_i];
	}
}

void AES_encrypt(u8* inp, u8* out, u8* usrkey)
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
	keyScheduling(roundkey,&round);

	for (cnt_i = 1; cnt_i < AES_MAXNR; cnt_i++)
	{
		SubByte(state);
		ShiftRow(state);
		MixColumns(state);
		AddRoundKey(state, roundkey);
		keyScheduling(roundkey,&round);

	}
	
	SubByte(state);
	ShiftRow(state);
	AddRoundKey(state, roundkey);

	for (cnt_i = 0; cnt_i < 4 * Nb; cnt_i++)
	{
		out[cnt_i] = state[cnt_i];
	}
}

void AES_encrypt_asm(u8* inp, u8* out, u8* usrkey)
{
	u8 state[16];
	u8 cnt_i = 0;
	u8 round = 0;
	u8 roundkey[16] = {0x00};

	for (cnt_i = 0; cnt_i < 16; cnt_i++)
	{
		state[cnt_i] = inp[cnt_i];
		roundkey[cnt_i] = usrkey[cnt_i];
	}
	AddRoundKey(state, roundkey);
	keyScheduling(roundkey,&round);

	for (cnt_i = 1; cnt_i < AES_MAXNR; cnt_i++)
	{
		SubByte(state);
		ShiftRow(state);
		MixColumns_asm(state);
		AddRoundKey(state, roundkey);
		keyScheduling(roundkey,&round);

	}
	
	SubByte(state);
	ShiftRow(state);
	AddRoundKey(state, roundkey);

	for (cnt_i = 0; cnt_i < 4 * Nb; cnt_i++)
	{
		out[cnt_i] = state[cnt_i];
	}
}
