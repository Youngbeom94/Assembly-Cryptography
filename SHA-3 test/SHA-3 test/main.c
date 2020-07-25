/*
 * studying.c
 *
 * Created: 2020-07-13 오후 3:17:10
 * Author : 김영범
 */ 

#include <avr/io.h>

#define LEN 200

typedef unsigned char u8;


void init(u8* in, u8* state, u8* temp);

void test(u8 *state);
void keccack(u8* in,u8* state, u8* temp);



int main(void)
{
	u8 in[200] = {0x00,};
	u8 state[1] = {0x00,};
	u8 temp[80] = {0x00,};
	
	init(in, state, temp);
	keccack(in, state,temp);
	
	
	//test(state);

	//final(state, in);
	
}

