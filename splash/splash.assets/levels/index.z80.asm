
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       INDEX ASSEMBLY FILE             ;
;		FILENAME INDEX.Z80.ASM			;
;       AUTHOR ERIC NANTEL              ;
;		COUNTRY CANADA					;
;       COPYRIGHT 2023-2024             ;
;		SOURCE CODE AVAILABLE ON		;
;		GITHUB.COM/ERICNANTEL/SPLASH	;
;========================================

.NOLIST
;========================================
;       NO LISTING                      ;
;========================================
.LIST

GLevels:
	#include "splash.assets/levels/thalasland.z80.asm"
	#include "splash.assets/levels/thalashome.z80.asm"
	#include "splash.assets/levels/thalascastle.z80.asm"
	#include "splash.assets/levels/thalascave.z80.asm"

GLevelHeaderOffsets:
	.DW LVL_THALASLAND_H_OFFSET
	.DW LVL_THALASHOME_H_OFFSET
	.DW LVL_THALASCASTLE_H_OFFSET
	.DW LVL_THALASCAVE_H_OFFSET

GLevelTileDataOffsets:
	.DW LVL_THALASLAND_TD_OFFSET
	.DW LVL_THALASHOME_TD_OFFSET
	.DW LVL_THALASCASTLE_TD_OFFSET
	.DW LVL_THALASCAVE_TD_OFFSET

.end
