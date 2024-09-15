
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

;========================================
;       ASSERT ENOUGH FREE MEMORY    	;
;   INPUT   NONE            			;
;   OUTPUT  F (CARRY)       			;
;========================================
AssertEnoughFreeMemory:
	LD HL, FREE_MEMORY_NEEDED
	bcall(_EnoughMem)
	RET

;========================================
;       INIT RUNTIMES					;
;   INPUT   NONE            			;
;   OUTPUT  NONE            			;
;========================================
InitRuntimes:
	LD BC, 0
	LD (GCameraWorldCoordY), BC

	LD BC, 256*48+32
	LD (GCameraWorldOffsetY), BC

	LD BC, 256*SCREEN_WIDTH+SCREEN_HEIGHT
	LD (GCameraViewportSizeY), BC

	XOR A
	SET CAMERA_VISIBLE_FLAG, A
	CALL UpdateCameraFlags

	LD BC, 0
	CALL UpdateCameraWorldCoords

	LD BC, 256*48+32
	CALL UpdateCameraWorldOffsets

	LD BC, 256*48+32
	LD (GPlayerWorldCoordY), BC
	
	XOR A
	SET PLAYER_VISIBLE_FLAG, A
	SET PLAYER_ATTACH_FLAG, A
	CALL UpdatePlayerFlags

	LD BC, 256*48+32
	CALL UpdatePlayerWorldCoords

	XOR A
	LD (GGameplayInputFlags), A

	LD HL, (_FreeMemStart)
	LD (GBufferStartAddressLow), HL

	LD HL, (_FreeMemEnd)
	LD (GBufferEndAddressLow), HL

	LD DE, (GBufferStartAddressLow)
	LD H, D
	LD L, E
	LD BC, CACHE_LINE_OFFSET
	ADD HL, BC
	LD (GCacheLineAddressLow), HL

	; NOTE: Initializing cache line extra byte
	INC HL
	LD (HL), 0

	INC HL
	; LD H, D
	; LD L, E
	LD BC, CACHE_BUFFER_OFFSET
	ADD HL, BC
	LD (GCacheBufferAddressLow), HL

	XOR A
	CALL ClearCacheLine
	CALL ClearCacheBuffer

	RET

.end
