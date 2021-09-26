.data

MASKING_TABLE:
    .word 0x01010101, 0x0F0F0F0F
    .word 0x1F1F1F1F, 0x03030303
    .word 0x07070707, 0x7F7F7F7F
    .word 0x3F3F3F3F, 0xFFFFFFFF

.text

//KEY ADD
.macro AddRoundKey PT0, PT1, PT2, PT3, PT4, PT5, PT6, PT7, TMP0, TMP1, TMP2, MK0, MK1, RCON, SHT, MSK

    xor \TMP1, \TMP1, \TMP1
    add  \TMP0, \MK0, zero
    and  \TMP2, \TMP0, \MSK
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    xor  \PT4, \PT4, \TMP1

    xor \TMP1, \TMP1, \TMP1
    srl \TMP0, \TMP0, \SHT
    and  \TMP2, \TMP0, \MSK
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    xor  \PT5, \PT5, \TMP1

    xor \TMP1, \TMP1, \TMP1
    srl \TMP0, \TMP0, \SHT
    and  \TMP2, \TMP0, \MSK
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    xor  \PT6, \PT6, \TMP1

    xor \TMP1, \TMP1, \TMP1
    srl \TMP0, \TMP0, \SHT
    and  \TMP2, \TMP0, \MSK
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    xor  \PT7, \PT7, \TMP1

    xor \TMP1, \TMP1, \TMP1//.......
    add  \TMP0, \MK1, zero
    and  \TMP2, \TMP0, \MSK
    xor  \TMP2, \TMP2, \RCON //+RCON
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    xor  \PT0, \PT0, \TMP1

    xor \TMP1, \TMP1, \TMP1
    srl \TMP0, \TMP0, \SHT
    and  \TMP2, \TMP0, \MSK
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    xor  \PT1, \PT1, \TMP1

    xor \TMP1, \TMP1, \TMP1
    srl \TMP0, \TMP0, \SHT
    and  \TMP2, \TMP0, \MSK
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    xor  \PT2, \PT2, \TMP1

    xor \TMP1, \TMP1, \TMP1
    srl  \TMP0, \TMP0, \SHT
    and  \TMP2, \TMP0, \MSK
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    sll  \TMP1, \TMP1, \SHT
    xor  \TMP1, \TMP1, \TMP2
    xor  \PT3, \PT3, \TMP1
.endm

//SLAYER
.macro sbox PT0, PT1, PT2, PT3, PT4, PT5, PT6, PT7, TMP0, TMP1, TMP2, TMP3, MSK, SHT
//S5_1
    and \TMP0, \PT7, \PT6 //X[5] ^= (X[7] & X[6]);
    xor \PT5, \PT5, \TMP0
    and \TMP0, \PT3, \PT5 //X[4] ^= (X[3] & X[5]);
    xor \PT4, \PT4, \TMP0
    xor \PT7, \PT7, \PT4 //X[7] ^= X[4];
    xor \PT6, \PT6, \PT3 //X[6] ^= X[3];
    or  \TMP0, \PT4, \PT5 //X[3] ^= (X[4] | X[5]);
    xor \PT3, \PT3, \TMP0
    xor \PT5, \PT5, \PT7 //X[5] ^= X[7];
    and \TMP0, \PT5, \PT6 //X[4] ^= (X[5] & X[6]);
    xor \PT4, \PT4, \TMP0
//S3
    and \TMP0, \PT1, \PT0 //X[2] ^= X[1] & X[0];
    xor \PT2, \PT2, \TMP0
    or  \TMP0, \PT2, \PT1 //X[0] ^= X[2] | X[1];
    xor \PT0, \PT0, \TMP0
    or  \TMP0, \PT2, \PT0 //X[1] ^= X[2] | X[0];
    xor \PT1, \PT1, \TMP0

    xor \TMP0, \TMP0, \TMP0 //X[2] = ~X[2];
    xor \TMP0, \TMP0, \MSK
    sll \TMP0, \TMP0, \SHT
    xor \TMP0, \TMP0, \MSK
    sll \TMP0, \TMP0, \SHT
    xor \TMP0, \TMP0, \MSK
    sll \TMP0, \TMP0, \SHT
    xor \TMP0, \TMP0, \MSK
    xor \PT2, \PT2, \TMP0

