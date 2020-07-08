; Description: Keccak[r=544,c=256] with n<=544.
; Version 1 - June 2012.

#define rate		544
#define capacity	256
#define output_size	rate

#include "init_update_final.asm"

#include "Keccak-f800.asm"

