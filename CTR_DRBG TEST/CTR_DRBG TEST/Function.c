#include "header.h"

void derived_function(u8 *input_data, u8 *seed)
{
    volatile int cnt_i = 0, cnt_j = 0, cnt_k = 0;
    u8 CBC_KEY[32] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f};
    u8 chain_value[BLOCK_SIZE] = {0x00};
    u8 KEYandV[LEN_SEED * BLOCK_SIZE] = {0x00};
    u8 in[DF_INPUT_LEN] = {0x00};

    for (cnt_i = 0; cnt_i < INSTANCE_INPUT; cnt_i++)
    {
        in[cnt_i + 24] = input_data[cnt_i];
    }
    in[cnt_i] = N_CONSTANT;
    in[19] = INSTANCE_INPUT;
    in[23] = N_DF;
    in[24 + INSTANCE_INPUT] = 0x80;

    u8 state[BLOCK_SIZE] = {0x00};
    /*
    * AVR function Setting
    */
    u8 round_key[16 * 17] = {0x00};

    //! step1
    for (cnt_j = 0; cnt_j < LEN_SEED; cnt_j++)
    {
        for (cnt_i = 0; cnt_i < DF_INPUT_LEN / 16; cnt_i++)
        {
            set_state(state, in, 16 * cnt_i);
            XoR(state, chain_value, BLOCK_SIZE);
            //!Function
           //Crypt(state, EncKeySetup(CBC_KEY, round_key, 128), round_key, chain_value);
        }
        copy_state(KEYandV, chain_value, cnt_j);
        clear(chain_value, BLOCK_SIZE);
        in[3]++;
    }

    //! step2
    u8 key[16] = {0x00};
    for (cnt_i = 0; cnt_i < KEY_SIZE; cnt_i++)
    {
        key[cnt_i] = KEYandV[cnt_i];
    }
    for (cnt_i = KEY_SIZE; cnt_i < SEED_LEN; cnt_i++)
    {
        state[cnt_i] = KEYandV[cnt_i];
    }

    for (cnt_i = 0; cnt_i < LEN_SEED; cnt_i++)
    {
        //!Function
        //Crypt(state, EncKeySetup(key, round_key, 128), round_key, chain_value);
        for (cnt_j = 0; cnt_j < BLOCK_SIZE; cnt_j++)
        {
            seed[cnt_i * BLOCK_SIZE + cnt_j] = chain_value[cnt_j];
            state[cnt_j] = chain_value[cnt_j];
        }
    }
}

