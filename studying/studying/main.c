/*
 * studying.c
 *
 * Created: 2020-07-13 오후 3:17:10
 * Author : 김영범
 */ 

#include <avr/io.h>

#define LEN 200


typedef volatile unsigned char u8;


void init(u8 *in, u8 * state, u8* temp);

void test(u8 *state);
void test2();
void keccack_first(u8* in, u8* temp);



int main(void)
{
	u8 in[25][8] = {0x00,};
	u8 state[25][8] = {0x00,};
	u8 temp[5][8] = {0x00,};
	
	init(in, state, temp);
	keccack_first(in, temp);
	
	
	//test();

	//final(state, in);
	
}

