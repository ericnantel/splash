
;========================================
;       PROGRAM SPLASH					;
;       VERSION 1.0.0					;
;       ROUTINE ASSEMBLY FILE			;
;		FILENAME CONVERSIONS.Z80.ASM	;
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
;       CONVERT WORLD TO BIT DISTANCE	;
;   INPUT   BC (WORLD_X | 0)			;
;   OUTPUT  A (BIT DISTANCE)			;
;========================================
ConvertWorld2BitDistance:
#ifdef USE_BIT_DISTANCE_LOOP
	LD A, B
	LD C, 8
LBitDistance_Loop:
	AND 11111000b
	JR Z, LBitDistance_End
	LD A, B
	SUB C
	LD B, A
	JR LBitDistance_Loop
LBitDistance_End:
	LD A, B
#else
	LD A, B					;4ticks
	AND %00000111			;4ticks = 8ticks
	; WORKS BUT NOT THE FASTEST FOR MOD8
	; LD C, 00011111b		;4ticks
	; LD A, B				;4ticks
	; RRA					;4ticks
	; RRA					;4ticks
	; RRA					;4ticks
	; AND C				;4ticks
	; ADD A, A			;4ticks
	; ADD A, A			;4ticks
	; ADD A, A			;4ticks
	; LD C, A				;4ticks
	; LD A, B				;4ticks
	; SUB C				;4ticks = 48ticks
#endif
	RET

;========================================
;       CONVERT WORLD TO CACHE COORD X	;
;   INPUT   A (WORLD_X)					;
;   OUTPUT  A (CACHE_X)					;
;========================================
ConvertWorld2CacheCoordX:
	RRA					;4ticks
	RRA					;4ticks
	RRA					;4ticks
	AND 00011111b		;4ticks = 16ticks
	RET

;========================================
;       CONVERT WORLD TO CACHE COORD Y	;
;   INPUT   A (WORLD_Y)					;
;   OUTPUT  A (CACHE_Y)					;
;========================================
ConvertWorld2CacheCoordY:
	; NOTE: Leave empty
	RET

;========================================
;       CONVERT CACHE TO WORLD COORD X	;
;   INPUT   A (CACHE_X)					;
;   OUTPUT  A (WORLD_X)					;
;========================================
ConvertCache2WorldCoordX:
	RLA					;4ticks
	RLA					;4ticks
	RLA					;4ticks
	AND 11111000b		;4ticks = 16ticks
	RET

;========================================
;       CONVERT CACHE TO WORLD COORD Y	;
;   INPUT   A (CACHE_Y)					;
;   OUTPUT  A (WORLD_Y)					;
;========================================
ConvertCache2WorldCoordY:
	; NOTE: Leave empty
	RET

;========================================
;		CONVERT WORLD TO SCREEN COORDS	;
;	INPUT BC (WORLD_X | WORLD_Y)		;
;	OUTPUT DE (SCREEN_X | SCREEN_Y)		;
;========================================
ConvertWorld2ScreenCoords:
	; NOTE: May cause issue ..
	; Perhaps it is best to check if within viewport
	LD DE, (GCameraWorldCoordY)	;20ticks
	LD A, B						;4ticks
	SUB D						;4ticks
	LD D, A						;4ticks
	LD A, C						;4ticks
	SUB E						;4ticks
	LD E, A						;4ticks = 44ticks
	RET

;========================================
;		CONVERT SCREEN TO WORLD COORDS	;
;	INPUT BC (SCREEN_X | SCREEN_Y)		;
;	OUTPUT DE (WORLD_X | WORLD_Y)		;
;========================================
ConvertScreen2WorldCoords:
	LD DE, (GCameraWorldCoordY)	;20ticks
	LD A, D						;4ticks
	ADD A, B					;4ticks
	LD D, A						;4ticks
	LD A, E						;4ticks
	ADD A, C					;4ticks
	LD E, A						;4ticks = 44ticks
	RET

; TODO: Grid Coord System & Tile Indexing
; A Map will have up to 4 layer
; Each can theorically have up to 255 tiles
; But it could be less, each tiles will
; have an ID in a grid or cluster system
; the id is to quickly find a tile by ID
; but also to draw a map layer quickly
; to the cache buffer when loading a level

; TODO: Matrix coord fit in a single byte
; a col index 0-15; row index 0-15
; we need to write a pack and unpack rout.

.end
