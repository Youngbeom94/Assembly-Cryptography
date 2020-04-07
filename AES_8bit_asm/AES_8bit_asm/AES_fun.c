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


void keyScheduling(u8* roundkey,u8* Rcon, u8* sbox,u8* round)
{
	volatile u8 cnt_i = 0x00;
	volatile u8 temp2[16] = {0x00};
	volatile u8 a,b,c;
	
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
	keyScheduling(roundkey,rcon, sbox,&round);

	for (cnt_i = 1; cnt_i < AES_MAXNR; cnt_i++)
	{
		SubByte(state,sbox);
		ShiftRow(state);
		MixColumns(state);
		AddRoundKey(state, roundkey);
		keyScheduling(roundkey,rcon, sbox,&round);

	}
	
	SubByte(state,sbox);
	ShiftRow(state);
	AddRoundKey(state, roundkey);

	for (cnt_i = 0; cnt_i < 4 * Nb; cnt_i++)
	{
		out[cnt_i] = state[cnt_i];
	}
}

void AES_encrypt_asm(u8* inp, u8* out, u8* usrkey,u8* sbox, u8* rcon)
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
	keyScheduling(roundkey,rcon, sbox,&round);

	for (cnt_i = 1; cnt_i < AES_MAXNR; cnt_i++)
	{
		SubByte(state,sbox);
		ShiftRow(state);
		MixColumns_asm(state);
		AddRoundKey(state, roundkey);
		keyScheduling(roundkey,rcon, sbox,&round);

	}
	
	SubByte(state,sbox);
	ShiftRow(state);
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
void Make_LUT_Face_Light(u8 LUT_FL[4][4][256],u8* userkey,u8* count,u8* sbox, u8* rcon)//! LUK Table of FACE_Light
{
	u8 state[16] = { 0x00 };
	u8 roundkey[16] = {0x00};
	volatile u8 round = 0;
	volatile u8 cnt_j = 0;


	reset_count(count);
		state_copy(state, count);


	for (volatile int16_t cnt_k = 0; cnt_k < 4; cnt_k++)
	{
		for (volatile int16_t cnt_i = 0; cnt_i < BLOCKSIZE ; cnt_i++)                      //! check BLOCKSIZE 블록size가 256넘어가면 그냥 256이라 써주면된다.
		{
			
			round = 0x00;
			state_copy(roundkey, userkey);
			AddRoundKey(state, roundkey);
			keyScheduling(roundkey,rcon, sbox,&round);
			

			SubByte(state,sbox);
			ShiftRow(state);
			MixColumns(state);
			AddRoundKey(state,roundkey);
			keyScheduling(roundkey,rcon, sbox,&round);
		
			SubByte(state,sbox);
			for (cnt_j = 0; cnt_j < 4; cnt_j++)			{	
				if (cnt_k != 3)
					LUT_FL[cnt_k][cnt_j][cnt_i] = state[((cnt_k + 1) * 4) + cnt_j];
				else
				LUT_FL[cnt_k][cnt_j][cnt_i] = state[cnt_j];
			}
			Count_Add_for_LUT(count, &cnt_k);
			state_copy(state, count);
		}
		reset_count(state);
		reset_count(count);
	}
}

void AES_encrypt_FACE_Light(u8 *inp,u8 LUT_FL[4][4][256], u8 *out, u8 *usrkey,u8* sbox, u8* rcon)//AES encryption of FACE mode
{
	u8 state[16] = {0x00};
	u8 cnt_i;
	u8 round = 0;
	u8 roundkey[16] = {0x00};

	for (cnt_i = 0; cnt_i < 4; cnt_i++)
	{
		state[cnt_i] = LUT_FL[3][cnt_i][inp[0]];
		state[cnt_i + 4] = LUT_FL[0][cnt_i][inp[3]];
		state[cnt_i + 8] = LUT_FL[1][cnt_i][inp[2]];
		state[cnt_i + 12] = LUT_FL[2][cnt_i][inp[1]];
		roundkey[cnt_i] = usrkey[cnt_i];
		roundkey[cnt_i+4] = usrkey[cnt_i+4];
		roundkey[cnt_i+8] = usrkey[cnt_i+8];
		roundkey[cnt_i+12] = usrkey[cnt_i+12];
	}
	keyScheduling(roundkey,rcon, sbox,&round);
	keyScheduling(roundkey,rcon, sbox,&round);

	ShiftRow(state);
	MixColumns_asm(state);
	AddRoundKey(state, roundkey);
	keyScheduling(roundkey,rcon, sbox,&round);

	for (cnt_i = 3; cnt_i < AES_MAXNR; cnt_i++)
	{
		SubByte(state,sbox);
		ShiftRow(state);
		MixColumns_asm(state);
		AddRoundKey(state, roundkey);
		keyScheduling(roundkey,rcon, sbox,&round);

	}
	
	SubByte(state,sbox);
	ShiftRow(state);
	AddRoundKey(state, roundkey);

	for (cnt_i = 0; cnt_i < 4 * Nb; cnt_i++)
	{
		out[cnt_i] = state[cnt_i];
	}
}

void CRYPTO_ctr128_encrypt_FACE_Light(u8* inp, u8* out, u8 LUT_FL[4][4][256],u8 length , u8* usrkey, u8* count ,u8* sbox, u8*rcon) //AES CTR Mode of FACE_Light ver
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
		AES_encrypt_FACE_Light(iparray, LUT_FL, oparray,usrkey,sbox,rcon);
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

void CRYPTO_ctr128_encrypt(u8* inp, u8* out, u8 len, u8* usrkey, u8* count, u8* sbox, u8* rcon)//AES CTR Mode of FACE_Light ver
{
	u8 cnt_i, cnt_j;
	u8 paddingcnt = len % 16;
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
		Count_Addition(count);

		for (cnt_j = 0; cnt_j < 16; cnt_j++)
		{
			iparray[cnt_j] = count[cnt_j];
		}
			AES_encrypt_asm(iparray, oparray,usrkey,sbox,rcon);
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
