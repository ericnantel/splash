
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       ROUTINE ASSEMBLY FILE           ;
;		FILENAME TILES.Z80.ASM  		;
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
;       LOAD TILE INDICES				;
;   INPUT	NONE						;
;   OUTPUT  NONE						;
;========================================
LoadTileIndices:
	
	; NOTE: Reading Level TD Start Offsets
	LD IX, (GLevelHBufferAddressLow)
	LD B, (IX+0) ;col offset
	LD C, (IX+1) ;row offset

	; NOTE: Calculating Tile Buffer Stride Offset
	; NOTE: Expecting start offsets to be in register pair BC
	; Result stored in (GTileIndexStrideOffset)
	LD D, (IX+2) ;col count
	LD A, DATA_LINE_LENGTH
	SUB D
	LD (GTileIndexStrideOffset), A

	; NOTE: Calculating Tile Buffer Start Offset
	; NOTE: Expecting start offsets to be in register pair BC
	; Result stored in HL
	LD D, 0
	LD E, C ;row x24 (DATA_LINE_LENGTH)
	LD H, D
	LD L, E
	ADD HL, DE
	ADD HL, DE
	ADD HL, HL
	ADD HL, HL
	ADD HL, HL
	LD D, 0
	LD E, B ;col
	ADD HL, DE

	; NOTE: Calculating Tile Buffer Start Address
	; NOTE: Expecting start offset in register pair HL
	; Result stored in DE
	LD DE, (GTileIndexBufferAddressLow)
	ADD HL, DE
	EX DE, HL

	; NOTE: Reading Level TD Buffer Start Address
	LD HL, (GLevelTDBufferAddressLow)

; TODO: Calculate Tile Buffer Stride (No Need for Level TD Buffer)

	LD A, (IX+3) ;row count
LROWLOOP:
	LD B, 0
	LD C, (IX+2) ;col count
	LDIR

	; LD B, A
	; LD A, (GTileIndexStrideOffset)
	; LD C, A
	; LD A, B
	; LD B, 0
	LD BC, (GTileIndexStrideOffset)
	LD B, 0

	EX DE, HL
	ADD HL, BC
	EX DE, HL

	DEC A
	JP NZ, LROWLOOP

	; This needs to change for smaller levels
	; LD HL, (GLevelTDBufferAddressLow)
	; LD DE, (GTileIndexBufferAddressLow)
	; LD BC, TILE_INDEX_BUFFER_LENGTH
	; LDIR
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

;========================================
;       CLEAR TILE IMAGE BUFFER			;
;   INPUT	NONE						;
;   OUTPUT  NONE						;
;========================================
ClearTileImageBuffer:
	LD BC, TILE_IMAGE_BLANK_OFFSET
	CALL LoadTileImage
	RET

;========================================
;       LOAD TILE IMAGE					;
;   INPUT	BC (TILES_OFFSET)			;
;   OUTPUT  NONE						;
;========================================
LoadTileImage:
	LD HL, GTileImages
	ADD HL, BC
	LD (GTileImageBufferAddressLow), HL
	RET

.end
