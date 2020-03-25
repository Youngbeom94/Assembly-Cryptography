/*
* AES_fun.c
*
* Created: 2020-03-25 오전 11:22:41
*  Author: 김영범
*/

#include "AES_header.h"
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