void update_first_call(st_state *state, u8 *seed)
{
    volatile int cnt_i = 0, cnt_j = 0, cnt_k = 0;
    u8 result[BLOCK_SIZE] = {0x00};
    u8 temp[SEED_LEN] = {0x00};

    /*
    * AVR function Setting
    */
   // u8 round_key[(KEY_BIT / 8) * 17] = {0x00};

    for (cnt_i = 0; cnt_i < LEN_SEED; cnt_i++)
    {
        state->V[BLOCK_SIZE - 1]++;
        //! Function
        //Crypt(state->V, EncKeySetup(state->key, round_key, KEY_BIT), round_key, result);
        for (cnt_j = 0; cnt_j < BLOCK_SIZE; cnt_j++)
        {
            temp[cnt_i * BLOCK_SIZE + cnt_j] = result[cnt_j];
        }
    }
    for (cnt_i = 0; cnt_i < KEY_SIZE; cnt_i++)
    {
        state->key[cnt_i] = temp[cnt_i] ^ seed[cnt_i];
    }
    for (cnt_i = 0; cnt_i < BLOCK_SIZE; cnt_i++)
    {
        state->V[cnt_i] = temp[KEY_SIZE + cnt_i] ^ seed[KEY_SIZE + cnt_i];
    }
	
}
void update(st_state *state, u8 *seed, u8 *add_data)
{
    volatile int cnt_i = 0, cnt_j = 0, cnt_k = 0;
    u8 result[BLOCK_SIZE] = {0x00};
    u8 temp[SEED_LEN] = {0x00};

    /*
    * AVR function Setting
    */
   // u8 round_key[(KEY_BIT / 8) * 17] = {0x00};

    for (cnt_i = 0; cnt_i < LEN_SEED; cnt_i++)
    {
        state->V[BLOCK_SIZE - 1]++;
        //! Function
        //Crypt(state->V, EncKeySetup(state->key, round_key, KEY_BIT), round_key, result);
        for (cnt_j = 0; cnt_j < BLOCK_SIZE; cnt_j++)
        {
            temp[cnt_i * BLOCK_SIZE + cnt_j] = result[cnt_j];
        }
    }
    for (cnt_i = 0; cnt_i < KEY_SIZE; cnt_i++)
    {
        state->key[cnt_i] = temp[cnt_i] ^ seed[cnt_i];
    }
    for (cnt_i = 0; cnt_i < BLOCK_SIZE; cnt_i++)
    {
        state->V[cnt_i] = temp[KEY_SIZE + cnt_i] ^ seed[KEY_SIZE + cnt_i];
    }

#if ((ADD_DATA_LEN > 0) && (ADD_DATA_LEN <= KEY_SIZE))
    for (cnt_i = 0; cnt_i < KEY_SIZE; cnt_i++)
    {
        state->key[cnt_i] ^= add_data[cnt_i];
    }
#elif (ADD_DATA_LEN > KEY_SIZE)
    for (cnt_i = 0; cnt_i < KEY_SIZE; cnt_i++)
    {
        state->key[cnt_i] ^= add_data[cnt_i];
    }
    for (cnt_i = 0; cnt_i < ADD_DATA_LEN - KEY_SIZE; cnt_i++)
    {

        state->V[cnt_i] ^= add_data[KEY_SIZE + cnt_i];
    }
#endif
}

void generate_Random(st_state *state, u8 *random, u8 *re_add_data)
{
    volatile int cnt_i = 0, cnt_j = 0, cnt_k = 0;
    u8 seed[SEED_LEN] = {0x00};

    if (state->prediction_flag == TRUE)
    {
        Reseed_Function(state, re_add_data);
        Output(state, random);
        copy_state_seed(seed, state);
        update_first_call(state, seed);
    }
    else
    {
        Output(state, random);
        copy_state_seed(seed, state);
        update_first_call(state, seed);
    }
    state->Reseed_counter++;
}

void Reseed_Function(st_state *state, u8 *Reseed_AddData)
{
    if (Reseed_AddData == NULL)
        return;

    volatile int cnt_i = 0, cnt_j = 0, cnt_k = 0;
    u8 CBC_KEY[32] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f};
    u8 chain_value[BLOCK_SIZE] = {0x00};
    u8 KEYandV[LEN_SEED * BLOCK_SIZE] = {0x00};
    u8 in[RESEED_INPUT_LEN] = {0x00};

    for (cnt_i = 0; cnt_i < RESEED_ADD_DATA_LEN; cnt_i++)
    {
        in[cnt_i + 24] = Reseed_AddData[cnt_i];
    }
    in[cnt_i] = N_CONSTANT;
    in[19] = RESEED_ADD_DATA_LEN;
    in[23] = N_DF;
    in[24 + RESEED_ADD_DATA_LEN] = 0x80;

    u8 state2[BLOCK_SIZE] = {0x00};
    /*
    * AVR function Setting
    */
    //u8 round_key[16 * 17] = {0x00};

    //! step1
    for (cnt_j = 0; cnt_j < LEN_SEED; cnt_j++)
    {
        for (cnt_i = 0; cnt_i < RESEED_INPUT_LEN / 16; cnt_i++)
        {
            set_state(state2, in, 16 * cnt_i);
            XoR(state2, chain_value, BLOCK_SIZE);
            //!Function
            //Crypt(state2, EncKeySetup(CBC_KEY, round_key, 128), round_key, chain_value);
        }
        copy_state(KEYandV, chain_value, cnt_j);
        clear(chain_value, BLOCK_SIZE);
        in[3]++;
    }

    //! step2
    u8 key[16] = {0x00};
    for (cnt_i = 0; cnt_i < KEY_SIZE; cnt_i++)
    {
        key[cnt_i] = KEYandV[cnt_i];
    }
    for (cnt_i = KEY_SIZE; cnt_i < SEED_LEN; cnt_i++)
    {
        state2[cnt_i] = KEYandV[cnt_i];
    }

    u8 temp[SEED_LEN] = {0x00};
    for (cnt_i = 0; cnt_i < LEN_SEED; cnt_i++)
    {
        //!Function
        //Crypt(state2, EncKeySetup(key, round_key, 128), round_key, chain_value);
        for (cnt_j = 0; cnt_j < BLOCK_SIZE; cnt_j++)
        {
            temp[cnt_i * BLOCK_SIZE + cnt_j] = chain_value[cnt_j];
            state2[cnt_j] = chain_value[cnt_j];
        }
    }
    update_first_call(state, temp);
}

