
;========================================
;       PROGRAM SPLASH                  ;
;       VERSION 1.0.0                   ;
;       INDEX ASSEMBLY FILE             ;
;		FILENAME INDEX.Z80.ASM			;
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
; #define USE_BIT_DISTANCE_LOOP
.LIST

#include "splash.routines/cache.z80.asm"
#include "splash.routines/tiles.z80.asm"
#include "splash.routines/levels.z80.asm"
#include "splash.routines/camera.z80.asm"
#include "splash.routines/player.z80.asm"
#include "splash.routines/ports.z80.asm"
#include "splash.routines/inputs.z80.asm"
#include "splash.routines/conversions.z80.asm"
#include "splash.routines/loaders.z80.asm"
#include "splash.routines/interrupts.z80.asm"
#include "splash.routines/init.z80.asm"

;========================================
;       CLEAR GRAPH BUFFER              ;
;   INPUT   NONE                        ;
;   OUTPUT  NONE                        ;
;========================================
ClearGraphBuffer:
    ; bcall(_GrBufClr) ;is this faster ?
	LD HL, _GraphBuffer
	LD (HL), A
	LD DE, _GraphBuffer+1
	LD BC, GRAPH_BUFFER_LENGTH-1
	LDIR
	RET

;========================================
;       PRESENT GRAPH BUFFER            ;
;   INPUT   NONE                        ;
;   OUTPUT  NONE                        ;
;========================================
PresentGraphBuffer:
    ; bcall(_GrBufCpy)
	CALL gbufCopy
    RET

;A Fast Clear Using StackPointer
;Requires Disabling Interrupts
;However there is existing OS routines that may do the same
;Make sure to have a word somewhere you can store SP
; ClearBufferFast:
; 	DI
; 	LD (temp), SP
; 	LD SP, _AppBuffer + APP_BUFFER_LENGTH
; 	LD HL, A ; Whatever we want
; 	LD B, 48
; CLSP:
; 	PUSH HL
; 	PUSH HL
; 	PUSH HL
; 	PUSH HL
; 	PUSH HL
; 	PUSH HL
; 	PUSH HL
; 	PUSH HL
; 	DJNZ CLSP
; 	LD SP, (temp)
; 	EI
; 	RET

gbuf = $9340
gbufCopy:
	di
	ld a,$80
	out ($10),a
	ld hl,gbuf-12-(-(12*64)+1)-12
	ld a,$20
	ld c,a
mapaYOff = $+1
	ld b,0
	inc b
		ld de,12
		add hl,de
	 djnz $-4
gbufCopyAgain:
	ld b,64
	inc c
	ld de,-(12*64)+1
	out ($10),a
	add hl,de
	ld de,10
gbufCopyLoop:
	add hl,de
	inc hl
	inc hl
	inc de
	ld a,(hl)
	out ($11),a
	dec de
	djnz gbufCopyLoop
	ld a,c
	cp $26
	 jr nz,$+5
		ld hl,gbuf-12-(-(12*64)+1)+6
	cp $2B+1
	 jr nz,gbufCopyAgain
	ret

.end
