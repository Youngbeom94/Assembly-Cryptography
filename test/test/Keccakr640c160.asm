; Description: Keccak[r=640,c=160] with n<=640.
; Version 1 - June 2012.

#define rate		640
#define capacity	160
#define output_size	rate

#include "init_update_final.asm"

#include "Keccak-f800.asm"
