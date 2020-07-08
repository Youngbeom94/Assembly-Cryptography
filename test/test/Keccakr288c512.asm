; Description: Keccak[r=288,c=512] with n<=288.
; Version 1 - June 2012.

#define rate		288
#define capacity	512
#define output_size	rate

#include "init_update_final.asm"

#include "Keccak-f800.asm"
