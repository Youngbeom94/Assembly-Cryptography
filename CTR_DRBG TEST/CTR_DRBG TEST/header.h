#ifndef __PLUS__
#define __PLUS__
/*
    암호최적화 연구실
    20175204 김영범
    2020년 05월 13일
*/

//! header file
#include <avr/io.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/*
*   choose your block Cipher, using flag
*
*   HIGHT_CHAM_64_128    <------ HIGHT   or  CHAM 64/128
*   LEA_128_CHAM_128_128 <------ LEA 128 or  CHAM 128/128
*   LEA_192              <------ LEA 192
*   LEA_256_CHAM_128_256 <------ LEA 256 or  CHAM 128/256,
*/

#define LEA_128_CHAM_128_128

#if defined(HIGHT_CHAM_64_128)
    #define KEY_BIT 128
    #define BLOCK_BIT 64
    #define N_CONSTANT 0x18
#elif defined(LEA_128_CHAM_128_128)
    #define KEY_BIT 128
    #define BLOCK_BIT 128
    #define N_CONSTANT 0x20
#elif defined(LEA_192)
    #define KEY_BIT 192
    #define BLOCK_BIT 128
    #define N_CONSTANT 0x30
#elif defined(LEA_256_CHAM_128_256)
    #define KEY_BIT 256
    #define BLOCK_BIT 128
    #define N_CONSTANT 0x40
#endif

#define LEN_SEED ((KEY_BIT + BLOCK_BIT) / BLOCK_BIT)
#define N_DF ((KEY_BIT + BLOCK_BIT)>>3)
#define SEED_BIT (KEY_BIT + BLOCK_BIT) 
#define SEED_LEN (SEED_BIT / 8)
#define BLOCK_SIZE (BLOCK_BIT/8)
#define KEY_SIZE (KEY_BIT / 8)
#define TRUE  1
#define FALSE  0


/*
*       INPUT Condition
*       Select length 
*/
#define ENTROPHY_LEN 10
#define NONCE 10
#define Personal_String 10
#define INSTANCE_INPUT (ENTROPHY_LEN + NONCE + Personal_String)
#define DF_PADDING_LEN ((INSTANCE_INPUT + 25) % BLOCK_SIZE)
#define DF_INPUT_LEN   ((INSTANCE_INPUT + 25) + DF_PADDING_LEN)

#define ADD_DATA_LEN 10 //it must be small then SEEN_LEN
#define RESEED_ADD_DATA_LEN 10 
#define RESEED_PADDING_LEN ((RESEED_ADD_DATA_LEN + 25) % BLOCK_SIZE)
#define RESEED_INPUT_LEN   ((RESEED_ADD_DATA_LEN + 25) + DF_PADDING_LEN)


#define RANDOM_LEN 128 //(BYTE)


typedef unsigned char u8;

typedef struct _IN_state {   
    u8 key[KEY_SIZE];   
    u8 V[BLOCK_SIZE];     
    u8 Reseed_counter;
    u8 prediction_flag;
} st_state;


void XoR(u8* drc, u8* src, int len);
void set_state(u8* drc, u8* src , int start);
void copy_state(u8* drc, u8 * src, int len);
void copy(u8 *drc, u8 * src);
void clear(u8 *src, int len);
void copy_state_seed(u8 *drc, st_state *src);
void Show_State(st_state *state);
void Show_Random_number(u8* random);

void derived_function(u8 *input_data,u8* seed);
void update_first_call_first_call(st_state* state,u8* seed);
void update(st_state *state, u8 *seed,u8* add_data);
void generate_Random(st_state *state, u8 *random, u8 *re_add_data);
void Reseed_Function(st_state *state,u8* Reseed_AddData);
void Output(st_state *state, u8* random);

void CTR_DRBG(st_state *in_state, u8 *in, u8 *seed, u8 *random, u8 *re_add_data);

void Optimize_CTR_DRBG(st_state *in_state, u8 *in, u8 *seed, u8 *random, u8 *re_add_data, u8* LUK_Table);
void derived_function_Optimize(u8 *input_data, u8 *seed, u8* LUK_Table);



//! ARIA
void DL(const u8 *i, u8 *o);
void RotXOR(const u8 *s, int n, u8 *t);
int EncKeySetup(const u8 *w0, u8 *e, int keyBits);
void Crypt(const u8 *p, int R, const u8 *e, u8 *c);

#endif