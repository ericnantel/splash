
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       ROUTINE ASSEMBLY FILE           ;
;		FILENAME LEVELS.Z80.ASM			;
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
;       LOAD LEVEL OFFSETS BY INDEX		;
;   INPUT	A (LEVEL_INDEX)				;
;   OUTPUT  NONE						;
;========================================
LoadLevelOffsetsByIndex:
	ADD A, A ;x2 (OFFSET_LENGTH)
	LD B, 0
	LD C, A

	; NOTE: Notice how we read a DW

	LD HL, GLevelHeaderOffsets
	ADD HL, BC
	LD E, (HL)
	INC HL
	LD D, (HL)
	LD HL, GLevels
	ADD HL, DE
	LD (GLevelHBufferAddressLow), HL

	LD HL, GLevelTileDataOffsets
	ADD HL, BC
	LD E, (HL)
	INC HL
	LD D, (HL)
	LD HL, GLevels
	ADD HL, DE
	LD (GLevelTDBufferAddressLow), HL

	RET

;========================================
;       CLEAR LEVEL HEADER BUFFER		;
;   INPUT	NONE						;
;   OUTPUT  NONE						;
;========================================
ClearLevelHeaderBuffer:
	LD BC, LVL_THALASLAND_H_OFFSET
	CALL LoadLevelHeader
	RET

;========================================
;       CLEAR LEVEL TILEDATA BUFFER		;
;   INPUT	NONE						;
;   OUTPUT  NONE						;
;========================================
ClearLevelTileDataBuffer:
	LD BC, LVL_THALASLAND_TD_OFFSET
	CALL LoadLevelTileData
	RET

;========================================
;       LOAD LEVEL HEADER				;
;   INPUT	BC (LEVELS_HEADER_OFFSET)	;
;   OUTPUT  NONE						;
;========================================
LoadLevelHeader:
	LD HL, GLevels
	ADD HL, BC
	LD (GLevelHBufferAddressLow), HL
	RET

;========================================
;       LOAD LEVEL TILE DATA			;
;   INPUT	BC (LEVELS_TILEDATA_OFFSET)	;
;   OUTPUT  NONE						;
;========================================
LoadLevelTileData:
	LD HL, GLevels
	ADD HL, BC
	LD (GLevelTDBufferAddressLow), HL
	RET

.end
