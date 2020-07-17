; Description: Keccak[r=1088,c=512] with n<=1088.
; Version 1 - June 2012.

#define rate		1088
#define capacity	512
#define output_size	rate

#include "init_update_final.asm"

;SELECT
#include "Keccak-f1600-compact.asm"
;#include "Keccak-f1600-fast.asm"