//Extend XOR
    xor \PT7, \PT7, \PT1 // X[7] ^= X[1];
    xor \PT3, \PT3, \PT2 // X[3] ^= X[2];
    xor \PT4, \PT4, \PT0 // X[4] ^= X[0];
//S5_2
    add \TMP0, \PT7, zero //T[0] = X[7];
    add \TMP1, \PT3, zero //T[1] = X[3];
    add \TMP2, \PT4, zero //T[2] = X[4];

    and \TMP3, \TMP0, \PT5 //X[6] ^= (T[0] & X[5]);
    xor \PT6, \PT6, \TMP3
    xor \TMP0, \TMP0, \PT6 //    T[0] ^= X[6];
    or  \TMP3, \TMP2, \TMP1  // X[6] ^= (T[2] | T[1]);
    xor \PT6, \PT6, \TMP3
    xor \TMP1, \TMP1, \PT5 // T[1] ^= X[5];
    or  \TMP3, \PT6, \TMP2 // X[5] ^= (X[6] | T[2]);
    xor \PT5, \PT5, \TMP3
    and \TMP3, \TMP1, \TMP0 // T[2] ^= (T[1] & T[0]);
    xor \TMP2, \TMP2, \TMP3

//Truncate XOR and bit change
    xor \PT2, \PT2, \TMP0
    xor \TMP0, \PT1, \TMP2
    xor \PT1, \PT0, \TMP1
    add \PT0, \PT7, zero
    add \PT7, \TMP0, zero
    add \TMP1, \PT3, zero
    add \PT3, \PT6, zero
    add \PT6, \TMP1, zero
    add \TMP2, \PT4, zero
    add \PT4, \PT5, zero
    add \PT5, \TMP2, zero
.endm

//PLAYER
.macro pbox PT0, PT1, PT2, PT3, PT4, PT5, PT6, PT7, TMP0, TMP1, TMP2, NOT, TABLE
    la \TABLE, MASKING_TABLE
    lw \NOT, 28(\TABLE)

    lw \TMP0, (\TABLE) //0x01010101
    and \TMP1, \PT1, \TMP0
    slli \TMP1, \TMP1, 7
    xor \TMP2, \TMP0, \NOT
    and \TMP2, \PT1, \TMP2
    srli \TMP2, \TMP2, 1
    or \PT1, \TMP1, \TMP2


    lw \TMP0, 4(\TABLE) //0x0F0F0F0F
    and \TMP1, \PT2, \TMP0
    slli \TMP1, \TMP1, 4
    xor \TMP2, \TMP0, \NOT
    and \TMP2, \PT2, \TMP2
    srli \TMP2, \TMP2, 4
    or \PT2, \TMP1, \TMP2

    lw \TMP0, 8(\TABLE) //0x1F1F1F1F
    and \TMP1, \PT3, \TMP0
    slli \TMP1, \TMP1, 3
    xor \TMP2, \TMP0, \NOT
    and \TMP2, \PT3, \TMP2
    srli \TMP2, \TMP2, 5
    or \PT3, \TMP1, \TMP2

    lw \TMP0, 12(\TABLE) //0x03030303
    and \TMP1, \PT4, \TMP0
    slli \TMP1, \TMP1, 6
    xor \TMP2, \TMP0, \NOT
    and \TMP2, \PT4, \TMP2
    srli \TMP2, \TMP2, 2
    or \PT4, \TMP1, \TMP2

    lw \TMP0, 16(\TABLE) //0x07070707
    and \TMP1, \PT5, \TMP0
    slli \TMP1, \TMP1, 5
    xor \TMP2, \TMP0, \NOT
    and \TMP2, \PT5, \TMP2
    srli \TMP2, \TMP2, 3
    or \PT5, \TMP1, \TMP2

    lw \TMP0, 20(\TABLE) //0x7F7F7F7F
    and \TMP1, \PT6, \TMP0
    slli \TMP1, \TMP1, 1
    xor \TMP2, \TMP0, \NOT
    and \TMP2, \PT6, \TMP2
    srli \TMP2, \TMP2, 7
    or \PT6, \TMP1, \TMP2

    lw \TMP0, 24(\TABLE) //0x3F3F3F3F
    and \TMP1, \PT7, \TMP0
    slli \TMP1, \TMP1, 2
    xor \TMP2, \TMP0, \NOT
    and \TMP2, \PT7, \TMP2
    srli \TMP2, \TMP2, 6
    or \PT7, \TMP1, \TMP2

