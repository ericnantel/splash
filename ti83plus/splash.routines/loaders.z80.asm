
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       ROUTINE ASSEMBLY FILE           ;
;		FILENAME LOADERS.Z80.ASM		;
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

;========================================
;       LOAD LEVEL						;
;   INPUT	TODO:NONE					;
;   OUTPUT  NONE						;
;========================================
LoadLevelTest:

	CALL LoadTileIndices
	
	LD B, CACHE_LINE_LENGTH ;Col Count
	LD C, 0 ;Col Index

LDrawGridCol1:
	PUSH BC

	LD HL, (GCacheBufferAddressLow)
	LD B, 0
	ADD HL, BC
	EX DE, HL

	LD IX, (GTileIndexBufferAddressLow)
	ADD IX, BC

	LD A, TILES_PER_CACHE_COLUMNS
LDrawGridRow1:
	PUSH AF

LLoadTile:

	; NOTE: Loading Tile Image From Tile Index
	LD H, 0
	LD L, (IX)
	ADD HL, HL
	ADD HL, HL
	ADD HL, HL ;x8
	;ADD HL, HL x16
	LD B, H
	LD C, L
	CALL LoadTileImage

LDrawTile1:
	LD HL, (GTileImageBufferAddressLow)

	LD B, TILE_HEIGHT
	; LD D, 0
	; LD E, CACHE_LINE_LENGTH ;offset

LDrawTileRow1:
	LD C, (HL)
	EX DE, HL
	LD (HL), C
	LD A, B
	LD B, 0
	LD C, CACHE_LINE_LENGTH
	ADD HL, BC
	EX DE, HL
	INC HL
	LD B, A
	DJNZ LDrawTileRow1
; LDrawTileRow1:
; 	LD C, (HL)
; 	LD (IX), C
; 	ADD IX, DE
; 	INC HL
; 	DJNZ LDrawTileRow1

	LD B, 0
	LD C, CACHE_LINE_LENGTH
	ADD IX, BC

	POP AF
	DEC A
	JR NZ, LDrawGridRow1

	POP BC
	INC C
	DJNZ LDrawGridCol1

	RET

;========================================
;       LOAD TILE INDICES				;
;   INPUT	TODO:NONE					;
;   OUTPUT  NONE						;
;========================================
LoadTileIndices:
; TODO: We need to load the header and update tile index buffer properly with tile data
	LD BC, 2;0 TEMP ! We need to load header and tiledata
	LD HL, GLevels
	ADD HL, BC
	LD DE, (GTileIndexBufferAddressLow)
	LD BC, TILE_INDEX_BUFFER_LENGTH
	LDIR
	RET

;		TODO:
;		OVERLAY SPRITE
; NOTE: AND GSpriteMask
;		OR  GSpriteImg

