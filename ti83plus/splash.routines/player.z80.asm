
;========================================
;       PROGRAM SPLASH					;
;       VERSION 1.0.0					;
;       ROUTINE ASSEMBLY FILE			;
;		FILENAME PLAYER.Z80.ASM			;
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
;		UPDATE PLAYER FLAGS       		;
;	INPUT A (FLAGS)             		;
;	OUTPUT NONE							;
;========================================
UpdatePlayerFlags:
	LD (GPlayerFlags), A
	RET

;========================================
;		UPDATE PLAYER WORLD COORDS		;
;	INPUT BC (WORLD_X | WORLD_Y)		;
;	OUTPUT NONE							;
;========================================
UpdatePlayerWorldCoords:
	LD (GPlayerWorldCoordY), BC
	LD A, (GPlayerFlags)
	BIT PLAYER_ATTACH_FLAG, A
	RET Z
	LD DE, (GCameraWorldOffsetY)
	LD A, B
	SUB D
	LD B, A
	LD A, C
	SUB E
	LD C, A
	CALL UpdateCameraWorldCoords
	RET

.end