.endm

//SHIFT TEXT
.macro shftL PT0, PT1, PT2, PT3, PT4, PT5, PT6, PT7, TMP
    sll \PT0, \PT0, \TMP
    sll \PT1, \PT1, \TMP
    sll \PT2, \PT2, \TMP
    sll \PT3, \PT3, \TMP
    sll \PT4, \PT4, \TMP
    sll \PT5, \PT5, \TMP
    sll \PT6, \PT6, \TMP
    sll \PT7, \PT7, \TMP
.endm

.macro shftR PT0, PT1, PT2, PT3, PT4, PT5, PT6, PT7, TMP
    srl \PT0, \PT0, \TMP
    srl \PT1, \PT1, \TMP
    srl \PT2, \PT2, \TMP
    srl \PT3, \PT3, \TMP
    srl \PT4, \PT4, \TMP
    srl \PT5, \PT5, \TMP
    srl \PT6, \PT6, \TMP
    srl \PT7, \PT7, \TMP
.endm

///////////////////////////////////////////////

/*REGISTER USING*/
// FUNCTION ARGUMENT : a0(PLAINTEXT) , a1(MASTERKEY)
// MASTER KEY : a4, a5, a6, a7
// PT : s2-s9
// TEMP : t3, t4, t5, t6
// RCON(ROUND#) : s11
// +1(0x01) : s10, SHIFT(0x08) : t0, 1BYTE MASKING(0xFF) : t1

.globl enc_round
.type enc_round, %function

.align 2

enc_round:

//SETTING
    li s10, 0x01 //for roundnum(+1)
    li t0, 0x08 //shift tmp
    li t1, 0xff //masking
    xor s11, s11, s11 //round_tmp(s11 = 0)

//LOAD DATA
    lw t3, 0(a0) //PT1
    lw t4, 4(a0)
    and s9, t3, t1
    srl t3, t3, t0
    and s8, t3, t1
    srl t3, t3, t0
    and s7, t3, t1
    srl t3, t3, t0
    and s6, t3, t1
    srl t3, t3, t0
    and s5, t4, t1
    srl t4, t4, t0
    and s4, t4, t1
    srl t4, t4, t0
    and s3, t4, t1
    srl t4, t4, t0
    and s2, t4, t1
    srl t4, t4, t0
    shftL s9, s8, s7, s6, s5, s4, s3, s2, t0

    lw t3, 8(a0) //PT2
    lw t4, 12(a0)
    and t5, t3, t1
    xor s9, s9, t5
    srl t3, t3, t0
    and t5, t3, t1
    xor s8, s8, t5
    srl t3, t3, t0
    and t5, t3, t1
    xor s7, s7, t5
    srl t3, t3, t0
    and t5, t3, t1
    xor s6, s6, t5
    srl t3, t3, t0
    and t5, t4, t1
    xor s5, s5, t5
    srl t4, t4, t0
    and t5, t4, t1
    xor s4, s4, t5
    srl t4, t4, t0
    and t5, t4, t1
    xor s3, s3, t5
    srl t4, t4, t0
    and t5, t4, t1
    xor s2, s2, t5
    srl t4, t4, t0
    shftL s9, s8, s7, s6, s5, s4, s3, s2, t0

    lw t3, 16(a0) //PT3
    lw t4, 20(a0)
    and t5, t3, t1
    xor s9, s9, t5
    srl t3, t3, t0
    and t5, t3, t1
    xor s8, s8, t5
    srl t3, t3, t0
    and t5, t3, t1
    xor s7, s7, t5
    srl t3, t3, t0
    and t5, t3, t1
    xor s6, s6, t5
    srl t3, t3, t0
    and t5, t4, t1
    xor s5, s5, t5
    srl t4, t4, t0
    and t5, t4, t1
    xor s4, s4, t5
    srl t4, t4, t0
    and t5, t4, t1
    xor s3, s3, t5
    srl t4, t4, t0
    and t5, t4, t1
    xor s2, s2, t5
    srl t4, t4, t0
    shftL s9, s8, s7, s6, s5, s4, s3, s2, t0

    lw t3, 24(a0) //PT4
    lw t4, 28(a0)
    and t5, t3, t1
    xor s9, s9, t5
    srl t3, t3, t0
    and t5, t3, t1
    xor s8, s8, t5
    srl t3, t3, t0
    and t5, t3, t1
    xor s7, s7, t5
    srl t3, t3, t0
    and t5, t3, t1
    xor s6, s6, t5
    srl t3, t3, t0
    and t5, t4, t1
    xor s5, s5, t5
    srl t4, t4, t0
    and t5, t4, t1
    xor s4, s4, t5
    srl t4, t4, t0
    and t5, t4, t1
    xor s3, s3, t5
    srl t4, t4, t0
    and t5, t4, t1
    xor s2, s2, t5
    srl t4, t4, t0
