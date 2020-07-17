; Description: Keccak[r=144,c=256] with n=256.
; Version 1 - June 2012.

#define rate 		144
#define capacity	256
#define output_size	256

#include "init_update_final.asm"

#include "Keccak-f400.asm"
