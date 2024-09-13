
;========================================
;       PROGRAM SPLASH					;
;       VERSION 1.0.0					;
;       RUNTIME ASSEMBLY FILE			;
;		FILENAME GAMEPLAY.Z80.ASM		;
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
GCameraWorldCoordY		EQU _AppBuffer + 0
GCameraWorldCoordX		EQU _AppBuffer + 1
GCameraBitDistance		EQU _AppBuffer + 2
GCameraWorldOffsetY		EQU _AppBuffer + 3
GCameraWorldOffsetX		EQU _AppBuffer + 4
GCameraViewportSizeY	EQU _AppBuffer + 5
GCameraViewportSizeX	EQU _AppBuffer + 6
GCameraFlags			EQU	_APPBuffer + 7
GPlayerWorldCoordY		EQU	_AppBuffer + 8
GPlayerWorldCoordX		EQU _AppBuffer + 9
GPlayerFlags			EQU _AppBuffer + 10

CAMERA_VISIBLE_FLAG		EQU 0
PLAYER_VISIBLE_FLAG		EQU 0
PLAYER_ATTACH_FLAG		EQU 1

.LIST

.end
