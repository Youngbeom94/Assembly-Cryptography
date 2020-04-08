/*
* AES_fun.c
*
* Created: 2020-03-25 오전 11:22:41
*  Author: 김영범
*/
#include "AES_header.h"

const u8 Rcon[13]PROGMEM ALIGN_ZH = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab};
const u8 sbox[256]PROGMEM ALIGN_ZH = {
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

const u8 sbox2[256]PROGMEM ALIGN_ZH = {
	//0     1    2      3     4    5     6     7      8    9     A      B    C     D     E     F
	0x00, 0x02, 0x04, 0x06, 0x08, 0x0a, 0x0c, 0x0e, 0x10, 0x12, 0x14, 0x16, 0x18, 0x1a, 0x1c, 0x1e,
	0x20, 0x22, 0x24, 0x26, 0x28, 0x2a, 0x2c, 0x2e, 0x30, 0x32, 0x34, 0x36, 0x38, 0x3a, 0x3c, 0x3e,
	0x40, 0x42, 0x44, 0x46, 0x48, 0x4a, 0x4c, 0x4e, 0x50, 0x52, 0x54, 0x56, 0x58, 0x5a, 0x5c, 0x5e,
	0x60, 0x62, 0x64, 0x66, 0x68, 0x6a, 0x6c, 0x6e, 0x70, 0x72, 0x74, 0x76, 0x78, 0x7a, 0x7c, 0x7e,
	0x80, 0x82, 0x84, 0x86, 0x88, 0x8a, 0x8c, 0x8e, 0x90, 0x92, 0x94, 0x96, 0x98, 0x9a, 0x9c, 0x9e,
	0xa0, 0xa2, 0xa4, 0xa6, 0xa8, 0xaa, 0xac, 0xae, 0xb0, 0xb2, 0xb4, 0xb6, 0xb8, 0xba, 0xbc, 0xbe,
	0xc0, 0xc2, 0xc4, 0xc6, 0xc8, 0xca, 0xcc, 0xce, 0xd0, 0xd2, 0xd4, 0xd6, 0xd8, 0xda, 0xdc, 0xde,
	0xe0, 0xe2, 0xe4, 0xe6, 0xe8, 0xea, 0xec, 0xee, 0xf0, 0xf2, 0xf4, 0xf6, 0xf8, 0xfa, 0xfc, 0xfe,
	0x1b, 0x19, 0x1f, 0x1d, 0x13, 0x11, 0x17, 0x15, 0x0b, 0x09, 0x0f, 0x0d, 0x03, 0x01, 0x07, 0x05,
	0x3b, 0x39, 0x3f, 0x3d, 0x33, 0x31, 0x37, 0x35, 0x2b, 0x29, 0x2f, 0x2d, 0x23, 0x21, 0x27, 0x25,
	0x5b, 0x59, 0x5f, 0x5d, 0x53, 0x51, 0x57, 0x55, 0x4b, 0x49, 0x4f, 0x4d, 0x43, 0x41, 0x47, 0x45,
	0x7b, 0x79, 0x7f, 0x7d, 0x73, 0x71, 0x77, 0x75, 0x6b, 0x69, 0x6f, 0x6d, 0x63, 0x61, 0x67, 0x65,
	0x9b, 0x99, 0x9f, 0x9d, 0x93, 0x91, 0x97, 0x95, 0x8b, 0x89, 0x8f, 0x8d, 0x83, 0x81, 0x87, 0x85,
	0xbb, 0xb9, 0xbf, 0xbd, 0xb3, 0xb1, 0xb7, 0xb5, 0xab, 0xa9, 0xaf, 0xad, 0xa3, 0xa1, 0xa7, 0xa5,
	0xdb, 0xd9, 0xdf, 0xdd, 0xd3, 0xd1, 0xd7, 0xd5, 0xcb, 0xc9, 0xcf, 0xcd, 0xc3, 0xc1, 0xc7, 0xc5,
0xfb, 0xf9, 0xff, 0xfd, 0xf3, 0xf1, 0xf7, 0xf5, 0xeb, 0xe9, 0xef, 0xed, 0xe3, 0xe1, 0xe7, 0xe5};

const u8 sbox3[256]PROGMEM ALIGN_ZH = {
	//0     1    2      3     4    5     6     7      8    9     A      B    C     D     E     F
	0x00, 0x03, 0x06, 0x05, 0x0c, 0x0f, 0x0a, 0x09, 0x18, 0x1b, 0x1e, 0x1d, 0x14, 0x17, 0x12, 0x11,
	0x30, 0x33, 0x36, 0x35, 0x3c, 0x3f, 0x3a, 0x39, 0x28, 0x2b, 0x2e, 0x2d, 0x24, 0x27, 0x22, 0x21,
	0x60, 0x63, 0x66, 0x65, 0x6c, 0x6f, 0x6a, 0x69, 0x78, 0x7b, 0x7e, 0x7d, 0x74, 0x77, 0x72, 0x71,
	0x50, 0x53, 0x56, 0x55, 0x5c, 0x5f, 0x5a, 0x59, 0x48, 0x4b, 0x4e, 0x4d, 0x44, 0x47, 0x42, 0x41,
	0xc0, 0xc3, 0xc6, 0xc5, 0xcc, 0xcf, 0xca, 0xc9, 0xd8, 0xdb, 0xde, 0xdd, 0xd4, 0xd7, 0xd2, 0xd1,
	0xf0, 0xf3, 0xf6, 0xf5, 0xfc, 0xff, 0xfa, 0xf9, 0xe8, 0xeb, 0xee, 0xed, 0xe4, 0xe7, 0xe2, 0xe1,
	0xa0, 0xa3, 0xa6, 0xa5, 0xac, 0xaf, 0xaa, 0xa9, 0xb8, 0xbb, 0xbe, 0xbd, 0xb4, 0xb7, 0xb2, 0xb1,
	0x90, 0x93, 0x96, 0x95, 0x9c, 0x9f, 0x9a, 0x99, 0x88, 0x8b, 0x8e, 0x8d, 0x84, 0x87, 0x82, 0x81,
	0x9b, 0x98, 0x9d, 0x9e, 0x97, 0x94, 0x91, 0x92, 0x83, 0x80, 0x85, 0x86, 0x8f, 0x8c, 0x89, 0x8a,
	0xab, 0xa8, 0xad, 0xae, 0xa7, 0xa4, 0xa1, 0xa2, 0xb3, 0xb0, 0xb5, 0xb6, 0xbf, 0xbc, 0xb9, 0xba,
	0xfb, 0xf8, 0xfd, 0xfe, 0xf7, 0xf4, 0xf1, 0xf2, 0xe3, 0xe0, 0xe5, 0xe6, 0xef, 0xec, 0xe9, 0xea,
	0xcb, 0xc8, 0xcd, 0xce, 0xc7, 0xc4, 0xc1, 0xc2, 0xd3, 0xd0, 0xd5, 0xd6, 0xdf, 0xdc, 0xd9, 0xda,
	0x5b, 0x58, 0x5d, 0x5e, 0x57, 0x54, 0x51, 0x52, 0x43, 0x40, 0x45, 0x46, 0x4f, 0x4c, 0x49, 0x4a,
	0x6b, 0x68, 0x6d, 0x6e, 0x67, 0x64, 0x61, 0x62, 0x73, 0x70, 0x75, 0x76, 0x7f, 0x7c, 0x79, 0x7a,
	0x3b, 0x38, 0x3d, 0x3e, 0x37, 0x34, 0x31, 0x32, 0x23, 0x20, 0x25, 0x26, 0x2f, 0x2c, 0x29, 0x2a,
0x0b, 0x08, 0x0d, 0x0e, 0x07, 0x04, 0x01, 0x02, 0x13, 0x10, 0x15, 0x16, 0x1f, 0x1c, 0x19, 0x1a};


void SubByte(u8 *state)
{
	u8 cnt_i;
	u8 temp = 0;
	for (cnt_i = 0; cnt_i < 16; cnt_i++)
	{
		temp = state[cnt_i];
		state[cnt_i] = pgm_read_byte(sbox+temp); //sbox를 이용해 치환하기
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
	
	temp2[12] = pgm_read_byte(sbox+a);
	temp2[13] = pgm_read_byte(sbox+b);
	temp2[14] = pgm_read_byte(sbox+c);
	temp2[15] = pgm_read_byte(sbox+ cnt_i);
	
	a = *round;
	cnt_i = pgm_read_byte(Rcon + a);
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
void AES_encrypt_asm_Progm(u8* inp, u8* out, u8* usrkey)
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
		Subbyte_ShiftRows_asm(state);
		MixColumns_asm_Progm(state);
		AddRoundKey(state, roundkey);
		keyScheduling(roundkey,&round);

	}
	
	Subbyte_ShiftRows_asm(state);
	AddRoundKey(state, roundkey);

	for (cnt_i = 0; cnt_i < 4 * Nb; cnt_i++)
	{
		out[cnt_i] = state[cnt_i];
	}
}

void reset_count(u8* count)
{
	u8 cnt_i = 0;
	for(cnt_i = 0 ; cnt_i < 16 ; cnt_i ++)
	{
		count[cnt_i] = 0x00;
	}
}

void state_copy(u8* dst, u8* src)
{
	u8 cnt_i = 0;
	for(cnt_i = 0 ; cnt_i < 16 ; cnt_i ++)
	{
		dst[cnt_i] = src[cnt_i];
	}
}
void Count_Add_for_LUT(u8* count, u8* cnt_k)
{
	
	u8 carry = 0;           //맨처음 Carry 값은 0
	u8 out[4] = { 0x00 }; // 최종배열
	u8 one[4] = { 0x00 }; // 0x01을 의미하는 배열

	if (*cnt_k == 0)
	{
		one[3] = 0x01;
		int8_t i = 3;
		while(i >=0)
		{
			out[i] = count[i] + one[i] + carry; // 마지막 배열 끼리 순차적으로 더해주면서 carry를 계산한다.
			if (out[i] < count[i])
			carry = 1;
			else
			{
				carry = 0;
			}
			i--;
		}
		
	}
	if (*cnt_k == 1)
	{
		one[2] = 0x01;
		int8_t i = 2;
		while(i >=0)
		{
			out[i] = count[i] + one[i] + carry; // 마지막 배열 끼리 순차적으로 더해주면서 carry를 계산한다.
			if (out[i] < count[i])
			carry = 1;
			else
			{
				carry = 0;
			}
			i--;
		}
	}
	if (*cnt_k == 2)
	{
		one[1] = 0x01;
		int8_t i = 1;
		while(i >=0)
		{
			out[i] = count[i] + one[i] + carry; // 마지막 배열 끼리 순차적으로 더해주면서 carry를 계산한다.
			if (out[i] < count[i])
			carry = 1;
			else
			{
				carry = 0;
			}
			i--;
		}
	}
	if (*cnt_k == 3)
	{
		one[0] = 0x01;
		int8_t i = 0;
		while(i >=0)
		{
			out[i] = count[i] + one[i] + carry; // 마지막 배열 끼리 순차적으로 더해주면서 carry를 계산한다.
			if (out[i] < count[i])
			carry = 1;
			else
			{
				carry = 0;
			}
			i--;
		}
	}

	for (volatile int8_t cnt_i = 0; cnt_i < 4; cnt_i++)
	{
		count[cnt_i] = out[cnt_i];
	}
	
}
void Count_Add_for_FACE_LIGHT(u8* count)
{
	u8 carry = 0;           //맨처음 Carry 값은 0
	u8 out[4] = { 0x00 }; // 최종배열
	u8 one[4] = { 0x00 }; // 0x01을 의미하는 배열
	one[3] = 0x01;

	int8_t i = 3,cnt_i = 0;
	while(i >=0)
	{
		out[i] = count[i] + one[i] + carry; // 마지막 배열 끼리 순차적으로 더해주면서 carry를 계산한다.
		if (out[i] < count[i])
		carry = 1;
		else
		{
			carry = 0;
		}
		i--;
	}
	for (cnt_i = 0; cnt_i < 4; cnt_i++)
	{
		count[cnt_i] = out[cnt_i];
	}
}
void Make_LUT_Face_Light(u8 LUT_FL[4][4][256],u8* userkey,u8* count)//! LUK Table of FACE_Light
{
	u8 state[16] = { 0x00 };
	u8 roundkey[16] = {0x00};
	volatile u8 round = 0;
	volatile u8 cnt_j = 0;
	volatile temp = 0;


	reset_count(count);
	state_copy(state, count);


	for (volatile int16_t cnt_k = 0; cnt_k < 4; cnt_k++)
	{
		for (volatile int16_t cnt_i = 0; cnt_i < 5 ; cnt_i++)                      //! check BLOCKSIZE 블록size가 256넘어가면 그냥 256이라 써주면된다.
		{
			
			round = 0x00;
			state_copy(roundkey, userkey);
			AddRoundKey(state, roundkey);
			keyScheduling(roundkey,&round);
			
			Subbyte_ShiftRows_asm(state);
			MixColumns_asm_Progm(state);
			AddRoundKey(state,roundkey);
			keyScheduling(roundkey,&round);
			
			SubByte(state);
			for (cnt_j = 0; cnt_j < 4; cnt_j++)			{
				if (cnt_k != 3){
					temp = state[((cnt_k + 1) * 4) + cnt_j];
					eeprom_update_byte(&LUT_FL[cnt_k][cnt_j][cnt_i],temp);
				}
				else{
					temp = state[cnt_j];
					eeprom_update_byte(&LUT_FL[cnt_k][cnt_j][cnt_i],temp);
				}
				
			}
			Count_Add_for_LUT(count, &cnt_k);
			state_copy(state, count);
		}
		reset_count(state);
		reset_count(count);
	}
}

void AES_encrypt_FACE_Light(u8 *inp,u8 LUT_FL[4][4][256], u8 *out, u8 *usrkey)//AES encryption of FACE mode
{
	u8 state[16] = {0x00};
	u8 cnt_i;
	u8 round = 0;
	u8 roundkey[16] = {0x00};

	for (cnt_i = 0; cnt_i < 4; cnt_i++)
	{
		state[cnt_i] = eeprom_read_byte(&LUT_FL[3][cnt_i][inp[0]]);
		state[cnt_i + 4] = eeprom_read_byte(&LUT_FL[0][cnt_i][inp[3]]);
		state[cnt_i + 8] =  eeprom_read_byte(&LUT_FL[1][cnt_i][inp[2]]);
		state[cnt_i + 12] =  eeprom_read_byte(&LUT_FL[2][cnt_i][inp[1]]);
		roundkey[cnt_i] = usrkey[cnt_i];
		roundkey[cnt_i+4] = usrkey[cnt_i+4];
		roundkey[cnt_i+8] = usrkey[cnt_i+8];
		roundkey[cnt_i+12] = usrkey[cnt_i+12];
	}
	keyScheduling(roundkey,&round);
	keyScheduling(roundkey,&round);

	ShiftRow(state);
	MixColumns_asm_Progm(state);
	AddRoundKey(state, roundkey);
	keyScheduling(roundkey,&round);

	for (cnt_i = 3; cnt_i < AES_MAXNR; cnt_i++)
	{
		Subbyte_ShiftRows_asm(state);
		MixColumns_asm_Progm(state);
		AddRoundKey(state, roundkey);
		keyScheduling(roundkey,&round);

	}
	
	Subbyte_ShiftRows_asm(state);
	AddRoundKey(state, roundkey);

	for (cnt_i = 0; cnt_i < 4 * Nb; cnt_i++)
	{
		out[cnt_i] = state[cnt_i];
	}
}

void CRYPTO_ctr128_encrypt_FACE_Light(u8* inp, u8* out, u8 LUT_FL[4][4][256],u8 length , u8* usrkey, u8* count) //AES CTR Mode of FACE_Light ver
{
	u8 cnt_i, cnt_j;
	u8 paddingcnt = length % 16;
	u8 PT[BLOCKSIZE][16] = { {0x00} };
	u8 CT[BLOCKSIZE][16] = { {0x00} };
	u8 iparray[16];
	u8 oparray[16];
	
	reset_count(count);

	for (cnt_i = 0; cnt_i < BLOCKSIZE - 1; cnt_i++)
	{
		for (cnt_j = 0; cnt_j < 16; cnt_j++)
		{
			PT[cnt_i][cnt_j] = inp[cnt_i * 16 + cnt_j];
		}
	}
	if (paddingcnt == 0)
	{
		for (cnt_j = 0; cnt_j < 16; cnt_j++)
		{
			PT[BLOCKSIZE - 1][cnt_j] = inp[(BLOCKSIZE - 1) * 16 + cnt_j];
		}
	}

	if (paddingcnt != 0) // 패딩 함수.
	{
		for (cnt_j = 0; cnt_j < paddingcnt; cnt_j++)
		{
			PT[BLOCKSIZE - 1][cnt_j] = inp[(BLOCKSIZE - 1) * 16 + cnt_j];
		}
		for (cnt_j = paddingcnt; cnt_j < 16; cnt_j++)
		{
			PT[BLOCKSIZE - 1][cnt_j] = (0x10 - paddingcnt);
		}
	}

	for (cnt_i = 0; cnt_i < BLOCKSIZE; cnt_i++) //각각의 count마다 1더하기 해주고, 암호화 시킨다음에 PT와 XoR 해준다. CORE
	{
		if (cnt_i != 0)
		Count_Add_for_FACE_LIGHT(count);

		for (cnt_j = 0; cnt_j < 16; cnt_j++)
		{
			iparray[cnt_j] = count[cnt_j];
		}
		AES_encrypt_FACE_Light(iparray, LUT_FL, oparray,usrkey);
		for (cnt_j = 0; cnt_j < 16; cnt_j++)
		{
			CT[cnt_i][cnt_j] = oparray[cnt_j] ^ PT[cnt_i][cnt_j];
		}
	}

	for (cnt_i = 0; cnt_i < BLOCKSIZE; cnt_i++)
	{
		for (cnt_j = 0; cnt_j < 16; cnt_j++)
		{
			out[cnt_i * 16 + cnt_j] = CT[cnt_i][cnt_j];
		}
	}
}

void Count_Addition(u8 *count) //Count 배열에서 값을 1증가시키는 함수
{
	int cnt_i, carry = 0;           //맨처음 Carry 값은 0
	u8 out[16] = {0x00}; // 최종배열
	u8 one[16] = {0x00}; // 0x01을 의미하는 배열
	one[15] = 0x01;

	for (cnt_i = 15; cnt_i >= 0; cnt_i--)
	{
		out[cnt_i] = count[cnt_i] + one[cnt_i] + carry; // 마지막 배열 끼리 순차적으로 더해주면서 carry를 계산한다.
		//만약 out의 결과값의 count값보다 작은 경우 carry가 발생했다. 만약 0xffffffff..인 경우 1을 더해주면 자동적으로 0x00상태로 돌아간다
		if (out[cnt_i] < count[cnt_i])
		carry = 1;
		else
		{
			carry = 0;
		}
	}
	for (cnt_i = 0; cnt_i < 16; cnt_i++)
	{
		count[cnt_i] = out[cnt_i];
	}
}

void CRYPTO_ctr128_encrypt(u8* inp, u8* out, u8 len, u8* usrkey, u8* count)//AES CTR Mode of FACE_Light ver
{
	u8 cnt_i, cnt_j;
	u8 paddingcnt = len % 16;
	u8 PT[BLOCKSIZE][16] = { {0x00} };
	u8 CT[BLOCKSIZE][16] = { {0x00} };
	u8 iparray[16] = {{0x00}};
	u8 oparray[16] = {{0x00}};
	
	reset_count(count);

	for (cnt_i = 0; cnt_i < BLOCKSIZE - 1; cnt_i++)
	{
		for (cnt_j = 0; cnt_j < 16; cnt_j++)
		{
			PT[cnt_i][cnt_j] = inp[cnt_i * 16 + cnt_j];
		}
	}
	if (paddingcnt == 0)
	{
		for (cnt_j = 0; cnt_j < 16; cnt_j++)
		{
			PT[BLOCKSIZE - 1][cnt_j] = inp[(BLOCKSIZE - 1) * 16 + cnt_j];
		}
	}

	if (paddingcnt != 0) // 패딩 함수.
	{
		for (cnt_j = 0; cnt_j < paddingcnt; cnt_j++)
		{
			PT[BLOCKSIZE - 1][cnt_j] = inp[(BLOCKSIZE - 1) * 16 + cnt_j];
		}
		for (cnt_j = paddingcnt; cnt_j < 16; cnt_j++)
		{
			PT[BLOCKSIZE - 1][cnt_j] = (0x10 - paddingcnt);
		}
	}

	for (cnt_i = 0; cnt_i < BLOCKSIZE; cnt_i++) //각각의 count마다 1더하기 해주고, 암호화 시킨다음에 PT와 XoR 해준다. CORE
	{
		if (cnt_i != 0)
		Count_Addition(count);

		for (cnt_j = 0; cnt_j < 16; cnt_j++)
		{
			iparray[cnt_j] = count[cnt_j];
		}
		AES_encrypt(iparray, oparray,usrkey);
		for (cnt_j = 0; cnt_j < 16; cnt_j++)
		{
			CT[cnt_i][cnt_j] = oparray[cnt_j] ^ PT[cnt_i][cnt_j];
		}
	}

	for (cnt_i = 0; cnt_i < BLOCKSIZE; cnt_i++)
	{
		for (cnt_j = 0; cnt_j < 16; cnt_j++)
		{
			out[cnt_i * 16 + cnt_j] = CT[cnt_i][cnt_j];
		}
	}
	
}

void CRYPTO_ctr128_encrypt_asm(u8* inp, u8* out, u8 len, u8* usrkey, u8* count) //AES CTR Mode of origin
{
	u8 cnt_i, cnt_j;
	u8 paddingcnt = len % 16;
	u8 PT[BLOCKSIZE][16] = { {0x00} };
	u8 CT[BLOCKSIZE][16] = { {0x00} };
	u8 iparray[16] = {{0x00}};
	u8 oparray[16] = {{0x00}};
	
	reset_count(count);
	for (cnt_i = 0; cnt_i < BLOCKSIZE - 1; cnt_i++)
	{
		for (cnt_j = 0; cnt_j < 16; cnt_j++)
		{
			PT[cnt_i][cnt_j] = inp[cnt_i * 16 + cnt_j];
		}
	}
	if (paddingcnt == 0)
	{
		for (cnt_j = 0; cnt_j < 16; cnt_j++)
		{
			PT[BLOCKSIZE - 1][cnt_j] = inp[(BLOCKSIZE - 1) * 16 + cnt_j];
		}
	}

	if (paddingcnt != 0) // 패딩 함수.
	{
		for (cnt_j = 0; cnt_j < paddingcnt; cnt_j++)
		{
			PT[BLOCKSIZE - 1][cnt_j] = inp[(BLOCKSIZE - 1) * 16 + cnt_j];
		}
		for (cnt_j = paddingcnt; cnt_j < 16; cnt_j++)
		{
			PT[BLOCKSIZE - 1][cnt_j] = (0x10 - paddingcnt);
		}
	}

	for (cnt_i = 0; cnt_i < BLOCKSIZE; cnt_i++) //각각의 count마다 1더하기 해주고, 암호화 시킨다음에 PT와 XoR 해준다. CORE
	{
		if (cnt_i != 0)
		Count_Addition_Asm(count);

		for (cnt_j = 0; cnt_j < 16; cnt_j++)
		{
			iparray[cnt_j] = count[cnt_j];
		}
		AES_encrypt_asm_Progm(iparray, oparray,usrkey);
		for (cnt_j = 0; cnt_j < 16; cnt_j++)
		{
			CT[cnt_i][cnt_j] = oparray[cnt_j] ^ PT[cnt_i][cnt_j];
		}
	}

	for (cnt_i = 0; cnt_i < BLOCKSIZE; cnt_i++)
	{
		for (cnt_j = 0; cnt_j < 16; cnt_j++)
		{
			out[cnt_i * 16 + cnt_j] = CT[cnt_i][cnt_j];
		}
	}
	
}
