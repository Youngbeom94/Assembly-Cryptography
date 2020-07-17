; Description: Keccak[r=1344,c=256] with n<=1344.
; Version 1 - June 2012.

#define rate		1344
#define capacity	256
#define output_size	rate

#include "init_update_final.asm"

;SELECT
#include "Keccak-f1600-compact.asm"
;#include "Keccak-f1600-fast.asm"