void Output(st_state *state, u8 *random)
{
    volatile int cnt_i = 0, cnt_j = 0, cnt_k = 0;
    u8 result[BLOCK_SIZE] = {0x00};

    /*
    * AVR function Setting
    */
    u8 round_key[(KEY_BIT / 8) * 17] = {0x00};

    for (cnt_i = 0; cnt_i < (RANDOM_LEN / BLOCK_SIZE); cnt_i++)
    {
        state->V[BLOCK_SIZE - 1]++;
        //! Function
        //Crypt(state->V, EncKeySetup(state->key, round_key, KEY_BIT), round_key, result);
        for (cnt_j = 0; cnt_j < BLOCK_SIZE; cnt_j++)
        {
            random[cnt_i * BLOCK_SIZE + cnt_j] = result[cnt_j];
        }
    }
}
void CTR_DRBG(st_state *in_state, u8 *in, u8 *seed, u8 *random, u8 *re_add_data)
{
    //derived_function(in, seed);
    //update_first_call(in_state, seed);
    //generate_Random(in_state, random,re_add_data);
}

void XoR(u8 *drc, u8 *src, int len)
{
    for (volatile int cnt_i = 0; cnt_i < len; cnt_i++)
    {
        drc[cnt_i] ^= src[cnt_i];
    }
}
void set_state(u8 *drc, u8 *src, int start)
{
    for (volatile int cnt_i = 0; cnt_i < BLOCK_SIZE; cnt_i++)
    {
        drc[cnt_i] = src[start + cnt_i];
    }
}
void copy_state(u8 *drc, u8 *src, int len)
{
    for (volatile int cnt_i = 0; cnt_i < BLOCK_SIZE; cnt_i++)
    {
        drc[16 * len + cnt_i] = src[cnt_i];
    }
}
void copy_state_seed(u8 *drc, st_state *src)
{
    for (volatile int cnt_i = 0; cnt_i < KEY_SIZE; cnt_i++)
    {
        drc[cnt_i] = src->key[cnt_i];
    }
    for (volatile int cnt_i = 0; cnt_i < BLOCK_SIZE; cnt_i++)
    {
        drc[KEY_SIZE + cnt_i] = src->V[cnt_i];
    }
}
void copy(u8 *drc, u8 *src)
{
    for (volatile int cnt_i = 0; cnt_i < BLOCK_SIZE; cnt_i++)
    {
        drc[cnt_i] = src[cnt_i];
    }
}
void clear(u8 *src, int len)
{
    for (volatile int cnt_i = 0; cnt_i < len; cnt_i++)
    {
        src[cnt_i] = 0x00;
    }
}
void Show_State(st_state *state)
{
    volatile int cnt_i = 0;

    for (cnt_i = 0; cnt_i < KEY_SIZE; cnt_i++)
    {
        printf("%02X ", state->key[cnt_i]);
    }
    printf("\n");
    for (cnt_i = 0; cnt_i < BLOCK_SIZE; cnt_i++)
    {
        printf("%02X ", state->V[cnt_i]);
    }
}
void Show_Random_number(u8* random)
{
    for(volatile int cnt_i = 0 ; cnt_i < RANDOM_LEN ; cnt_i ++)
    {
        printf("%02X ", random[cnt_i]);
    }
    printf("\n");
}