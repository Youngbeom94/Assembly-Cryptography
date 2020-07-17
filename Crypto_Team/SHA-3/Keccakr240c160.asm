; Description: Keccak[r=240,c=160] with n<=240.
; Version 1 - June 2012.

#define rate		240
#define capacity	160
#define output_size	rate

#include "init_update_final.asm"

#include "Keccak-f400.asm"
