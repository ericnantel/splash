
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
