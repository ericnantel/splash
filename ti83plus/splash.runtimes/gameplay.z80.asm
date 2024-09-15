
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
GCameraWorldCoordY				EQU _AppBuffer + 0
GCameraWorldCoordX				EQU _AppBuffer + 1
GCameraBitDistance				EQU _AppBuffer + 2
GCameraWorldOffsetY				EQU _AppBuffer + 3
GCameraWorldOffsetX				EQU _AppBuffer + 4
GCameraViewportSizeY			EQU _AppBuffer + 5
GCameraViewportSizeX			EQU _AppBuffer + 6
GCameraFlags					EQU	_AppBuffer + 7
GPlayerWorldCoordY				EQU	_AppBuffer + 8
GPlayerWorldCoordX				EQU _AppBuffer + 9
GPlayerFlags					EQU _AppBuffer + 10
GGameplayInputFlags				EQU _AppBuffer + 11
GBufferStartAddressLow			EQU _AppBuffer + 12
GBufferStartAddressHigh			EQU _AppBuffer + 13
GBufferEndAddressLow			EQU _AppBuffer + 14
GBufferEndAddressHigh			EQU _AppBuffer + 15
GCacheLineAddressLow			EQU _AppBuffer + 16
GCacheLineAddressHigh			EQU _AppBuffer + 17
GCacheBufferAddressLow			EQU _AppBuffer + 18
GCacheBufferAddressHigh			EQU _AppBuffer + 19

CAMERA_VISIBLE_FLAG				EQU 0
PLAYER_VISIBLE_FLAG				EQU 0
PLAYER_ATTACH_FLAG				EQU 1
GAMEPLAY_INPUT_KEY_DOWN_FLAG	EQU 0
GAMEPLAY_INPUT_KEY_LEFT_FLAG	EQU 1
GAMEPLAY_INPUT_KEY_RIGHT_FLAG	EQU 2
GAMEPLAY_INPUT_KEY_UP_FLAG		EQU 3
GAMEPLAY_INPUT_KEY_ALPHA_FLAG	EQU 4
GAMEPLAY_INPUT_KEY_2ND_FLAG		EQU 5
GAMEPLAY_INPUT_KEY_MODE_FLAG	EQU 6
GAMEPLAY_INPUT_KEY_DEL_FLAG		EQU 7

.LIST

.end
