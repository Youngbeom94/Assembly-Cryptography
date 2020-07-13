/*
 * studying.c
 *
 * Created: 2020-07-13 오후 3:17:10
 * Author : 김영범
 */ 

#include <avr/io.h>

typedef volatile unsigned char u8;
void test(u8 *state);
void test2(u8 *state);



int main(void)
{
	u8 state[25][8] = {0x00};
	
	test(state);
	
}