//END DATA LOAD

//LOAD MASTERKEY
    lw a4, (a1)
    lw a5, 4(a1)
    lw a6, 8(a1)
    lw a7, 12(a1)

//KEY ADD
    AddRoundKey s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, a4, a5, s11, t0, t1

//ROUND

    //0
    add s11, s11, s10
    sbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t1, t0
    pbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t2
    AddRoundKey s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, a6, a7, s11, t0, t1

    //1
    add s11, s11, s10
    sbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t1, t0
    pbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t2
    AddRoundKey s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, a4, a5, s11, t0, t1

    //2
    add s11, s11, s10
    sbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t1, t0
    pbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t2
    AddRoundKey s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, a6, a7, s11, t0, t1

    //3
    add s11, s11, s10
    sbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t1, t0
    pbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t2
    AddRoundKey s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, a4, a5, s11, t0, t1

    //4
    add s11, s11, s10
    sbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t1, t0
    pbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t2
    AddRoundKey s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, a6, a7, s11, t0, t1

    //5
    add s11, s11, s10
    sbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t1, t0
    pbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t2
    AddRoundKey s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, a4, a5, s11, t0, t1

    //6
    add s11, s11, s10
    sbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t1, t0
    pbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t2
    AddRoundKey s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, a6, a7, s11, t0, t1

    //7
    add s11, s11, s10
    sbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t1, t0
    pbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t2
    AddRoundKey s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, a4, a5, s11, t0, t1

    //8
    add s11, s11, s10
    sbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t1, t0
    pbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t2
    AddRoundKey s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, a6, a7, s11, t0, t1

    //9
    add s11, s11, s10
    sbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t1, t0
    pbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t2
    AddRoundKey s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, a4, a5, s11, t0, t1

    //10
    add s11, s11, s10
    sbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t1, t0
    pbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t2
    AddRoundKey s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, a6, a7, s11, t0, t1

    //11
    add s11, s11, s10
    sbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t1, t0
    pbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t2
    AddRoundKey s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, a4, a5, s11, t0, t1

    //12
    add s11, s11, s10
    sbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t1, t0
    pbox s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, t6, t2
    AddRoundKey s2, s3, s4, s5, s6, s7, s8, s9, t3, t4, t5, a6, a7, s11, t0, t1
//ROUND END

//STORE DATA
    sb s9, (a0) //CT1
    sb s8, 1(a0)
    sb s7, 2(a0)
    sb s6, 3(a0)
    sb s5, 4(a0)
    sb s4, 5(a0)
    sb s3, 6(a0)
    sb s2, 7(a0)
    shftR s2, s3, s4, s5, s6, s7, s8, s9, t0
    sb s9, 8(a0) //CT2
    sb s8, 9(a0)
    sb s7, 10(a0)
    sb s6, 11(a0)
    sb s5, 12(a0)
    sb s4, 13(a0)
    sb s3, 14(a0)
    sb s2, 15(a0)
    shftR s2, s3, s4, s5, s6, s7, s8, s9, t0
    sb s9, 16(a0) //CT3
    sb s8, 17(a0)
    sb s7, 18(a0)
    sb s6, 19(a0)
    sb s5, 20(a0)
    sb s4, 21(a0)
    sb s3, 22(a0)
    sb s2, 23(a0)
    shftR s2, s3, s4, s5, s6, s7, s8, s9, t0
    sb s9, 24(a0) //CT4
    sb s8, 25(a0)
    sb s7, 26(a0)
    sb s6, 27(a0)
    sb s5, 28(a0)
    sb s4, 29(a0)
    sb s3, 30(a0)
    sb s2, 31(a0)
//END STORE DATA

/**************Round END****************/
    ret

///////////////////////////////////////////////



