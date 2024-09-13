
;========================================
;       PROGRAM SPLASH					;
;       VERSION 1.0.0					;
;       ROUTINE ASSEMBLY FILE			;
;		FILENAME CAMERA.Z80.ASM			;
;       AUTHOR ERIC NANTEL				;
;		COUNTRY CANADA					;
;       COPYRIGHT 2023-2024				;
;		SOURCE CODE AVAILABLE ON		;
;		GITHUB.COM/ERICNANTEL/SPLASH	;
;========================================

;========================================
;       UPDATE CAMERA FLAGS       		;
;   INPUT   A (FLAGS)             		;
;   OUTPUT  NONE						;
;========================================
UpdateCameraFlags:
	LD (GCameraFlags), A
	RET

;========================================
;       UPDATE CAMERA WORLD COORDS		;
;   INPUT   BC (WORLD_X | WORLD_Y)		;
;   OUTPUT  NONE						;
;========================================
UpdateCameraWorldCoords:
	LD (GCameraWorldCoordY), BC
	CALL ConvertWorld2BitDistance
	LD (GCameraBitDistance), A
	RET

;========================================
;       UPDATE CAMERA WORLD OFFSETS		;
;   INPUT   BC (OFFSET_X | OFFSET_Y)	;
;   OUTPUT  NONE						;
;========================================
UpdateCameraWorldOffsets:
	LD (GCameraWorldOffsetY), BC
	RET

; TODO: Add WithinViewport Routine
; Add the other routines related to camera

.end
