
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       ROUTINE ASSEMBLY FILE			;
;		FILENAME INIT.Z80.ASM			;
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

InitGameplayRuntimes:
	LD BC, 0
	LD (GCameraWorldCoordY), BC

	LD BC, 256*47+31
	LD (GCameraWorldOffsetY), BC

	LD BC, 256*SCREEN_WIDTH+SCREEN_HEIGHT
	LD (GCameraViewportSizeY), BC

	XOR A
	SET CAMERA_VISIBLE_FLAG, A
	CALL UpdateCameraFlags

	LD BC, 0
	CALL UpdateCameraWorldCoords

	LD BC, 256*47+31
	CALL UpdateCameraWorldOffsets

	LD BC, 256*48+32
	LD (GPlayerWorldCoordY), BC
	
	XOR A
	SET PLAYER_VISIBLE_FLAG, A
	SET PLAYER_ATTACH_FLAG, A
	CALL UpdatePlayerFlags

	LD BC, 256*48+32
	CALL UpdatePlayerWorldCoords

	RET

.end
