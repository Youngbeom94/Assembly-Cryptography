/*
 * PIPO_AVR.c
 *
 * Created: 2021-03-08 오전 11:11:02
 * Author : YoungBeom Kim
 */ 

#include <avr/io.h>
typedef unsigned char u8;
extern void PIPO_enc(u8* p, u8* m);

int main(void)
{
	u8 p[8] = {0x09, 0x85, 0x52, 0xF6, 0x1E, 0x27, 0x00, 0x26};
	u8 m[16] = {0x6D, 0xC4, 0x16, 0xDD, 0x77, 0x94, 0x28, 0xD2, 0x7E, 0x1D, 0x20, 0xAD, 0x2E, 0x15, 0x22, 0x97};
	PIPO_enc(p,m);
	
}
//Compile Option : -O3
//CC : 1393
//CPB : 174.12
//RAM : 24 bytes (0.6% Full of ATmega128)
//Code_Size : 1020 bytes (0.8% Full of ATmega128)
