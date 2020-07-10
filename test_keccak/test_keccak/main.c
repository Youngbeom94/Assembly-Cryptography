/*
* test_keccak.c
*
* Created: 2020-07-09 오후 3:15:33
* Author : 김영범
*/

#include <avr/io.h>

void test(unsigned char *a, unsigned char *b, unsigned char *c);

int main(void)
{
	unsigned char a[3] = {9,8,7};
	unsigned char b[3] = {8,2,3};
	unsigned char c[3] = {5,6,5};
	
	test(a,b,c);


}