
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
;   INPUT	A (LEVEL_INDEX)				;
;   OUTPUT  NONE						;
;========================================
LoadLevelTest:

	CALL LoadLevelOffsetsByIndex

	LD A, TILE_IMAGE_BLANK_INDEX ;XOR A
	CALL ClearTileIndexBuffer
	CALL LoadTileIndices
	
	LD B, DATA_LINE_LENGTH ;Col Count
	LD C, 0 ;Col Index

LDrawGridCol1:
	PUSH BC

	LD HL, (GCacheBufferAddressLow)
	LD B, 0
	ADD HL, BC
	EX DE, HL

	LD IX, (GTileIndexBufferAddressLow)
	ADD IX, BC

	LD A, TILES_PER_DATA_COLUMNS
LDrawGridRow1:
	PUSH AF

LLoadTile:

	; NOTE: Loading Tile Image From Tile Index
	LD H, 0
	LD L, (IX)
	ADD HL, HL ;x8 (TILE_IMAGE_LENGTH)
	ADD HL, HL
	ADD HL, HL
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
	LD C, DATA_LINE_LENGTH
	ADD IX, BC

	POP AF
	DEC A
	JR NZ, LDrawGridRow1

	POP BC
	INC C
	DJNZ LDrawGridCol1

	RET

.end
