; Description: Keccak[r=1440,c=160] with n<=1440.
; Version 1 - June 2012.

#define rate		1440
#define capacity	160
#define output_size	rate

#include "init_update_final.asm"

;SELECT
#include "Keccak-f1600-compact.asm"
;#include "Keccak-f1600-fast.asm"
