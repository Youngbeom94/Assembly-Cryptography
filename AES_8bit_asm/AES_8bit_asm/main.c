/*
 * AES_8bit_asm.c
 *
 * Created: 2020-03-25 오전 11:21:43
 * Author : 김영범
 */ 

#include <avr/io.h>
#include "AES_header.h"


int main(void)
{
    u8 plain_txt[16] = {0xCB,0x67,0x1F,0x6F,0x63,0xE9,0xDA,0xF0,0x7C,0x98,0xFF,0xF5,0x3A,0xFb,0xB1,0xB6};
	
	//ShiftRow(plain_txt);
	//ShiftRow_asm(plain_txt);
	
	//MixColumns(plain_txt);
	MixColumns_asm(plain_txt);
	
}

