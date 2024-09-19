
;========================================
;       PROGRAM SPLASH					;
;       VERSION 1.0.0					;
;       ROUTINE ASSEMBLY FILE			;
;		FILENAME CACHE.Z80.ASM			;
;       AUTHOR ERIC NANTEL				;
;		COUNTRY CANADA					;
;       COPYRIGHT 2023-2024				;
;		SOURCE CODE AVAILABLE ON		;
;		GITHUB.COM/ERICNANTEL/SPLASH	;
;========================================

.NOLIST
;========================================
;       NO LISTING                      ;
;========================================
.LIST

;========================================
;       CLEAR CACHE LINE				;
;   INPUT	A (CLEAR_VALUE)				;
;   OUTPUT  NONE						;
;========================================
ClearCacheLine:
	LD HL, (GCacheLineAddressLow)
	LD D, H
	LD E, L
	INC DE
	LD (HL), A
	LD BC, CACHE_LINE_LENGTH-1
	LDIR
	RET

;========================================
;       CLEAR CACHE BUFFER				;
;   INPUT	A (CLEAR_VALUE)				;
;   OUTPUT  NONE						;
;========================================
ClearCacheBuffer:
	LD HL, (GCacheBufferAddressLow)
	LD D, H
	LD E, L
	INC DE
	LD (HL), A
	LD BC, CACHE_BUFFER_LENGTH-1
	LDIR
	RET

;========================================
;       CLEAR TILE INDEX BUFFER			;
;   INPUT	A (CLEAR_TILE_INDEX)		;
;   OUTPUT  NONE						;
;========================================
ClearTileIndexBuffer:
	LD HL, (GTileIndexBufferAddressLow)
	LD D, H
	LD E, L
	INC DE
	LD (HL), A
	LD BC, TILE_INDEX_BUFFER_LENGTH-1
	LDIR
	RET

.end
