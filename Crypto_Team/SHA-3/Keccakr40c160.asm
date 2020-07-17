; Description: Keccak[r=40,c=160] with n=160.
; Version 1 - June 2012.

#define rate		40
#define capacity	160
#define output_size	160

#include "init_update_final.asm"

#include "Keccak-f200.asm"
